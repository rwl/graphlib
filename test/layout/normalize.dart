library graphlib.test.layout.normalize;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, Edge;
import 'package:graphlib/src/layout/normalize.dart' as normalize;

normalizeTest() {
  group("normalize", () {
    Graph g;

    setUp(() {
      g = new Graph(multigraph: true, compound: true)..setGraph({});
    });

    group("run", () {
      test("does not change a short edge", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 1 });
        g.setEdge("a", "b", {});

        normalize.run(g);

        expect(g.edges.map(incidentNodes), equals([{ "v": "a", "w": "b" }]));
        expect(g.node("a").rank, equals(0));
        expect(g.node("b").rank, equals(1));
      });

      test("splits a two layer edge into two segments", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 2 });
        g.setEdge("a", "b", {});

        normalize.run(g);

        expect(g.successors("a"), hasLength(equals(1)));
        var successor = g.successors("a").first;
        expect(g.node(successor).dummy, equals("edge"));
        expect(g.node(successor).rank, equals(1));
        expect(g.successors(successor), equals(["b"]));
        expect(g.node("a").rank, equals(0));
        expect(g.node("b").rank, equals(2));

        expect(g.graph().dummyChains, hasLength(equals(1)));
        expect(g.graph().dummyChains[0], equals(successor));
      });

      test("assigns width = 0, height = 0 to dummy nodes by default", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 2 });
        g.setEdge("a", "b", { "width": 10, "height": 10 });

        normalize.run(g);

        expect(g.successors("a"), hasLength(equals(1)));
        var successor = g.successors("a").first;
        expect(g.node(successor).width, equals(0));
        expect(g.node(successor).height, equals(0));
      });

      test("assigns width and height from the edge for the node on labelRank", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 4 });
        g.setEdge("a", "b", { "width": 20, "height": 10, "labelRank": 2 });

        normalize.run(g);

        var labelV = g.successors(g.successors("a").first).first,
            labelNode = g.node(labelV);
        expect(labelNode.width, equals(20));
        expect(labelNode.height, equals(10));
      });

      test("preserves the weight for the edge", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 2 });
        g.setEdge("a", "b", { "weight": 2 });

        normalize.run(g);

        expect(g.successors("a"), hasLength(equals(1)));
        expect(g.edge("a", g.successors("a").first).weight, equals(2));
      });
    });

    group("undo", () {
      test("reverses the run operation", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 2 });
        g.setEdge("a", "b", {});

        normalize.run(g);
        normalize.undo(g);

        expect(g.edges.map(incidentNodes), equals([{ "v": "a", "w": "b" }]));
        expect(g.node("a").rank, equals(0));
        expect(g.node("b").rank, equals(2));
      });

      test("restores previous edge labels", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 2 });
        g.setEdge("a", "b", { "foo": "bar" });

        normalize.run(g);
        normalize.undo(g);

        expect(g.edge("a", "b").foo, equals("bar"));
      });

      test("collects assigned coordinates into the 'points' attribute", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 2 });
        g.setEdge("a", "b", {});

        normalize.run(g);

        var dummyLabel = g.node(g.neighbors("a")[0]);
        dummyLabel.x = 5;
        dummyLabel.y = 10;

        normalize.undo(g);

        expect(g.edge("a", "b").points, equals([{ "x": 5, "y": 10 }]));
      });

      test("merges assigned coordinates into the 'points' attribute", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 4 });
        g.setEdge("a", "b", {});

        normalize.run(g);

        var aSucLabel = g.node(g.neighbors("a")[0]);
        aSucLabel.x = 5;
        aSucLabel.y = 10;

        var midLabel = g.node(g.successors(g.successors("a").first).first);
        midLabel.x = 20;
        midLabel.y = 25;

        var bPredLabel = g.node(g.neighbors("b")[0]);
        bPredLabel.x = 100;
        bPredLabel.y = 200;

        normalize.undo(g);

        expect(g.edge("a", "b").points, equals([{ "x": 5, "y": 10 }, { "x": 20, "y": 25 }, { "x": 100, "y": 200 }]));
      });

      test("sets coords and dims for the label, if the edge has one", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 2 });
        g.setEdge("a", "b", { "width": 10, "height": 20, "labelRank": 1 });

        normalize.run(g);

        var labelNode = g.node(g.successors("a").first);
        labelNode.x = 50;
        labelNode.y = 60;
        labelNode.width = 20;
        labelNode.height = 10;

        normalize.undo(g);

        expect(g.edge("a", "b").pick(["x", "y", "width", "height"]), equals({
          "x": 50, "y": 60, "width": 20, "height": 10
        }));
      });

      test("sets coords and dims for the label, if the long edge has one", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 4 });
        g.setEdge("a", "b", { "width": 10, "height": 20, "labelRank": 2 });

        normalize.run(g);

        var labelNode = g.node(g.successors(g.successors("a").first).first);
        labelNode.x = 50;
        labelNode.y = 60;
        labelNode.width = 20;
        labelNode.height = 10;

        normalize.undo(g);

        expect(g.edge("a", "b").pick(["x", "y", "width", "height"]), equals({
          "x": 50, "y": 60, "width": 20, "height": 10
        }));
      });

      test("restores multi-edges", () {
        g.setNode("a", { "rank": 0 });
        g.setNode("b", { "rank": 2 });
        g.setEdge("a", "b", {}, "bar");
        g.setEdge("a", "b", {}, "foo");

        normalize.run(g);

        var outEdges = g.outEdges("a").toList()..sort((Edge a, Edge b) => a.name.compareTo(b.name));
        expect(outEdges, hasLength(equals(2)));

        var barDummy = g.node(outEdges[0].w);
        barDummy.x = 5;
        barDummy.y = 10;

        var fooDummy = g.node(outEdges[1].w);
        fooDummy.x = 15;
        fooDummy.y = 20;

        normalize.undo(g);

        expect(g.hasEdge("a", "b"), isFalse);
        expect(g.edge("a", "b", "bar").points, equals([{ "x": 5, "y": 10 }]));
        expect(g.edge("a", "b", "foo").points, equals([{ "x": 15, "y": 20 }]));
      });
    });
  });
}

incidentNodes(edge) {
  return { "v": edge.v, "w": edge.w };
}

main() {
  normalizeTest();
}
