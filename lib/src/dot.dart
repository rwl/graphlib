library graphlib.dot.util;

import 'attr.pb.dart';

const Map<Font, String> fontNames = const {

  Font.AVANTGARDE_BOOK: 'AvantGarde-Book',
  Font.AVANTGARDE_BOOK_OBLIQUE: 'AvantGarde-BookOblique',
  Font.AVANTGARDE_DEMI: 'AvantGarde-Demi',
  Font.AVANTGARDE_DEMI_OBLIQUE: 'AvantGarde-DemiOblique',

  Font.BOOKMAN_DEMI: 'Bookman-Demi',
  Font.BOOKMAN_DEMI_ITALIC: 'Bookman-DemiItalic',
  Font.BOOKMAN_LIGHT: 'Bookman-Light',
  Font.BOOKMAN_LIGHT_ITALIC: 'Bookman-LightItalic',

  Font.COURIER: 'Courier',
  Font.COURIER_BOLD: 'Courier-Bold',
  Font.COURIER_BOLD_OBLIQUE: 'Courier-BoldOblique',
  Font.COURIER_OBLIQUE: 'Courier-Oblique',

  Font.HELVETICA: 'Helvetica',
  Font.HELVETICA_BOLD: 'Helvetica-Bold',
  Font.HELVETICA_BOLD_OBLIQUE: 'Helvetica-BoldOblique',
  Font.HELVETICA_NARROW: 'Helvetica-Narrow',
  Font.HELVETICA_NARROW_BOLD: 'Helvetica-Narrow-Bold',
  Font.HELVETICA_NARROW_BOLD_OBLIQUE: 'Helvetica-Narrow-BoldOblique',
  Font.HELVETICA_NARROW_OBLIQUE: 'Helvetica-Narrow-Oblique',
  Font.HELVETICA_OBLIQUE: 'Helvetica-Oblique',

  Font.NEWCENTURYSCHLBK_BOLD: 'NewCenturySchlbk-Bold',
  Font.NEWCENTURYSCHLBK_BOLD_ITALIC: 'NewCenturySchlbk-BoldItalic',
  Font.NEWCENTURYSCHLBK_ITALIC: 'NewCenturySchlbk-Italic',
  Font.NEWCENTURYSCHLBK_ROMAN: 'NewCenturySchlbk-Roman',

  Font.PALATINO_BOLD: 'Palatino-Bold',
  Font.PALATINO_BOLD_ITALIC: 'Palatino-BoldItalic',
  Font.PALATINO_ITALIC: 'Palatino-Italic',
  Font.PALATINO_ROMAN: 'Palatino-Roman',

  Font.SYMBOL: 'Symbol',

  Font.TIMES_BOLD: 'Times-Bold',
  Font.TIMES_BOLD_ITALIC: 'Times-BoldItalic',
  Font.TIMES_ITALIC: 'Times-Italic',
  Font.TIMES_ROMAN: 'Times-Roman',

  Font.ZAPFCHANCERY_MEDIUM_ITALIC: 'ZapfChancery-MediumItalic',
  Font.ZAPFDINGBATS: 'ZapfDingbats'
};

