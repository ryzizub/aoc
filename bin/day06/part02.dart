import 'dart:io';

final _regexGuard = RegExp(r'(\^)|(\v)|(\<)|(\>)');
final _regexRoute = RegExp(r'(\.)');
final _regexObstacle = RegExp(r'\#');

// Note :D : This is a brute force solution that takes a long time to run.
// For some copying and equality would be better to use equatable

Future<void> main() async {
  final file = File('assets/day06/part02.txt');
  final content = await file.readAsString();

  final split = content.split('\n');

  final map = split.map((line) => line.split('')).toList();

  final parsedMap = _parseMap(map);

  _printMap(parsedMap);

  final navigatedMap = _navigateGuardMap(parsedMap, true);

  if (navigatedMap == null) {
    print('Guard is stuck in a loop and cannot navigate out.');
    return;
  }

  final visitedRoutes = _countGuardVisitedRoutes(navigatedMap.$1);
  final loopCount = navigatedMap.$2;

  print('visitedRoutes: $visitedRoutes');
  print('loopCount: $loopCount');
}

int _countGuardVisitedRoutes(List<List<_Element>> map) {
  final result = map.fold(
    0,
    (init, value) =>
        init +
        value.where((element) => element is _Route && element.visited).length,
  );

  return result;
}

(List<List<_Element>>, int)? _navigateGuardMap(
  List<List<_Element>> map,
  bool loopTest,
) {
  final source = _copyMap(map);

  var leftMap = false;

  final visitedStates = <(int, int, _Direction)>{};

  final loopMap = <List<List<_Element>>>[];

  while (!leftMap) {
    final guard = _findGuard(source);

    if (guard == null) {
      leftMap = true;
      break;
    }

    final state = (guard.x, guard.y, guard.direction);
    if (visitedStates.contains(state)) {
      // We are in a loop
      return null;
    } else {
      visitedStates.add(state);
    }

    final possibleMove = _findPossibleMove(source, guard.direction, guard);

    if (possibleMove == null) {
      leftMap = true;
      source[guard.x][guard.y] = _Route(x: guard.x, y: guard.y, visited: true);
    } else {
      final newGuard = guard.copyWith(
        x: possibleMove.$1,
        y: possibleMove.$2,
        direction: possibleMove.$3,
      );

      source[guard.x][guard.y] = _Route(x: guard.x, y: guard.y, visited: true);
      source[newGuard.x][newGuard.y] = newGuard;

      if (loopTest) {
        final copyMap = _copyMap(source);

        copyMap[newGuard.x][newGuard.y] =
            _Obstacle(x: newGuard.x, y: newGuard.y);
        copyMap[guard.x][guard.y] = guard;

        loopMap.add(copyMap);
      }
    }
  }

  if (loopTest) {
    final filterDistinct = _filterMapsByObstacles(loopMap);

    var loopCount = 0;

    for (final distinctMap in filterDistinct) {
      final navigatedMap = _navigateGuardMap(distinctMap, false);

      if (navigatedMap == null) {
        loopCount++;
      }
    }

    return (source, loopCount);
  }

  return (source, 0);
}

List<List<_Element>> _copyMap(List<List<_Element>> map) {
  final newMap = <List<_Element>>[];
  for (final row in map) {
    final newRow = <_Element>[];
    for (final e in row) {
      if (e is _Guard) {
        newRow.add(_Guard(direction: e.direction, x: e.x, y: e.y));
      } else if (e is _Route) {
        newRow.add(_Route(x: e.x, y: e.y, visited: e.visited));
      } else if (e is _Obstacle) {
        newRow.add(_Obstacle(x: e.x, y: e.y));
      } else {
        newRow.add(e);
      }
    }
    newMap.add(newRow);
  }
  return newMap;
}

String _obstacleMapToString(List<List<_Element>> map) {
  final obstaclePositions = <String>[];
  for (final row in map) {
    for (final element in row) {
      if (element is _Obstacle) {
        obstaclePositions.add('${element.x}:${element.y}');
      }
    }
  }
  obstaclePositions.sort();
  return obstaclePositions.join(';');
}

List<List<List<_Element>>> _filterMapsByObstacles(
  List<List<List<_Element>>> maps,
) {
  final seenObstacleArrangements = <String>{};
  final uniqueMaps = <List<List<_Element>>>[];

  for (final map in maps) {
    final obstaclesKey = _obstacleMapToString(map);
    if (!seenObstacleArrangements.contains(obstaclesKey)) {
      seenObstacleArrangements.add(obstaclesKey);
      uniqueMaps.add(map);
    }
  }

  return uniqueMaps;
}

