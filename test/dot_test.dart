library graphlib.test.dot;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart';

dotTest() {
  group("dot", () {
    test("cluster", () {
      var g = new Graph(directed: true, compound: true);

      var attr = new NodeAttributes()
        ..style = NodeAttributes_Style.FILLED
        ..color = Color.WHITE;
      var parent = 'cluster_0';
      for (var i = 0; i < 4; i++) {
        var v = 'a$i';
        g.setNode(v, nodeMap(attr));
        g.setParent(v, parent);
      }
      attr = new GraphAttributes()
        ..style = GraphAttributes_Style.FILLED
        ..color = Color.LIGHT_GREY
        ..label = 'process #1';
      g.setNode(parent, graphMap(attr));

      attr = new NodeAttributes()
        ..style = NodeAttributes_Style.FILLED
        ..color = Color.LIGHT_GREY;
      parent = 'cluster_1';
      for (var i = 0; i < 4; i++) {
        var v = 'b$i';
        g.setNode(v, nodeMap(attr));
        g.setParent(v, parent);
      }
      attr = new GraphAttributes()
        ..color = Color.BLUE
        ..label = 'process #1';
      g.setNode(parent, graphMap(attr));

      g.setEdge('start', 'a0');
      g.setEdge('start', 'b0');
      g.setEdge('a1', 'b3');
      g.setEdge('b2', 'a3');
      g.setEdge('a3', 'a0');
      g.setEdge('a3', 'end');
      g.setEdge('b3', 'end');

      var a = new NodeAttributes();
      a.shape = NodeAttributes_Shape.MDIAMOND;
      g.setNode('start', nodeMap(a));
      a.shape = NodeAttributes_Shape.MSQUARE;
      g.setNode('end', nodeMap(a));

      var str = writeDot(g);
      logMessage(str);
    });
  });
}

main() => dotTest();