const Map<Color, String> colorNames = const {

  Color.ALICE_BLUE: 'aliceblue',
  Color.ANTIQUE_WHITE: 'antiquewhite',
  Color.AQUA: 'aqua',
  Color.AQUAMARINE: 'aquamarine',
  Color.AZURE: 'azure',
  Color.BEIGE: 'beige',
  Color.BISQUE: 'bisque',
  Color.BLACK: 'black',
  Color.BLANCHED_ALMOND: 'blanchedalmond',
  Color.BLUE: 'blue',
  Color.BLUE_VIOLET: 'blueviolet',
  Color.BROWN: 'brown',
  Color.BURLYWOOD: 'burlywood',
  Color.CADET_BLUE: 'cadetblue',
  Color.CHARTREUSE: 'chartreuse',
  Color.CHOCOLATE: 'chocolate',
  Color.CORAL: 'coral',
  Color.CORNFLOWER_BLUE: 'cornflowerblue',
  Color.CORNSILK: 'cornsilk',
  Color.CRIMSON: 'crimson',
  Color.CYAN: 'cyan',

  Color.DARK_BLUE: 'darkblue',
  Color.DARK_CYAN: 'darkcyan',
  Color.DARK_GOLDENROD: 'darkgoldenrod',
  Color.DARK_GRAY: 'darkgray',
  Color.DARK_GREEN: 'darkgreen',
  Color.DARK_GREY: 'darkgrey',
  Color.DARK_KHAKI: 'darkkhaki',
  Color.DARK_MAGENTA: 'darkmagenta',
  Color.DARK_OLIVE_GREEN: 'darkolivegreen',
  Color.DARK_ORANGE: 'darkorange',
  Color.DARK_ORCHID: 'darkorchid',
  Color.DARK_RED: 'darkred',
  Color.DARK_SALMON: 'darksalmon',
  Color.DARK_SEA_GREEN: 'darkseagreen',
  Color.DARK_SLATE_BLUE: 'darkslateblue',
  Color.DARK_SLATE_GRAY: 'darkslategray',
  Color.DARK_SLATE_GREY: 'darkslategrey',
  Color.DARK_TURQUOISE: 'darkturquoise',
  Color.DARK_VIOLET: 'darkviolet',

  Color.DEEP_PINK: 'deeppink',
  Color.DEEP_SKY_BLUE: 'deepskyblue',
  Color.DIM_GRAY: 'dimgray',
  Color.DIM_GREY: 'dimgrey',
  Color.DODGER_BLUE: 'dodgerblue',
  Color.FIREBRICK: 'firebrick',
  Color.FLORAL_WHITE: 'floralwhite',
  Color.FOREST_GREEN: 'forestgreen',
  Color.FUCHSIA: 'fuchsia',
  Color.GAINSBORO: 'gainsboro',
  Color.GHOST_WHITE: 'ghostwhite',
  Color.GOLD: 'gold',
  Color.GOLDENROD: 'goldenrod',
  Color.GRAY: 'gray',
  Color.GREY: 'grey',
  Color.GREEN: 'green',
  Color.GREEN_YELLOW: 'greenyellow',
  Color.HONEYDEW: 'honeydew',
  Color.HOT_PINK: 'hotpink',
  Color.INDIAN_RED: 'indianred',
  Color.INDIGO: 'indigo',
  Color.IVORY: 'ivory',
  Color.KHAKI: 'khaki',
  Color.LAVENDER: 'lavender',
  Color.LAVENDERBLUSH: 'lavenderblush',
  Color.LAWN_GREEN: 'lawngreen',
  Color.LEMON_CHIFFON: 'lemonchiffon',

  Color.LIGHT_BLUE: 'lightblue',
  Color.LIGHT_CORAL: 'lightcoral',
  Color.LIGHT_CYAN: 'lightcyan',
  Color.LIGHT_GOLDENRODYELLOW: 'lightgoldenrodyellow',
  Color.LIGHT_GRAY: 'lightgray',
  Color.LIGHT_GREEN: 'lightgreen',
  Color.LIGHT_GREY: 'lightgrey',
  Color.LIGHT_PINK: 'lightpink',
  Color.LIGHT_SALMON: 'lightsalmon',
  Color.LIGHT_SEA_GREEN: 'lightseagreen',
  Color.LIGHT_SKY_BLUE: 'lightskyblue',
  Color.LIGHT_SLATE_GRAY: 'lightslategray',
  Color.LIGHT_SLATE_GREY: 'lightslategrey',
  Color.LIGHT_STEEL_BLUE: 'lightsteelblue',
  Color.LIGHT_YELLOW: 'lightyellow',
  Color.LIME: 'lime',
  Color.LIME_GREEN: 'limegreen',
  Color.LINEN: 'linen',
  Color.MAGENTA: 'magenta',
  Color.MAROON: 'maroon',

  Color.MEDIUM_AQUAMARINE: 'mediumaquamarine',
  Color.MEDIUM_BLUE: 'mediumblue',
  Color.MEDIUM_ORCHID: 'mediumorchid',
  Color.MEDIUM_PURPLE: 'mediumpurple',
  Color.MEDIUM_SEA_GREEN: 'mediumseagreen',
  Color.MEDIUM_SLATE_BLUE: 'mediumslateblue',
  Color.MEDIUM_SPRING_GREEN: 'mediumspringgreen',
  Color.MEDIUM_TURQUOISE: 'mediumturquoise',
  Color.MEDIUM_VIOLET_RED: 'mediumvioletred',

  Color.MIDNIGHT_BLUE: 'midnightblue',
  Color.MINT_CREAM: 'mintcream',
  Color.MISTY_ROSE: 'mistyrose',
  Color.MOCCASIN: 'moccasin',
  Color.NAVAJO_WHITE: 'navajowhite',
  Color.NAVY: 'navy',
  Color.OLD_LACE: 'oldlace',
  Color.OLIVE: 'olive',
  Color.OLIVE_DRAB: 'olivedrab',
  Color.ORANGE: 'orange',
  Color.ORANGE_RED: 'orangered',
  Color.ORCHID: 'orchid',
  Color.PALE_GOLDENROD: 'palegoldenrod',
  Color.PALE_GREEN: 'palegreen',
  Color.PALE_TURQUOISE: 'paleturquoise',
  Color.PALE_VIOLET_RED: 'palevioletred',
  Color.PAPAYAWHIP: 'papayawhip',
  Color.PEACHPUFF: 'peachpuff',
  Color.PERU: 'peru',
  Color.PINK: 'pink',
  Color.PLUM: 'plum',
  Color.POWDER_BLUE: 'powderblue',
  Color.PURPLE: 'purple',
  Color.RED: 'red',
  Color.ROSY_BROWN: 'rosybrown',
  Color.ROYAL_BLUE: 'royalblue',
  Color.SADDLE_BROWN: 'saddlebrown',
  Color.SALMON: 'salmon',
  Color.SANDY_BROWN: 'sandybrown',
  Color.SEA_GREEN: 'seagreen',
  Color.SEASHELL: 'seashell',
  Color.SIENNA: 'sienna',
  Color.SILVER: 'silver',
  Color.SKY_BLUE: 'skyblue',
  Color.SLATE_BLUE: 'slateblue',
  Color.SLATE_GRAY: 'slategray',
  Color.SLATE_GREY: 'slategrey',
  Color.SNOW: 'snow',
  Color.SPRING_GREEN: 'springgreen',
  Color.STEEL_BLUE: 'steelblue',
  Color.TAN: 'tan',
  Color.TEAL: 'teal',
  Color.THISTLE: 'thistle',
  Color.TOMATO: 'tomato',
  Color.TURQUOISE: 'turquoise',
  Color.VIOLET: 'violet',
  Color.WHEAT: 'wheat',
  Color.WHITE: 'white',
  Color.WHITE_SMOKE: 'whitesmoke',
  Color.YELLOW: 'yellow',
  Color.YELLOW_GREEN: 'yellowgreen',
};

