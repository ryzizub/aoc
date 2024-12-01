import 'dart:io';

Future<void> main() async {
  final file = File('assets/day01/part02.txt');
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

  final counted = secondColumn.fold(<int, int>{}, (previous, value) {
    final previouVal = previous[value] ?? 0;

    final updatedMap = Map<int, int>.from(previous);

    updatedMap[value] = previouVal + 1;

    return updatedMap;
  });

  var result = 0;

  for (final value in firstColumn) {
    final similarity = value * (counted[value] ?? 0);

    result += similarity;
  }

  print('final result: $result');
}
