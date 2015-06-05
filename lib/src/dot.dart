library graphlib.dot;

class Font {
  final String _name;
  const Font(this._name);
  String toString() => _name;

  static const TIMES_ROMAN = const Font('Times-Roman');
  static const HELVETICA = const Font('Helvectica');
  static const COURIER = const Font('Courier');
}

class Color {
  final String _value;
  const Color.name(this._value);
//  const Color.rgb(int r, int g, int b) : _value = '#${r.toRadixString(16)}$g$b';
  const Color.hsv(double h, double s, double v) : _value = '$h, $s, $v';
  String toString() => _value;

  static const BLACK = const Color.name('black');
  static const WHITE = const Color.name('white');
  static const YELLOW = const Color.name('yellow');
}

class Shape {
  final String _name;
  const Shape.name(this._name);
  String toString() => _name;

  static const BOX = const Shape.name('box');
  static const POLYGON = const Shape.name('polygon');
  static const ELLIPSE = const Shape.name('ellipse');
  static const OVAL = const Shape.name('oval');

  static const CIRCLE = const Shape.name('circle');
  static const POINT = const Shape.name('point');
  static const EGG = const Shape.name('egg');
  static const TRIANGLE = const Shape.name('triangle');

  static const PLAIN_TEXT = const Shape.name('plaintext');
  static const PLAIN = const Shape.name('plain');
  static const DIAMOND = const Shape.name('diamond');
  static const TRAPEZIUM = const Shape.name('trapezium');

  static const PARALLELOGRAM = const Shape.name('parallelogram');
  static const HOUSE = const Shape.name('house');
  static const PENTAGON = const Shape.name('pentagon');
  static const HEXAGON = const Shape.name('hexagon');

  static const SEPTAGON = const Shape.name('septagon');
  static const OCTAGON = const Shape.name('octagon');
  static const DOUBLE_CIRCLE = const Shape.name('doublecircle');
  static const DOUBLE_OCTAGON = const Shape.name('doubleoctagon');

  static const TRIPLE_OCTAGON = const Shape.name('tripleoctagon');
  static const INV_TRIANGLE = const Shape.name('invtriangle');
  static const INV_TRAPEZIUM = const Shape.name('invtrapezium');
  static const INV_HOUSE = const Shape.name('invhouse');

  static const MDIAMOND = const Shape.name('Mdiamond');
  static const MSQUARE = const Shape.name('Msquare');
  static const MCIRCLE = const Shape.name('Mcircle');
  static const RECT = const Shape.name('rect');

  static const RECTANGLE = const Shape.name('rectangle');
  static const SQUARE = const Shape.name('square');
  static const STAR = const Shape.name('star');
  static const NONE = const Shape.name('none');
}

class NodeStyle {
  final String _name;
  const NodeStyle._(this._name);
  String toString() => _name;

  static const SOLID = const NodeStyle._('solid');
  static const DASHED = const NodeStyle._('dashed');
  static const DOTTED = const NodeStyle._('dotted');
  static const BOLD = const NodeStyle._('bold');
  static const ROUNDED = const NodeStyle._('rounded');
  static const DIAGONALS = const NodeStyle._('diagonals');

  static const FILLED = const NodeStyle._('filled');
  static const STRIPED = const NodeStyle._('striped');
  static const WEDGED = const NodeStyle._('wedged');
}

class EdgeStyle {
  final String _name;
  const EdgeStyle._(this._name);
  String toString() => _name;

  static const SOLID = const EdgeStyle._('solid');
  static const DASHED = const EdgeStyle._('dashed');
  static const DOTTED = const EdgeStyle._('dotted');
  static const BOLD = const EdgeStyle._('bold');
}

class ClusterStyle {
  final String _name;
  const ClusterStyle._(this._name);
  String toString() => _name;

  static const SOLID = const ClusterStyle._('solid');
  static const DASHED = const ClusterStyle._('dashed');
  static const DOTTED = const ClusterStyle._('dotted');
  static const BOLD = const ClusterStyle._('bold');
  static const ROUNDED = const ClusterStyle._('rounded');
  static const FILLED = const ClusterStyle._('filled');
  static const STRIPED = const ClusterStyle._('striped');
}

class NodeAttr {
  String label;
  Font fontname;
  int fontsize;
  NodeStyle style;
  Color fillcolor;
  Shape shape;
  num width, height;

  Map<String, String> toMap() {
    final m = <String, String>{};
    if (label != null) m['label'] = label;
    if (fontname != null) m['fontname'] = fontname.toString();
    if (fontsize != null) m['fontsize'] = fontsize.toString();
    if (style != null) m['style'] = style.toString();
    if (fillcolor != null) m['fillcolor'] = fillcolor.toString();
    if (shape != null) m['shape'] = shape.toString();
    if (width != null) m['width'] = width.toString();
    if (height != null) m['height'] = height.toString();
    return m;
  }
}

class Dir {
  final String _name;
  const Dir._(this._name);
  String toString() => _name;

  static const BOTH = const Dir._('both');
  static const FORWARD = const Dir._('forward');
  static const BACK = const Dir._('back');
}

class ArrowShape {
  final String _name;
  const ArrowShape(this._name);
  String toString() => _name;

  static const BOX = const ArrowShape('box');
  static const CROW = const ArrowShape('crow');
  static const CURVE = const ArrowShape('curve');
  static const ICURVE = const ArrowShape('icurve');
  static const DIAMOND = const ArrowShape('diamond');
  static const DOT = const ArrowShape('dot');
  static const INV = const ArrowShape('inv');
  static const NONE = const ArrowShape('none');
  static const NORMAL = const ArrowShape('normal');
  static const TEE = const ArrowShape('tee');
  static const VEE = const ArrowShape('vee');
}

class EdgeAttr {
  String headlabel, taillabel;
  Dir dir;
  ArrowShape arrowhead, arrowtail;

  Map<String, String> toMap() {
    final m = <String, String>{};
    if (headlabel != null) {
      m['headlabel'] = headlabel;
    }
    if (taillabel != null) {
      m['taillabel'] = taillabel;
    }
    if (dir != null) {
      m['dir'] = dir.toString();
    }
    if (arrowhead != null) {
      m['arrowhead'] = arrowhead.toString();
    }
    if (arrowtail != null) {
      m['arrowtail'] = arrowtail.toString();
    }
    return m;
  }
}

class GraphAttr {
  String label;
  Font fontname;
  int fontsize;
  Color bgcolor;

  Map<String, String> toMap() {
    final m = <String, String>{};
    if (label != null) {
      m['label'] = label;
    }
    if (fontname != null) {
      m['fontname'] = fontname.toString();
    }
    if (fontsize != null) {
      m['fontsize'] = fontsize.toString();
    }
    if (bgcolor != null) {
      m['bgcolor'] = bgcolor.toString();
    }
    return m;
  }
}
