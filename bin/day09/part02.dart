import 'dart:io';

Future<void> main() async {
  final file = File('assets/day09/part02.txt');
  final content = await file.readAsString();

  final blocks = _parseBlocks(content);
  final representedBlocks = _representBlocks(blocks);
  final fragmentedDisks = _fragmentDisks(representedBlocks);

  final checkSum = _calculateChecksum(fragmentedDisks);

  print(checkSum);
}

List<int> _parseBlocks(String input) {
  return input.split('').map(int.parse).toList();
}

List<String> _representBlocks(List<int> blocks) {
  final list = <String>[];

  var fileIndex = 0;

  for (var i = 1; i < blocks.length + 1; i += 2) {
    final fileBlock = blocks[i - 1];

    list.addAll(List.filled(fileBlock, fileIndex.toString()));

    if (blocks.length > i) {
      final spaceBlock = blocks[i];
      list.addAll(List.filled(spaceBlock, '.'));
    }

    fileIndex++;
  }

  return list;
}

List<String> _fragmentDisks(List<String> disks) {
  final copy = List<String>.from(disks);

  final files = <int, List<int>>{};
  for (var i = 0; i < copy.length; i++) {
    if (copy[i] != '.') {
      final fileId = int.parse(copy[i]);
      files.putIfAbsent(fileId, () => []);
      files[fileId]!.add(i);
    }
  }

  final fileIds = files.keys.toList()..sort((a, b) => b.compareTo(a));

  for (final fileId in fileIds) {
    print('fragmetFileId:$fileId');

    final filePositions = files[fileId]!;
    if (filePositions.isEmpty) continue;

    final fileStart = filePositions.first;
    final fileSize = filePositions.length;

    var bestSpaceStart = -1;
    var currentSpaceStart = -1;
    var currentSpaceLength = 0;

    for (var i = 0; i < fileStart; i++) {
      if (copy[i] == '.') {
        if (currentSpaceStart == -1) {
          currentSpaceStart = i;
          currentSpaceLength = 1;
        } else {
          currentSpaceLength++;
        }
      } else {
        if (currentSpaceLength >= fileSize) {
          bestSpaceStart = currentSpaceStart;
          break;
        }
        currentSpaceStart = -1;
        currentSpaceLength = 0;
      }
    }

    if (currentSpaceLength >= fileSize && bestSpaceStart == -1) {
      bestSpaceStart = currentSpaceStart;
    }

    if (bestSpaceStart != -1) {
      for (final pos in filePositions) {
        copy[pos] = '.';
      }
      for (var offset = 0; offset < fileSize; offset++) {
        copy[bestSpaceStart + offset] = fileId.toString();
      }

      files[fileId] =
          List<int>.generate(fileSize, (i) => currentSpaceStart + i);
    }
  }

  return copy;
}

int _calculateChecksum(List<String> disks) {
  var checkSum = 0;

  for (var i = 0; i < disks.length; i++) {
    if (disks[i] == '.') continue;
    final file = int.parse(disks[i]);
    checkSum += i * file;
  }

  return checkSum;
}
