library graphlib.src.alg;

import 'dart:js';
import 'package:quiver/core.dart' show hash2;
import 'graph.dart';

final weightFunc DEFAULT_WEIGHT_FUNC = (_) => 1;

typedef num weightFunc(Edge e);
typedef List<Edge> edgeFunc(v);

class Path<U> {
  final num distance;
  final U predecessor;

  Path._({this.distance: 0.0, this.predecessor});

  bool operator ==(Path other) {
    if (other == null) {
      return false;
    }
    if (distance != other.distance) {
      return false;
    }
    if (predecessor != other.predecessor) {
      return false;
    }
    return true;
  }

  int get hashCode => hash2(distance, predecessor);
}

components(Graph graph) {
  return context['alg']['components'](graph.g);
}
