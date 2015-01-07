library graphlib.test.layout.lodash;

import "package:unittest/unittest.dart";
import "package:graphlib/src/layout/lodash.dart" as lodash;

lodashTest() {
  group("lodash", () {
    group("min", () {
      test('should return the smallest value from a collection', () {
        expect(lodash.min([1, 2, 3]), equals(1));
      });
      test('should return `Infinity` for empty collections', () {
        expect(lodash.min([]), equals(double.INFINITY));
      });
//      test('should return `Infinity` for non-numeric collection values', () {
//        var collections = [['a', 'b'], { 'a': 'a', 'b': 'b' }],
//        expected = collections.map((_) => double.INFINITY);
//        var actual = collections.map((value) {
//          try {
//            return lodash.min(value);
//          } catch(e) {
//          }
//        });
//        expect(expected, equals(actual));
//      });


      var array = [1, 2, 3];
//      test('should work with DateTime objects', () {
//        var now = new DateTime.now(),
//          past = new DateTime(0);
//          expect(lodash.min([now, past]), equals(past));
//      });
      test('should work with a `callback` argument', () {
        var actual = lodash.min(array, (n) => -n);
        expect(actual, equals(3));
      });
//      test('should pass the correct `callback` arguments when iterating an array', () {
//        var args;
//        lodash.min(array, (_) {
//          args || (args = slice.call(arguments));
//        });
//        expect(args, [1, 0, array]);
//      });
//      test('should pass the correct `callback` arguments when iterating an object', () {
//        var args,
//          object = { 'a': 1, 'b': 2 },
//          firstKey = _.first(lodash.keys(object));
//        var expected = firstKey == 'a'
//          ? [1, 'a', object]
//          : [2, 'b', object];
//        lodash.min(object, () {
//          args || (args = slice.call(arguments));
//        }, 0);
//        expect(args, expected);
//      });
//      test('should support the `thisArg` argument', () {
//        var actual = lodash.min(array, (num, index) {
//          return -self[index];
//        }, array);
//        equal(actual, methodName == 'max' ? 1 : 3);
//      });
      test('should work when used as `callback` for `_.map`', () {
        var array = [[2, 3, 1], [5, 6, 4], [8, 9, 7]],
        actual = array.map(lodash.min);
        expect(actual, equals([1, 4, 7]));
      });
      /*test('should iterate an object', () {
        var actual = lodash.min({ 'a': 1, 'b': 2, 'c': 3 });
        equal(actual, methodName == 'max' ? 3 : 1);
      });
      test('should iterate a string', () {
        _.forEach(['abc', Object('abc')], (value) {
          var actual = lodash.min(value);
          equal(actual, methodName == 'max' ? 'c' : 'a');
        });
      });*/
      test('should resolve the correct value when provided an array containing only one value', () {
        var actual = lodash.min([40]);
        expect(actual, equals(40));
      });
      test('should work with extremely large arrays', () {
        var array = lodash.range(0, 5e5.toInt());
        expect(lodash.min(array), /*499999*/equals(0));
      });
    });
    group("max", () {

    });
    group("flatten", () {
      var args = [1, 2, 3],//args = arguments,
        array = [{ 'a': [1, [2]] }, { 'a': [3] }];
      test('should flatten `arguments` objects', () {
        var actual = lodash.flatten([args, args]);
        expect(actual, equals([1, 2, 3, 1, 2, 3]));
      });
      test('should work with a `callback`', () {
        var actual = lodash.flatten(array, (m) => m["a"]);
        //expect(actual, equals([1, 2, 3]));
        expect(actual, equals([1, [2], 3]));
      });
//      test('should work with `isShallow` and `callback`', () {
//        var actual = lodash.flatten(array, true, (object) {
//          return object.a;
//        });
//        expect(actual, [1, [2], 3]);
//      });
//      test('should pass the correct `callback` arguments', () {
//        var args;
//        _.flatten(array, () {
//          args || (args = slice.call(arguments));
//        });
//        expect(args, [{ 'a': [1, [2]] }, 0, array]);
//      });
//      test('should support the `thisArg` argument', () {
//        var actual = _.flatten(array, (object, index) {
//          return self[index].a;
//        }, array);
//        expect(actual, [1, 2, 3]);
//      });
      test('should work with a string for `callback`', () {
        expect(lodash.flatten(array, 'a'), equals([1, 2, 3]));
      });
//      test('should perform a deep flatten when used as `callback` for `_.map`', () {
//        var array = [[[['a']]], [[['b']]]],
//          actual = _.map(array, _.flatten);
//        expect(actual, [['a'], ['b']]);
//      });
//      test('should treat sparse arrays as dense', () {
//        var array = [[1, 2, 3], Array(3)],
//          expected = [1, 2, 3],
//          actual1 = _.flatten(array),
//          actual2 = _.flatten(array, true);
//        expected.push(undefined, undefined, undefined);
//        expect(actual1, expected);
//        expect(actual1, contains(4));
//        expect(actual2, expected);
//        expect(actual2, contains(4));
//      });
//      test('should work with extremely large arrays', () {
//        var expected = Array(5e5),
//        pass = true;
//        if (freeze) {
//          try {
//            var actual = _.flatten([expected]);
//          } catch(e) {
//            pass = false;
//          }
//          if (pass) {
//            expect(actual, expected);
//          } else {
//            ok(pass);
//          }
//        } else {
//          skipTest();
//        }
//      });
//      test('should work with empty arrays', () {
//        var actual = _.flatten([[], [[]], [[], [[[]]]]]);
//        expect(actual, []);
//      });
//      test('should flatten nested arrays', () {
//        var array = [1, [2], [3, [[4]]]],
//        expected = [1, 2, 3, 4];
//        expect(lodash.flatten(array), expected);
//      });
      test('should support shallow flattening nested arrays', () {
        var array = [1, [2], [3, [4]]],
        expected = [1, 2, 3, [4]];
        expect(lodash.flatten(array), equals(expected));
      });
      test('should support shallow flattening arrays of other arrays', () {
        var array = [[1], [2], [3], [[4]]],
        expected = [1, 2, 3, [4]];
        expect(lodash.flatten(array), equals(expected));
      });
    });
    group("pick", () {
      var args = ['a', 'c'],
        object = { 'a': 1, 'b': 2, 'c': 3 },
        expected = { 'a': 1, 'c': 3 };
      test('should create an object of picked properties', () {
        expect(lodash.pick(object, 'a'), equals({ 'a': 1 }));
        expect(lodash.pick(object, 'a', 'c'), equals(expected));
      });
      test('should support picking an array of properties', () {
        expect(lodash.pick(object, ['a', 'c']), equals(expected));
      });
      test('should support picking an array of properties and individual properties', () {
        expect(lodash.pick(object, ['a'], 'c'), equals(expected));
      });
      test('should iterate over inherited properties', () {
        Foo() {}
          Foo.prototype = object;
        expect(lodash.pick(new Foo(), 'a', 'c'), equals(expected));
      });
      test('should work with `arguments` objects as secondary arguments', () {
        expect(lodash.pick(object, args), equals(expected));
      });
      test('should work with an array `object` argument', () {
        expect(lodash.pick([1, 2, 3], '1'), equals({ '1': 2 }));
      });
      test('should work with a `callback` argument', () {
        var actual = lodash.pick(object, (n) => n != 2);
        expect(actual, expected);
      });
//      test('should pass the correct `callback` arguments', () {
//        var args,
//          object = { 'a': 1, 'b': 2 },
//          lastKey = _.keys(object).pop();
//        var expected = lastKey == 'b'
//          ? [1, 'a', object]
//          : [2, 'b', object];
//        lodash.pick(object, () {
//          args || (args = slice.call(arguments));
//        });
//        expect(args, expected);
//      });
//      test('should correctly set the `this` binding', () {
//        var actual = lodash.pick(object, (num) {
//          return num != self.b;
//        }, { 'b': 2 });
//        expect(actual, expected);
//      });
    });
    group("mapValues", () {
      var object = { 'a': 1, 'b': 2, 'c': 3 };
      test('should pass the correct `callback` arguments', () {
        var args;
        lodash.mapValues(object, () {
          args || (args = slice.call(arguments));
        });
        expect(args, equals([1, 'a', object]));
      });
      test('should support the `thisArg` argument', () {
        callback(num, key) {
          return self[key] + num;
        }
        var actual = lodash.mapValues({ 'a': 1 }, callback, { 'a': 2 });
        expect(actual, { 'a': 3 });
        actual = lodash.mapValues([1], callback, [2]);
        expect(actual, { '0': 3 });
      });
      test('should iterate over own properties of objects', () {
        Foo() { self.a = 1; }
        Foo.prototype.b = 2;
        var actual = lodash.mapValues(new Foo(), (value, key) => key);
        expect(actual, equals({ 'a': 'a' }));
      });
      test('should work on an object with no `callback`', () {
        var actual = lodash.mapValues({ 'a': 1, 'b': 2, 'c': 3 });
        expect(actual, equals(object));
      });
//      test('should return a wrapped value when chaining', () {
//        if (!isNpm) {
//          ok(_(object).mapValues(noop) instanceof _);
//        } else {
//          skipTest();
//        }
//      });
      test('should accept a falsey `object` argument', () {
        var expected = falsey.map(() => {});
        var actual = falsey.map((value, index) {
          try {
            return index ? lodash.mapValues(value) : lodash.mapValues();
          } catch(e) {
          }
        });
        expect(actual, equals(expected));
      });
    });
    group("defaults", () {
      test('should assign properties of a source object if missing on the destination object', () {
        expect(lodash.defaults({ 'a': 1 }, { 'a': 2, 'b': 2 }), { 'a': 1, 'b': 2 });
      });
      test('should assign own source properties', () {
        Foo() {
          self.a = 1;
          self.c = 3;
        }
        Foo.prototype.b = 2;
        expect(lodash.defaults({ 'c': 2 }, new Foo()), { 'a': 1, 'c': 2 });
      });
      test('should accept multiple source objects', () {
        var expected = { 'a': 1, 'b': 2, 'c': 3 };
        expect(lodash.defaults({ 'a': 1, 'b': 2 }, { 'b': 3 }, { 'c': 3 }), equals(expected));
        expect(lodash.defaults({ 'a': 1, 'b': 2 }, { 'b': 3, 'c': 3 }, { 'c': 2 }), equals(expected));
      });
      test('should not overwrite `null` values', () {
        var actual = lodash.defaults({ 'a': null }, { 'a': 1 });
        expect(actual["a"], equals(null));
      });
      test('should overwrite `undefined` values', () {
        var actual = lodash.defaults({ 'a': null }, { 'a': 1 });
        expect(actual["a"], equals(1));
      });
      test('should not error on `null` or `undefined` sources (test in IE < 9)', () {
        try {
          expect(lodash.defaults({ 'a': 1 }, null, undefined, { 'a': 2, 'b': 2 }), { 'a': 1, 'b': 2 });
        } catch(e) {
          ok(false);
        }
      });
    });
    group("merge", () {
      var args = [1, 2, 3];
      test('should merge `source` into the destination object', () {
      var names = {
        'characters': [
          { 'name': 'barney' },
          { 'name': 'fred' }
        ]
      };
      var ages = {
        'characters': [
          { 'age': 36 },
          { 'age': 40 }
        ]
      };
      var heights = {
        'characters': [
          { 'height': '5\'4"' },
          { 'height': '5\'5"' }
        ]
      };
      var expected = {
        'characters': [
          { 'name': 'barney', 'age': 36, 'height': '5\'4"' },
          { 'name': 'fred', 'age': 40, 'height': '5\'5"' }
        ]
      };
      expect(lodash.merge(names, ages, heights), equals(expected));
      });
      test('should merge sources containing circular references', () {
        var object = {
          'foo': { 'a': 1 },
          'bar': { 'a': 2 }
        };
        var source = {
          'foo': { 'b': { 'foo': { 'c': { } } } },
          'bar': { }
        };
        source['foo']['b']['foo']['c'] = source;
        source['bar']['b'] = source['foo']['b'];
        var actual = lodash.merge(object, source);
        expect(actual['bar']['b'] == actual['foo']['b'] &&
            actual['foo']['b']['foo']['c'] == actual['foo']['b']['foo']['c']['foo']['b']['foo']['c'], isTrue);
      });
      test('should not treat `arguments` objects as plain objects', () {
        var object = {
          'args': args
        };
        var source = {
          'args': { '3': 4 }
        };
        var actual = lodash.merge(object, source);
        expect(lodash.isArguments(actual.args), isFalse);
      });
      test('should work with four arguments', () {
        var expected = { 'a': 4 };
        expect(lodash.merge({ 'a': 1 }, { 'a': 2 }, { 'a': 3 }, expected), equals(expected));
      });
      test('should assign `null` values', () {
        var actual = lodash.merge({ 'a': 1 }, { 'a': null });
        expect(actual['a'], isNull);
      });
      test('should not assign `undefined` values', () {
        var actual = lodash.merge({ 'a': 1 }, { 'a': null });
        expect(actual['a'], equals(1));
      });
      test('should handle merging if `callback` returns `undefined`', () {
        var actual = lodash.merge({ 'a': { 'b': [1, 1] } }, { 'a': { 'b': [0] } }, () {});
        expect(actual, equals({ 'a': { 'b': [0, 1] } }));
      });
      test('should defer to `callback` when it returns a value other than `undefined`', () {
          var actual = lodash.merge({ 'a': { 'b': [0, 1] } }, { 'a': { 'b': [2] } }, (a, b) {
          return a is List ? a.concat(b) : null;
        });
        expect(actual, { 'a': { 'b': [0, 1, 2] } });
      });
      test('should pass the correct values to `callback`', () {
        var argsList = [],
        array = [1, 2],
        object = { 'b': 2 };
        lodash.merge({ 'a': array }, { 'a': object }, (a, b) {
          argsList.add(slice.call(arguments));
        });
        expect(argsList, [[array, object], [null, 2]]);
      });
    });
    group("pluck", () {
      test('should return an array of property values from each element of a collection', () {
        var objects = [{ 'name': 'barney', 'age': 36 }, { 'name': 'fred', 'age': 40 }],
        actual = lodash.pluck(objects, 'name');
        expect(actual, equals(['barney', 'fred']));
      });
      test('should work with an object for `collection`', () {
        var object = { 'a': [1], 'b': [1, 2], 'c': [1, 2, 3] };
        expect(lodash.pluck(object, 'length'), equals([1, 2, 3]));
      });
    });
    group("uniqueId", () {
      test('should generate unique ids', () {
        var actual = [];
        for (int i = 0; i < 1000; i++) {
        //_.times(1000, () {
          actual.add(lodash.uniqueId);
        }
        expect(lodash.uniq(actual).length, equals(actual.length));
      });
      test('should return a string value when not passing a prefix argument', () {
        expect(lodash.uniqueId is String, isTrue);
      });
      test('should coerce the prefix argument to a string', () {
        var actual = [lodash.uniqueId(3), lodash.uniqueId(2), lodash.uniqueId(1)];
        expect(actual, matches("3\d+,2\d+,1\d+"));
      });
    });
    group("range", () {
      test('should work when passing a single `end` argument', () {
        expect(lodash.range(4), equals([0, 1, 2, 3]));
      });
      test('should work when passing `start` and `end` arguments', () {
        expect(lodash.range(1, 5), equals([1, 2, 3, 4]));
      });
      test('should work when passing `start`, `end`, and `step` arguments', () {
        expect(lodash.range(0, 20, 5), equals([0, 5, 10, 15]));
      });
      test('should support a `step` of `0`', () {
        expect(lodash.range(1, 4, 0), equals([1, 1, 1]));
      });
      test('should work when passing `step` larger than `end`', () {
        expect(lodash.range(1, 5, 20), equals([1]));
      });
      test('should work when passing a negative `step` argument', () {
        expect(lodash.range(0, -4, -1), equals([0, -1, -2, -3]));
        expect(lodash.range(21, 10, -3), equals([21, 18, 15, 12]));
      });
      test('should treat falsey `start` arguments as `0`', () {
        falsey.forEach((value, index) {
          if (index != 0) {
            expect(lodash.range(value), equals([]));
            expect(lodash.range(value, 1), equals([0]));
          } else {
            expect(lodash.range(), equals([]));
          }
        });
      });
      test('should coerce arguments to numbers', () {
        var actual = [lodash.min('0', 1), lodash.min('1'), lodash.min(0, 1, '1')];
        expect(actual, equals([[0], [0], [0]]));
      });
    });
  });
}

main() {
  lodashTest();
}
