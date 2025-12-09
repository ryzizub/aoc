import 'dart:io';

class _RedTile {
  _RedTile(this.x, this.y);

  final int x;
  final int y;
}

Future<void> main() async {
  final file = File('assets/day09/part01.txt');
  final content = await file.readAsString();
  final lines = content.split('\n');

  final redTiles = lines.map((line) {
    final coordinates = line.split(',');
    return _RedTile(int.parse(coordinates[0]), int.parse(coordinates[1]));
  }).toList();

  final result = _findLargestRectangleArea(redTiles);
  print(result);
}

int _findLargestRectangleArea(
  List<_RedTile> redTiles,
) {
  var maxArea = 0;

  for (var i = 0; i < redTiles.length; i++) {
    for (var j = 0; j < redTiles.length; j++) {
      final tile1 = redTiles[i];
      final tile2 = redTiles[j];

      if (i == j) continue;

      final x1 = tile1.x < tile2.x ? tile1.x : tile2.x;
      final x2 = tile1.x > tile2.x ? tile1.x : tile2.x;
      final y1 = tile1.y < tile2.y ? tile1.y : tile2.y;
      final y2 = tile1.y > tile2.y ? tile1.y : tile2.y;

      if (tile1.x == tile2.x || tile1.y == tile2.y) continue;

      final area = (x2 - x1 + 1) * (y2 - y1 + 1);

      if (area > maxArea) {
        print(
          'tile1: ${tile1.x},${tile1.y}, tile2: ${tile2.x},${tile2.y},'
          ' area: $area',
        );
        maxArea = area;
      }
    }
  }

  return maxArea;
}
