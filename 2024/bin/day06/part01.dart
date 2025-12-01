import 'dart:io';

final _regexGuard = RegExp(r'(\^)|(\v)|(\<)|(\>)');
final _regexRoute = RegExp(r'(\.)');
final _regexObstacle = RegExp(r'\#');
Future<void> main() async {
  final file = File('assets/day06/part01.txt');
  final content = await file.readAsString();

  final split = content.split('\n');

  final map = split.map((line) => line.split('')).toList();

  final parsedMap = _parseMap(map);

  _printMap(parsedMap);

  final navigatedMap = _navigateGuardMap(parsedMap);

  final visitedRoutes = _countGuardVisitedRoutes(navigatedMap);

  print('visitedRoutes: $visitedRoutes');
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

List<List<_Element>> _navigateGuardMap(List<List<_Element>> map) {
  final source = List<List<_Element>>.from(map);

  var leftMap = false;

  while (!leftMap) {
    final guard = _findGuard(source);

    if (guard == null) {
      leftMap = true;
    } else {
      final direction = guard.direction;

      final possibleMove = _findPossibleMove(source, direction, guard);

      if (possibleMove == null) {
        leftMap = true;

        source[guard.x][guard.y] =
            _Route(x: guard.x, y: guard.y, visited: true);
      } else {
        final newGuard = guard.copyWith(
          x: possibleMove.$1,
          y: possibleMove.$2,
          direction: possibleMove.$3,
        );

        source[guard.x][guard.y] =
            _Route(x: guard.x, y: guard.y, visited: true);
        source[newGuard.x][newGuard.y] = newGuard;
      }
    }

    _printMap(source);
  }

  return source;
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
    final possibleMove = switch (direction) {
      _Direction.up => (guard.x > 0) ? map[guard.x - 1][guard.y] : null,
      _Direction.down =>
        (guard.x < map.length - 1) ? map[guard.x + 1][guard.y] : null,
      _Direction.left => (guard.y > 0) ? map[guard.x][guard.y - 1] : null,
      _Direction.right =>
        (guard.y < map[guard.x].length - 1) ? map[guard.x][guard.y + 1] : null,
    };

    if (possibleMove is _Obstacle) {
      foundMove = false;
      direction = direction.next;
    } else {
      foundMove = true;
    }
  }

  return switch (direction) {
    _Direction.up => (guard.x > 0) ? (guard.x - 1, guard.y, direction) : null,
    _Direction.down =>
      (guard.x < map.length - 1) ? (guard.x + 1, guard.y, direction) : null,
    _Direction.left => (guard.y > 0) ? (guard.x, guard.y - 1, direction) : null,
    _Direction.right => (guard.y < map[guard.x].length - 1)
        ? (guard.x, guard.y + 1, direction)
        : null,
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
      }
      if (_regexRoute.hasMatch(element)) {
        line.add(const _Route(x: 0, y: 0, visited: false));
      }
      if (_regexObstacle.hasMatch(element)) {
        line.add(const _Obstacle(x: 0, y: 0));
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

sealed class _Element {
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
  const _Obstacle({required super.x, required super.y});

  @override
  String toString() {
    return '#';
  }
}
