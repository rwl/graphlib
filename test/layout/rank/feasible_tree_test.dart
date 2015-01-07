library graphlib.test.layout.rank.feasible_tree;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/rank/feasible_tree.dart';

feasibleTreeTest() {
  group("feasibleTree", () {
    test("creates a tree for a trivial input graph", () {
      var g = new Graph()
        ..setNode("a", { "rank": 0 })
        ..setNode("b", { "rank": 1 })
        ..setEdge("a", "b", { "minlen": 1 });

      var tree = feasibleTree(g);
      expect(g.node("b").rank, equals(g.node("a").rank + 1));
      expect(tree.neighbors("a"), equals(["b"]));
    });

    test("correctly shortens slack by pulling a node up", () {
      var g = new Graph()
        ..setNode("a", { "rank": 0 })
        ..setNode("b", { "rank": 1 })
        ..setNode("c", { "rank": 2 })
        ..setNode("d", { "rank": 2 })
        ..setPath(["a", "b", "c"], { "minlen": 1 })
        ..setEdge("a", "d", { "minlen": 1 });

      var tree = feasibleTree(g);
      expect(g.node("b").rank, equals(g.node("a").rank + 1));
      expect(g.node("c").rank, equals(g.node("b").rank + 1));
      expect(g.node("d").rank, equals(g.node("a").rank + 1));
      expect(tree.neighbors("a"), unorderedEquals(["b", "d"]));
      expect(tree.neighbors("b"), unorderedEquals(["a", "c"]));
      expect(tree.neighbors("c"), equals(["b"]));
      expect(tree.neighbors("d"), equals(["a"]));
    });

    test("correctly shortens slack by pulling a node down", () {
      var g = new Graph()
        ..setNode("a", { "rank": 2 })
        ..setNode("b", { "rank": 0 })
        ..setNode("c", { "rank": 2 })
        ..setEdge("b", "a", { "minlen": 1 })
        ..setEdge("b", "c", { "minlen": 1 });

      var tree = feasibleTree(g);
      expect(g.node("a").rank, equals(g.node("b").rank + 1));
      expect(g.node("c").rank, equals(g.node("b").rank + 1));
      expect(tree.neighbors("a"), unorderedEquals(["b"]));
      expect(tree.neighbors("b"), unorderedEquals(["a", "c"]));
      expect(tree.neighbors("c"), unorderedEquals(["b"]));
    });
  });
}

main() {
  feasibleTreeTest();
}
