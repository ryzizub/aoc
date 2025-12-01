import 'dart:io';

Future<void> main() async {
  final file = File('assets/day15/part01.txt');
  final content = await file.readAsString();

  final split = content.split('\n\n');

  final map = _parseMap(split[0]);
  final directions = _parseDirections(split[1]);

  _printMap(map);

  final result = _moveRobot(map, directions);

  _printMap(result);

  final count = _countBoxes(result);

  print(count);
}

int _countBoxes(List<List<_Object>> map) {
  var count = 0;
  for (var x = 0; x < map.length; x++) {
    for (var y = 0; y < map[x].length; y++) {
      if (map[x][y] is _Box) {
        count += 100 * x + y;
      }
    }
  }
  return count;
}

/// Rules for moving the robot:
/// - If the robot is on a wall, it cannot move
/// - If the robot is on a box, it cannot move only if there is wallet after box or other box, if there is empty space after box/boxes, it moves boxes with the robot direction
/// - If the robot is on an empty space, it can move
List<List<_Object>> _moveRobot(
  List<List<_Object>> map,
  List<_Direction> directions,
) {
  final currentCopy = _copyMap(map);

  for (final direction in directions) {
    final robotRowX =
        currentCopy.indexWhere((row) => row.any((e) => e is _Robot));
    final robotRowY = currentCopy[robotRowX].indexWhere((e) => e is _Robot);

    final movement = switch (direction) {
      _Direction.up => _Movement(-1, 0, robotRowX > 0, currentCopy.length),
      _Direction.down =>
        _Movement(1, 0, robotRowX < currentCopy.length - 1, currentCopy.length),
      _Direction.left =>
        _Movement(0, -1, robotRowY > 0, currentCopy[robotRowX].length),
      _Direction.right => _Movement(
          0,
          1,
          robotRowY < currentCopy[robotRowX].length - 1,
          currentCopy[robotRowX].length,
        ),
    };

    if (!movement.canMove) continue;

    final nextPos =
        currentCopy[robotRowX + movement.dx][robotRowY + movement.dy];

    if (nextPos is _Wall) {
      continue;
    } else if (nextPos is _Box) {
      _handleBoxMovement(
        currentCopy,
        robotRowX,
        robotRowY,
        movement,
      );
    } else {
      _moveRobotTo(
        currentCopy,
        robotRowX,
        robotRowY,
        robotRowX + movement.dx,
        robotRowY + movement.dy,
      );
    }
  }

  return currentCopy;
}

void _handleBoxMovement(
  List<List<_Object>> map,
  int robotX,
  int robotY,
  _Movement movement,
) {
  var boxCount = 1;
  final nextX = robotX + movement.dx;
  final nextY = robotY + movement.dy;

  while (_isValidPosition(
        nextX + movement.dx * boxCount,
        nextY + movement.dy * boxCount,
        movement,
      ) &&
      map[nextX + movement.dx * boxCount][nextY + movement.dy * boxCount]
          is _Box) {
    boxCount++;
  }

  final lastBoxX = nextX + movement.dx * boxCount;
  final lastBoxY = nextY + movement.dy * boxCount;

  if (_isValidPosition(lastBoxX, lastBoxY, movement) &&
      map[lastBoxX][lastBoxY] is! _Wall) {
    for (var i = 0; i < boxCount; i++) {
      final newX = lastBoxX - movement.dx * i;
      final newY = lastBoxY - movement.dy * i;
      map[newX][newY] = _Box(newX, newY);
    }
    _moveRobotTo(map, robotX, robotY, nextX, nextY);
  }
}

bool _isValidPosition(int x, int y, _Movement movement) {
  if (movement.dx != 0) {
    return x >= 0 && x < movement.limit;
  } else {
    return y >= 0 && y < movement.limit;
  }
}

void _moveRobotTo(
  List<List<_Object>> map,
  int fromX,
  int fromY,
  int toX,
  int toY,
) {
  map[toX][toY] = _Robot(toX, toY);
  map[fromX][fromY] = _Object(fromX, fromY);
}

List<List<_Object>> _copyMap(List<List<_Object>> map) {
  final newMap = <List<_Object>>[];
  for (final row in map) {
    final newRow = <_Object>[];
    for (final e in row) {
      if (e is _Box) {
        newRow.add(_Box(e.x, e.y));
      } else if (e is _Robot) {
        newRow.add(_Robot(e.x, e.y));
      } else if (e is _Wall) {
        newRow.add(_Wall(e.x, e.y));
      } else {
        newRow.add(e);
      }
    }
    newMap.add(newRow);
  }
  return newMap;
}

void _printMap(List<List<_Object>> map) {
  print('-----');

  for (final row in map) {
    print(
      row
          .map(
            (e) => switch (e) {
              _Wall() => '#',
              _Box() => 'O',
              _Robot() => '@',
              _Object() => '.',
            },
          )
          .join(),
    );
  }

  print('-----');
}

List<List<_Object>> _parseMap(String content) {
  final lines = content.split('\n');
  final map = <List<_Object>>[];
  for (var x = 0; x < lines.length; x++) {
    final line = lines[x];
    final row = <_Object>[];
    for (var y = 0; y < line.length; y++) {
      final char = line[y];
      if (char == '#') {
        row.add(_Wall(x, y));
      } else if (char == '.') {
        row.add(_Object(x, y));
      } else if (char == 'O') {
        row.add(_Box(x, y));
      } else if (char == '@') {
        row.add(_Robot(x, y));
      }
    }
    map.add(row);
  }
  return map;
}

List<_Direction> _parseDirections(String content) {
  final split = content.replaceAll('\n', '').split('');

  return split
      .map((e) => _Direction.values.firstWhere((d) => d.value == e))
      .toList();
}

enum _Direction {
  up('^'),
  down('v'),
  left('<'),
  right('>');

  const _Direction(this.value);

  final String value;
}

class _Object {
  _Object(this.x, this.y);

  final int x;
  final int y;
}

class _Wall extends _Object {
  _Wall(super.x, super.y);
}

class _Box extends _Object {
  _Box(super.x, super.y);
}

class _Robot extends _Object {
  _Robot(super.x, super.y);
}

class _Movement {
  const _Movement(
    this.dx,
    this.dy,
    // ignore: avoid_positional_boolean_parameters
    this.canMove,
    this.limit,
  );

  final int dx;
  final int dy;
  final bool canMove;
  final int limit;
}
