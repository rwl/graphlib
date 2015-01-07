library graphlib.test.layout.rank;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/rank/rank.dart' show rank;

rankTest() {
  group("rank", () {
    var RANKERS = [
          "longest-path", "tight-tree",
          "network-simplex", "unknown-should-still-work"
        ];
    Graph g;

    setUp(() {
      g = new Graph()
        ..setGraph({})
        ..defaultNodeLabelFn = ((v) => {})
        ..defaultEdgeLabelFn = ((v, w, n) => { "minlen": 1, "weight": 1 })
        ..setPath(["a", "b", "c", "d", "h"])
        ..setPath(["a", "e", "g", "h"])
        ..setPath(["a", "f", "g"]);
    });

    RANKERS.forEach((ranker) {
      group(ranker, () {
        test("respects the minlen attribute", () {
          g.graph()["ranker"] = ranker;
          rank(g);
          g.edges.forEach((e) {
            var vRank = g.node(e.v).rank,
                wRank = g.node(e.w).rank;
            expect(wRank - vRank, greaterThanOrEqualTo(g.edgeObj(e)["minlen"]));
          });
        });

        test("can rank a single node graph", () {
          var g = new Graph()
            ..setGraph({"ranker": ranker})
            ..setNode("a", {});
          rank(g);
          expect(g.node("a").rank, equals(0));
        });
      });
    });
  });
}

main() {
  rankTest();
}
