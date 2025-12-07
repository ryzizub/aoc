import 'dart:io';

enum _ObjectType {
  empty('.'),
  beam('|'),
  splitter('^'),
  start('S');

  const _ObjectType(this.value);

  final String value;

  static _ObjectType fromString(String value) {
    return _ObjectType.values.firstWhere((e) => e.value == value);
  }
}

Future<void> main() async {
  final file = File('assets/day07/part01.txt');
  final content = await file.readAsString();

  final lines = content.split('\n');

  final map = lines
      .map((line) => line.split('').map(_ObjectType.fromString).toList())
      .toList();

  var beamSplittedCount = 0;

  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[y].length; x++) {
      final objectType = map[y][x];

      if (objectType == _ObjectType.start && y + 1 < map.length) {
        map[y + 1][x] = _ObjectType.beam;
      }

      if (y + 1 < map.length &&
          objectType == _ObjectType.beam &&
          map[y + 1][x] == _ObjectType.splitter) {
        beamSplittedCount++;
        if (y + 1 < map.length && x - 1 >= 0) {
          map[y + 1][x - 1] = _ObjectType.beam;
        }
        if (y + 1 < map.length && x + 1 < map[y + 1].length) {
          map[y + 1][x + 1] = _ObjectType.beam;
        }
      }

      if (y + 1 < map.length &&
          objectType == _ObjectType.beam &&
          map[y + 1][x] == _ObjectType.empty) {
        map[y + 1][x] = _ObjectType.beam;
      }

      _printMap(map);
    }
  }

  print('beamSplittedCount: $beamSplittedCount');
}

void _printMap(List<List<_ObjectType>> map) {
  print('--------------------------------');
  for (final row in map) {
    print(row.map((e) => e.value).join());
  }
  print('--------------------------------');
}
