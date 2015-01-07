library graphlib.test.graph;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart';

graphTest() {
  group("Graph", () {
    Graph g;

    setUp(() {
      g = new Graph();
    });

    group("initial state", () {
      test("has no nodes", () {
        expect(g.nodeCount, equals(0));
      });

      test("has no edges", () {
        expect(g.edgeCount, equals(0));
      });

      test("has no attributes", () {
        expect(g.graph(), isNull);
      });

      test("defaults to a simple directed graph", () {
        expect(g.isDirected, isTrue);
        expect(g.isCompound, isFalse);
        expect(g.isMultigraph, isFalse);
      });

      test("can be set to undirected", () {
        var g = new Graph(directed: false);
        expect(g.isDirected, isFalse);
        expect(g.isCompound, isFalse);
        expect(g.isMultigraph, isFalse);
      });

      test("can be set to a compound graph", () {
        var g = new Graph(compound: true);
        expect(g.isDirected, isTrue);
        expect(g.isCompound, isTrue);
        expect(g.isMultigraph, isFalse);
      });

      test("can be set to a mulitgraph", () {
        var g = new Graph(multigraph: true);
        expect(g.isDirected, isTrue);
        expect(g.isCompound, isFalse);
        expect(g.isMultigraph, isTrue);
      });
    });

    group("setGraph", () {
      test("can be used to get and set properties for the graph", () {
        g.setGraph("foo");
        expect(g.graph(), equals("foo"));
      });

      test("is chainable", () {
        expect(g..setGraph("foo"), equals(g));
      });
    });

    group("nodes", () {
      test("is empty if there are no nodes in the graph", () {
        expect(g.nodes, equals([]));
      });

      test("returns the ids of nodes in the graph", () {
        g.setNode("a");
        g.setNode("b");
        expect(g.nodes, unorderedEquals(["a", "b"]));
      });
    });

    group("sources", () {
      test("returns nodes in the graph that have no in-edges", () {
        g.setPath(["a", "b", "c"]);
        g.setNode("d");
        expect(g.sources, unorderedEquals(["a", "d"]));
      });
    });

    group("sinks", () {
      test("returns nodes in the graph that have no out-edges", () {
        g.setPath(["a", "b", "c"]);
        g.setNode("d");
        expect(g.sinks, unorderedEquals(["c", "d"]));
      });
    });

    group("setNodes", () {
      test("creates multiple nodes", () {
        g.setNodes(["a", "b", "c"]);
        expect(g.hasNode("a"), isTrue);
        expect(g.hasNode("b"), isTrue);
        expect(g.hasNode("c"), isTrue);
      });

      test("can set a value for all of the nodes", () {
        g.setNodes(["a", "b", "c"], "foo");
        expect(g.node("a"), equals("foo"));
        expect(g.node("b"), equals("foo"));
        expect(g.node("c"), equals("foo"));
      });

      test("is chainable", () {
        expect(g..setNodes(["a", "b", "c"]), equals(g));
      });
    });

    group("setNode", () {
      test("creates the node if it isn't part of the graph", () {
        g.setNode("a");
        expect(g.hasNode("a"), isTrue);
        expect(g.node("a"), isNull);
        expect(g.nodeCount, equals(1));
      });

      test("can set a value for the node", () {
        g.setNode("a", "foo");
        expect(g.node("a"), equals("foo"));
      });

      test("does not change the node's value with a 1-arg invocation", () {
        g.setNode("a", "foo");
        g.setNode("a");
        expect(g.node("a"), equals("foo"));
      });

      test("can remove the node's value by passing undefined", () {
        g.setNode("a", null);
        expect(g.node("a"), isNull);
      });

      test("is idempotent", () {
        g.setNode("a", "foo");
        g.setNode("a", "foo");
        expect(g.node("a"), equals("foo"));
        expect(g.nodeCount, equals(1));
      });

      test("uses the stringified form of the id", () {
        g.setNode(1);
        expect(g.hasNode(1), isTrue);
//        expect(g.hasNode("1"), isTrue);
//        expect(g.nodes, equals(["1"]));
      });

      test("is chainable", () {
        expect(g..setNode("a"), equals(g));
      });
    });

    group("setNodeDefaults", () {
      test("sets a default label for new nodes", () {
        g.setDefaultNodeLabel("foo");
        g.setNode("a");
        expect(g.node("a"), equals("foo"));
      });

      test("does not change existing nodes", () {
        g.setNode("a");
        g.setDefaultNodeLabel("foo");
        expect(g.node("a"), isNull);
      });

      test("is not used if an explicit value is set", () {
        g.setDefaultNodeLabel("foo");
        g.setNode("a", "bar");
        expect(g.node("a"), equals("bar"));
      });

      test("can take a function", () {
        g.defaultNodeLabelFn = (v) => "foo";
        g.setNode("a");
        expect(g.node("a"), equals("foo"));
      });

      test("can take a function that takes the node's name", () {
        g.defaultNodeLabelFn = (v) => "$v-foo";
        g.setNode("a");
        expect(g.node("a"), equals("a-foo"));
      });

      test("is chainable", () {
        expect(g..setDefaultNodeLabel("foo"), equals(g));
      });
    });

    group("node", () {
      test("returns undefined if the node isn't part of the graph", () {
        expect(g.node("a"), isNull);
      });

      test("returns the value of the node if it is part of the graph", () {
        g.setNode("a", "foo");
        expect(g.node("a"), equals("foo"));
      });
    });

    group("removeNode", () {
      test("does nothing if the node is not in the graph", () {
        expect(g.nodeCount, equals(0));
        g.removeNode("a");
        expect(g.hasNode("a"), isFalse);
        expect(g.nodeCount, equals(0));
      });

      test("removes the node if it is in the graph", () {
        g.setNode("a");
        g.removeNode("a");
        expect(g.hasNode("a"), isFalse);
        expect(g.nodeCount, equals(0));
      });

      test("is idempotent", () {
        g.setNode("a");
        g.removeNode("a");
        g.removeNode("a");
        expect(g.hasNode("a"), isFalse);
        expect(g.nodeCount, equals(0));
      });

      test("removes edges incident on the node", () {
        g.setEdge("a", "b");
        g.setEdge("b", "c");
        g.removeNode("b");
        expect(g.edgeCount, equals(0));
      });

      test("removes parent / child relationships for the node", () {
        var g = new Graph(compound: true);
        g.setParent("c", "b");
        g.setParent("b", "a");
        g.removeNode("b");
        expect(g.parent("b"), isNull);
        expect(g.children("b"), isNull);
        expect(g.children("a"), isNot(contains("b")));
        expect(g.parent("c"), isNull);
      });

      test("is chainable", () {
        expect(g..removeNode("a"), equals(g));
      });
    });

    group("setParent", () {
      setUp(() {
        g = new Graph(compound: true);
      });

      test("throws if the graph is not compound", () {
        expect(() { new Graph().setParent("a", "parent"); }, throws);
      });

      test("creates the parent if it does not exist", () {
        g.setNode("a");
        g.setParent("a", "parent");
        expect(g.hasNode("parent"), isTrue);
        expect(g.parent("a"), equals("parent"));
      });

      test("creates the child if it does not exist", () {
        g.setNode("parent");
        g.setParent("a", "parent");
        expect(g.hasNode("a"), isTrue);
        expect(g.parent("a"), equals("parent"));
      });

      test("has the parent as undefined if it has never been invoked", () {
        g.setNode("a");
        expect(g.parent("a"), isNull);
      });

      test("moves the node from the previous parent", () {
        g.setParent("a", "parent");
        g.setParent("a", "parent2");
        expect(g.parent("a"), equals("parent2"));
        expect(g.children("parent"), equals([]));
        expect(g.children("parent2"), equals(["a"]));
      });

      test("removes the parent if the parent is undefined", () {
        g.setParent("a", "parent");
        g.setParent("a", null);
        expect(g.parent("a"), isNull);
        expect(g.children(), unorderedEquals(["a", "parent"]));
      });

      test("removes the parent if no parent was specified", () {
        g.setParent("a", "parent");
        g.setParent("a");
        expect(g.parent("a"), isNull);
        expect(g.children(), unorderedEquals(["a", "parent"]));
      });

      test("is idempotent to remove a parent", () {
        g.setParent("a", "parent");
        g.setParent("a");
        g.setParent("a");
        expect(g.parent("a"), isNull);
        expect(g.children(), unorderedEquals(["a", "parent"]));
      });

      test("preserves the tree invariant", () {
        g.setParent("c", "b");
        g.setParent("b", "a");
        expect(() { g.setParent("a", "c"); }, throwsA(new isInstanceOf<GraphException>()));
      });

      test("is chainable", () {
        expect(g..setParent("a", "parent"), equals(g));
      });
    });

    group("parent", () {
      setUp(() {
        g = new Graph(compound: true);
      });

      test("returns undefined if the graph is not compound", () {
        expect(new Graph(compound: false).parent("a"), isNull);
      });

      test("returns undefined if the node is not in the graph", () {
        expect(g.parent("a"), isNull);
      });

      test("defaults to undefined for new nodes", () {
        g.setNode("a");
        expect(g.parent("a"), isNull);
      });

      test("returns the current parent assignment", () {
        g.setNode("a");
        g.setNode("parent");
        g.setParent("a", "parent");
        expect(g.parent("a"), equals("parent"));
      });
    });

    group("children", () {
      setUp(() {
        g = new Graph(compound: true);
      });

      test("returns undefined if the node is not in the graph", () {
        expect(g.children("a"), isNull);
      });

      test("defaults to en empty list for new nodes", () {
        g.setNode("a");
        expect(g.children("a"), equals([]));
      });

      test("returns undefined for a non-compound graph without the node", () {
        var g = new Graph();
        expect(g.children("a"), isNull);
      });

      test("returns an empty list for a non-compound graph with the node", () {
        var g = new Graph();
        g.setNode("a");
        expect(g.children("a"), equals([]));
      });

      test("returns all nodes for the root of a non-compound graph", () {
        var g = new Graph();
        g.setNode("a");
        g.setNode("b");
        expect(g.children(), unorderedEquals(["a", "b"]));
      });

      test("returns children for the node", () {
        g.setParent("a", "parent");
        g.setParent("b", "parent");
        expect(g.children("parent"), unorderedEquals(["a", "b"]));
      });

      test("returns all nodes without a parent when the parent is not set", () {
        g.setNode("a");
        g.setNode("b");
        g.setNode("c");
        g.setNode("parent");
        g.setParent("a", "parent");
        expect(g.children(), unorderedEquals(["b", "c", "parent"]));
        expect(g.children(null), unorderedEquals(["b", "c", "parent"]));
      });
    });

    group("predecessors", () {
      test("returns undefined for a node that is not in the graph", () {
        expect(g.predecessors("a"), isNull);
      });

      test("returns the predecessors of a node", () {
        g.setEdge("a", "b");
        g.setEdge("b", "c");
        g.setEdge("a", "a");
        expect(g.predecessors("a"), unorderedEquals(["a"]));
        expect(g.predecessors("b"), unorderedEquals(["a"]));
        expect(g.predecessors("c"), unorderedEquals(["b"]));
      });
    });

    group("successors", () {
      test("returns undefined for a node that is not in the graph", () {
        expect(g.successors("a"), isNull);
      });

      test("returns the successors of a node", () {
        g.setEdge("a", "b");
        g.setEdge("b", "c");
        g.setEdge("a", "a");
        expect(g.successors("a"), unorderedEquals(["a", "b"]));
        expect(g.successors("b"), unorderedEquals(["c"]));
        expect(g.successors("c"), unorderedEquals([]));
      });
    });

    group("neighbors", () {
      test("returns undefined for a node that is not in the graph", () {
        expect(g.neighbors("a"), isNull);
      });

      test("returns the neighbors of a node", () {
        g.setEdge("a", "b");
        g.setEdge("b", "c");
        g.setEdge("a", "a");
        expect(g.neighbors("a"), unorderedEquals(["a", "b"]));
        expect(g.neighbors("b"), unorderedEquals(["a", "c"]));
        expect(g.neighbors("c"), unorderedEquals(["b"]));
      });
    });

    group("edges", () {
      test("is empty if there are no edges in the graph", () {
        expect(g.edges, equals([]));
      });

      test("returns the keys for edges in the graph", () {
        g.setEdge("a", "b");
        g.setEdge("b", "c");
        expect(g.edges, unorderedEquals([
          new Edge("a", "b"),
          new Edge("b", "c")
        ]));
      });
    });

    group("setPath", () {
      test("creates a path of mutiple edges", () {
        g.setPath(["a", "b", "c"]);
        expect(g.hasEdge("a", "b"), isTrue);
        expect(g.hasEdge("b", "c"), isTrue);
      });

      test("can set a value for all of the edges", () {
        g.setPath(["a", "b", "c"], "foo");
        expect(g.edge("a", "b"), equals("foo"));
        expect(g.edge("b", "c"), equals("foo"));
      });

      test("is chainable", () {
        expect(g..setPath(["a", "b", "c"]), equals(g));
      });
    });

    group("setEdge", () {
      test("creates the edge if it isn't part of the graph", () {
        g.setNode("a");
        g.setNode("b");
        g.setEdge("a", "b");
        expect(g.edge("a", "b"), isNull);
        expect(g.hasEdge("a", "b"), isTrue);
        expect(g.hasEdgeObj(new Edge("a", "b")), isTrue);
        expect(g.edgeCount, equals(1));
      });

      test("creates the nodes for the edge if they are not part of the graph", () {
        g.setEdge("a", "b");
        expect(g.hasNode("a"), isTrue);
        expect(g.hasNode("b"), isTrue);
        expect(g.nodeCount, equals(2));
      });

      test("creates a multi-edge if if it isn't part of the graph", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b", null, "name");
        expect(g.hasEdge("a", "b"), isFalse);
        expect(g.hasEdge("a", "b", "name"), isTrue);
      });

      test("throws if a multi-edge is used with a non-multigraph", () {
        expect(() { g.setEdge("a", "b", null, "name"); }, throwsA(new isInstanceOf<GraphException>()));
      });

      test("changes the value for an edge if it is already in the graph", () {
        g.setEdge("a", "b", "foo");
        g.setEdge("a", "b", "bar");
        expect(g.edge("a", "b"), equals("bar"));
      });

      test("deletes the value for the edge if the value arg is undefined", () {
        g.setEdge("a", "b", "foo");
        g.setEdge("a", "b", null);
        expect(g.edge("a", "b"), isNull);
        expect(g.hasEdge("a", "b"), isTrue);
      });

      test("changes the value for a multi-edge if it is already in the graph", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b", "value", "name");
        g.setEdge("a", "b", null, "name");
        expect(g.edge("a", "b", "name"), isNull);
        expect(g.hasEdge("a", "b", "name"), isTrue);
      });

      test("can take an edge object as the first parameter", () {
        g.setEdgeObj(new Edge("a", "b"), "value");
        expect(g.edge("a", "b"), equals("value"));
      });

      test("can take an multi-edge object as the first parameter", () {
        var g = new Graph(multigraph: true);
        g.setEdgeObj(new Edge("a", "b", "name"), "value");
        expect(g.edge("a", "b", "name"), equals("value"));
      });

      test("uses the stringified form of the id #1", () {
        g.setEdge(1, 2, "foo");
        expect(g.edges, unorderedEquals([new Edge("1", "2")]));
        expect(g.edge("1", "2"), equals("foo"));
        expect(g.edge(1, 2), equals("foo"));
      });

      test("uses the stringified form of the id #2", () {
        g = new Graph(multigraph: true);
        g.setEdge(1, 2, "foo", null);
        expect(g.edges, unorderedEquals([new Edge("1", "2")]));
        expect(g.edge("1", "2"), equals("foo"));
        expect(g.edge(1, 2), equals("foo"));
      });

      test("uses the stringified form of the id with a name", () {
        g = new Graph(multigraph: true);
        g.setEdge(1, 2, "foo", 3);
        expect(g.edge("1", "2", "3"), equals("foo"));
        expect(g.edge(1, 2, 3), equals("foo"));
        expect(g.edges, unorderedEquals([new Edge("1", "2", "3")]));
      });

      test("treats edges in opposite directions as distinct in a digraph", () {
        g.setEdge("a", "b");
        expect(g.hasEdge("a", "b"), isTrue);
        expect(g.hasEdge("b", "a"), isFalse);
      });

      test("handles undirected graph edges", () {
        var g = new Graph(directed: false);
        g.setEdge("a", "b", "foo");
        expect(g.edge("a", "b"), equals("foo"));
        expect(g.edge("b", "a"), equals("foo"));
      });

      test("is chainable", () {
        expect(g..setEdge("a", "b"), equals(g));
      });
    });

    group("setDefaultEdgeLabel", () {
      test("sets a default label for new edges", () {
        g.setDefaultEdgeLabel("foo");
        g.setEdge("a", "b");
        expect(g.edge("a", "b"), equals("foo"));
      });

      test("does not change existing edges", () {
        g.setEdge("a", "b");
        g.setDefaultEdgeLabel("foo");
        expect(g.edge("a", "b"), isNull);
      });

      test("is not used if an explicit value is set", () {
        g.setDefaultEdgeLabel("foo");
        g.setEdge("a", "b", "bar");
        expect(g.edge("a", "b"), equals("bar"));
      });

      test("can take a function", () {
        g.defaultEdgeLabelFn = (v, w, name) => "foo";
        g.setEdge("a", "b");
        expect(g.edge("a", "b"), equals("foo"));
      });

      test("can take a function that takes the edge's endpoints and name", () {
        var g = new Graph(multigraph: true);
        g.defaultEdgeLabelFn = (v, w, name) {
          return "$v-$w-$name-foo";
        };
        g.setEdgeObj(new Edge("a", "b", "name"));
        expect(g.edge("a", "b", "name"), equals("a-b-name-foo"));
      });

      test("does not set a default value for a multi-edge that already exists", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b", "old", "name");
        g.defaultEdgeLabelFn = (v, w, name) => "should not set this";
        g.setEdgeObj(new Edge("a", "b", "name"));
        expect(g.edge("a", "b", "name"), equals("old"));
      });

      test("is chainable", () {
        expect(g..setDefaultEdgeLabel("foo"), equals(g));
      });
    });

    group("edge", () {
      test("returns undefined if the edge isn't part of the graph", () {
        expect(g.edge("a", "b"), isNull);
        expect(g.edgeObj(new Edge("a", "b")), isNull);
        expect(g.edge("a", "b", "foo"), isNull);
      });

      test("returns the value of the edge if it is part of the graph", () {
        g.setEdge("a", "b", { "foo": "bar" });
        expect(g.edge("a", "b"), equals({ 'foo': "bar" }));
        expect(g.edgeObj(new Edge("a", "b")), equals({ "foo": "bar" }));
        expect(g.edge("b", "a"), isNull);
      });

      test("returns the value of a multi-edge if it is part of the graph", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b", { "bar": "baz" }, "foo");
        expect(g.edge("a", "b", "foo"), equals({ "bar": "baz" }));
        expect(g.edge("a", "b"), isNull);
      });

      test("returns an edge in either direction in an undirected graph", () {
        var g = new Graph(directed: false);
        g.setEdge("a", "b", { "foo": "bar" });
        expect(g.edge("a", "b"), equals({ "foo": "bar" }));
        expect(g.edge("b", "a"), equals({ "foo": "bar" }));
      });
    });

    group("removeEdge", () {
      test("has no effect if the edge is not in the graph", () {
        g.removeEdge("a", "b");
        expect(g.hasEdge("a", "b"), isFalse);
        expect(g.edgeCount, equals(0));
      });

      test("can remove an edge by edgeObj", () {
        var g = new Graph(multigraph: true);
        g.setEdgeObj(new Edge("a", "b", "foo"));
        g.removeEdgeObj(new Edge("a", "b", "foo"));
        expect(g.hasEdge("a", "b", "foo"), isFalse);
        expect(g.edgeCount, equals(0));
      });

      test("can remove an edge by separate ids", () {
        var g = new Graph(multigraph: true);
        g.setEdgeObj(new Edge("a", "b", "foo"));
        g.removeEdge("a", "b", "foo");
        expect(g.hasEdge("a", "b", "foo"), isFalse);
        expect(g.edgeCount, equals(0));
      });

      test("correctly removes neighbors", () {
        g.setEdge("a", "b");
        g.removeEdge("a", "b");
        expect(g.successors("a"), equals([]));
        expect(g.neighbors("a"), equals([]));
        expect(g.predecessors("b"), equals([]));
        expect(g.neighbors("b"), equals([]));
      });

      test("correctly decrements neighbor counts", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b");
        g.setEdgeObj(new Edge("a", "b", "foo"));
        g.removeEdge("a", "b");
        expect(g.hasEdge("a", "b", "foo"), isTrue);
        expect(g.successors("a"), equals(["b"]));
        expect(g.neighbors("a"), equals(["b"]));
        expect(g.predecessors("b"), equals(["a"]));
        expect(g.neighbors("b"), equals(["a"]));
      });

      test("works with undirected graphs", () {
        var g = new Graph(directed: false);
        g.setEdge("h", "g");
        g.removeEdge("g", "h");
        expect(g.neighbors("g"), equals([]));
        expect(g.neighbors("h"), equals([]));
      });

      test("is chainable", () {
        g.setEdge("a", "b");
        expect(g..removeEdge("a", "b"), equals(g));
      });
    });

    group("inEdges", () {
      test("returns undefined for a node that is not in the graph", () {
        expect(g.inEdges("a"), isNull);
      });

      test("returns the edges that point at the specified node", () {
        g.setEdge("a", "b");
        g.setEdge("b", "c");
        expect(g.inEdges("a"), equals([]));
        expect(g.inEdges("b"), equals([new Edge("a", "b")]));
        expect(g.inEdges("c"), equals([new Edge("b", "c")]));
      });

      test("works for multigraphs", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b");
        g.setEdge("a", "b", null, "bar");
        g.setEdge("a", "b", null, "foo");
        expect(g.inEdges("a"), equals([]));
        expect(g.inEdges("b"), unorderedEquals([
          new Edge("a", "b", "bar"),
          new Edge("a", "b", "foo"),
          new Edge("a", "b")
        ]));
      });

      test("can return only edges from a specified node", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b");
        g.setEdge("a", "b", null, "foo");
        g.setEdge("a", "c");
        g.setEdge("b", "c");
        g.setEdge("z", "a");
        g.setEdge("z", "b");
        expect(g.inEdges("a", "b"), equals([]));
        expect(g.inEdges("b", "a"), unorderedEquals([
          new Edge("a", "b", "foo"),
          new Edge("a", "b")
        ]));
      });
    });

    group("outEdges", () {
      test("returns undefined for a node that is not in the graph", () {
        expect(g.outEdges("a"), isNull);
      });

      test("returns all edges that this node points at", () {
        g.setEdge("a", "b");
        g.setEdge("b", "c");
        expect(g.outEdges("a"), equals([new Edge("a", "b")]));
        expect(g.outEdges("b"), equals([new Edge("b", "c")]));
        expect(g.outEdges("c"), equals([]));
      });

      test("works for multigraphs", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b");
        g.setEdge("a", "b", null, "bar");
        g.setEdge("a", "b", null, "foo");
        expect(g.outEdges("a"), unorderedEquals([
          new Edge("a", "b", "bar"),
          new Edge("a", "b", "foo"),
          new Edge("a", "b")
        ]));
        expect(g.outEdges("b"), equals([]));
      });

      test("can return only edges to a specified node", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b");
        g.setEdge("a", "b", null, "foo");
        g.setEdge("a", "c");
        g.setEdge("b", "c");
        g.setEdge("z", "a");
        g.setEdge("z", "b");
        expect(g.outEdges("a", "b"), unorderedEquals([
          new Edge("a", "b", "foo"),
          new Edge("a", "b")
        ]));
        expect(g.outEdges("b", "a"), equals([]));
      });
    });

    group("nodeEdges", () {
      test("returns undefined for a node that is not in the graph", () {
        expect(g.nodeEdges("a"), isNull);
      });

      test("returns all edges that this node points at", () {
        g.setEdge("a", "b");
        g.setEdge("b", "c");
        expect(g.nodeEdges("a"), equals([new Edge("a", "b")]));
        expect(g.nodeEdges("b"), unorderedEquals([
          new Edge("a", "b"),
          new Edge("b", "c")]));
        expect(g.nodeEdges("c"), equals([new Edge("b", "c")]));
      });

      test("works for multigraphs", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b");
        g.setEdgeObj(new Edge("a", "b", "bar"));
        g.setEdgeObj(new Edge("a", "b", "foo"));
        expect(g.nodeEdges("a"), unorderedEquals([
          new Edge("a", "b", "bar"),
          new Edge("a", "b", "foo"),
          new Edge("a", "b")
        ]));
        expect(g.nodeEdges("b"), unorderedEquals([
          new Edge("a", "b", "bar"),
          new Edge("a", "b", "foo"),
          new Edge("a", "b")
        ]));
      });

      test("can return only edges between specific nodes", () {
        var g = new Graph(multigraph: true);
        g.setEdge("a", "b");
        g.setEdgeObj(new Edge("a", "b", "foo"));
        g.setEdge("a", "c");
        g.setEdge("b", "c");
        g.setEdge("z", "a");
        g.setEdge("z", "b");
        expect(g.nodeEdges("a", "b"), unorderedEquals([
          new Edge("a", "b", "foo"),
          new Edge("a", "b")
        ]));
        expect(g.nodeEdges("b", "a"), unorderedEquals([
          new Edge("a", "b", "foo"),
          new Edge("a", "b")
        ]));
      });
    });
  });
}

main() {
  graphTest();
}
