library graphlib.test.layout.util;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/util.dart' as util;

utilTest() {
  group("util", () {
    group("simplify", () {
      Graph g;

      setUp(() {
        g = new Graph(multigraph: true);
      });

      test("copies without change a graph with no multi-edges", () {
        g.setEdge("a", "b", { "weight": 1, "minlen": 1 });
        var g2 = util.simplify(g);
        expect(g2.edge("a", "b"), equals({ "weight": 1, "minlen": 1 }));
        expect(g2.edgeCount, equals(1));
      });

      test("collapses multi-edges", () {
        g.setEdge("a", "b", { "weight": 1, "minlen": 1 });
        g.setEdge("a", "b", { "weight": 2, "minlen": 2 }, "multi");
        var g2 = util.simplify(g);
        expect(g2.isMultigraph, isFalse);
        expect(g2.edge("a", "b"), equals({ "weight": 3, "minlen": 2 }));
        expect(g2.edgeCount, equals(1));
      });

      test("copies the graph object", () {
        g.setGraph({ "foo": "bar" });
        var g2 = util.simplify(g);
        expect(g2.graph(), equals({ "foo": "bar" }));
      });
    });

    group("asNonCompoundGraph", () {
      Graph g;

      setUp(() {
        g = new Graph(compound: true, multigraph: true);
      });

      test("copies all nodes", () {
        g.setNode("a", { "foo": "bar" });
        g.setNode("b");
        var g2 = util.asNonCompoundGraph(g);
        expect(g2.node("a"), equals({ "foo": "bar" }));
        expect(g2.hasNode("b"), isTrue);
      });

      test("copies all edges", () {
        g.setEdge("a", "b", { "foo": "bar" });
        g.setEdge("a", "b", { "foo": "baz" }, "multi");
        var g2 = util.asNonCompoundGraph(g);
        expect(g2.edge("a", "b"), equals({ "foo": "bar" }));
        expect(g2.edge("a", "b", "multi"), equals({ "foo": "baz" }));
      });

      test("does not copy compound nodes", () {
        g.setParent("a", "sg1");
        var g2 = util.asNonCompoundGraph(g);
        expect(g2.parent(g), isNull);
        expect(g2.isCompound, isFalse);
      });

      test("copies the graph object", () {
        g.setGraph({ "foo": "bar" });
        var g2 = util.asNonCompoundGraph(g);
        expect(g2.graph(), equals({ "foo": "bar" }));
      });
    });

    group("successorWeights", () {
      test("maps a node to its successors with associated weights", () {
         var g = new Graph(multigraph: true);
         g.setEdge("a", "b", { "weight": 2 });
         g.setEdge("b", "c", { "weight": 1 });
         g.setEdge("b", "c", { "weight": 2 }, "multi");
         g.setEdge("b", "d", { "weight": 1 }, "multi");
         expect(util.successorWeights(g)["a"], equals({ "b": 2 }));
         expect(util.successorWeights(g)["b"], equals({ "c": 3, "d": 1 }));
         expect(util.successorWeights(g)["c"], equals({}));
         expect(util.successorWeights(g)["d"], equals({}));
      });
    });

    group("predecessorWeights", () {
      test("maps a node to its predecessors with associated weights", () {
         var g = new Graph(multigraph: true);
         g.setEdge("a", "b", { "weight": 2 });
         g.setEdge("b", "c", { "weight": 1 });
         g.setEdge("b", "c", { "weight": 2 }, "multi");
         g.setEdge("b", "d", { "weight": 1 }, "multi");
         expect(util.predecessorWeights(g)["a"], equals({}));
         expect(util.predecessorWeights(g)["b"], equals({ "a": 2 }));
         expect(util.predecessorWeights(g)["c"], equals({ "b": 3 }));
         expect(util.predecessorWeights(g)["d"], equals({ "b": 1 }));
      });
    });

    group("intersectRect", () {
      expectIntersects(Map rect, Map point) {
        var cross = util.intersectRect(rect, point);
        if (cross["x"] != point["x"]) {
          var m = (cross["y"] - point["y"]) / (cross["x"] - point["x"]);
          expect(cross["y"] - rect["y"], equals(m * (cross["x"] - rect["x"])));
        }
      }

      expectTouchesBorder(Map rect, Map point) {
        var cross = util.intersectRect(rect, point);
        if ((rect["x"] - cross["x"]).abs() != rect["width"] / 2) {
          expect((rect["y"] - cross["y"]).abs(), equals(rect["height"] / 2));
        }
      }

      test("creates a slope that will intersect the rectangle's center", () {
        var rect = { "x": 0, "y": 0, "width": 1, "height": 1 };
        expectIntersects(rect, { "x":  2, "y":  6 });
        expectIntersects(rect, { "x":  2, "y": -6 });
        expectIntersects(rect, { "x":  6, "y":  2 });
        expectIntersects(rect, { "x": -6, "y":  2 });
        expectIntersects(rect, { "x":  5, "y":  0 });
        expectIntersects(rect, { "x":  0, "y":  5 });
      });

      test("touches the border of the rectangle", () {
        var rect = { "x": 0, "y": 0, "width": 1, "height": 1 };
        expectTouchesBorder(rect, { "x":  2, "y":  6 });
        expectTouchesBorder(rect, { "x":  2, "y": -6 });
        expectTouchesBorder(rect, { "x":  6, "y":  2 });
        expectTouchesBorder(rect, { "x": -6, "y":  2 });
        expectTouchesBorder(rect, { "x":  5, "y":  0 });
        expectTouchesBorder(rect, { "x":  0, "y":  5 });
      });

      test("throws an error if the point is at the center of the rectangle", () {
        var rect = { "x": 0, "y": 0, "width": 1, "height": 1 };
        expect(() { util.intersectRect(rect, { "x": 0, "y": 0 }); }, throws);
      });
    });

    group("buildLayerMatrix", () {
      test("creates a matrix based on rank and order of nodes in the graph", () {
        var g = new Graph();
        g.setNode("a", { "rank": 0, "order": 0 });
        g.setNode("b", { "rank": 0, "order": 1 });
        g.setNode("c", { "rank": 1, "order": 0 });
        g.setNode("d", { "rank": 1, "order": 1 });
        g.setNode("e", { "rank": 2, "order": 0 });

        expect(util.buildLayerMatrix(g), equals([
          ["a", "b"],
          ["c", "d"],
          ["e"]
        ]));
      });
    });

    group("time", () {
      var capture;
      var consoleLog;

      setUp(() {
        capture = [];
        consoleLog = (String s) => capture.add(s);
      });

//      tearDown(() {
//        console.log = consoleLog;
//      });

      test("logs timing information", () {
        //var capture = [];
        //console.log = () { capture.add(_.toArray(arguments)[0]); };
        util.time("foo", () {}, consoleLog);
        expect(capture.length, equals(1));
        expect(capture[0], matches(r"^foo time: .*ms"));
      });

      test("returns the value from the evaluated function", () {
        consoleLog = (s) {};
        expect(util.time("foo", () => "bar", consoleLog), equals("bar"));
      });
    });

    group("normalizeRanks", () {
      test("adjust ranks such that all are >= 0, and at least one is 0", () {
        var g = new Graph()
          ..setNode("a", { "rank": 3 })
          ..setNode("b", { "rank": 2 })
          ..setNode("c", { "rank": 4 });

        util.normalizeRanks(g);

        expect(g.node("a").rank, equals(1));
        expect(g.node("b").rank, equals(0));
        expect(g.node("c").rank, equals(2));
      });

      test("works for negative ranks", () {
        var g = new Graph()
          ..setNode("a", { "rank": -3 })
          ..setNode("b", { "rank": -2 });

        util.normalizeRanks(g);

        expect(g.node("a").rank, equals(0));
        expect(g.node("b").rank, equals(1));
      });

      test("does not assign a rank to subgraphs", () {
        var g = new Graph(compound: true)
          ..setNode("a", { "rank": 0 })
          ..setNode("sg", {})
          ..setParent("a", "sg");

        util.normalizeRanks(g);

        expect(g.node("sg"), isNot(anyElement(equals("rank"))));
        expect(g.node("a").rank, equals(0));
      });
    });

    group("removeEmptyRanks", () {
      test("Removes border ranks without any nodes", () {
        var g = new Graph()
          ..setGraph({ "nodeRankFactor": 4 })
          ..setNode("a", { "rank": 0 })
          ..setNode("b", { "rank": 4 });
        util.removeEmptyRanks(g);
        expect(g.node("a").rank, equals(0));
        expect(g.node("b").rank, equals(1));
      });

      test("Does not remove non-border ranks", () {
        var g = new Graph()
          ..setGraph({ "nodeRankFactor": 4 })
          ..setNode("a", { "rank": 0 })
          ..setNode("b", { "rank": 8 });
        util.removeEmptyRanks(g);
        expect(g.node("a").rank, equals(0));
        expect(g.node("b").rank, equals(2));
      });
    });
  });
}

main() {
  utilTest();
}
