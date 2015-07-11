library graphlib.dot;

import 'attr.pb.dart';

const fontNames = const <Font, String>{

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

const colorNames = const <Color, String>{

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

const shapeNames = const <NodeSpec_Shape, String>{

  NodeSpec_Shape.BOX: 'box',
  NodeSpec_Shape.POLYGON: 'polygon',
  NodeSpec_Shape.ELLIPSE: 'ellipse',
  NodeSpec_Shape.OVAL: 'oval',

  NodeSpec_Shape.CIRCLE: 'circle',
  NodeSpec_Shape.POINT: 'point',
  NodeSpec_Shape.EGG: 'egg',
  NodeSpec_Shape.TRIANGLE: 'triangle',

  NodeSpec_Shape.PLAIN_TEXT: 'plaintext',
  NodeSpec_Shape.PLAIN: 'plain',
  NodeSpec_Shape.DIAMOND: 'diamond',
  NodeSpec_Shape.TRAPEZIUM: 'trapezium',

  NodeSpec_Shape.PARALLELOGRAM: 'parallelogram',
  NodeSpec_Shape.HOUSE: 'house',
  NodeSpec_Shape.PENTAGON: 'pentagon',
  NodeSpec_Shape.HEXAGON: 'hexagon',

  NodeSpec_Shape.SEPTAGON: 'septagon',
  NodeSpec_Shape.OCTAGON: 'octagon',
  NodeSpec_Shape.DOUBLE_CIRCLE: 'doublecircle',
  NodeSpec_Shape.DOUBLE_OCTAGON: 'doubleoctagon',

  NodeSpec_Shape.TRIPLE_OCTAGON: 'tripleoctagon',
  NodeSpec_Shape.INV_TRIANGLE: 'invtriangle',
  NodeSpec_Shape.INV_TRAPEZIUM: 'invtrapezium',
  NodeSpec_Shape.INV_HOUSE: 'invhouse',

  NodeSpec_Shape.MDIAMOND: 'Mdiamond',
  NodeSpec_Shape.MSQUARE: 'Msquare',
  NodeSpec_Shape.MCIRCLE: 'Mcircle',
  NodeSpec_Shape.RECT: 'rect',

  NodeSpec_Shape.RECTANGLE: 'rectangle',
  NodeSpec_Shape.SQUARE: 'square',
  NodeSpec_Shape.STAR: 'star',
  NodeSpec_Shape.NONE: 'none'
};

const nodeStyles = const <NodeSpec_Style, String>{

  NodeSpec_Style.SOLID: 'solid',
  NodeSpec_Style.DASHED: 'dashed',
  NodeSpec_Style.DOTTED: 'dotted',
  NodeSpec_Style.BOLD: 'bold',
  NodeSpec_Style.ROUNDED: 'rounded',
  NodeSpec_Style.DIAGONALS: 'diagonals',

  NodeSpec_Style.FILLED: 'filled',
  NodeSpec_Style.STRIPED: 'striped',
  NodeSpec_Style.WEDGED: 'wedged'
};

const edgeStyles = const <EdgeSpec_Style, String>{

  EdgeSpec_Style.SOLID: 'solid',
  EdgeSpec_Style.DASHED: 'dashed',
  EdgeSpec_Style.DOTTED: 'dotted',
  EdgeSpec_Style.BOLD: 'bold'
};

const clusterStyles = const <GraphSpec_Style, String>{

  GraphSpec_Style.SOLID: 'solid',
  GraphSpec_Style.DASHED: 'dashed',
  GraphSpec_Style.DOTTED: 'dotted',
  GraphSpec_Style.BOLD: 'bold',
  GraphSpec_Style.ROUNDED: 'rounded',
  GraphSpec_Style.FILLED: 'filled',
  GraphSpec_Style.STRIPED: 'striped'
};

const dirNames = const <EdgeSpec_Dir, String>{

  EdgeSpec_Dir.BOTH: 'both',
  EdgeSpec_Dir.FORWARD: 'forward',
  EdgeSpec_Dir.BACK: 'back'
};

String compoundArrowShape(EdgeSpec_CompoundArrowShape compound) {
  var aname = '${compound.shape1}${compound.shape2}';
  if (compound.shape3 != null) {
    aname += arrowShapes[compound.shape3];
  }
  if (compound.shape4 != null) {
    aname += arrowShapes[compound.shape4];
  }
  return aname;
}

const arrowShapes = const <EdgeSpec_ArrowShape, String>{
  EdgeSpec_ArrowShape.BOX: 'box',
  EdgeSpec_ArrowShape.CROW: 'crow',
  EdgeSpec_ArrowShape.CURVE: 'curve',
  EdgeSpec_ArrowShape.ICURVE: 'icurve',
  EdgeSpec_ArrowShape.DIAMOND: 'diamond',
  EdgeSpec_ArrowShape.DOT: 'dot',
  EdgeSpec_ArrowShape.INV: 'inv',
  EdgeSpec_ArrowShape.NONE: 'none',
  EdgeSpec_ArrowShape.NORMAL: 'normal',
  EdgeSpec_ArrowShape.TEE: 'tee',
  EdgeSpec_ArrowShape.VEE: 'vee',

  EdgeSpec_ArrowShape.OBOX: 'obox',
  EdgeSpec_ArrowShape.ODIAMOND: 'odiamond',
  EdgeSpec_ArrowShape.ODOT: 'odot',
  EdgeSpec_ArrowShape.OINV: 'oinv',
  EdgeSpec_ArrowShape.ONORMAL: 'onormal'
};

Map<String, String> nodeMap(NodeSpec node) {
  final m = <String, String>{};
  if (node.hasId()) {
    m['id'] = node.id;
  }
  if (node.hasLabel()) {
    m['label'] = node.label;
  }
  if (node.hasFontName()) {
    m['fontname'] = fontNames[node.fontName];
  }
  if (node.hasFontSize()) {
    m['fontsize'] = node.fontSize.toString();
  }
  if (node.hasStyle()) {
    m['style'] = nodeStyles[node.style];
  }
  if (node.hasFillColor()) {
    m['fillcolor'] = colorNames[node.fillColor];
  }
  if (node.hasColor()) {
    m['color'] = colorNames[node.color];
  }
  if (node.hasShape()) {
    m['shape'] = shapeNames[node.shape];
  }
  if (node.hasWidth()) {
    m['width'] = node.width.toString();
  }
  if (node.hasHeight()) {
    m['height'] = node.height.toString();
  }
  if (node.hasPenWidth()) {
    m['penwidth'] = node.penWidth.toString();
  }
  return m;
}

Map<String, String> edgeMap(EdgeSpec edge) {
  final m = <String, String>{};
  if (edge.hasId()) {
    m['id'] = edge.id;
  }
  if (edge.hasHeadLabel()) {
    m['headlabel'] = edge.headLabel;
  }
  if (edge.hasTailLabel()) {
    m['taillabel'] = edge.tailLabel;
  }
  if (edge.hasDir()) {
    m['dir'] = dirNames[edge.dir];
  }
  if (edge.hasArrowHead()) {
    m['arrowhead'] = arrowShapes[edge.arrowHead];
  }
  if (edge.hasArrowTail()) {
    m['arrowtail'] = arrowShapes[edge.arrowTail];
  }
  return m;
}

Map<String, String> graphMap(GraphSpec graph) {
  final m = <String, String>{};
  if (graph.hasLabel()) {
    m['label'] = graph.label;
  }
  if (graph.hasFontName()) {
    m['fontname'] = fontNames[graph.fontName];
  }
  if (graph.hasFontSize()) {
    m['fontsize'] = graph.fontSize.toString();
  }
  if (graph.hasBgColor()) {
    m['bgcolor'] = colorNames[graph.bgColor];
  }
  if (graph.hasColor()) {
    m['color'] = colorNames[graph.color];
  }
  if (graph.hasStyle()) {
    m['style'] = nodeStyles[graph.style];
  }
  if (graph.hasRankDir()) {
    const dirs = const {
      GraphSpec_RankDir.TB: 'TB',
      GraphSpec_RankDir.LR: 'LR'
    };
    m['rankdir'] = dirs[graph.rankDir];
  }
  return m;
}
