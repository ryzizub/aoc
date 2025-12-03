import 'dart:io';

Future<void> main() async {
  final file = File('assets/day03/part02.txt');
  final content = await file.readAsString();

  final banks = content.split('\n');

  final banksBatteries = banks.map((bank) {
    final batteries = bank.split('').map(int.parse).toList();

    return batteries;
  }).toList();

  var totalOutputJoltage = 0;
  const targetDigits = 12;

  for (final bankBatteries in banksBatteries) {
    final selectedBatteries = <int>[];

    for (var i = 0; i < bankBatteries.length; i++) {
      final currentDigit = bankBatteries[i];

      while (selectedBatteries.isNotEmpty &&
          selectedBatteries.length + (bankBatteries.length - i) >
              targetDigits &&
          currentDigit > selectedBatteries.last) {
        selectedBatteries.removeLast();
      }

      if (selectedBatteries.length < targetDigits) {
        selectedBatteries.add(currentDigit);
      }
    }

    final largestOutput = selectedBatteries.join();
    totalOutputJoltage += int.parse(largestOutput);
  }

  print('totalOutputJoltage: $totalOutputJoltage');
}
