import 'dart:io';

import 'package:collection/collection.dart';

class _RedTile {
  _RedTile(this.x, this.y);

  final int x;
  final int y;
}

Future<void> main() async {
  final file = File('assets/day09/part02.txt');
  final lines = await file.readAsLines();

  final points = lines.map((line) {
    final coords = line.split(',');
    return _RedTile(int.parse(coords[0]), int.parse(coords[1]));
  }).toList();

  final rowRanges = _buildRowRanges(points);
  final result = _findLargestRectangleArea(points, rowRanges);

  print(result);
}

Map<int, ({int minX, int maxX})> _buildRowRanges(List<_RedTile> tiles) {
  final tilesInRow = <int, Set<int>>{};

  for (final tile in tiles) {
    tilesInRow.putIfAbsent(tile.y, () => <int>{}).add(tile.x);
  }

  for (var i = 0; i < tiles.length; i++) {
    final t1 = tiles[i];
    final t2 = tiles[(i + 1) % tiles.length];

    if (t1.x == t2.x) {
      // Vertical edge
      final minY = t1.y < t2.y ? t1.y : t2.y;
      final maxY = t1.y > t2.y ? t1.y : t2.y;
      for (var y = minY; y <= maxY; y++) {
        tilesInRow.putIfAbsent(y, () => <int>{}).add(t1.x);
      }
    } else if (t1.y == t2.y) {
      // Horizontal edge
      final minX = t1.x < t2.x ? t1.x : t2.x;
      final maxX = t1.x > t2.x ? t1.x : t2.x;
      for (var x = minX; x <= maxX; x++) {
        tilesInRow.putIfAbsent(t1.y, () => <int>{}).add(x);
      }
    }
  }

  final rowRanges = <int, ({int minX, int maxX})>{};
  for (final entry in tilesInRow.entries) {
    final xs = entry.value;
    if (xs.isEmpty) continue;
    rowRanges[entry.key] = (minX: xs.min, maxX: xs.max);
  }

  return rowRanges;
}

bool _isRectangleValid(
  int x1,
  int x2,
  int y1,
  int y2,
  Map<int, ({int minX, int maxX})> rowRanges,
) {
  for (var y = y1; y <= y2; y++) {
    final range = rowRanges[y];
    if (range == null || x1 < range.minX || x2 > range.maxX) {
      return false;
    }
  }
  return true;
}

int _findLargestRectangleArea(
  List<_RedTile> tiles,
  Map<int, ({int minX, int maxX})> rowRanges,
) {
  var maxArea = 0;

  for (var i = 0; i < tiles.length; i++) {
    for (var j = i + 1; j < tiles.length; j++) {
      final t1 = tiles[i];
      final t2 = tiles[j];

      if (t1.x == t2.x || t1.y == t2.y) continue;

      final x1 = t1.x < t2.x ? t1.x : t2.x;
      final x2 = t1.x > t2.x ? t1.x : t2.x;
      final y1 = t1.y < t2.y ? t1.y : t2.y;
      final y2 = t1.y > t2.y ? t1.y : t2.y;

      if (!_isRectangleValid(x1, x2, y1, y2, rowRanges)) continue;

      final area = (x2 - x1 + 1) * (y2 - y1 + 1);
      if (area > maxArea) maxArea = area;
    }
  }

  return maxArea;
}
