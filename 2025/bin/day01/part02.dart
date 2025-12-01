import 'dart:io';

enum _Direction {
  left('L'),
  right('R');

  const _Direction(this.charIndicator);

  final String charIndicator;

  static _Direction fromCharIndicator(String charIndicator) {
    return _Direction.values.firstWhere(
      (direction) => direction.charIndicator == charIndicator,
    );
  }
}

Future<void> main() async {
  final file = File('assets/day01/part02.txt');
  final content = await file.readAsString();

  final lines = content.split('\n');

  final instructions = lines.map((line) {
    final direction = _Direction.fromCharIndicator(line[0]);

    final steps = int.parse(line.substring(1));

    return (direction, steps);
  });

  const startingPosition = 50;
  const maxPositions = 100;

  var currentPosition = startingPosition;
  var numberOfPassedZero = 0;

  for (final instruction in instructions) {
    final direction = instruction.$1;
    final steps = instruction.$2;

    final newPosition = switch (direction) {
      _Direction.left => currentPosition - steps,
      _Direction.right => currentPosition + steps,
    };

    final (rangeStart, rangeEnd) = switch (direction) {
      _Direction.right => (currentPosition + 1, newPosition),
      _Direction.left => (newPosition + 1, currentPosition - 1),
    };

    final firstZeroIndex = (rangeStart / maxPositions).ceil();
    final lastZeroIndex = rangeEnd ~/ maxPositions;

    var count = 0;
    for (
      var zeroIndex = firstZeroIndex;
      zeroIndex <= lastZeroIndex;
      zeroIndex++
    ) {
      final zeroPos = zeroIndex * maxPositions;
      if (zeroPos >= rangeStart && zeroPos <= rangeEnd) count++;
    }

    final wrappedPosition =
        ((newPosition % maxPositions) + maxPositions) % maxPositions;
    if (wrappedPosition == 0) {
      final finalZeroPos = (newPosition ~/ maxPositions) * maxPositions;
      if (finalZeroPos < rangeStart || finalZeroPos > rangeEnd) count++;
    }

    numberOfPassedZero += count;
    currentPosition = wrappedPosition;
  }

  print('numberOfPassedThroughZero: $numberOfPassedZero');
}
