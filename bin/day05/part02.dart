import 'dart:io';

Future<void> main() async {
  final file = File('assets/day05/part02.txt');
  final content = await file.readAsString();

  final split = content.split('\n\n');

  final rulesLines = split[0].split('\n');
  final printOrdersLines = split[1].split('\n');

  final rulesList = rulesLines.map((rule) {
    final split = rule.split('|');

    final target = int.parse(split[0]);
    final before = int.parse(split[1]);

    return (target, before);
  });

  final rules = <int, List<int>>{};

  for (final rule in rulesList) {
    rules.putIfAbsent(rule.$1, () => []).add(rule.$2);
  }

  final printOrders =
      printOrdersLines.map((line) => line.split(',').map(int.parse).toList());

  final inCorrectOrders = printOrders.where((order) => !order.isCorrect(rules));

  final orderedInCorrectOrders =
      inCorrectOrders.map((order) => order.orderByRules(rules));

  final middlePages = orderedInCorrectOrders.map((order) {
    final middleIndex = order.length ~/ 2;
    final middleElement = order[middleIndex];

    return middleElement;
  });

  final middlePagesSum = middlePages.reduce((a, b) => a + b);

  print('final result: $middlePagesSum');
}

extension on List<int> {
  bool isCorrect(Map<int, List<int>> rules) {
    for (final rule in rules.entries) {
      for (final after in rule.value) {
        final target = rule.key;

        final index = indexOf(target);

        if (index == -1) {
          continue;
        }

        final afterIndex = indexOf(after);

        if (afterIndex == -1) {
          continue;
        }

        if (afterIndex > index) {
          continue;
        } else {
          return false;
        }
      }
    }
    return true;
  }

  List<int> orderByRules(Map<int, List<int>> rules) {
    final result = List<int>.from(this);

    var hasSwapped = true;
    while (hasSwapped) {
      hasSwapped = false;

      for (final rule in rules.entries) {
        for (final after in rule.value) {
          final target = rule.key;

          final targetIndex = result.indexOf(target);
          final afterIndex = result.indexOf(after);

          if (targetIndex == -1 || afterIndex == -1) {
            continue;
          }

          if (afterIndex > targetIndex) {
            continue;
          }

          final temp = result[targetIndex];
          result[targetIndex] = result[afterIndex];
          result[afterIndex] = temp;
          hasSwapped = true;
        }
      }
    }

    return result;
  }
}
