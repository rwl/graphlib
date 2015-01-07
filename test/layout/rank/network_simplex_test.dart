library graphlib.test.layout.rank.network_simplex;

import "package:unittest/unittest.dart";
import "package:graphlib/graphlib.dart" show Graph, Edge;
import "package:graphlib/src/layout/rank/network_simplex.dart";
import "package:graphlib/src/layout/rank/util.dart" show longestPath;
import "package:graphlib/src/layout/util.dart" show normalizeRanks, range;

networkSimplexTest() {
  group("network simplex", () {
    Graph g, t, gansnerGraph, gansnerTree;

    setUp(() {
      g = new Graph(multigraph: true)
        ..defaultNodeLabelFn = ((v) => {})
        ..defaultEdgeLabelFn = (v, w, n) => { "minlen": 1, "weight": 1 };

      t = new Graph(directed: false)
        ..defaultNodeLabelFn = ((v) => {})
        ..defaultEdgeLabelFn = (v, w, n) => {};

      gansnerGraph = new Graph()
        ..defaultNodeLabelFn = ((v) => {})
        ..defaultEdgeLabelFn = ((v, w, n) => { "minlen": 1, "weight": 1 })
        ..setPath(["a", "b", "c", "d", "h"])
        ..setPath(["a", "e", "g", "h"])
        ..setPath(["a", "f", "g"]);

      gansnerTree = new Graph(directed: false)
        ..defaultNodeLabelFn = ((v) => {})
        ..defaultEdgeLabelFn = ((v, w, n) => {})
        ..setPath(["a", "b", "c", "d", "h", "g", "e"])
        ..setEdge("g", "f");
    });

    test("can assign a rank to a single node", () {
      g.setNode("a");
      ns(g);
      expect(g.node("a").rank, equals(0));
    });

    test("can assign a rank to a 2-node connected graph", () {
      g.setEdge("a", "b");
      ns(g);
      expect(g.node("a").rank, equals(0));
      expect(g.node("b").rank, equals(1));
    });

    test("can assign ranks for a diamond", () {
      g.setPath(["a", "b", "d"]);
      g.setPath(["a", "c", "d"]);
      ns(g);
      expect(g.node("a").rank, equals(0));
      expect(g.node("b").rank, equals(1));
      expect(g.node("c").rank, equals(1));
      expect(g.node("d").rank, equals(2));
    });

    test("uses the minlen attribute on the edge", () {
      g.setPath(["a", "b", "d"]);
      g.setEdge("a", "c");
      g.setEdge("c", "d", { "minlen": 2 });
      ns(g);
      expect(g.node("a").rank, equals(0));
      // longest path biases towards the lowest rank it can assign. Since the
      // graph has no optimization opportunities we can assume that the longest
      // path ranking is used.
      expect(g.node("b").rank, equals(2));
      expect(g.node("c").rank, equals(1));
      expect(g.node("d").rank, equals(3));
    });

    test("can rank the gansner graph", () {
      g = gansnerGraph;
      ns(g);
      expect(g.node("a").rank, equals(0));
      expect(g.node("b").rank, equals(1));
      expect(g.node("c").rank, equals(2));
      expect(g.node("d").rank, equals(3));
      expect(g.node("h").rank, equals(4));
      expect(g.node("e").rank, equals(1));
      expect(g.node("f").rank, equals(1));
      expect(g.node("g").rank, equals(2));
    });

    test("can handle multi-edges", () {
      g.setPath(["a", "b", "c", "d"]);
      g.setEdge("a", "e", { "weight": 2, "minlen": 1 });
      g.setEdge("e", "d");
      g.setEdge("b", "c", { "weight": 1, "minlen": 2 }, "multi");
      ns(g);
      expect(g.node("a").rank, equals(0));
      expect(g.node("b").rank, equals(1));
      // b -> c has minlen = 1 and minlen = 2, so it should be 2 ranks apart.
      expect(g.node("c").rank, equals(3));
      expect(g.node("d").rank, equals(4));
      expect(g.node("e").rank, equals(1));
    });

    group("leaveEdge", () {
      test("returns undefined if there is no edge with a negative cutvalue", () {
        var tree = new Graph(directed: false);
        tree.setEdge("a", "b", { "cutvalue": 1 });
        tree.setEdge("b", "c", { "cutvalue": 1 });
        expect(leaveEdge(tree), isNull);
      });

      test("returns an edge if one is found with a negative cutvalue", () {
        var tree = new Graph(directed: false);
        tree.setEdge("a", "b", { "cutvalue": 1 });
        tree.setEdge("b", "c", { "cutvalue": -1 });
        expect(leaveEdge(tree), equals({ "v": "b", "w": "c" }));
      });
    });

    group("enterEdge", () {
      test("finds an edge from the head to tail component", () {
        g
          ..setNode("a", { "rank": 0 })
          ..setNode("b", { "rank": 2 })
          ..setNode("c", { "rank": 3 })
          ..setPath(["a", "b", "c"])
          ..setEdge("a", "c");
        t.setPath(["b", "c", "a"]);
        initLowLimValues(t, "c");

        var f = enterEdge(t, g, new Edge("b", "c"));
        expect(undirectedEdge(f), equals(undirectedEdge({ "v": "a", "w": "b" })));
      });

      test("works when the root of the tree is in the tail component", () {
        g
          ..setNode("a", { "rank": 0 })
          ..setNode("b", { "rank": 2 })
          ..setNode("c", { "rank": 3 })
          ..setPath(["a", "b", "c"])
          ..setEdge("a", "c");
        t.setPath(["b", "c", "a"]);
        initLowLimValues(t, "b");

        var f = enterEdge(t, g, new Edge("b", "c"));
        expect(undirectedEdge(f), equals(undirectedEdge({ "v": "a", "w": "b" })));
      });

      test("finds the edge with the least slack", () {
        g
          ..setNode("a", { "rank": 0 })
          ..setNode("b", { "rank": 1 })
          ..setNode("c", { "rank": 3 })
          ..setNode("d", { "rank": 4 })
          ..setEdge("a", "d")
          ..setPath(["a", "c", "d"])
          ..setEdge("b", "c");
        t.setPath(["c", "d", "a", "b"]);
        initLowLimValues(t, "a");

        var f = enterEdge(t, g, new Edge("c", "d"));
        expect(undirectedEdge(f), equals(undirectedEdge({ "v": "b", "w": "c" })));
      });

      test("finds an appropriate edge for gansner graph #1", () {
        g = gansnerGraph;
        t = gansnerTree;
        longestPath(g);
        initLowLimValues(t, "a");

        var f = enterEdge(t, g, new Edge("g", "h"));
        expect(undirectedEdge(f).v, equals("a"));
        expect(["e", "f"], contains(undirectedEdge(f).w));
      });

      test("finds an appropriate edge for gansner graph #2", () {
        g = gansnerGraph;
        t = gansnerTree;
        longestPath(g);
        initLowLimValues(t, "e");

        var f = enterEdge(t, g, new Edge("g", "h"));
        expect(undirectedEdge(f).v, equals("a"));
        expect(["e", "f"], contains(undirectedEdge(f).w));
      });

      test("finds an appropriate edge for gansner graph #3", () {
        g = gansnerGraph;
        t = gansnerTree;
        longestPath(g);
        initLowLimValues(t, "a");

        var f = enterEdge(t, g, new Edge("h", "g"));
        expect(undirectedEdge(f).v, equals("a"));
        expect(["e", "f"], contains(undirectedEdge(f).w));
      });

      test("finds an appropriate edge for gansner graph #4", () {
        g = gansnerGraph;
        t = gansnerTree;
        longestPath(g);
        initLowLimValues(t, "e");

        var f = enterEdge(t, g, new Edge("h", "g"));
        expect(undirectedEdge(f).v, equals("a"));
        expect(["e", "f"], contains(undirectedEdge(f).w));
      });
    });

    group("initLowLimValues", () {
      test("assigns low, lim, and parent for each node in a tree", () {
        var g = new Graph()
          ..defaultNodeLabelFn = ((v) => {})
          ..setNodes(["a", "b", "c", "d", "e"])
          ..setPath(["a", "b", "a", "c", "d", "c", "e"]);

        initLowLimValues(g, "a");

        var a = g.node("a"),
            b = g.node("b"),
            c = g.node("c"),
            d = g.node("d"),
            e = g.node("e");

        expect(g.nodes.map((v) => g.node(v).lim), unorderedEquals([1, 2, 3, 4, 5]));

        expect(a, equals({ "low": 1, "lim": 5 }));

        expect(b.parent, equals("a"));
        expect(b.lim, lessThan(a.lim));

        expect(c.parent, equals("a"));
        expect(c.lim, lessThan(a.lim));
        expect(c.lim, equals(b.lim));

        expect(d.parent, equals("c"));
        expect(d.lim, lessThan(c.lim));

        expect(e.parent, equals("c"));
        expect(e.lim, lessThan(c.lim));
        expect(e.lim, isNot(equals(d.lim)));
      });
    });

    group("exchangeEdges", () {
      test("exchanges edges and updates cut values and low/lim numbers", () {
        g = gansnerGraph;
        t = gansnerTree;
        longestPath(g);
        initLowLimValues(t);

        exchangeEdges(t, g, new Edge("g", "h"), new Edge("a", "e"));

        // check new cut values
        expect(t.edge("a", "b").cutvalue, equals(2));
        expect(t.edge("b", "c").cutvalue, equals(2));
        expect(t.edge("c", "d").cutvalue, equals(2));
        expect(t.edge("d", "h").cutvalue, equals(2));
        expect(t.edge("a", "e").cutvalue, equals(1));
        expect(t.edge("e", "g").cutvalue, equals(1));
        expect(t.edge("g", "f").cutvalue, equals(0));

        // ensure lim numbers look right
        var lims = t.nodes.map((v) => t.node(v).lim).toList()..sort();
        expect(lims, equals(range(1, 9)));
      });

      test("updates ranks", () {
        g = gansnerGraph;
        t = gansnerTree;
        longestPath(g);
        initLowLimValues(t);

        exchangeEdges(t, g, new Edge("g", "h"), new Edge("a", "e"));
        normalizeRanks(g);

        // check new ranks
        expect(g.node("a").rank, equals(0));
        expect(g.node("b").rank, equals(1));
        expect(g.node("c").rank, equals(2));
        expect(g.node("d").rank, equals(3));
        expect(g.node("e").rank, equals(1));
        expect(g.node("f").rank, equals(1));
        expect(g.node("g").rank, equals(2));
        expect(g.node("h").rank, equals(4));
      });
    });

    // Note: we use p for parent, c for child, gc_x for grandchild nodes, and o for
    // other nodes in the tree for these tests.
    group("calcCutValue", () {
      test("works for a 2-node tree with c -> p", () {
        g.setPath(["c", "p"]);
        t.setPath(["p", "c"]);
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(1));
      });

      test("works for a 2-node tree with c <- p", () {
        g.setPath(["p", "c"]);
        t.setPath(["p", "c"]);
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(1));
      });

      test("works for 3-node tree with gc -> c -> p", () {
        g.setPath(["gc", "c", "p"]);
        t
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setEdge("p", "c");
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(3));
      });

      test("works for 3-node tree with gc -> c <- p", () {
        g
          .setEdge("p", "c")
          .setEdge("gc", "c");
        t
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setEdge("p", "c");
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(-1));
      });

      test("works for 3-node tree with gc <- c -> p", () {
        g
          .setEdge("c", "p")
          .setEdge("c", "gc");
        t
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setEdge("p", "c");
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(-1));
      });

      test("works for 3-node tree with gc <- c <- p", () {
        g.setPath(["p", "c", "gc"]);
        t
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setEdge("p", "c");
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(3));
      });

      test("works for 4-node tree with gc -> c -> p -> o, with o -> c", () {
        g
          .setEdge("o", "c", { "weight": 7 })
          .setPath(["gc", "c", "p", "o"]);
        t
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setPath(["c", "p", "o"]);
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(-4));
      });

      test("works for 4-node tree with gc -> c -> p -> o, with o <- c", () {
        g
          .setEdge("c", "o", { "weight": 7 })
          .setPath(["gc", "c", "p", "o"]);
        t
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setPath(["c", "p", "o"]);
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(10));
      });

      test("works for 4-node tree with o -> gc -> c -> p, with o -> c", () {
        g
          .setEdge("o", "c", { "weight": 7 })
          .setPath(["o", "gc", "c", "p"]);
        t
          .setEdge("o", "gc")
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setEdge("c", "p");
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(-4));
      });

      test("works for 4-node tree with o -> gc -> c -> p, with o <- c", () {
        g
          .setEdge("c", "o", { "weight": 7 })
          .setPath(["o", "gc", "c", "p"]);
        t
          .setEdge("o", "gc")
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setEdge("c", "p");
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(10));
      });

      test("works for 4-node tree with gc -> c <- p -> o, with o -> c", () {
        g
          .setEdge("gc", "c")
          .setEdge("p", "c")
          .setEdge("p", "o")
          .setEdge("o", "c", { "weight": 7 });
        t
          .setEdge("o", "gc")
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setEdge("c", "p");
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(6));
      });

      test("works for 4-node tree with gc -> c <- p -> o, with o <- c", () {
        g
          .setEdge("gc", "c")
          .setEdge("p", "c")
          .setEdge("p", "o")
          .setEdge("c", "o", { "weight": 7 });
        t
          .setEdge("o", "gc")
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setEdge("c", "p");
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(-8));
      });

      test("works for 4-node tree with o -> gc -> c <- p, with o -> c", () {
        g
          .setEdge("o", "c", { "weight": 7 })
          .setPath(["o", "gc", "c"])
          .setEdge("p", "c");
        t
          .setEdge("o", "gc")
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setEdge("c", "p");
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(6));
      });

      test("works for 4-node tree with o -> gc -> c <- p, with o <- c", () {
        g
          .setEdge("c", "o", { "weight": 7 })
          .setPath(["o", "gc", "c"])
          .setEdge("p", "c");
        t
          .setEdge("o", "gc")
          .setEdge("gc", "c", { "cutvalue": 3 })
          .setEdge("c", "p");
        initLowLimValues(t, "p");

        expect(calcCutValue(t, g, "c"), equals(-8));
      });
    });

    group("initCutValues", () {
      test("works for gansnerGraph", () {
        initLowLimValues(gansnerTree);
        initCutValues(gansnerTree, gansnerGraph);
        expect(gansnerTree.edge("a", "b").cutvalue, equals(3));
        expect(gansnerTree.edge("b", "c").cutvalue, equals(3));
        expect(gansnerTree.edge("c", "d").cutvalue, equals(3));
        expect(gansnerTree.edge("d", "h").cutvalue, equals(3));
        expect(gansnerTree.edge("g", "h").cutvalue, equals(-1));
        expect(gansnerTree.edge("e", "g").cutvalue, equals(0));
        expect(gansnerTree.edge("f", "g").cutvalue, equals(0));
      });

      test("works for updated gansnerGraph", () {
        gansnerTree.removeEdge("g", "h");
        gansnerTree.setEdge("a", "e");
        initLowLimValues(gansnerTree);
        initCutValues(gansnerTree, gansnerGraph);
        expect(gansnerTree.edge("a", "b").cutvalue, equals(2));
        expect(gansnerTree.edge("b", "c").cutvalue, equals(2));
        expect(gansnerTree.edge("c", "d").cutvalue, equals(2));
        expect(gansnerTree.edge("d", "h").cutvalue, equals(2));
        expect(gansnerTree.edge("a", "e").cutvalue, equals(1));
        expect(gansnerTree.edge("e", "g").cutvalue, equals(1));
        expect(gansnerTree.edge("f", "g").cutvalue, equals(0));
      });
    });
  });
}

ns(g) {
  networkSimplex(g);
  normalizeRanks(g);
}

Edge undirectedEdge(e) {
  return e.v < e.w ? new Edge(e.v, e.w) : new Edge(e.w, e.v);
}

main() {
  networkSimplexTest();
}
