import 'dart:html';

import 'package:graphviz/graphviz.dart';
import 'package:graphlib/graphlib.dart';

main() {
  var g = new Graph(directed: true, compound: true);

  var attr = new NodeAttr()
    ..style = NodeStyle.FILLED
    ..color = Color.WHITE;
  var parent = 'cluster_0';
  for (var i = 0; i < 4; i++) {
    var v = 'a$i';
    g.setNode(v, attr.toMap());
    g.setParent(v, parent);
    if (i != 0) {
      g.setEdge('a${i-1}', v);
    }
  }
  attr = new GraphAttr()
    ..style = ClusterStyle.FILLED
    ..color = Color.LIGHT_GREY
    ..label = 'process #1';
  g.setNode(parent, attr.toMap());

  attr = new NodeAttr()
    ..style = NodeStyle.FILLED
    ..color = Color.LIGHT_GREY;
  parent = 'cluster_1';
  for (var i = 0; i < 4; i++) {
    var v = 'b$i';
    g.setNode(v, attr.toMap());
    g.setParent(v, parent);
    if (i != 0) {
      g.setEdge('b${i-1}', v);
    }
  }
  attr = new GraphAttr()
    ..color = Color.BLUE
    ..label = 'process #1';
  g.setNode(parent, attr.toMap());

  g.setEdge('start', 'a0');
  g.setEdge('start', 'b0');
  g.setEdge('a1', 'b3');
  g.setEdge('b2', 'a3');
  g.setEdge('a3', 'a0');
  g.setEdge('a3', 'end');
  g.setEdge('b3', 'end');

  var a = new NodeAttr();
  a.shape = Shape.MDIAMOND;
  g.setNode('start', a.toMap());
  a.shape = Shape.MSQUARE;
  g.setNode('end', a.toMap());

  var gv = new Graphviz();
  gv.layout(writeDot(g)).then((result) {
    var doc = new DomParser().parseFromString(result, 'text/xml');
    var node = document.importNode(doc.documentElement, true);
    document.body.append(node);
  });
}
