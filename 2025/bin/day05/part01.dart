import 'dart:io';

Future<void> main() async {
  final file = File('assets/day05/part01.txt');
  final content = await file.readAsString();

  final lines = content.split(
    '\n'
    '\n',
  );

  final freshRanges = lines[0].split('\n').map((line) {
    final split = line.split('-');
    return (int.parse(split[0]), int.parse(split[1]));
  }).toList();

  final selectedIngrediences = lines[1].split('\n').map(int.parse).toList();

  var result = 0;

  for (final selectedIngredience in selectedIngrediences) {
    for (final freshRange in freshRanges) {
      if (selectedIngredience >= freshRange.$1 &&
          selectedIngredience <= freshRange.$2) {
        result += 1;
        break;
      }
    }
  }

  print(result);
}