const Map<NodeAttributes_Shape, String> shapeNames = const {

  NodeAttributes_Shape.BOX: 'box',
  NodeAttributes_Shape.POLYGON: 'polygon',
  NodeAttributes_Shape.ELLIPSE: 'ellipse',
  NodeAttributes_Shape.OVAL: 'oval',

  NodeAttributes_Shape.CIRCLE: 'circle',
  NodeAttributes_Shape.POINT: 'point',
  NodeAttributes_Shape.EGG: 'egg',
  NodeAttributes_Shape.TRIANGLE: 'triangle',

  NodeAttributes_Shape.PLAIN_TEXT: 'plaintext',
  NodeAttributes_Shape.PLAIN: 'plain',
  NodeAttributes_Shape.DIAMOND: 'diamond',
  NodeAttributes_Shape.TRAPEZIUM: 'trapezium',

  NodeAttributes_Shape.PARALLELOGRAM: 'parallelogram',
  NodeAttributes_Shape.HOUSE: 'house',
  NodeAttributes_Shape.PENTAGON: 'pentagon',
  NodeAttributes_Shape.HEXAGON: 'hexagon',

  NodeAttributes_Shape.SEPTAGON: 'septagon',
  NodeAttributes_Shape.OCTAGON: 'octagon',
  NodeAttributes_Shape.DOUBLE_CIRCLE: 'doublecircle',
  NodeAttributes_Shape.DOUBLE_OCTAGON: 'doubleoctagon',

  NodeAttributes_Shape.TRIPLE_OCTAGON: 'tripleoctagon',
  NodeAttributes_Shape.INV_TRIANGLE: 'invtriangle',
  NodeAttributes_Shape.INV_TRAPEZIUM: 'invtrapezium',
  NodeAttributes_Shape.INV_HOUSE: 'invhouse',

  NodeAttributes_Shape.MDIAMOND: 'Mdiamond',
  NodeAttributes_Shape.MSQUARE: 'Msquare',
  NodeAttributes_Shape.MCIRCLE: 'Mcircle',
  NodeAttributes_Shape.RECT: 'rect',

  NodeAttributes_Shape.RECTANGLE: 'rectangle',
  NodeAttributes_Shape.SQUARE: 'square',
  NodeAttributes_Shape.STAR: 'star',
  NodeAttributes_Shape.NONE: 'none'
};

