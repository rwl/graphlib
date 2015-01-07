library graphlib.test.layout.nesting_graph;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, components;
import 'package:graphlib/src/layout/nesting_graph.dart' as nestingGraph;

nestingGraphTest() {
  group("rank/nestingGraph", () {
    Graph g;

    setUp(() {
      g = new Graph(compound: true)
            ..setGraph({})
            ..defaultNodeLabelFn = (v) => {};
    });

    group("run", () {
      test("connects a disconnected graph", () {
        g.setNode("a");
        g.setNode("b");
        expect(components(g), hasLength(equals(2)));
        nestingGraph.run(g);
        expect(components(g), hasLength(equals(1)));
        expect(g.hasNode("a"), isTrue);
        expect(g.hasNode("b"), isTrue);
      });

      test("adds border nodes to the top and bottom of a subgraph", () {
        g.setParent("a", "sg1");
        nestingGraph.run(g);

        var borderTop = g.node("sg1")["borderTop"],
            borderBottom = g.node("sg1")["borderBottom"];
        expect(borderTop, isNotNull/*exists*/);
        expect(borderBottom, isNotNull/*exists*/);
        expect(g.parent(borderTop), equals("sg1"));
        expect(g.parent(borderBottom), equals("sg1"));
        expect(g.outEdges(borderTop, "a"), hasLength(equals(1)));
        expect(g.edgeObj(g.outEdges(borderTop, "a").first)["minlen"], equals(1));
        expect(g.outEdges("a", borderBottom), hasLength(equals(1)));
        expect(g.edgeObj(g.outEdges("a", borderBottom).first)["minlen"], equals(1));
        expect(g.node(borderTop), equals({ "width": 0, "height": 0, "dummy": "border" }));
        expect(g.node(borderBottom), equals({ "width": 0, "height": 0, "dummy": "border" }));
      });

      test("adds edges between borders of nested subgraphs", () {
        g.setParent("sg2", "sg1");
        g.setParent("a", "sg2");
        nestingGraph.run(g);

        var sg1Top = g.node("sg1")["borderTop"],
            sg1Bottom = g.node("sg1")["borderBottom"],
            sg2Top = g.node("sg2")["borderTop"],
            sg2Bottom = g.node("sg2")["borderBottom"];
        expect(sg1Top, isNotNull/*exists*/);
        expect(sg1Bottom, isNotNull/*exists*/);
        expect(sg2Top, isNotNull/*exists*/);
        expect(sg2Bottom, isNotNull/*exists*/);
        expect(g.outEdges(sg1Top, sg2Top), hasLength(equals(1)));
        expect(g.edgeObj(g.outEdges(sg1Top, sg2Top).first)["minlen"], equals(1));
        expect(g.outEdges(sg2Bottom, sg1Bottom), hasLength(equals(1)));
        expect(g.edgeObj(g.outEdges(sg2Bottom, sg1Bottom).first)["minlen"], equals(1));
      });

      test("adds sufficient weight to border to node edges", () {
        // We want to keep subgraphs tight, so we should ensure that the weight for
        // the edge between the top (and bottom) border nodes and nodes in the
        // subgraph have weights exceeding anything in the graph.
        g.setParent("x", "sg");
        g.setEdge("a", "x", { "weight": 100 });
        g.setEdge("x", "b", { "weight": 200 });
        nestingGraph.run(g);

        var top = g.node("sg").borderTop,
            bot = g.node("sg").borderBottom;
        expect(g.edge(top, "x").weight, greaterThan(300));
        expect(g.edge("x", bot).weight, greaterThan(300));
      });

      test("adds an edge from the root to the tops of top-level subgraphs", () {
        g.setParent("a", "sg1");
        nestingGraph.run(g);

        var root = g.graph().nestingRoot,
            borderTop = g.node("sg1").borderTop;
        expect(root, isNotNull/*exists*/);
        expect(borderTop, isNotNull/*exists*/);
        expect(g.outEdges(root, borderTop), hasLength(equals(1)));
        expect(g.hasEdgeObj(g.outEdges(root, borderTop).first), isTrue);
      });

      test("adds an edge from root to each node with the correct minlen #1", () {
        g.setNode("a");
        nestingGraph.run(g);

        var root = g.graph().nestingRoot;
        expect(root, isNotNull/*exists*/);
        expect(g.outEdges(root, "a"), hasLength(equals(1)));
        expect(g.edgeObj(g.outEdges(root, "a").first), equals({ "weight": 0, "minlen": 1 }));
      });

      test("adds an edge from root to each node with the correct minlen #2", () {
        g.setParent("a", "sg1");
        nestingGraph.run(g);

        var root = g.graph().nestingRoot;
        expect(root, isNotNull/*exists*/);
        expect(g.outEdges(root, "a"), hasLength(equals(1)));
        expect(g.edgeObj(g.outEdges(root, "a").first), equals({ "weight": 0, "minlen": 3 }));
      });

      test("adds an edge from root to each node with the correct minlen #3", () {
        g.setParent("sg2", "sg1");
        g.setParent("a", "sg2");
        nestingGraph.run(g);

        var root = g.graph().nestingRoot;
        expect(root, isNotNull/*exists*/);
        expect(g.outEdges(root, "a"), hasLength(equals(1)));
        expect(g.edgeObj(g.outEdges(root, "a").first), equals({ "weight": 0, "minlen": 5 }));
      });

      test("does not add an edge from the root to itself", () {
        g.setNode("a");
        nestingGraph.run(g);

        var root = g.graph().nestingRoot;
        expect(g.outEdges(root, root), equals([]));
      });

      test("expands inter-node edges to separate SG border and nodes #1", () {
        g.setEdge("a", "b", { "minlen": 1 });
        nestingGraph.run(g);
        expect(g.edge("a", "b").minlen, equals(1));
      });

      test("expands inter-node edges to separate SG border and nodes #2", () {
        g.setParent("a", "sg1");
        g.setEdge("a", "b", { "minlen": 1 });
        nestingGraph.run(g);
        expect(g.edge("a", "b").minlen, equals(3));
      });

      test("expands inter-node edges to separate SG border and nodes #3", () {
        g.setParent("sg2", "sg1");
        g.setParent("a", "sg2");
        g.setEdge("a", "b", { "minlen": 1 });
        nestingGraph.run(g);
        expect(g.edge("a", "b").minlen, equals(5));
      });

      test("sets minlen correctly for nested SG boder to children", () {
        g.setParent("a", "sg1");
        g.setParent("sg2", "sg1");
        g.setParent("b", "sg2");
        nestingGraph.run(g);

        // We expect the following layering:
        //
        // 0: root
        // 1: empty (close sg2)
        // 2: empty (close sg1)
        // 3: open sg1
        // 4: open sg2
        // 5: a, b
        // 6: close sg2
        // 7: close sg1

        var root = g.graph().nestingRoot,
            sg1Top = g.node("sg1").borderTop,
            sg1Bot = g.node("sg1").borderBottom,
            sg2Top = g.node("sg2").borderTop,
            sg2Bot = g.node("sg2").borderBottom;

        expect(g.edge(root, sg1Top).minlen, equals(3));
        expect(g.edge(sg1Top, sg2Top).minlen, equals(1));
        expect(g.edge(sg1Top, "a").minlen, equals(2));
        expect(g.edge("a", sg1Bot).minlen, equals(2));
        expect(g.edge(sg2Top, "b").minlen, equals(1));
        expect(g.edge("b", sg2Bot).minlen, equals(1));
        expect(g.edge(sg2Bot, sg1Bot).minlen, equals(1));
      });
    });

    group("cleanup", () {
      test("removes nesting graph edges", () {
        g.setParent("a", "sg1");
        g.setEdge("a", "b", { "minlen": 1 });
        nestingGraph.run(g);
        nestingGraph.cleanup(g);
        expect(g.successors("a"), equals(["b"]));
      });

      test("removes the root node", () {
        g.setParent("a", "sg1");
        nestingGraph.run(g);
        nestingGraph.cleanup(g);
        expect(g.nodeCount, equals(4)); // sg1 + sg1Top + sg1Bottom + "a"
      });
    });
  });
}

main() {
  nestingGraphTest();
}
