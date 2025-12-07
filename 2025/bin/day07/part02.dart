import 'dart:io';

enum _ObjectType {
  empty('.'),
  splitter('^'),
  start('S');

  const _ObjectType(this.value);

  final String value;

  static _ObjectType fromString(String value) {
    return _ObjectType.values.firstWhere((e) => e.value == value);
  }
}

Future<void> main() async {
  final file = File('assets/day07/part02.txt');
  final content = await file.readAsString();

  final lines = content.split('\n').where((l) => l.isNotEmpty).toList();
  final map = lines
      .map((line) => line.split('').map(_ObjectType.fromString).toList())
      .toList();

  final timer = Stopwatch()..start();

  var startX = 0;
  var startY = 0;
  breaker:
  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[y].length; x++) {
      if (map[y][x] == _ObjectType.start) {
        startX = x;
        startY = y;
        break breaker;
      }
    }
  }

  print('Time taken to find start: ${timer.elapsed}');

  final cache = <String, BigInt>{};
  final timelines = _countTimelines(map, startX, startY + 1, cache);

  print('Time taken to find end: ${timer.elapsed}');

  print('Total timelines: $timelines');
}

BigInt _countTimelines(
  List<List<_ObjectType>> map,
  int startX,
  int startY,
  Map<String, BigInt> cache,
) {
  final key = '$startX,$startY';
  if (cache.containsKey(key)) {
    return cache[key]!;
  }

  final x = startX;
  var y = startY;

  while (y < map.length) {
    if (x < 0 || x >= map[y].length) {
      cache[key] = BigInt.one;
      return BigInt.one;
    }

    final cell = map[y][x];

    if (cell == _ObjectType.splitter) {
      final nextY = y + 1;

      BigInt leftTimelines;
      BigInt rightTimelines;

      if (nextY >= map.length) {
        leftTimelines = BigInt.one;
      } else if (x - 1 < 0) {
        leftTimelines = BigInt.one;
      } else {
        leftTimelines = _countTimelines(map, x - 1, nextY, cache);
      }

      if (nextY >= map.length) {
        rightTimelines = BigInt.one;
      } else if (x + 1 >= map[y].length) {
        rightTimelines = BigInt.one;
      } else {
        rightTimelines = _countTimelines(map, x + 1, nextY, cache);
      }

      final result = leftTimelines + rightTimelines;
      cache[key] = result;
      return result;
    }

    y++;
  }

  cache[key] = BigInt.one;
  return BigInt.one;
}
