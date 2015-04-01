library graphlib.test.write;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart';

writeTest() {
  group("write", () {
    test("can write an empty digraph", () {
      var str = writeDot(new Graph());
      logMessage(str);
    });

    test("can write an empty undirected graph", () {
      var str = writeDot(new Graph(directed: false));
      logMessage(str);
    });

    test("can write a graph label with an object", () {
      var g = new Graph();
      g.setGraph({"foo": "bar"});
      var str = writeDot(g);
      logMessage(str);
    });

    test("can write a node", () {
      var g = new Graph();
      g.setNode("n1");
      var str = writeDot(g);
      logMessage(str);
    });

    test("can write a node with attributes", () {
      var g = new Graph();
      g.setNode("n1", {"foo": "bar"});
      var str = writeDot(g);
      logMessage(str);
    });

    test("can write an edge", () {
      var g = new Graph();
      g.setEdge("n1", "n2");
      var str = writeDot(g); //, { "strict": true });
      logMessage(str);
    });

    test("can write an edge with attributes", () {
      var g = new Graph();
      g.setEdge("n1", "n2", {"foo": "bar"});
      var str = writeDot(g); //, { strict: true });
      logMessage(str);
    });

    test("can write multi-edges", () {
      var g = new Graph(multigraph: true);
      g.setEdge("n1", "n2", {"foo": "bar"});
      g.setEdge("n1", "n2", {"foo": "baz"}, "another");
      var str = writeDot(g);
      logMessage(str);
    });

    test("preserves the strict (non-multigraph) state", () {
      var g = new Graph();
      var str = writeDot(g);
      logMessage(str);
    });

    test("can write ids that must be escaped", () {
      var g = new Graph();
      g.setNode("\"n1\"");
      var str = writeDot(g);
      logMessage(str);
    });

    test("can write subgraphs", () {
      var g = new Graph(compound: true);
      g.setParent("n1", "root");
      var str = writeDot(g);
      logMessage(str);
    });

    test("can write subgraphs with attributes", () {
      var g = new Graph(compound: true);
      g.setParent("n1", "root");
      g.setNode("root", {"foo": "bar"});
      var str = writeDot(g);
      logMessage(str);
    });
  });
}

/*strict digraph {
}

strict graph {
}

strict digraph {
  bar=foo;
}

strict digraph {
  n1
}

strict digraph {
  n1 [foo=bar]
}

strict digraph {
  n1
  n2
  n1 -> n2
}

strict digraph {
  n1
  n2
  n1 -> n2 [foo=bar]
}

digraph {
  n1
  n2
  n1 -> n2 [foo=bar]
  n1 -> n2 [foo=baz]
}

strict digraph {
}

strict digraph {
  "\"n1\""
}

strict digraph {
  subgraph root {
    n1
  }
}

strict digraph {
  subgraph root {
    bar=foo;
    n1
  }
}
*/
main() => writeTest();
