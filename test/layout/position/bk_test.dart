library graphlib.test.layout.position.bk;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/position/bk.dart';
import 'package:graphlib/src/layout/util.dart' show buildLayerMatrix;

bkTest() {
  group("position/bk", () {
    Graph g;

    setUp(() {
      g = new Graph()..setGraph({});
    });

    group("findType1Conflicts", () {
      var layering;

      setUp(() {
        g
          ..defaultEdgeLabelFn = ((v, w, n) => {})
          ..setNode("a", { "rank": 0, "order": 0 })
          ..setNode("b", { "rank": 0, "order": 1 })
          ..setNode("c", { "rank": 1, "order": 0 })
          ..setNode("d", { "rank": 1, "order": 1 })
          // Set up crossing
          ..setEdge("a", "d")
          ..setEdge("b", "c");

        layering = buildLayerMatrix(g);
      });

      test("does not mark edges that have no conflict", () {
        g.removeEdge("a", "d");
        g.removeEdge("b", "c");
        g.setEdge("a", "c");
        g.setEdge("b", "d");

        var conflicts = findType1Conflicts(g, layering);
        expect(hasConflict(conflicts, "a", "c"), isFalse);
        expect(hasConflict(conflicts, "b", "d"), isFalse);
      });

      test("does not mark type-0 conflicts (no dummies)", () {
        var conflicts = findType1Conflicts(g, layering);
        expect(hasConflict(conflicts, "a", "d"), isFalse);
        expect(hasConflict(conflicts, "b", "c"), isFalse);
      });

      ["a", "b", "c", "d"].forEach((v) {
        test("does not mark type-0 conflicts (" + v + " is dummy)", () {
          g.node(v).dummy = true;

          var conflicts = findType1Conflicts(g, layering);
          expect(hasConflict(conflicts, "a", "d"), isFalse);
          expect(hasConflict(conflicts, "b", "c"), isFalse);
        });
      });

      ["a", "b", "c", "d"].forEach((v) {
        test("does mark type-1 conflicts (" + v + " is non-dummy)", () {
          ["a", "b", "c", "d"].forEach((w) {
            if (v != w) {
              g.node(w).dummy = true;
            }
          });

          var conflicts = findType1Conflicts(g, layering);
          if (v == "a" || v == "d") {
            expect(hasConflict(conflicts, "a", "d"), isTrue);
            expect(hasConflict(conflicts, "b", "c"), isFalse);
          } else {
            expect(hasConflict(conflicts, "a", "d"), isFalse);
            expect(hasConflict(conflicts, "b", "c"), isTrue);
          }
        });
      });

      test("does not mark type-2 conflicts (all dummies)", () {
        ["a", "b", "c", "d"].forEach((v) {
          g.node(v).dummy = true;
        });

        var conflicts = findType1Conflicts(g, layering);
        expect(hasConflict(conflicts, "a", "d"), isFalse);
        expect(hasConflict(conflicts, "b", "c"), isFalse);
        findType1Conflicts(g, layering);
      });
    });

    group("findType2Conflicts", () {
      var layering;

      setUp(() {
        g
          ..defaultEdgeLabelFn = ((v, w, n) => {})
          ..setNode("a", { "rank": 0, "order": 0 })
          ..setNode("b", { "rank": 0, "order": 1 })
          ..setNode("c", { "rank": 1, "order": 0 })
          ..setNode("d", { "rank": 1, "order": 1 })
          // Set up crossing
          ..setEdge("a", "d")
          ..setEdge("b", "c");

        layering = buildLayerMatrix(g);
      });

      test("marks type-2 conflicts favoring border segments #1", () {
        ["a", "d"].forEach((v) {
          g.node(v).dummy = true;
        });

        ["b", "c"].forEach((v) {
          g.node(v).dummy = "border";
        });

        var conflicts = findType2Conflicts(g, layering);
        expect(hasConflict(conflicts, "a", "d"), isTrue);
        expect(hasConflict(conflicts, "b", "c"), isFalse);
        findType1Conflicts(g, layering);
      });

      test("marks type-2 conflicts favoring border segments #2", () {
        ["b", "c"].forEach((v) {
          g.node(v).dummy = true;
        });

        ["a", "d"].forEach((v) {
          g.node(v).dummy = "border";
        });

        var conflicts = findType2Conflicts(g, layering);
        expect(hasConflict(conflicts, "a", "d"), isFalse);
        expect(hasConflict(conflicts, "b", "c"), isTrue);
        findType1Conflicts(g, layering);
      });
    });

    group("hasConflict", () {
      test("can test for a type-1 conflict regardless of edge orientation", () {
        var conflicts = {};
        addConflict(conflicts, "b", "a");
        expect(hasConflict(conflicts, "a", "b"), isTrue);
        expect(hasConflict(conflicts, "b", "a"), isTrue);
      });

      test("works for multiple conflicts with the same node", () {
        var conflicts = {};
        addConflict(conflicts, "a", "b");
        addConflict(conflicts, "a", "c");
        expect(hasConflict(conflicts, "a", "b"), isTrue);
        expect(hasConflict(conflicts, "a", "c"), isTrue);
      });
    });

    group("verticalAlignment", () {
      test("Aligns with itself if the node has no adjacencies", () {
        g.setNode("a", { "rank": 0, "order": 0 });
        g.setNode("b", { "rank": 1, "order": 0 });

        var layering = buildLayerMatrix(g),
            conflicts = {};

        var result = verticalAlignment(g, layering, conflicts, (v) => g.predecessors(v));
        expect(result, equals({
          "root":  { "a": "a", "b": "b" },
          "align": { "a": "a", "b": "b" }
        }));
      });

      test("Aligns with its sole adjacency", () {
        g.setNode("a", { "rank": 0, "order": 0 });
        g.setNode("b", { "rank": 1, "order": 0 });
        g.setEdge("a", "b");

        var layering = buildLayerMatrix(g),
            conflicts = {};

        var result = verticalAlignment(g, layering, conflicts, (v) => g.predecessors(v));
        expect(result, equals({
          "root":  { "a": "a", "b": "a" },
          "align": { "a": "b", "b": "a" }
        }));
      });

      test("aligns with its left median when possible", () {
        g.setNode("a", { "rank": 0, "order": 0 });
        g.setNode("b", { "rank": 0, "order": 1 });
        g.setNode("c", { "rank": 1, "order": 0 });
        g.setEdge("a", "c");
        g.setEdge("b", "c");

        var layering = buildLayerMatrix(g),
            conflicts = {};

        var result = verticalAlignment(g, layering, conflicts, (v) => g.predecessors(v));
        expect(result, equals({
          "root":  { "a": "a", "b": "b", "c": "a" },
          "align": { "a": "c", "b": "b", "c": "a" }
        }));
      });

      test("aligns correctly even regardless of node name / insertion order", () {
        // This test ensures that we're actually properly sorting nodes by
        // position when searching for candidates. Many of these tests previously
        // passed because the node insertion order matched the order of the nodes
        // in the layering.
        g.setNode("b", { "rank": 0, "order": 1 });
        g.setNode("c", { "rank": 1, "order": 0 });
        g.setNode("z", { "rank": 0, "order": 0 });
        g.setEdge("z", "c");
        g.setEdge("b", "c");

        var layering = buildLayerMatrix(g),
            conflicts = {};

        var result = verticalAlignment(g, layering, conflicts, (v) => g.predecessors(v));
        expect(result, equals({
          "root":  { "z": "z", "b": "b", "c": "z" },
          "align": { "z": "c", "b": "b", "c": "z" }
        }));
      });


      test("aligns with its right median when left is unavailable", () {
        g.setNode("a", { "rank": 0, "order": 0 });
        g.setNode("b", { "rank": 0, "order": 1 });
        g.setNode("c", { "rank": 1, "order": 0 });
        g.setEdge("a", "c");
        g.setEdge("b", "c");

        var layering = buildLayerMatrix(g),
            conflicts = {};

        addConflict(conflicts, "a", "c");

        var result = verticalAlignment(g, layering, conflicts, (v) => g.predecessors(v));
        expect(result, equals({
          "root":  { "a": "a", "b": "b", "c": "b" },
          "align": { "a": "a", "b": "c", "c": "b" }
        }));
      });

      test("aligns with neither median if both are unavailable", () {
        g.setNode("a", { "rank": 0, "order": 0 });
        g.setNode("b", { "rank": 0, "order": 1 });
        g.setNode("c", { "rank": 1, "order": 0 });
        g.setNode("d", { "rank": 1, "order": 1 });
        g.setEdge("a", "d");
        g.setEdge("b", "c");
        g.setEdge("b", "d");

        var layering = buildLayerMatrix(g),
            conflicts = {};

        var result = verticalAlignment(g, layering, conflicts, (v) => g.predecessors(v));
        // c will align with b, so d will not be able to align with a, because
        // (a,d) and (c,b) cross.
        expect(result, equals({
          "root":  { "a": "a", "b": "b", "c": "b", "d": "d" },
          "align": { "a": "a", "b": "c", "c": "b", "d": "d" }
        }));
      });

      test("aligns with the single median for an odd number of adjacencies", () {
        g.setNode("a", { "rank": 0, "order": 0 });
        g.setNode("b", { "rank": 0, "order": 1 });
        g.setNode("c", { "rank": 0, "order": 2 });
        g.setNode("d", { "rank": 1, "order": 0 });
        g.setEdge("a", "d");
        g.setEdge("b", "d");
        g.setEdge("c", "d");

        var layering = buildLayerMatrix(g),
            conflicts = {};

        var result = verticalAlignment(g, layering, conflicts, (v) => g.predecessors(v));
        expect(result, equals({
          "root":  { "a": "a", "b": "b", "c": "c", "d": "b" },
          "align": { "a": "a", "b": "d", "c": "c", "d": "b" }
        }));
      });

      test("aligns blocks across multiple layers", () {
        g.setNode("a", { "rank": 0, "order": 0 });
        g.setNode("b", { "rank": 1, "order": 0 });
        g.setNode("c", { "rank": 1, "order": 1 });
        g.setNode("d", { "rank": 2, "order": 0 });
        g.setPath(["a", "b", "d"]);
        g.setPath(["a", "c", "d"]);

        var layering = buildLayerMatrix(g),
            conflicts = {};

        var result = verticalAlignment(g, layering, conflicts, (v) => g.predecessors(v));
        expect(result, equals({
          "root":  { "a": "a", "b": "a", "c": "c", "d": "a" },
          "align": { "a": "b", "b": "d", "c": "c", "d": "a" }
        }));
      });
    });

    group("horizonalCompaction", () {
      test("places the center of a single node graph at origin (0,0)", () {
        var root =  { "a": "a" },
            align = { "a": "a" };
        g.setNode("a", { "rank": 0, "order": 0 });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(0));
      });

      test("separates adjacent nodes by specified node separation", () {
        var root =  { "a": "a", "b": "b" },
            align = { "a": "a", "b": "b" };
        g.graph().nodesep = 100;
        g.setNode("a", { "rank": 0, "order": 0, "width": 100 });
        g.setNode("b", { "rank": 0, "order": 1, "width": 200 });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(0));
        expect(xs["b"], equals(100 / 2 + 100 + 200 / 2));
      });

      test("separates adjacent edges by specified node separation", () {
        var root =  { "a": "a", "b": "b" },
            align = { "a": "a", "b": "b" };
        g.graph().edgesep = 20;
        g.setNode("a", { "rank": 0, "order": 0, "width": 100, "dummy": true });
        g.setNode("b", { "rank": 0, "order": 1, "width": 200, "dummy": true });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(0));
        expect(xs["b"], equals(100 / 2 + 20 + 200 / 2));
      });

      test("aligns the centers of nodes in the same block", () {
        var root =  { "a": "a", "b": "a" },
            align = { "a": "b", "b": "a" };
        g.setNode("a", { "rank": 0, "order": 0, "width": 100 });
        g.setNode("b", { "rank": 1, "order": 0, "width": 200 });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(0));
        expect(xs["b"], equals(0));
      });

      test("separates blocks with the appropriate separation", () {
        var root =  { "a": "a", "b": "a", "c": "c" },
            align = { "a": "b", "b": "a", "c": "c" };
        g.graph().nodesep = 75;
        g.setNode("a", { "rank": 0, "order": 0, "width": 100 });
        g.setNode("b", { "rank": 1, "order": 1, "width": 200 });
        g.setNode("c", { "rank": 1, "order": 0, "width":  50 });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(50 / 2 + 75 + 200 / 2));
        expect(xs["b"], equals(50 / 2 + 75 + 200 / 2));
        expect(xs["c"], equals(0));
      });

      test("separates classes with the appropriate separation", () {
        var root =  { "a": "a", "b": "b", "c": "c", "d": "b" },
            align = { "a": "a", "b": "d", "c": "c", "d": "b" };
        g.graph().nodesep = 75;
        g.setNode("a", { "rank": 0, "order": 0, "width": 100 });
        g.setNode("b", { "rank": 0, "order": 1, "width": 200 });
        g.setNode("c", { "rank": 1, "order": 0, "width":  50 });
        g.setNode("d", { "rank": 1, "order": 1, "width":  80 });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(0));
        expect(xs["b"], equals(100 / 2 + 75 + 200 / 2));
        expect(xs["c"], equals(100 / 2 + 75 + 200 / 2 - 80 / 2 - 75 - 50 / 2));
        expect(xs["d"], equals(100 / 2 + 75 + 200 / 2));
      });

      test("shifts classes by max sep from the adjacent block #1", () {
        var root =  { "a": "a", "b": "b", "c": "a", "d": "b" },
            align = { "a": "c", "b": "d", "c": "a", "d": "b" };
        g.graph().nodesep = 75;
        g.setNode("a", { "rank": 0, "order": 0, "width":  50 });
        g.setNode("b", { "rank": 0, "order": 1, "width": 150 });
        g.setNode("c", { "rank": 1, "order": 0, "width":  60 });
        g.setNode("d", { "rank": 1, "order": 1, "width":  70 });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(0));
        expect(xs["b"], equals(50 / 2 + 75 + 150 / 2));
        expect(xs["c"], equals(0));
        expect(xs["d"], equals(50 / 2 + 75 + 150 / 2));
      });

      test("shifts classes by max sep from the adjacent block #2", () {
        var root =  { "a": "a", "b": "b", "c": "a", "d": "b" },
            align = { "a": "c", "b": "d", "c": "a", "d": "b" };
        g.graph().nodesep = 75;
        g.setNode("a", { "rank": 0, "order": 0, "width":  50 });
        g.setNode("b", { "rank": 0, "order": 1, "width":  70 });
        g.setNode("c", { "rank": 1, "order": 0, "width":  60 });
        g.setNode("d", { "rank": 1, "order": 1, "width": 150 });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(0));
        expect(xs["b"], equals(60 / 2 + 75 + 150 / 2));
        expect(xs["c"], equals(0));
        expect(xs["d"], equals(60 / 2 + 75 + 150 / 2));
      });

      test("cascades class shift", () {
        var root =  { "a": "a", "b": "b", "c": "c", "d": "d", "e": "b", "f": "f", "g": "d" },
            align = { "a": "a", "b": "e", "c": "c", "d": "g", "e": "b", "f": "f", "g": "d" };
        g.graph().nodesep = 75;
        g.setNode("a", { "rank": 0, "order": 0, "width": 50 });
        g.setNode("b", { "rank": 0, "order": 1, "width": 50 });
        g.setNode("c", { "rank": 1, "order": 0, "width": 50 });
        g.setNode("d", { "rank": 1, "order": 1, "width": 50 });
        g.setNode("e", { "rank": 1, "order": 2, "width": 50 });
        g.setNode("f", { "rank": 2, "order": 0, "width": 50 });
        g.setNode("g", { "rank": 2, "order": 1, "width": 50 });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);

        // Use f as 0, everything is relative to it
        expect(xs["a"], equals(xs["b"] - 50 / 2 - 75 - 50 / 2));
        expect(xs["b"], equals(xs["e"]));
        expect(xs["c"], equals(xs["f"]));
        expect(xs["d"], equals(xs["c"] + 50 / 2 + 75 + 50 / 2));
        expect(xs["e"], equals(xs["d"] + 50 / 2 + 75 + 50 / 2));
        expect(xs["g"], equals(xs["f"] + 50 / 2 + 75 + 50 / 2));
      });

      test("handles labelpos = l", () {
        var root =  { "a": "a", "b": "b", "c": "c" },
            align = { "a": "a", "b": "b", "c": "c" };
        g.graph().edgesep = 50;
        g.setNode("a", { "rank": 0, "order": 0, "width":  100, "dummy": "edge" });
        g.setNode("b", {
          "rank": 0, "order": 1, "width": 200,
          "dummy": "edge-label", "labelpos": "l"
        });
        g.setNode("c", { "rank": 0, "order": 2, "width":  300, "dummy": "edge" });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(0));
        expect(xs["b"], equals(xs["a"] + 100 / 2 + 50 + 200));
        expect(xs["c"], equals(xs["b"] + 0 + 50 + 300 / 2));
      });

      test("handles labelpos = c", () {
        var root =  { "a": "a", "b": "b", "c": "c" },
            align = { "a": "a", "b": "b", "c": "c" };
        g.graph().edgesep = 50;
        g.setNode("a", { "rank": 0, "order": 0, "width":  100, "dummy": "edge" });
        g.setNode("b", {
          "rank": 0, "order": 1, "width": 200,
          "dummy": "edge-label", "labelpos": "c"
        });
        g.setNode("c", { "rank": 0, "order": 2, "width":  300, "dummy": "edge" });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(0));
        expect(xs["b"], equals(xs["a"] + 100 / 2 + 50 + 200 / 2));
        expect(xs["c"], equals(xs["b"] + 200 / 2 + 50 + 300 / 2));
      });

      test("handles labelpos = r", () {
        var root =  { "a": "a", "b": "b", "c": "c" },
            align = { "a": "a", "b": "b", "c": "c" };
        g.graph().edgesep = 50;
        g.setNode("a", { "rank": 0, "order": 0, "width":  100, "dummy": "edge" });
        g.setNode("b", {
          "rank": 0, "order": 1, "width": 200,
          "dummy": "edge-label", "labelpos": "r"
        });
        g.setNode("c", { "rank": 0, "order": 2, "width":  300, "dummy": "edge" });

        var xs = horizontalCompaction(g, buildLayerMatrix(g), root, align);
        expect(xs["a"], equals(0));
        expect(xs["b"], equals(xs["a"] + 100 / 2 + 50 + 0));
        expect(xs["c"], equals(xs["b"] + 200 + 50 + 300 / 2));
      });
    });

    group("alignCoordinates", () {
      test("aligns a single node", () {
        var xss = {
          "ul": { "a":  50 },
          "ur": { "a": 100 },
          "dl": { "a":  50 },
          "dr": { "a": 200 }
        };

        alignCoordinates(xss, xss["ul"]);

        expect(xss["ul"], equals({ "a": 50 }));
        expect(xss["ur"], equals({ "a": 50 }));
        expect(xss["dl"], equals({ "a": 50 }));
        expect(xss["dr"], equals({ "a": 50 }));
      });

      test("aligns multiple nodes", () {
        var xss = {
          "ul": { "a":  50, "b": 1000 },
          "ur": { "a": 100, "b":  900 },
          "dl": { "a": 150, "b":  800 },
          "dr": { "a": 200, "b":  700 }
        };

        alignCoordinates(xss, xss["ul"]);

        expect(xss["ul"], equals({ "a":  50, "b": 1000 }));
        expect(xss["ur"], equals({ "a": 200, "b": 1000 }));
        expect(xss["dl"], equals({ "a":  50, "b":  700 }));
        expect(xss["dr"], equals({ "a": 500, "b": 1000 }));
      });
    });

    group("findSmallestWidthAlignment", () {
      test("finds the alignment with the smallest width", () {
        g.setNode("a", { "width": 50 });
        g.setNode("b", { "width": 50 });

        var xss = {
          "ul": { "a":  0, "b": 1000 },
          "ur": { "a": -5, "b": 1000 },
          "dl": { "a":  5, "b": 2000 },
          "dr": { "a":  0, "b":  200 },
        };

        expect(findSmallestWidthAlignment(g, xss), equals(xss["dr"]));
      });

      test("takes node width into account", () {
        g.setNode("a", { "width":  50 });
        g.setNode("b", { "width":  50 });
        g.setNode("c", { "width": 200 });

        var xss = {
          "ul": { "a":  0, "b": 100, "c": 75 },
          "ur": { "a":  0, "b": 100, "c": 80 },
          "dl": { "a":  0, "b": 100, "c": 85 },
          "dr": { "a":  0, "b": 100, "c": 90 },
        };

        expect(findSmallestWidthAlignment(g, xss), equals(xss["ul"]));
      });
    });

    group("balance", () {
      test("aligns a single node to the shared median value", () {
        var xss = {
          "ul": { "a":   0 },
          "ur": { "a": 100 },
          "dl": { "a": 100 },
          "dr": { "a": 200 }
        };

        expect(balance(xss), equals({ "a": 100 }));
      });

      test("aligns a single node to the average of different median values", () {
        var xss = {
          "ul": { "a":   0 },
          "ur": { "a":  75 },
          "dl": { "a": 125 },
          "dr": { "a": 200 }
        };

        expect(balance(xss), equals({ "a": 100 }));
      });

      test("balances multiple nodes", () {
        var xss = {
          "ul": { "a":   0, "b": 50 },
          "ur": { "a":  75, "b":  0 },
          "dl": { "a": 125, "b": 60 },
          "dr": { "a": 200, "b": 75 }
        };

        expect(balance(xss), equals({ "a": 100, "b": 55 }));
      });
    });

    group("positionX", () {
      test("positions a single node at origin", () {
        g.setNode("a", { "rank": 0, "order": 0, "width": 100 });
        expect(positionX(g), equals({ "a": 0 }));
      });

      test("positions a single node block at origin", () {
        g.setNode("a", { "rank": 0, "order": 0, "width": 100 });
        g.setNode("b", { "rank": 1, "order": 0, "width": 100 });
        g.setEdge("a", "b");
        expect(positionX(g), equals({ "a": 0, "b": 0 }));
      });

      test("positions a single node block at origin even when their sizes differ", () {
        g.setNode("a", { "rank": 0, "order": 0, "width":  40 });
        g.setNode("b", { "rank": 1, "order": 0, "width": 500 });
        g.setNode("c", { "rank": 2, "order": 0, "width":  20 });
        g.setPath(["a", "b", "c"]);
        expect(positionX(g), equals({ "a": 0, "b": 0, "c": 0 }));
      });

      test("centers a node if it is a predecessor of two same sized nodes", () {
        g.graph().nodesep = 10;
        g.setNode("a", { "rank": 0, "order": 0, "width":  20 });
        g.setNode("b", { "rank": 1, "order": 0, "width":  50 });
        g.setNode("c", { "rank": 1, "order": 1, "width":  50 });
        g.setEdge("a", "b");
        g.setEdge("a", "c");

        var pos = positionX(g),
            a = pos.a;
        expect(pos, equals({ "a": a, "b": a - (25 + 5), "c": a + (25 + 5) }));
      });

      test("shifts blocks on both sides of aligned block", () {
        g.graph().nodesep = 10;
        g.setNode("a", { "rank": 0, "order": 0, "width":  50 });
        g.setNode("b", { "rank": 0, "order": 1, "width":  60 });
        g.setNode("c", { "rank": 1, "order": 0, "width":  70 });
        g.setNode("d", { "rank": 1, "order": 1, "width":  80 });
        g.setEdge("b", "c");

        var pos = positionX(g),
            b = pos.b,
            c = b;
        expect(pos, equals({
          "a": b - 60 / 2 - 10 - 50 / 2,
          "b": b,
          "c": c,
          "d": c + 70 / 2 + 10 + 80 / 2
        }));
      });

      test("aligns inner segments", () {
        g.graph().nodesep = 10;
        g.setNode("a", { "rank": 0, "order": 0, "width":  50, "dummy": true });
        g.setNode("b", { "rank": 0, "order": 1, "width":  60 });
        g.setNode("c", { "rank": 1, "order": 0, "width":  70 });
        g.setNode("d", { "rank": 1, "order": 1, "width":  80, "dummy": true });
        g.setEdge("b", "c");
        g.setEdge("a", "d");

        var pos = positionX(g),
            a = pos.a,
            d = a;
        expect(pos, equals({
          "a": a,
          "b": a + 50 / 2 + 10 + 60 / 2,
          "c": d - 70 / 2 - 10 - 80 / 2,
          "d": d
        }));
      });
    });
  });
}

main() {
  bkTest();
}