const Map<NodeAttributes_Style, String> nodeStyles = const {

  NodeAttributes_Style.SOLID: 'solid',
  NodeAttributes_Style.DASHED: 'dashed',
  NodeAttributes_Style.DOTTED: 'dotted',
  NodeAttributes_Style.BOLD: 'bold',
  NodeAttributes_Style.ROUNDED: 'rounded',
  NodeAttributes_Style.DIAGONALS: 'diagonals',

  NodeAttributes_Style.FILLED: 'filled',
  NodeAttributes_Style.STRIPED: 'striped',
  NodeAttributes_Style.WEDGED: 'wedged'
};

const Map<EdgeAttributes_Style, String> edgeStyles = const {

  EdgeAttributes_Style.SOLID: 'solid',
  EdgeAttributes_Style.DASHED: 'dashed',
  EdgeAttributes_Style.DOTTED: 'dotted',
  EdgeAttributes_Style.BOLD: 'bold'
};

const Map<GraphAttributes_Style, String> clusterStyles = const {

  GraphAttributes_Style.SOLID: 'solid',
  GraphAttributes_Style.DASHED: 'dashed',
  GraphAttributes_Style.DOTTED: 'dotted',
  GraphAttributes_Style.BOLD: 'bold',
  GraphAttributes_Style.ROUNDED: 'rounded',
  GraphAttributes_Style.FILLED: 'filled',
  GraphAttributes_Style.STRIPED: 'striped'
};

const Map<EdgeAttributes_Dir, String> dirNames = const {

  EdgeAttributes_Dir.BOTH: 'both',
  EdgeAttributes_Dir.FORWARD: 'forward',
  EdgeAttributes_Dir.BACK: 'back'
};

String compoundArrowShape(EdgeAttributes_CompoundArrowShape compound) {
  var aname = '${compound.shape1}${compound.shape2}';
  if (compound.shape3 != null) {
    aname += arrowShapes[compound.shape3];
  }
  if (compound.shape4 != null) {
    aname += arrowShapes[compound.shape4];
  }
  return aname;
}

