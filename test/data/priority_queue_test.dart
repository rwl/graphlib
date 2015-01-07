library graphlib.test.data.priority_queue;

import 'package:graphlib/src/data/priority_queue.dart';
import 'package:unittest/unittest.dart';

priorityQueueTest() {
  group('PriorityQueue', () {
    PriorityQueue<String> pq;

    setUp(() {
      pq = new PriorityQueue();
    });

    group('size', () {
      test('returns 0 for an empty queue', () {
        expect(pq.length, equals(0));
      });

      test('returns the number of elements in the queue', () {
        pq.add('a', 1);
        expect(pq.length, equals(1));
        pq.add('b', 2);
        expect(pq.length, equals(2));
      });
    });

    group('keys', () {
      test('returns all of the keys in the queue', () {
        final q = new PriorityQueue();
        q.add('a', 1);
        q.add(1, 2);
        q.add(false, 3);
        q.add(null, 5);
        expect(q.keys, equals(['a', 1, false, null]));
      });
    });

    group('has', () {
      test('returns true if the key is in the queue', () {
        pq.add('a', 1);
        expect(pq.has('a'), isTrue);
      });

      test('returns false if the key is not in the queue', () {
        expect(pq.has('a'), isFalse);
      });
    });

    group('priority', () {
      test('returns the current priority for the key', () {
        pq.add('a', 1);
        pq.add('b', 2);
        expect(pq.priority('a'), equals(1));
        expect(pq.priority('b'), equals(2));
      });

      test('returns undefined if the key is not in the queue', () {
        expect(pq.priority('foo'), isNull);
      });
    });

    group('min', () {
      test('throws an error if there is no element in the queue', () {
        expect(() {
          pq.min();
        }, throwsA(new isInstanceOf<PriorityQueueException>()));
      });

      test('returns the smallest element', () {
        pq.add('b', 2);
        pq.add('a', 1);
        expect(pq.min(), equals('a'));
      });

      test('does not remove the minimum element from the queue', () {
        pq.add('b', 2);
        pq.add('a', 1);
        pq.min();
        expect(pq.length, equals(2));
      });
    });

    group('add', () {
      test('adds the key to the queue', () {
        pq.add('a', 1);
        expect(pq.keys, equals(['a']));
      });

      test('returns true if the key was added', () {
        expect(pq.add('a', 1), isTrue);
      });

      test('returns false if the key already exists in the queue', () {
        pq.add('a', 1);
        expect(pq.add('a', 1), isFalse);
      });
    });

    group('removeMin', () {
      test('removes the minimum element from the queue', () {
        pq.add('b', 2);
        pq.add('a', 1);
        pq.add('c', 3);
        pq.add('e', 5);
        pq.add('d', 4);
        expect(pq.removeMin(), equals('a'));
        expect(pq.removeMin(), equals('b'));
        expect(pq.removeMin(), equals('c'));
        expect(pq.removeMin(), equals('d'));
        expect(pq.removeMin(), equals('e'));
      });

      test('throws an error if there is no element in the queue', () {
        expect(() {
          pq.removeMin();
        }, throwsA(new isInstanceOf<RangeError>()));
      });
    });

    group('decrease', () {
      test('decreases the priority of a key', () {
        pq.add('a', 1);
        pq.decrease('a', -1);
        expect(pq.priority('a'), equals(-1));
      });

      test('raises an error if the key is not in the queue', () {
        expect(() {
          pq.decrease('a', -1);
        }, throwsA(new isInstanceOf<ArgumentError>()));
      });

      test('raises an error if the new priority is greater than current', () {
        pq.add('a', 1);
        expect(() {
          pq.decrease('a', 2);
        }, throwsA(new isInstanceOf<PriorityQueueException>()));
      });
    });
  });
}

main() {
  priorityQueueTest();
}
