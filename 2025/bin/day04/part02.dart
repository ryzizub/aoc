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
  final file = File('assets/day04/part02.txt');
  final content = await file.readAsString();

  final lines = content.split('\n');

  final placesLines = lines.map((line) {
    return line.split('').map(_PlaceType.fromCharIndicator).toList();
  }).toList();

  var accessiblePlaces = 0;

  final toUpdate = <(int, int)>[];

  do {
    toUpdate.clear();

    _printPlaces(placesLines);

    for (var y = 0; y < placesLines.length; y++) {
      final line = placesLines[y];
      for (var x = 0; x < line.length; x++) {
        final place = line[x];

        if (place == _PlaceType.roll) {
          if (_isAccessible(placesLines, x, y)) {
            toUpdate.add((x, y));
            accessiblePlaces++;
          }
        }
      }
    }

    for (final (x, y) in toUpdate) {
      placesLines[y][x] = _PlaceType.empty;
    }
  } while (toUpdate.isNotEmpty);

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

void _printPlaces(List<List<_PlaceType>> placesLines) {
  for (final line in placesLines) {
    print(line.map((place) => place.charIndicator).join());
  }
}
