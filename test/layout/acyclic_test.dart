library graphlib.test.layout.acyclic;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, Edge, findCycles;
import 'package:graphlib/src/layout/acyclic.dart' as acyclic;

//var _ = require("lodash"),
//    expect = require("./chai").expect,
//    acyclic = require("../lib/acyclic"),
//    Graph = require("graphlib").Graph,
//    findCycles = require("graphlib").alg.findCycles;

acyclicTest() {
  group("acyclic", () {
    var ACYCLICERS = [
      "greedy",
      "dfs",
      "unknown-should-still-work"
    ];
    Graph g;

    setUp(() {
      g = new Graph(multigraph: true)
        ..defaultEdgeLabelFn = (v, w, n) => { "minlen": 1, "weight": 1 };
    });

    ACYCLICERS.forEach((acyclicer) {
      group(acyclicer, () {
        setUp(() {
          g.setGraph({ "acyclicer": acyclicer });
        });

        group("run", () {
          test("does not change an already acyclic graph", () {
            g.setPath(["a", "b", "d"]);
            g.setPath(["a", "c", "d"]);
            acyclic.run(g);
            var results = g.edges;//.map(stripLabel);
            expect(results, unorderedEquals([
              new Edge("a", "b"),
              new Edge("a", "c"),
              new Edge("b", "d"),
              new Edge("c", "d")
            ]));
          });

          test("breaks cycles in the input graph", () {
            g.setPath(["a", "b", "c", "d", "a"]);
            acyclic.run(g);
            expect(findCycles(g), equals([]));
          });

          test("creates a multi-edge where necessary", () {
            g.setPath(["a", "b", "a"]);
            acyclic.run(g);
            expect(findCycles(g), equals([]));
            if (g.hasEdge("a", "b")) {
              expect(g.outEdges("a", "b"), hasLength(equals(2)));
            } else {
              expect(g.outEdges("b", "a"), hasLength(equals(2)));
            }
            expect(g.edgeCount, equals(2));
          });
        });

        group("undo", () {
          test("does not change edges where the original graph was acyclic", () {
            g.setEdge("a", "b", { "minlen": 2, "weight": 3 });
            acyclic.run(g);
            acyclic.undo(g);
            expect(g.edge("a", "b"), equals({ "minlen": 2, "weight": 3 }));
            expect(g.edges, hasLength(equals(1)));
          });

          test("can restore previosuly reversed edges", () {
            g.setEdge("a", "b", { "minlen": 2, "weight": 3 });
            g.setEdge("b", "a", { "minlen": 3, "weight": 4 });
            acyclic.run(g);
            acyclic.undo(g);
            expect(g.edge("a", "b"), equals({ "minlen": 2, "weight": 3 }));
            expect(g.edge("b", "a"), equals({ "minlen": 3, "weight": 4 }));
            expect(g.edges, hasLength(equals(2)));
          });
        });
      });
    });

    group("greedy-specific functionality", () {
      test("prefers to break cycles at low-weight edges", () {
        g.setGraph({ "acyclicer": "greedy" });
        g.defaultEdgeLabelFn = (v, w, n) => { "minlen": 1, "weight": 2 };
        g.setPath(["a", "b", "c", "d", "a"]);
        g.setEdge("c", "d", { "weight": 1 });
        acyclic.run(g);
        expect(findCycles(g), equals([]));
        expect(g.hasEdge("c", "d"), isFalse);
      });
    });
  });
}

stripLabel(Map edge) {
  var c = new Map.from(edge);
  c.remove("label");
  return c;
}
