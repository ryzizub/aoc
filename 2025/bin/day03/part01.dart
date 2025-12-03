import 'dart:io';

Future<void> main() async {
  final file = File('assets/day03/part01.txt');
  final content = await file.readAsString();

  final banks = content.split('\n');

  final banksBatteries = banks.map((bank) {
    final batteries = bank.split('').map(int.parse).toList();

    return batteries;
  }).toList();

  var totalOutputJoltage = 0;

  for (final bankBatteries in banksBatteries) {
    var largestOutput = '';

    var largestBattery = 0;
    var largestBatteryIndex = 0;

    for (var i = 0; i < bankBatteries.length - 1; i++) {
      final battery = bankBatteries[i];
      if (battery > largestBattery) {
        largestBattery = battery;
        largestBatteryIndex = i;
      }
    }

    largestOutput += largestBattery.toString();
    largestBattery = 0;

    for (var i = largestBatteryIndex + 1; i < bankBatteries.length; i++) {
      final battery = bankBatteries[i];
      if (battery > largestBattery) {
        largestBattery = battery;
      }
    }

    largestOutput += largestBattery.toString();

    totalOutputJoltage += int.parse(largestOutput);
  }

  print('totalOutputJoltage: $totalOutputJoltage');
}
