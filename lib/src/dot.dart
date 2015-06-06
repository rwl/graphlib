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
  const Color(this._value);
  const Color.hsv(double h, double s, double v) : _value = '$h, $s, $v';
  String toString() => _value;

  static const ALICE_BLUE = const Color('aliceblue');
  static const ANTIQUE_WHITE = const Color('antiquewhite');
  static const AQUA = const Color('aqua');
  static const AQUAMARINE = const Color('aquamarine');
  static const AZURE = const Color('azure');
  static const BEIGE = const Color('beige');
  static const BISQUE = const Color('bisque');
  static const BLACK = const Color('black');
  static const BLANCHED_ALMOND = const Color('blanchedalmond');
  static const BLUE = const Color('blue');
  static const BLUE_VIOLET = const Color('blueviolet');
  static const BROWN = const Color('brown');
  static const BURLYWOOD = const Color('burlywood');
  static const CADET_BLUE = const Color('cadetblue');
  static const CHARTREUSE = const Color('chartreuse');
  static const CHOCOLATE = const Color('chocolate');
  static const CORAL = const Color('coral');
  static const CORNFLOWER_BLUE = const Color('cornflowerblue');
  static const CORNSILK = const Color('cornsilk');
  static const CRIMSON = const Color('crimson');
  static const CYAN = const Color('cyan');

  static const DARK_BLUE = const Color('darkblue');
  static const DARK_CYAN = const Color('darkcyan');
  static const DARK_GOLDENROD = const Color('darkgoldenrod');
  static const DARK_GRAY = const Color('darkgray');
  static const DARK_GREEN = const Color('darkgreen');
  static const DARK_GREY = const Color('darkgrey');
  static const DARK_KHAKI = const Color('darkkhaki');
  static const DARK_MAGENTA = const Color('darkmagenta');
  static const DARK_OLIVE_GREEN = const Color('darkolivegreen');
  static const DARK_ORANGE = const Color('darkorange');
  static const DARK_ORCHID = const Color('darkorchid');
  static const DARK_RED = const Color('darkred');
  static const DARK_SALMON = const Color('darksalmon');
  static const DARK_SEA_GREEN = const Color('darkseagreen');
  static const DARK_SLATE_BLUE = const Color('darkslateblue');
  static const DARK_SLATE_GRAY = const Color('darkslategray');
  static const DARK_SLATE_GREY = const Color('darkslategrey');
  static const DARK_TURQUOISE = const Color('darkturquoise');
  static const DARK_VIOLET = const Color('darkviolet');

  static const DEEP_PINK = const Color('deeppink');
  static const DEEP_SKY_BLUE = const Color('deepskyblue');
  static const DIM_GRAY = const Color('dimgray');
  static const DIM_GREY = const Color('dimgrey');
  static const DODGER_BLUE = const Color('dodgerblue');
  static const FIREBRICK = const Color('firebrick');
  static const FLORAL_WHITE = const Color('floralwhite');
  static const FOREST_GREEN = const Color('forestgreen');
  static const FUCHSIA = const Color('fuchsia');
  static const GAINSBORO = const Color('gainsboro');
  static const GHOST_WHITE = const Color('ghostwhite');
  static const GOLD = const Color('gold');
  static const GOLDENROD = const Color('goldenrod');
  static const GRAY = const Color('gray');
  static const GREY = const Color('grey');
  static const GREEN = const Color('green');
  static const GREEN_YELLOW = const Color('greenyellow');
  static const HONEYDEW = const Color('honeydew');
  static const HOT_PINK = const Color('hotpink');
  static const INDIAN_RED = const Color('indianred');
  static const INDIGO = const Color('indigo');
  static const IVORY = const Color('ivory');
  static const KHAKI = const Color('khaki');
  static const LAVENDER = const Color('lavender');
  static const LAVENDERBLUSH = const Color('lavenderblush');
  static const LAWN_GREEN = const Color('lawngreen');
  static const LEMON_CHIFFON = const Color('lemonchiffon');

  static const LIGHT_BLUE = const Color('lightblue');
  static const LIGHT_CORAL = const Color('lightcoral');
  static const LIGHT_CYAN = const Color('lightcyan');
  static const LIGHT_GOLDENRODYELLOW = const Color('lightgoldenrodyellow');
  static const LIGHT_GRAY = const Color('lightgray');
  static const LIGHT_GREEN = const Color('lightgreen');
  static const LIGHT_GREY = const Color('lightgrey');
  static const LIGHT_PINK = const Color('lightpink');
  static const LIGHT_SALMON = const Color('lightsalmon');
  static const LIGHT_SEA_GREEN = const Color('lightseagreen');
  static const LIGHT_SKY_BLUE = const Color('lightskyblue');
  static const LIGHT_SLATE_GRAY = const Color('lightslategray');
  static const LIGHT_SLATE_GREY = const Color('lightslategrey');
  static const LIGHT_STEEL_BLUE = const Color('lightsteelblue');
  static const LIGHT_YELLOW = const Color('lightyellow');
  static const LIME = const Color('lime');
  static const LIME_GREEN = const Color('limegreen');
  static const LINEN = const Color('linen');
  static const MAGENTA = const Color('magenta');
  static const MAROON = const Color('maroon');

  static const MEDIUM_AQUAMARINE = const Color('mediumaquamarine');
  static const MEDIUM_BLUE = const Color('mediumblue');
  static const MEDIUM_ORCHID = const Color('mediumorchid');
  static const MEDIUM_PURPLE = const Color('mediumpurple');
  static const MEDIUM_SEA_GREEN = const Color('mediumseagreen');
  static const MEDIUM_SLATE_BLUE = const Color('mediumslateblue');
  static const MEDIUM_SPRING_GREEN = const Color('mediumspringgreen');
  static const MEDIUM_TURQUOISE = const Color('mediumturquoise');
  static const MEDIUM_VIOLET_RED = const Color('mediumvioletred');

  static const MIDNIGHT_BLUE = const Color('midnightblue');
  static const MINT_CREAM = const Color('mintcream');
  static const MISTY_ROSE = const Color('mistyrose');
  static const MOCCASIN = const Color('moccasin');
  static const NAVAJO_WHITE = const Color('navajowhite');
  static const NAVY = const Color('navy');
  static const OLD_LACE = const Color('oldlace');
  static const OLIVE = const Color('olive');
  static const OLIVE_DRAB = const Color('olivedrab');
  static const ORANGE = const Color('orange');
  static const ORANGE_RED = const Color('orangered');
  static const ORCHID = const Color('orchid');
  static const PALE_GOLDENROD = const Color('palegoldenrod');
  static const PALE_GREEN = const Color('palegreen');
  static const PALE_TURQUOISE = const Color('paleturquoise');
  static const PALE_VIOLET_RED = const Color('palevioletred');
  static const PAPAYAWHIP = const Color('papayawhip');
  static const PEACHPUFF = const Color('peachpuff');
  static const PERU = const Color('peru');
  static const PINK = const Color('pink');
  static const PLUM = const Color('plum');
  static const POWDER_BLUE = const Color('powderblue');
  static const PURPLE = const Color('purple');
  static const RED = const Color('red');
  static const ROSY_BROWN = const Color('rosybrown');
  static const ROYAL_BLUE = const Color('royalblue');
  static const SADDLE_BROWN = const Color('saddlebrown');
  static const SALMON = const Color('salmon');
  static const SANDY_BROWN = const Color('sandybrown');
  static const SEA_GREEN = const Color('seagreen');
  static const SEASHELL = const Color('seashell');
  static const SIENNA = const Color('sienna');
  static const SILVER = const Color('silver');
  static const SKY_BLUE = const Color('skyblue');
  static const SLATE_BLUE = const Color('slateblue');
  static const SLATE_GRAY = const Color('slategray');
  static const SLATE_GREY = const Color('slategrey');
  static const SNOW = const Color('snow');
  static const SPRING_GREEN = const Color('springgreen');
  static const STEEL_BLUE = const Color('steelblue');
  static const TAN = const Color('tan');
  static const TEAL = const Color('teal');
  static const THISTLE = const Color('thistle');
  static const TOMATO = const Color('tomato');
  static const TURQUOISE = const Color('turquoise');
  static const VIOLET = const Color('violet');
  static const WHEAT = const Color('wheat');
  static const WHITE = const Color('white');
  static const WHITE_SMOKE = const Color('whitesmoke');
  static const YELLOW = const Color('yellow');
  static const YELLOW_GREEN = const Color('yellowgreen');
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
