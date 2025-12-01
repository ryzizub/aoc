import 'dart:io';

import 'package:collection/collection.dart';

Future<void> main() async {
  final file = File('assets/day16/part01.txt');
  final content = await file.readAsString();

  final map = _getMap(content);

  final start = map
      .firstWhere((row) => row.any((object) => object is _Start))
      .whereType<_Start>()
      .first;
  final directions = _getBestPathsToTheEnd(map, start);

  final lowest = directions.reduce((a, b) => a.cost < b.cost ? a : b);

  print('shortest path: ${lowest.cost}');
}

List<
    ({
      _Object position,
      List<_Direction> path,
      List<String> visited,
      int cost,
    })> _getBestPathsToTheEnd(
  List<List<_Object>> map,
  _Start start,
) {
  final visited = <String, int>{};
  final queue = PriorityQueue<
      ({
        _Object position,
        List<_Direction> path,
        List<String> visited,
        int cost,
      })>((a, b) => a.cost.compareTo(b.cost))
    ..add(
      (
        position: start,
        path: <_Direction>[],
        visited: <String>['${start.y}:${start.x}'],
        cost: 0,
      ),
    );

  final validPaths = <({
    _Object position,
    List<_Direction> path,
    List<String> visited,
    int cost,
  })>[];

  while (queue.isNotEmpty) {
    final current = queue.removeFirst();
    final position = current.position;
    final positionKey = '${position.y}:${position.x}';

    // Skip if we've found this position with a better cost
    if (visited.containsKey(positionKey) &&
        visited[positionKey]! <= current.cost) {
      continue;
    }
    visited[positionKey] = current.cost;

    if (position is _End) {
      validPaths.add(current);
      continue;
    }

    final lastDirection =
        current.path.isEmpty ? _Direction.right : current.path.last;
    final possibleMoves = _getPossibleMoves(position, lastDirection);

    for (final move in possibleMoves) {
      if (move.y < 0 ||
          move.y >= map.length ||
          move.x < 0 ||
          move.x >= map[move.y].length) {
        continue;
      }

      final nextPosition = map[move.y][move.x];

      if (nextPosition is _Wall) continue;

      final turnCost = lastDirection != move.direction ? 1000 : 0;
      final newCost = current.cost + 1 + turnCost;

      queue.add(
        (
          position: nextPosition,
          path: [...current.path, move.direction],
          visited: [...current.visited, '${move.y}:${move.x}'],
          cost: newCost,
        ),
      );
    }
  }

  return validPaths;
}

List<({_Direction direction, int x, int y})> _getPossibleMoves(
  _Object position,
  _Direction lastDirection,
) {
  switch (lastDirection) {
    case _Direction.right:
    case _Direction.left:
      return [
        (direction: _Direction.top, x: position.x, y: position.y - 1),
        (direction: _Direction.down, x: position.x, y: position.y + 1),
        (
          direction: lastDirection,
          x: position.x + (lastDirection == _Direction.right ? 1 : -1),
          y: position.y
        ),
      ];
    case _Direction.top:
    case _Direction.down:
      return [
        (direction: _Direction.left, x: position.x - 1, y: position.y),
        (direction: _Direction.right, x: position.x + 1, y: position.y),
        (
          direction: lastDirection,
          x: position.x,
          y: position.y + (lastDirection == _Direction.down ? 1 : -1)
        ),
      ];
  }
}

enum _Direction {
  top,
  down,
  left,
  right,
}

List<List<_Object>> _getMap(String map) {
  final lines = map.split('\n');

  final result = <List<_Object>>[];

  for (var y = 0; y < lines.length; y++) {
    final row = <_Object>[];

    for (var x = 0; x < lines[y].length; x++) {
      final char = lines[y][x];

      if (char == '#') {
        row.add(_Wall(x, y));
      } else if (char == 'S') {
        row.add(_Start(x, y));
      } else if (char == 'E') {
        row.add(_End(x, y));
      } else {
        row.add(_Object(x, y));
      }
    }

    result.add(row);
  }

  return result;
}

class _Object {
  _Object(this.x, this.y);
  final int x;
  final int y;
}

class _Wall extends _Object {
  _Wall(super.x, super.y);
}

class _Start extends _Object {
  _Start(super.x, super.y);
}

class _End extends _Object {
  _End(super.x, super.y);
}
