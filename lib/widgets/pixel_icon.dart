import 'package:flutter/material.dart';

enum PixelGlyph { sun, moon, menu, prompt, search, arrowUpRight }

/// 11×11 bitmap icons drawn on the same hard pixel grid as the display
/// type, so the chrome shares one grammar (and no icon font is shipped).
class PixelIcon extends StatelessWidget {
  final PixelGlyph glyph;
  final Color color;

  /// Size of one bitmap pixel in logical px; the icon is 11 × this.
  final double cell;

  const PixelIcon(this.glyph, {super.key, required this.color, this.cell = 2});

  static const Map<PixelGlyph, List<String>> _bitmaps = {
    PixelGlyph.sun: [
      '.....#.....',
      '.#...#...#.',
      '..#.....#..',
      '....###....',
      '...#####...',
      '##.#####.##',
      '...#####...',
      '....###....',
      '..#.....#..',
      '.#...#...#.',
      '.....#.....',
    ],
    PixelGlyph.moon: [
      '....#......',
      '..##.......',
      '.###.......',
      '.###.......',
      '####.......',
      '####.......',
      '#####......',
      '.######....',
      '.#########.',
      '..#######..',
      '....###....',
    ],
    PixelGlyph.menu: [
      '...........',
      '...........',
      '###########',
      '...........',
      '...........',
      '###########',
      '...........',
      '...........',
      '###########',
      '...........',
      '...........',
    ],
    PixelGlyph.prompt: [
      '...........',
      '...........',
      '...#.......',
      '...##......',
      '...###.....',
      '...####....',
      '...###.....',
      '...##......',
      '...#.......',
      '...........',
      '...........',
    ],
    PixelGlyph.search: [
      '..####.....',
      '.#....#....',
      '#......#...',
      '#......#...',
      '#......#...',
      '#......#...',
      '.#....#....',
      '..####.##..',
      '.......###.',
      '........###',
      '.........##',
    ],
    PixelGlyph.arrowUpRight: [
      '...........',
      '...#######.',
      '........##.',
      '.......#.#.',
      '......#..#.',
      '.....#...#.',
      '....#....#.',
      '...#.......',
      '..#........',
      '.#.........',
      '...........',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: cell * 11,
      child: CustomPaint(painter: _PixelIconPainter(_bitmaps[glyph]!, color, cell)),
    );
  }
}

class _PixelIconPainter extends CustomPainter {
  final List<String> rows;
  final Color color;
  final double cell;

  _PixelIconPainter(this.rows, this.color, this.cell);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;
    for (var y = 0; y < rows.length; y++) {
      for (var x = 0; x < rows[y].length; x++) {
        if (rows[y][x] == '#') canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_PixelIconPainter old) => old.color != color || old.rows != rows || old.cell != cell;
}
