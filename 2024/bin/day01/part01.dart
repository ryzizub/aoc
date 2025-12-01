import 'dart:io';

Future<void> main() async {
  final file = File('assets/day01/part01.txt');
  final content = await file.readAsString();

  final lines = content.split('\n');

  final numbers = lines.map((line) {
    final regex = RegExp(r'\d+');
    final matches = regex.allMatches(line);
    final numbers = matches.map((match) => int.parse(match.group(0)!)).toList();

    return (numbers[0], numbers[1]);
  });

  final firstColumn = numbers.map((numbers) => numbers.$1).toList()..sort();
  final secondColumn = numbers.map((numbers) => numbers.$2).toList()..sort();

  var result = 0;

  for (var index = 0; index < firstColumn.length; index++) {
    final firstPoint = firstColumn[index];
    final secondPoint = secondColumn[index];

    final diff = (firstPoint - secondPoint).abs();

    result += diff;
  }

  print('final result: $result');
}
