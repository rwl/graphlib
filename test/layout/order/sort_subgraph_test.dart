library graphlib.test.layout.order.sort_subgraph;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/order/sort_subgraph.dart' show sortSubgraph;

sortSubgraphTest() {
  group("order sortSubgraph", () {
    Graph g, cg;

    setUp(() {
      g = new Graph(compound: true)
        ..defaultNodeLabelFn = ((v) => {})
        ..defaultEdgeLabelFn = (v, w, n) => { "weight": 1 };
      [0, 1, 2, 3, 4, 5].forEach((v) {
        g.setNode(v, { "order": v });
      });
      cg = new Graph();
    });

    test("sorts a flat subgraph based on barycenter", () {
      g.setEdge(3, "x");
      g.setEdge(1, "y", { "weight": 2 });
      g.setEdge(4, "y");
      ["x", "y"].forEach((v) => g.setParent(v, "movable"));

      expect(sortSubgraph(g, "movable", cg)["vs"], equals(["y", "x"]));
    });

    test("preserves the pos of a node (y) w/o neighbors in a flat subgraph", () {
      g.setEdge(3, "x");
      g.setNode("y");
      g.setEdge(1, "z", { "weight": 2 });
      g.setEdge(4, "z");
      ["x", "y", "z"].forEach((v) => g.setParent(v, "movable"));

      expect(sortSubgraph(g, "movable", cg)["vs"], equals(["z", "y", "x"]));
    });

    test("biases to the left without reverse bias", () {
      g.setEdge(1, "x");
      g.setEdge(1, "y");
      ["x", "y"].forEach((v) => g.setParent(v, "movable"));

      expect(sortSubgraph(g, "movable", cg)["vs"], equals(["x", "y"]));
    });

    test("biases to the right with reverse bias", () {
      g.setEdge(1, "x");
      g.setEdge(1, "y");
      ["x", "y"].forEach((v) => g.setParent(v, "movable"));

      expect(sortSubgraph(g, "movable", cg, true)["vs"], equals(["y", "x"]));
    });

    test("aggregates stats about the subgraph", () {
      g.setEdge(3, "x");
      g.setEdge(1, "y", { "weight": 2 });
      g.setEdge(4, "y");
      ["x", "y"].forEach((v) => g.setParent(v, "movable"));

      var results = sortSubgraph(g, "movable", cg);
      expect(results["barycenter"], equals(2.25));
      expect(results["weight"], equals(4));
    });

    test("can sort a nested subgraph with no barycenter", () {
      g.setNodes(["a", "b", "c"]);
      g.setParent("a", "y");
      g.setParent("b", "y");
      g.setParent("c", "y");
      g.setEdge(0, "x");
      g.setEdge(1, "z");
      g.setEdge(2, "y");
      ["x", "y", "z"].forEach((v) => g.setParent(v, "movable"));

      expect(sortSubgraph(g, "movable", cg)["vs"], equals(["x", "z", "a", "b", "c"]));
    });

    test("can sort a nested subgraph with a barycenter", () {
      g.setNodes(["a", "b", "c"]);
      g.setParent("a", "y");
      g.setParent("b", "y");
      g.setParent("c", "y");
      g.setEdge(0, "a", { "weight": 3 });
      g.setEdge(0, "x");
      g.setEdge(1, "z");
      g.setEdge(2, "y");
      ["x", "y", "z"].forEach((v) => g.setParent(v, "movable"));

      expect(sortSubgraph(g, "movable", cg)["vs"], equals(["x", "a", "b", "c", "z"]));
    });

    test("can sort a nested subgraph with no in-edges", () {
      g.setNodes(["a", "b", "c"]);
      g.setParent("a", "y");
      g.setParent("b", "y");
      g.setParent("c", "y");
      g.setEdge(0, "a");
      g.setEdge(1, "b");
      g.setEdge(0, "x");
      g.setEdge(1, "z");
      ["x", "y", "z"].forEach((v) => g.setParent(v, "movable"));

      expect(sortSubgraph(g, "movable", cg)["vs"], equals(["x", "a", "b", "c", "z"]));
    });

    test("sorts border nodes to the extremes of the subgraph", () {
      g.setEdge(0, "x");
      g.setEdge(1, "y");
      g.setEdge(2, "z");
      g.setNode("sg1", { "borderLeft": "bl", "borderRight": "br" });
      ["x", "y", "z", "bl", "br"].forEach((v) => g.setParent(v, "sg1"));
      expect(sortSubgraph(g, "sg1", cg)["vs"], equals(["bl", "x", "y", "z", "br"]));
    });

    test("assigns a barycenter to a subgraph based on previous border nodes", () {
      g.setNode("bl1", { "order": 0 });
      g.setNode("br1", { "order": 1 });
      g.setEdge("bl1", "bl2");
      g.setEdge("br1", "br2");
      ["bl2", "br2"].forEach((v) => g.setParent(v, "sg"));
      g.setNode("sg", { "borderLeft": "bl2", "borderRight": "br2" });
      expect(sortSubgraph(g, "sg", cg), equals({
        "barycenter": 0.5,
        "weight": 2,
        "vs": ["bl2", "br2"]
      }));
    });
  });

}

main() {
  sortSubgraphTest();
}
