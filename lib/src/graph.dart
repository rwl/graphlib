library graphlib.src.graph;

import 'dart:js';
import 'dart:math' show PI, E;

import 'package:quiver/core.dart' show hash3;

const _undefined = PI * E;

/// Directed or undirected multi-graph.
class Graph {
  final JsObject _graph;

  JsObject get g => _graph;

  Graph._(this._graph);

  /// A [directed] (default: true) graph treats the order of nodes in an edge
  /// as significant. A [multigraph] (default:false) may have multiple edges
  /// between the same pair of nodes. A [compound] (default: false) graph may
  /// have nodes which can be the parent of other nodes.
  factory Graph({bool directed, bool compound, bool multigraph}) {
    var opts = {};
    if (directed != null) opts['directed'] = directed;
    if (compound != null) opts['compound'] = compound;
    if (multigraph != null) opts['multigraph'] = multigraph;
    var _opts = new JsObject.jsify(opts);
    var graph = new JsObject(context['graphlib']['Graph'], [_opts]);
    return new Graph._(graph);
  }

  /// Construct a [Graph] from a JSON string.
  factory Graph.read(String json) {
    var obj = context['JSON'].callMethod('parse', [json]);
    var g = context['graphlib']['json'].callMethod('read', [obj]);
    return new Graph._(g);
  }

  /// A directed graph treats the order of nodes in an edge as significant
  /// whereas an undirected graph does not.
  bool isDirected() => _graph.callMethod('isDirected');

  bool isMultigraph() => _graph.callMethod('isMultigraph');

  bool isCompound() => _graph.callMethod('isCompound');

  /// The currently assigned label for the graph.
  graph() => _graph.callMethod('graph');

  /// Sets the label for the graph to [label].
  setGraph(label) => _graph.callMethod('setGraph', [label]);

  int nodeCount() => _graph.callMethod('nodeCount');

  int edgeCount() => _graph.callMethod('edgeCount');

  /// Sets a new default value that is assigned to nodes that are created
  /// without a label. If [val] is not a function it is assigned as the label
  /// directly. If [val] is a function, it is called with the id of the node
  /// being created.
  setDefaultNodeLabel(val) {
    if (val is Map) {
      val = new JsObject.jsify(val);
    }
    _graph.callMethod('setDefaultNodeLabel', [val]);
  }

  /// Sets a new default value that is assigned to edges that are created
  /// without a label. If [val] is not a function it is assigned as the label
  /// directly. If [val] is a function, it is called with the parameters
  /// `(v, w, name)`.
  setDefaultEdgeLabel(val) {
    if (val is Map) {
      val = new JsObject.jsify(val);
    }
    _graph.callMethod('setDefaultEdgeLabel', [val]);
  }

  /// Returns the ids of the nodes in the graph. Use [node] to get the label
  /// for each node. Takes `O(|V|)` time.
  nodes() => _graph.callMethod('nodes');

  /// Returns the `edgeObj` for each edge in the graph. Use [edge] to get the
  /// label for each edge. Takes `O(|E|)` time.
  Iterable<Edge> edges() {
    var ret = _graph.callMethod('edges');
    return ret.map((JsObject e) {
      return new Edge._(e['v'], e['w'], e['name']);
    });
  }

  /// Returns those nodes in the graph that have no in-edges. Takes `O(|V|)`
  /// time.
  sources() => _graph.callMethod('sources');

  /// Returns those nodes in the graph that have no out-edges. Takes `O(|V|)`
  /// time.
  sinks() => _graph.callMethod('sinks');

  /// Returns true if the graph has a node with the id [v]. Takes `O(1)` time.
  hasNode(v) {
    if (v is Map) {
      v = new JsObject.jsify(v);
    }
    return _graph.callMethod('hasNode', [v]);
  }

  /// Returns the label assigned to the node with the id [v] if it is in the
  /// graph. Otherwise returns `undefined`. Takes O(1) time.
  node(v) {
    if (v is Map) {
      v = new JsObject.jsify(v);
    }
    return _graph.callMethod('node', [v]);
  }

  /// Creates or updates the value for the node [v] in the graph.
  setNode(v, [value = _undefined]) {
    var args = [v];
    if (value != _undefined) {
      if (value is Map) {
        value = new JsObject.jsify(value);
      }
      args.add(value);
    }
    return _graph.callMethod('setNode', args);
  }

