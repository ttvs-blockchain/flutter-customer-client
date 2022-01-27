import 'package:vacpass/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store) {
    // add any additional setup code, e.g. build queries
  }

  // create an instance of ObjectBox to use throughout the app
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox
    final store = await openStore();
    return ObjectBox._create(store);
  }
}

