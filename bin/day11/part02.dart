import 'dart:io';

Future<void> main() async {
  final file = File('assets/day11/part02.txt');
  final content = await file.readAsString();

  final regex = RegExp(r'\d+');
  final matches = regex.allMatches(content);
  final stones = matches.map((match) => int.parse(match.group(0)!)).toList();

  final stoneMap = <int, int>{};
  for (final stone in stones) {
    stoneMap[stone] = (stoneMap[stone] ?? 0) + 1;
  }

  final result = _rotateStones(stoneMap, 75);

  print('Final total number of stones: ${_stoneCount(result)}');
}

Map<int, int> _rotateStones(Map<int, int> stones, int count) {
  var currentStones = Map<int, int>.from(stones);

  for (var i = 0; i < count; i++) {
    currentStones = _transformStones(currentStones);
  }

  return currentStones;
}

Map<int, int> _transformStones(Map<int, int> stones) {
  final newStones = <int, int>{};

  for (final entry in stones.entries) {
    final stone = entry.key;
    final amount = entry.value;

    final transforms = _blinkStone(stone);

    for (final transformedStone in transforms) {
      newStones[transformedStone] = (newStones[transformedStone] ?? 0) + amount;
    }
  }

  return newStones;
}

List<int> _blinkStone(int stone) {
  if (stone == 0) {
    return [1];
  }

  final stoneString = stone.toString();
  if (stoneString.length.isEven) {
    final half = stoneString.length ~/ 2;
    final firstHalf = int.parse(stoneString.substring(0, half));
    final secondHalf = int.parse(stoneString.substring(half));
    return [firstHalf, secondHalf];
  }

  return [stone * 2024];
}

int _stoneCount(Map<int, int> stones) {
  return stones.values.reduce((a, b) => a + b);
}