const Map<EdgeAttributes_ArrowShape, String> arrowShapes = const {
  EdgeAttributes_ArrowShape.BOX: 'box',
  EdgeAttributes_ArrowShape.CROW: 'crow',
  EdgeAttributes_ArrowShape.CURVE: 'curve',
  EdgeAttributes_ArrowShape.ICURVE: 'icurve',
  EdgeAttributes_ArrowShape.DIAMOND: 'diamond',
  EdgeAttributes_ArrowShape.DOT: 'dot',
  EdgeAttributes_ArrowShape.INV: 'inv',
  EdgeAttributes_ArrowShape.NONE: 'none',
  EdgeAttributes_ArrowShape.NORMAL: 'normal',
  EdgeAttributes_ArrowShape.TEE: 'tee',
  EdgeAttributes_ArrowShape.VEE: 'vee',

  EdgeAttributes_ArrowShape.OBOX: 'obox',
  EdgeAttributes_ArrowShape.ODIAMOND: 'odiamond',
  EdgeAttributes_ArrowShape.ODOT: 'odot',
  EdgeAttributes_ArrowShape.OINV: 'oinv',
  EdgeAttributes_ArrowShape.ONORMAL: 'onormal'
};

Map<String, String> nodeMap(NodeAttributes attr) {
  final m = <String, String>{};
  if (attr.hasId()) {
    m['id'] = attr.id;
  }
  if (attr.hasLabel()) {
    m['label'] = attr.label;
  }
  if (attr.hasFontName()) {
    m['fontname'] = fontNames[attr.fontName];
  }
  if (attr.hasFontSize()) {
    m['fontsize'] = attr.fontSize.toString();
  }
  if (attr.hasStyle()) {
    m['style'] = nodeStyles[attr.style];
  }
  if (attr.hasFillColor()) {
    m['fillcolor'] = colorNames[attr.fillColor];
  }
  if (attr.hasColor()) {
    m['color'] = colorNames[attr.color];
  }
  if (attr.hasShape()) {
    m['shape'] = shapeNames[attr.shape];
  }
  if (attr.hasWidth()) {
    m['width'] = attr.width.toString();
  }
  if (attr.hasHeight()) {
    m['height'] = attr.height.toString();
  }
  if (attr.hasPenWidth()) {
    m['penwidth'] = attr.penWidth.toString();
  }
  return m;
}

Map<String, String> edgeMap(EdgeAttributes attr) {
  final m = <String, String>{};
  if (attr.hasId()) {
    m['id'] = attr.id;
  }
  if (attr.hasHeadLabel()) {
    m['headlabel'] = attr.headLabel;
  }
  if (attr.hasTailLabel()) {
    m['taillabel'] = attr.tailLabel;
  }
  if (attr.hasDir()) {
    m['dir'] = dirNames[attr.dir];
  }
  if (attr.hasArrowHead()) {
    m['arrowhead'] = arrowShapes[attr.arrowHead];
  }
  if (attr.hasArrowTail()) {
    m['arrowtail'] = arrowShapes[attr.arrowTail];
  }
  return m;
}

Map<String, String> graphMap(GraphAttributes attr) {
  final m = <String, String>{};
  if (attr.hasLabel()) {
    m['label'] = attr.label;
  }
  if (attr.hasFontName()) {
    m['fontname'] = fontNames[attr.fontName];
  }
  if (attr.hasFontSize()) {
    m['fontsize'] = attr.fontSize.toString();
  }
  if (attr.hasBgColor()) {
    m['bgcolor'] = colorNames[attr.bgColor];
  }
  if (attr.hasColor()) {
    m['color'] = colorNames[attr.color];
  }
  if (attr.hasStyle()) {
    m['style'] = clusterStyles[attr.style];
  }
  if (attr.hasRankDir()) {
    const dirs = const {
      GraphAttributes_RankDir.TB: 'TB',
      GraphAttributes_RankDir.LR: 'LR'
    };
    m['rankdir'] = dirs[attr.rankDir];
  }
  return m;
}
