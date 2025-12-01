import 'dart:io';

Future<void> main() async {
  final file = File('assets/day09/part01.txt');
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

  for (var i = disks.length - 1; i >= 0; i--) {
    print('fragment:$i');
    final file = disks[i];

    if (file != '.') {
      final indexToMove = copy.indexOf('.');

      copy[indexToMove] = file;
      copy[i] = '.';
    }

    final lastNumber = copy.lastIndexWhere((e) => e != '.');
    final firstPart = copy.sublist(0, lastNumber);

    if (firstPart.where((e) => e == '.').isEmpty) {
      break;
    }
  }

  return copy;
}

int _calculateChecksum(List<String> disks) {
  var checkSum = 0;

  for (var i = 0; i < disks.where((e) => e != '.').length; i++) {
    print('checksum:$i');
    final file = int.parse(disks[i]);
    checkSum += i * file;
  }

  return checkSum;
}
