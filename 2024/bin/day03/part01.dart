import 'dart:io';

Future<void> main() async {
  final file = File('assets/day03/part01.txt');
  final content = await file.readAsString();

  final regex = RegExp(r'mul\((\d+),(\d+)\)');

  final matches = regex.allMatches(content);

  final results = matches.map((match) {
    final x = int.parse(match.group(1)!);
    final y = int.parse(match.group(2)!);

    return x * y;
  });

  final sum = results.reduce((a, b) => a + b);

  print('final result: $sum');
}
