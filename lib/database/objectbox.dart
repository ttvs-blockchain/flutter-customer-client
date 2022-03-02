import 'package:vacpass/models/models.dart';
import 'package:vacpass/objectbox.g.dart';

class ObjectBox {
  // the store of this App
  late final Store store;

  // a Box of UserModel
  late final Box<UserModel> userModelBox;

  // a Box of CertificateModel
  late final Box<CertificateModel> certificateModelBox;

  // a stream of all CertificateModels ordered by date
  late final Stream<Query<CertificateModel>> certificateModelStream;

  ObjectBox._create(this.store) {
    userModelBox = Box<UserModel>(store);
    certificateModelBox = Box<CertificateModel>(store);

    final qBuilder = certificateModelBox.query()
      ..order(CertificateModel_.issueDate, flags: Order.descending);
    certificateModelStream = qBuilder.watch(triggerImmediately: true);

    // add dummy data if the box is empty
    if (userModelBox.isEmpty()) {
      _putDummyUserData();
    }
    if (certificateModelBox.isEmpty()) {
      _putDummyCertificateData();
    }
  }

  // create an instance of ObjectBox to use throughout the app
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox
    final store = await openStore();
    return ObjectBox._create(store);
  }

  void _putDummyUserData() {
    final user = UserModel("001", "John Doe", 1, "123456", 1, DateTime.now());
    userModelBox.put(user);
  }

  void _putDummyCertificateData() {
    final certificates = [
      CertificateModel("001", "Certificate 1", DateTime.now(), 0, 0, "0x0001",
          0, DateTime.now(), "001", "0x0001", 0, DateTime.now()),
      CertificateModel("001", "Certificate 2", DateTime.now(), 0, 0, "0x0002",
          0, DateTime.now(), "001", "0x0002", 0, DateTime.now()),
      CertificateModel("001", "Certificate 3", DateTime.now(), 0, 0, "0x0003",
          0, DateTime.now(), "001", "0x0003", 0, DateTime.now()),
      CertificateModel("001", "Certificate 4", DateTime.now(), 0, 0, "0x0004",
          0, DateTime.now(), "001", "0x0004", 0, DateTime.now()),
    ];
    certificateModelBox.putMany(certificates);
  }
}
