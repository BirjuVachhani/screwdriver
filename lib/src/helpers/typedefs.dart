import 'mixins/serializable_mixin.dart';

/// Defines a type for typical JSON map.
typedef JsonMap = Map<String, dynamic>;

/// Defines a type for a list of integers.
typedef IntList = List<int>;

/// Defines a type for a list of strings.
typedef StringList = List<String>;

/// Defines a type for a list of doubles.
typedef DoubleList = List<double>;

/// Defines a type for a set of booleans.
typedef IntSet = Set<int>;

/// Defines a type for a set of strings.
typedef StringSet = Set<String>;

/// Defines a type for a set of doubles.
typedef DoubleSet = Set<double>;

/// A function that converts a json map to a serializable object.
typedef FromJson<D extends SerializableMixin> = D Function(JsonMap json);

/// A function that converts a serializable object to a json map.
typedef ToJson<D extends SerializableMixin> = JsonMap Function(D data);
