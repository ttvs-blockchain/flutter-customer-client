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
      id: const IdUid(3, 3674108589893178163),
      name: 'CertificateData',
      lastPropertyId: const IdUid(4, 4017322226922491066),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4049148177805120468),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2900664357796267651),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4879233691191538919),
            name: 'info',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4017322226922491066),
            name: 'issueDate',
            type: 10,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 2681017754855805294),
      name: 'UserData',
      lastPropertyId: const IdUid(7, 1766486300622527347),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5902291689279068055),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2451050465916018140),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 766594321599444416),
            name: 'countryCode',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 911036110356113363),
            name: 'countryID',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7211873253173754214),
            name: 'gender',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7662497243827549388),
            name: 'dateOfBirth',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1766486300622527347),
            name: 'otherInfo',
            type: 9,
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
      lastEntityId: const IdUid(4, 2681017754855805294),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [2646085520246708451, 8712893154994919789],
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
        8205960989758986779
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    CertificateData: EntityDefinition<CertificateData>(
        model: _entities[0],
        toOneRelations: (CertificateData object) => [],
        toManyRelations: (CertificateData object) => {},
        getId: (CertificateData object) => object.id,
        setId: (CertificateData object, int id) {
          object.id = id;
        },
        objectToFB: (CertificateData object, fb.Builder fbb) {
          final titleOffset =
              object.title == null ? null : fbb.writeString(object.title!);
          final infoOffset =
              object.info == null ? null : fbb.writeString(object.info!);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, titleOffset);
          fbb.addOffset(2, infoOffset);
          fbb.addInt64(3, object.issueDate.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = CertificateData(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              const fb.StringReader().vTableGetNullable(buffer, rootOffset, 8),
              DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0)))
            ..title = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 6);

          return object;
        }),
    UserData: EntityDefinition<UserData>(
        model: _entities[1],
        toOneRelations: (UserData object) => [],
        toManyRelations: (UserData object) => {},
        getId: (UserData object) => object.id,
        setId: (UserData object, int id) {
          object.id = id;
        },
        objectToFB: (UserData object, fb.Builder fbb) {
          final nameOffset =
              object.name == null ? null : fbb.writeString(object.name!);
          final countryIDOffset = object.countryID == null
              ? null
              : fbb.writeString(object.countryID!);
          final otherInfoOffset = object.otherInfo == null
              ? null
              : fbb.writeString(object.otherInfo!);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.countryCode);
          fbb.addOffset(3, countryIDOffset);
          fbb.addBool(4, object.gender);
          fbb.addInt64(5, object.dateOfBirth.millisecondsSinceEpoch);
          fbb.addOffset(6, otherInfoOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = UserData(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              const fb.StringReader().vTableGetNullable(buffer, rootOffset, 6),
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 8),
              const fb.StringReader().vTableGetNullable(buffer, rootOffset, 10),
              const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 12),
              DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0)),
              otherInfo: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [CertificateData] entity fields to define ObjectBox queries.
class CertificateData_ {
  /// see [CertificateData.id]
  static final id =
      QueryIntegerProperty<CertificateData>(_entities[0].properties[0]);

  /// see [CertificateData.title]
  static final title =
      QueryStringProperty<CertificateData>(_entities[0].properties[1]);

  /// see [CertificateData.info]
  static final info =
      QueryStringProperty<CertificateData>(_entities[0].properties[2]);

  /// see [CertificateData.issueDate]
  static final issueDate =
      QueryIntegerProperty<CertificateData>(_entities[0].properties[3]);
}

/// [UserData] entity fields to define ObjectBox queries.
class UserData_ {
  /// see [UserData.id]
  static final id = QueryIntegerProperty<UserData>(_entities[1].properties[0]);

  /// see [UserData.name]
  static final name = QueryStringProperty<UserData>(_entities[1].properties[1]);

  /// see [UserData.countryCode]
  static final countryCode =
      QueryIntegerProperty<UserData>(_entities[1].properties[2]);

  /// see [UserData.countryID]
  static final countryID =
      QueryStringProperty<UserData>(_entities[1].properties[3]);

  /// see [UserData.gender]
  static final gender =
      QueryBooleanProperty<UserData>(_entities[1].properties[4]);

  /// see [UserData.dateOfBirth]
  static final dateOfBirth =
      QueryIntegerProperty<UserData>(_entities[1].properties[5]);

  /// see [UserData.otherInfo]
  static final otherInfo =
      QueryStringProperty<UserData>(_entities[1].properties[6]);
}
