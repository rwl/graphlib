library graphlib.test.layout.rank;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/rank/util.dart';
import 'package:graphlib/src/layout/util.dart' show normalizeRanks;

utilTest() {
  group("rank/util", () {
    group("longestPath", () {
      Graph g;

      setUp(() {
        g = new Graph()
          ..defaultNodeLabelFn = ((v) => {})
          ..defaultEdgeLabelFn = (v, w, n) => { "minlen": 1 };
      });

      test("can assign a rank to a single node graph", () {
        g.setNode("a");
        longestPath(g);
        normalizeRanks(g);
        expect(g.node("a").rank, equals(0));
      });

      test("can assign ranks to unconnected nodes", () {
        g.setNode("a");
        g.setNode("b");
        longestPath(g);
        normalizeRanks(g);
        expect(g.node("a").rank, equals(0));
        expect(g.node("b").rank, equals(0));
      });

      test("can assign ranks to connected nodes", () {
        g.setEdge("a", "b");
        longestPath(g);
        normalizeRanks(g);
        expect(g.node("a").rank, equals(0));
        expect(g.node("b").rank, equals(1));
      });

      test("can assign ranks for a diamond", () {
        g.setPath(["a", "b", "d"]);
        g.setPath(["a", "c", "d"]);
        longestPath(g);
        normalizeRanks(g);
        expect(g.node("a").rank, equals(0));
        expect(g.node("b").rank, equals(1));
        expect(g.node("c").rank, equals(1));
        expect(g.node("d").rank, equals(2));
      });

      test("uses the minlen attribute on the edge", () {
        g.setPath(["a", "b", "d"]);
        g.setEdge("a", "c");
        g.setEdge("c", "d", { "minlen": 2 });
        longestPath(g);
        normalizeRanks(g);
        expect(g.node("a").rank, equals(0));
        // longest path biases towards the lowest rank it can assign
        expect(g.node("b").rank, equals(2));
        expect(g.node("c").rank, equals(1));
        expect(g.node("d").rank, equals(3));
      });
    });
  });
}

main() {
  utilTest();
}