void _printMap(List<List<_Element>> map) {
  print('--------------------------------');
  print(map.map((line) => line.map((e) => e.toString()).join()).join('\n'));
  print('--------------------------------');
}

(int, int, _Direction)? _findPossibleMove(
  List<List<_Element>> map,
  _Direction startDirection,
  _Guard guard,
) {
  var foundMove = false;
  var direction = startDirection;

  while (!foundMove) {
    final possibleMove = _move(guard.x, guard.y, direction, map);

    final element =
        possibleMove != null ? map[possibleMove.$1][possibleMove.$2] : null;

    if (element is _Obstacle) {
      foundMove = false;
      direction = direction.next;
    } else {
      foundMove = true;
    }
  }

  final move = _move(guard.x, guard.y, direction, map);
  if (move == null) {
    return null;
  }

  return (move.$1, move.$2, direction);
}

(int, int)? _move(
  int initX,
  int initY,
  _Direction direction,
  List<List<_Element>> map,
) {
  return switch (direction) {
    _Direction.up => (initX > 0) ? (initX - 1, initY) : null,
    _Direction.down => (initX < map.length - 1) ? (initX + 1, initY) : null,
    _Direction.left => (initY > 0) ? (initX, initY - 1) : null,
    _Direction.right =>
      (initY < map[initX].length - 1) ? (initX, initY + 1) : null,
  };
}

_Guard? _findGuard(List<List<_Element>> map) {
  for (final line in map) {
    for (final element in line) {
      if (element is _Guard) {
        return element;
      }
    }
  }
  return null;
}

List<List<_Element>> _parseMap(List<List<String>> map) {
  final result = <List<_Element>>[];

  for (var x = 0; x < map.length; x++) {
    final line = <_Element>[];

    for (var y = 0; y < map[x].length; y++) {
      final element = map[x][y];

      if (_regexGuard.hasMatch(element)) {
        final direction = _parseDirection(element);
        line.add(_Guard(direction: direction, x: x, y: y));
      } else if (_regexRoute.hasMatch(element)) {
        line.add(_Route(x: x, y: y, visited: false));
      } else if (_regexObstacle.hasMatch(element)) {
        line.add(_Obstacle(x: x, y: y));
      }
    }
    result.add(line);
  }

  return result;
}

_Direction _parseDirection(String direction) {
  if (direction == '^') {
    return _Direction.up;
  } else if (direction == 'v') {
    return _Direction.down;
  } else if (direction == '<') {
    return _Direction.left;
  } else if (direction == '>') {
    return _Direction.right;
  }
  throw Exception('Invalid direction: $direction');
}

enum _Direction {
  up,
  down,
  left,
  right,
}

extension _DirectionExtension on _Direction {
  _Direction get next => switch (this) {
        _Direction.up => _Direction.right,
        _Direction.down => _Direction.left,
        _Direction.left => _Direction.up,
        _Direction.right => _Direction.down,
      };
}

class _Element {
  const _Element({required this.x, required this.y});

  final int x;
  final int y;
}

class _Guard extends _Element {
  const _Guard({
    required this.direction,
    required super.x,
    required super.y,
  });

  final _Direction direction;

  _Guard copyWith({_Direction? direction, int? x, int? y}) => _Guard(
        direction: direction ?? this.direction,
        x: x ?? this.x,
        y: y ?? this.y,
      );

  @override
  String toString() {
    switch (direction) {
      case _Direction.up:
        return '^';
      case _Direction.down:
        return 'v';
      case _Direction.left:
        return '<';
      case _Direction.right:
        return '>';
    }
  }
}

class _Route extends _Element {
  const _Route({
    required super.x,
    required super.y,
    required this.visited,
  });

  final bool visited;

  _Route copyWith({int? x, int? y, bool? visited}) => _Route(
        x: x ?? this.x,
        y: y ?? this.y,
        visited: visited ?? this.visited,
      );

  @override
  String toString() {
    return visited ? 'X' : '.';
  }
}

class _Obstacle extends _Element {
  const _Obstacle({
    required super.x,
    required super.y,
  });

  @override
  String toString() {
    return '#';
  }
}
