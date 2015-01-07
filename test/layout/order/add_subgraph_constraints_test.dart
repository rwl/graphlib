library graphlib.test.layout.order.add_subgraph_constraints;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/order/add_subgraph_constraints.dart' show addSubgraphConstraints;

addSubgraphConstraintsTest() {
  group("order/addSubgraphConstraints", () {
    Graph g, cg;

    setUp(() {
      g = new Graph(compound: true);
      cg = new Graph();
    });

    test("does not change CG for a flat set of nodes", () {
      var vs = ["a", "b", "c", "d"];
      vs.forEach((v) => g.setNode(v));
      addSubgraphConstraints(g, cg, vs);
      expect(cg.nodeCount, equals(0));
      expect(cg.edgeCount, equals(0));
    });

    test("doesn't create a constraint for contiguous subgraph nodes", () {
      var vs = ["a", "b", "c"];
      vs.forEach((v) {
        g.setParent(v, "sg");
      });
      addSubgraphConstraints(g, cg, vs);
      expect(cg.nodeCount, equals(0));
      expect(cg.edgeCount, equals(0));
    });

    test("adds a constraint when the parents for adjacent nodes are different", () {
      var vs = ["a", "b"];
      g.setParent("a", "sg1");
      g.setParent("b", "sg2");
      addSubgraphConstraints(g, cg, vs);
      expect(cg.edges, equals([{ "v": "sg1", "w": "sg2" }]));
    });

    test("works for multiple levels", () {
      var vs = ["a", "b", "c", "d", "e", "f", "g", "h"];
      vs.forEach((v) {
        g.setNode(v);
      });
      g.setParent("b", "sg2");
      g.setParent("sg2", "sg1");
      g.setParent("c", "sg1");
      g.setParent("d", "sg3");
      g.setParent("sg3", "sg1");
      g.setParent("f", "sg4");
      g.setParent("g", "sg5");
      g.setParent("sg5", "sg4");
      addSubgraphConstraints(g, cg, vs);
      expect(cg.edges, unorderedEquals([
        { "v": "sg1", "w": "sg4" },
        { "v": "sg2", "w": "sg3" }
      ]));
    });
  });
}

main() {
  addSubgraphConstraintsTest();
}
