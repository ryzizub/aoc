import 'dart:io';

enum _PlaceType {
  empty('.'),
  roll('@');

  const _PlaceType(this.charIndicator);

  final String charIndicator;

  static _PlaceType fromCharIndicator(String charIndicator) {
    return _PlaceType.values.firstWhere(
      (placeType) => placeType.charIndicator == charIndicator,
    );
  }
}

Future<void> main() async {
  final file = File('assets/day04/part01.txt');
  final content = await file.readAsString();

  final lines = content.split('\n');

  final placesLines = lines.map((line) {
    return line.split('').map(_PlaceType.fromCharIndicator).toList();
  }).toList();

  var accessiblePlaces = 0;

  for (var y = 0; y < placesLines.length; y++) {
    final line = placesLines[y];
    for (var x = 0; x < line.length; x++) {
      final place = line[x];

      if (place == _PlaceType.roll) {
        if (_isAccessible(placesLines, x, y)) {
          accessiblePlaces++;
        }
      }
    }
  }

  print('accessiblePlaces: $accessiblePlaces');
}

bool _isAccessible(List<List<_PlaceType>> placesLines, int x, int y) {
  var rollsAround = 0;
  for (var i = -1; i <= 1; i++) {
    for (var j = -1; j <= 1; j++) {
      if (y + i < 0 ||
          y + i >= placesLines.length ||
          x + j < 0 ||
          x + j >= placesLines[0].length) {
        continue;
      }

      if (placesLines[y + i][x + j] == _PlaceType.roll) {
        rollsAround++;
      }
    }
  }

  return rollsAround <= 4;
}
