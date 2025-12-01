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
  final file = File('assets/day01/part01.txt');
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
  var numberOfRotations = 0;

  for (final instruction in instructions) {
    final direction = instruction.$1;
    final steps = instruction.$2;

    var newPosition = switch (direction) {
      _Direction.left => currentPosition - steps,
      _Direction.right => currentPosition + steps,
    };

    // Wrap around the circle
    newPosition = ((newPosition % maxPositions) + maxPositions) % maxPositions;

    currentPosition = newPosition;

    print('newPosition: $newPosition');

    if (newPosition == 0) {
      numberOfRotations++;
    }
  }

  print('numberOfRotations on 0: $numberOfRotations');
}