  /// Remove the node with the id [v] in the graph or do nothing if the node
  /// is not in the graph. If the node was removed this function also removes
  /// any incident edges. Takes `O(|E|)` time.
  removeNode(v) => _graph.callMethod('removeNode', [v]);

  /// Return all nodes that are predecessors of the specified node or
  /// `null` if node [v] is not in the graph.
  predecessors(v) => _graph.callMethod('predecessors', [v]);

  /// Return all nodes that are successors of the specified node or `null`
  /// if node [v] is not in the graph.
  successors(v) => _graph.callMethod('successors', [v]);

  /// Return all nodes that are predecessors or successors of the specified
  /// node or `null` if node [v] is not in the graph. Takes O(|V|) time.
  neighbors(v) => _graph.callMethod('neighbors', [v]);

  /// Return all edges that point to the node [v]. Optionally filters those
  /// edges down to just those coming from node [u].
  Iterable<Edge> inEdges(v, [u]) {
    var args = [v];
    if (u != null) {
      args.add(u);
    }
    var ret = _graph.callMethod('inEdges', args);
    return ret.map((JsObject e) {
      return new Edge._(e['v'], e['w'], e['name']);
    });
  }

  /// Return all edges that are pointed at by node [v]. Optionally filters
  /// those edges down to just those point to [w].
  Iterable<Edge> outEdges(v, [w]) {
    var args = [v];
    if (w != null) {
      args.add(w);
    }
    var ret = _graph.callMethod('outEdges', args);
    return ret.map((JsObject e) {
      return new Edge._(e['v'], e['w'], e['name']);
    });
  }

  /// Returns all edges to or from node [v] regardless of direction.
  /// Optionally filters those edges down to just those between nodes
  /// [v] and [w] regardless of direction.
  Iterable<Edge> nodeEdges(v, [w = null]) {
    var args = [v];
    if (w != null) {
      args.add(w);
    }
    var ret = _graph.callMethod('nodeEdges', args);
    return ret.map((JsObject e) {
      return new Edge._(e['v'], e['w'], e['name']);
    });
  }

  /// Returns the node that is a parent of node [v] or `null` if
  /// node `v` does not have a parent or is not a member of the graph.
  parent(v) => _graph.callMethod('parent', [v]);

  /// Returns all nodes that are children of node v or `null` if node
  /// [v] is not in the graph.
  children(v) => _graph.callMethod('children', [v]);

  /// Sets the parent for [v] to [parent] if it is defined or removes the
  /// parent for [v] if parent is `undefined`.
  setParent(v, parent) => _graph.callMethod('setParent', [v, parent]);

  /// Returns true if the graph has an edge between [v] and [w] with the
  /// optional [name].
  hasEdge(v, w, [name]) {
    var args = [v, w];
    if (name != null) {
      args.add(name);
    }
    return _graph.callMethod('hasEdge', args);
  }

  /// Returns the label for the edge ([v], [w]) if the graph has an edge
  /// between [v] and [w] with the optional [name].
  edge(v, w, [name]) {
    var args = [v, w];
    if (name != null) {
      args.add(name);
    }
    return _graph.callMethod('edge', args);
  }

  /// Creates or updates the label for the edge ([v], [w]) with the optionally
  /// supplied [name].
  setEdge(v, w, [value = _undefined, name = null]) {
    var args = [v, w];

    if (value != _undefined) {
      if (value is Map) {
        value = new JsObject.jsify(value);
      }
      args.add(value);
      if (name != null) {
        args.add(name);
      }
    }
    return _graph.callMethod('setEdge', args);
  }

  /// Removes the edge ([v], [w]) if the graph has an edge between [v] and [w]
  /// with the optional [name].
  removeEdge(v, w) => _graph.callMethod('removeEdge', [v, w]);

  /// Create a JSON representation of the graph.
  String toJsonString() {
    var json = context['graphlib']['json'].callMethod('write', [_graph]);
    return context['JSON'].callMethod('stringify', [json]);
  }
}

class Edge {
  final v, w, name;

  Edge._(this.v, this.w, [this.name]);

  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (other is! Edge) {
      return false;
    }
    if (other.v != v) {
      return false;
    }
    if (other.w != w) {
      return false;
    }
    if (other.name != name) {
      return false;
    }
    return true;
  }

  int get hashCode => hash3(v.hashCode, w.hashCode, name.hashCode);

  String toString() => 'Edge(v: $v, w: $w, name: $name)';
}
