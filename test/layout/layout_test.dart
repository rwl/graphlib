library graphlib.test.layout;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, layout;
import 'package:graphlib/src/layout/util.dart' as util;

layoutTest() {
  group("layout", () {
    Graph g;

    setUp(() {
      g = new Graph(multigraph: true, compound: true)
            ..setGraph({})
            ..defaultEdgeLabelFn = (v, w, n) => {};
    });

    test("can layout a single node", () {
      g.setNode("a", { "width": 50, "height": 100 });
      layout(g);
      expect(extractCoordinates(g), equals({
        "a": { "x": 50 / 2, "y": 100 / 2 }
      }));
      expect(g.node("a").x, equals(50 / 2));
      expect(g.node("a").y, equals(100 / 2));
    });

    test("can layout two nodes on the same rank", () {
      g.graph().nodesep = 200;
      g.setNode("a", { "width": 50, "height": 100 });
      g.setNode("b", { "width": 75, "height": 200 });
      layout(g);
      expect(extractCoordinates(g), equals({
        "a": { "x": 50 / 2,            "y": 200 / 2 },
        "b": { "x": 50 + 200 + 75 / 2, "y": 200 / 2 }
      }));
    });

    test("can layout two nodes connected by an edge", () {
      g.graph().ranksep = 300;
      g.setNode("a", { "width": 50, "height": 100 });
      g.setNode("b", { "width": 75, "height": 200 });
      g.setEdge("a", "b");
      layout(g);
      expect(extractCoordinates(g), equals({
        "a": { "x": 75 / 2, "y": 100 / 2 },
        "b": { "x": 75 / 2, "y": 100 + 300 + 200 / 2 }
      }));

      // We should not get x, y coordinates if the edge has no label
      expect(g.edge("a", "b"), isNot(anyElement(equals("x"))));
      expect(g.edge("a", "b"), isNot(anyElement(equals("y"))));
    });

    test("can layout an edge with a label", () {
      g.graph().ranksep = 300;
      g.setNode("a", { "width": 50, "height": 100 });
      g.setNode("b", { "width": 75, "height": 200 });
      g.setEdge("a", "b", { "width": 60, "height": 70, "labelpos": "c" });
      layout(g);
      expect(extractCoordinates(g), equals({
        "a": { "x": 75 / 2, "y": 100 / 2 },
        "b": { "x": 75 / 2, "y": 100 + 150 + 70 + 150 + 200 / 2 }
      }));
      expect(util.pick(g.edge("a", "b"), ["x", "y"]),
          equals({ "x": 75 / 2, "y": 100  + 150 + 70 / 2 }));
    });

    group("can layout an edge with a long label, with rankdir =", () {
      ["TB", "BT", "LR", "RL"].forEach((rankdir) {
        test(rankdir, () {
          g.graph().nodesep = g.graph().edgesep = 10;
          g.graph().rankdir = rankdir;
          ["a", "b", "c", "d"].forEach((v) {
            g.setNode(v, { "width": 10, "height": 10 });
          });
          g.setEdge("a", "c", { "width": 2000, "height": 10, "labelpos": "c" });
          g.setEdge("b", "d", { "width": 1, "height": 1 });
          layout(g);

          var p1, p2;
          if (rankdir == "TB" || rankdir == "BT") {
            p1 = g.edge("a", "c");
            p2 = g.edge("b", "d");
          } else {
            p1 = g.node("a");
            p2 = g.node("c");
          }

          expect((p1.x - p2.x).abs(), greaterThan(1000));
        });
      });
    });

    group("can apply an offset, with rankdir =", () {
      ["TB", "BT", "LR", "RL"].forEach((rankdir) {
        test(rankdir, () {
          g.graph().nodesep = g.graph().edgesep = 10;
          g.graph().rankdir = rankdir;
          ["a", "b", "c", "d"].forEach((v) {
            g.setNode(v, { "width": 10, "height": 10 });
          });
          g.setEdge("a", "b", { "width": 10, "height": 10, "labelpos": "l", "labeloffset": 1000 });
          g.setEdge("c", "d", { "width": 10, "height": 10, "labelpos": "r", "labeloffset": 1000 });
          layout(g);

          if (rankdir == "TB" || rankdir == "BT") {
            expect(g.edge("a", "b").x - g.edge("a", "b").points[0].x, equals(-1000 - 10 / 2));
            expect(g.edge("c", "d").x - g.edge("c", "d").points[0].x, equals(1000 + 10 / 2));
          } else {
            expect(g.edge("a", "b").y - g.edge("a", "b").points[0].y, equals(-1000 - 10 / 2));
            expect(g.edge("c", "d").y - g.edge("c", "d").points[0].y, equals(1000 + 10 / 2));
          }
        });
      });
    });

    test("can layout a long edge with a label", () {
      g.graph().ranksep = 300;
      g.setNode("a", { "width": 50, "height": 100 });
      g.setNode("b", { "width": 75, "height": 200 });
      g.setEdge("a", "b", { "width": 60, "height": 70, "minlen": 2, "labelpos": "c" });
      layout(g);
      expect(g.edge("a", "b").x, equals(75 / 2));
      expect(g.edge("a", "b").y, greaterThan(g.node("a").y));
      expect(g.edge("a", "b").y, lessThan(g.node("b").y));
    });

    test("can layout out a short cycle", () {
      g.graph().ranksep = 200;
      g.setNode("a", { "width": 100, "height": 100 });
      g.setNode("b", { "width": 100, "height": 100 });
      g.setEdge("a", "b", { "weight": 2 });
      g.setEdge("b", "a");
      layout(g);
      expect(extractCoordinates(g), equals({
        "a": { "x": 100 / 2, "y": 100 / 2 },
        "b": { "x": 100 / 2, "y": 100 + 200 + 100 / 2}
      }));
      // One arrow should point down, one up
      expect(g.edge("a", "b").points[1].y, greaterThan(g.edge("a", "b").points[0].y));
      expect(g.edge("b", "a").points[0].y, greaterThan(g.edge("b", "a").points[1].y));
    });

    test("adds rectangle intersects for edges", () {
      g.graph().ranksep = 200;
      g.setNode("a", { "width": 100, "height": 100 });
      g.setNode("b", { "width": 100, "height": 100 });
      g.setEdge("a", "b");
      layout(g);
      var points = g.edge("a", "b").points;
      expect(points, hasLength(equals(3)));
      expect(points, equals([
        { "x": 100 / 2, "y": 100 },           // intersect with bottom of a
        { "x": 100 / 2, "y": 100 + 200 / 2 }, // point for edge label
        { "x": 100 / 2, "y": 100 + 200 }      // intersect with top of b
      ]));
    });

    test("adds rectangle intersects for edges spanning multiple ranks", () {
      g.graph().ranksep = 200;
      g.setNode("a", { "width": 100, "height": 100 });
      g.setNode("b", { "width": 100, "height": 100 });
      g.setEdge("a", "b", { "minlen": 2 });
      layout(g);
      var points = g.edge("a", "b").points;
      expect(points, hasLength(equals(5)));
      expect(points, equals([
        { "x": 100 / 2, "y": 100 },           // intersect with bottom of a
        { "x": 100 / 2, "y": 100 + 200 / 2 }, // bend #1
        { "x": 100 / 2, "y": 100 + 400 / 2 }, // point for edge label
        { "x": 100 / 2, "y": 100 + 600 / 2 }, // bend #2
        { "x": 100 / 2, "y": 100 + 800 / 2 }  // intersect with top of b
      ]));
    });

    group("can layout a self loop", () {
      ["TB", "BT", "LR", "RL"].forEach((rankdir) {
        test("in rankdir = " + rankdir, () {
          g.graph().edgesep = 75;
          g.graph().rankdir = rankdir;
          g.setNode("a", { "width": 100, "height": 100 });
          g.setEdge("a", "a", { "width": 50, "height": 50 });
          layout(g);
          var nodeA = g.node("a"),
              points = g.edge("a", "a").points;
          expect(points, hasLength(equals(7)));
          points.forEach((point) {
            if (rankdir != "LR" && rankdir != "RL") {
              expect(point.x, greaterThan(nodeA.x));
              expect((point.y - nodeA.y).abs(), lessThanOrEqualTo(nodeA.height / 2));
            } else {
              expect(point.y, greaterThan(nodeA.y));
              expect((point.x - nodeA.x).abs(), lessThanOrEqualTo(nodeA.width / 2));
            }
          });
        });
      });
    });

    test("can layout a graph with subgraphs", () {
      // To be expanded, this primarily ensures nothing blows up for the moment.
      g.setNode("a", { "width": 50, "height": 50 });
      g.setParent("a", "sg1");
      layout(g);
    });

    test("minimizes the height of subgraphs", () {
      ["a", "b", "c", "d", "x", "y"].forEach((v) {
        g.setNode(v, { "width": 50, "height": 50 });
      });
      g.setPath(["a", "b", "c", "d"]);
      g.setEdge("a", "x", { "weight": 100 });
      g.setEdge("y", "d", { "weight": 100 });
      g.setParent("x", "sg");
      g.setParent("y", "sg");

      // We did not set up an edge (x, y), and we set up high-weight edges from
      // outside of the subgraph to nodes in the subgraph. This is to try to
      // force nodes x and y to be on different ranks, which we want our ranker
      // to avoid.
      layout(g);
      expect(g.node("x").y, equals(g.node("y").y));
    });

    test("can layout subgraphs with different rankdirs", () {
      g.setNode("a", { "width": 50, "height": 50 });
      g.setNode("sg", {});
      g.setParent("a", "sg");

      check(rankdir) {
        expect(g.node("sg").width, greaterThan(50), reason: "width " + rankdir);
        expect(g.node("sg").height, greaterThan(50), reason: "height " + rankdir);
        expect(g.node("sg").x, greaterThan(50 / 2), reason: "x " + rankdir);
        expect(g.node("sg").y, greaterThan(50 / 2), reason: "y " + rankdir);
      }

      ["tb", "bt", "lr", "rl"].forEach((rankdir) {
        g.graph().rankdir = rankdir;
        layout(g);
        check(rankdir);
      });
    });

    test("adds dimensions to the graph", () {
      g.setNode("a", { "width": 100, "height": 50 });
      layout(g);
      expect(g.graph().width, equals(100));
      expect(g.graph().height, equals(50));
    });

    group("ensures all coordinates are in the bounding box for the graph", () {
      ["TB", "BT", "LR", "RL"].forEach((rankdir) {
        group(rankdir, () {
          setUp(() {
            g.graph().rankdir = rankdir;
          });

          test("node", () {
            g.setNode("a", { "width": 100, "height": 200 });
            layout(g);
            expect(g.node("a").x, equals(100 / 2));
            expect(g.node("a").y, equals(200 / 2));
          });

          test("edge, labelpos = l", () {
            g.setNode("a", { "width": 100, "height": 100 });
            g.setNode("b", { "width": 100, "height": 100 });
            g.setEdge("a", "b", {
              "width": 1000, "height": 2000, "labelpos": "l", "labeloffset": 0
            });
            layout(g);
            if (rankdir == "TB" || rankdir == "BT") {
              expect(g.edge("a", "b").x, equals(1000 / 2));
            } else {
              expect(g.edge("a", "b").y, equals(2000 / 2));
            }
          });
        });
      });
    });

    test("treats attributes with case-insensitivity", () {
      g.graph().nodeSep = 200; // note the capital S
      g.setNode("a", { "width": 50, "height": 100 });
      g.setNode("b", { "width": 75, "height": 200 });
      layout(g);
      expect(extractCoordinates(g), equals({
        "a": { "x": 50 / 2,            "y": 200 / 2 },
        "b": { "x": 50 + 200 + 75 / 2, "y": 200 / 2 }
      }));
    });
  });
}

extractCoordinates(Graph g) {
  var nodes = g.nodes;
  return new Map.fromIterables(nodes, nodes.map((v) {
    return util.pick(g.node(v), ["x", "y"]);
  }));
}

main() {
  layoutTest();
}
