// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'models/models.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(5, 4411164528988902566),
      name: 'CertificateModel',
      lastPropertyId: const IdUid(5, 4152391929604504699),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5814480612886014576),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7597554401621556937),
            name: 'systemID',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1077691859559048461),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1795246115933045041),
            name: 'issueDate',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 4152391929604504699),
            name: 'payload',
            type: 23,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(6, 7367438525054002819),
      name: 'UserModel',
      lastPropertyId: const IdUid(8, 4619424469462703763),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6593315900129188779),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 8587800012359924075),
            name: 'systemID',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 478801455058555738),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1659716911066355340),
            name: 'countryCode',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2006221175005786938),
            name: 'countryID',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 246213264137237459),
            name: 'gender',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 471942948572488206),
            name: 'dateOfBirth',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 4619424469462703763),
            name: 'payload',
            type: 23,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(6, 7367438525054002819),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [
        2646085520246708451,
        8712893154994919789,
        3674108589893178163,
        2681017754855805294
      ],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        3089025725881703,
        8394862488912187424,
        7737014800492087671,
        6887992049439609797,
        3513656569435801954,
        2932788598821775084,
        2760853907308527208,
        4701123415752674357,
        5550188255663160995,
        2291716881864004207,
        200636520719827684,
        4152768145488683993,
        8205960989758986779,
        4049148177805120468,
        2900664357796267651,
        4879233691191538919,
        4017322226922491066,
        8386395776448327247,
        5902291689279068055,
        2451050465916018140,
        766594321599444416,
        911036110356113363,
        7211873253173754214,
        7662497243827549388,
        1766486300622527347,
        1371822362206017588
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    CertificateModel: EntityDefinition<CertificateModel>(
        model: _entities[0],
        toOneRelations: (CertificateModel object) => [],
        toManyRelations: (CertificateModel object) => {},
        getId: (CertificateModel object) => object.id,
        setId: (CertificateModel object, int id) {
          object.id = id;
        },
        objectToFB: (CertificateModel object, fb.Builder fbb) {
          final systemIDOffset = fbb.writeString(object.systemID);
          final nameOffset = fbb.writeString(object.name);
          final payloadOffset = object.payload == null
              ? null
              : fbb.writeListInt8(object.payload!);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, systemIDOffset);
          fbb.addOffset(2, nameOffset);
          fbb.addInt64(3, object.issueDate.millisecondsSinceEpoch);
          fbb.addOffset(4, payloadOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final payloadValue = const fb.ListReader<int>(fb.Int8Reader())
              .vTableGetNullable(buffer, rootOffset, 12);
          final object = CertificateModel(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0)),
              payload: payloadValue == null
                  ? null
                  : Uint8List.fromList(payloadValue));

          return object;
        }),
    UserModel: EntityDefinition<UserModel>(
        model: _entities[1],
        toOneRelations: (UserModel object) => [],
        toManyRelations: (UserModel object) => {},
        getId: (UserModel object) => object.id,
        setId: (UserModel object, int id) {
          object.id = id;
        },
        objectToFB: (UserModel object, fb.Builder fbb) {
          final systemIDOffset = fbb.writeString(object.systemID);
          final nameOffset = fbb.writeString(object.name);
          final countryIDOffset = fbb.writeString(object.countryID);
          final payloadOffset = object.payload == null
              ? null
              : fbb.writeListInt8(object.payload!);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, systemIDOffset);
          fbb.addOffset(2, nameOffset);
          fbb.addInt64(3, object.countryCode);
          fbb.addOffset(4, countryIDOffset);
          fbb.addInt64(5, object.gender);
          fbb.addInt64(6, object.dateOfBirth.millisecondsSinceEpoch);
          fbb.addOffset(7, payloadOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final payloadValue = const fb.ListReader<int>(fb.Int8Reader())
              .vTableGetNullable(buffer, rootOffset, 18);
          final object = UserModel(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0),
              DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0)),
              payload: payloadValue == null
                  ? null
                  : Uint8List.fromList(payloadValue));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [CertificateModel] entity fields to define ObjectBox queries.
class CertificateModel_ {
  /// see [CertificateModel.id]
  static final id =
      QueryIntegerProperty<CertificateModel>(_entities[0].properties[0]);

  /// see [CertificateModel.systemID]
  static final systemID =
      QueryStringProperty<CertificateModel>(_entities[0].properties[1]);

  /// see [CertificateModel.name]
  static final name =
      QueryStringProperty<CertificateModel>(_entities[0].properties[2]);

  /// see [CertificateModel.issueDate]
  static final issueDate =
      QueryIntegerProperty<CertificateModel>(_entities[0].properties[3]);

  /// see [CertificateModel.payload]
  static final payload =
      QueryByteVectorProperty<CertificateModel>(_entities[0].properties[4]);
}

/// [UserModel] entity fields to define ObjectBox queries.
class UserModel_ {
  /// see [UserModel.id]
  static final id = QueryIntegerProperty<UserModel>(_entities[1].properties[0]);

  /// see [UserModel.systemID]
  static final systemID =
      QueryStringProperty<UserModel>(_entities[1].properties[1]);

  /// see [UserModel.name]
  static final name =
      QueryStringProperty<UserModel>(_entities[1].properties[2]);

  /// see [UserModel.countryCode]
  static final countryCode =
      QueryIntegerProperty<UserModel>(_entities[1].properties[3]);

  /// see [UserModel.countryID]
  static final countryID =
      QueryStringProperty<UserModel>(_entities[1].properties[4]);

  /// see [UserModel.gender]
  static final gender =
      QueryIntegerProperty<UserModel>(_entities[1].properties[5]);

  /// see [UserModel.dateOfBirth]
  static final dateOfBirth =
      QueryIntegerProperty<UserModel>(_entities[1].properties[6]);

  /// see [UserModel.payload]
  static final payload =
      QueryByteVectorProperty<UserModel>(_entities[1].properties[7]);
}
