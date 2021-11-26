// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'data/models.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 2646085520246708451),
      name: 'User',
      lastPropertyId: const IdUid(10, 2291716881864004207),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6887992049439609797),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3513656569435801954),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2932788598821775084),
            name: 'countryCode',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2760853907308527208),
            name: 'countryID',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 4701123415752674357),
            name: 'gender',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 5550188255663160995),
            name: 'dateOfBirth',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2291716881864004207),
            name: 'otherInfo',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 8712893154994919789),
      name: 'Certificate',
      lastPropertyId: const IdUid(3, 8205960989758986779),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 200636520719827684),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 4152768145488683993),
            name: 'info',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8205960989758986779),
            name: 'issueDate',
            type: 10,
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
      lastEntityId: const IdUid(2, 8712893154994919789),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        3089025725881703,
        8394862488912187424,
        7737014800492087671
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    User: EntityDefinition<User>(
        model: _entities[0],
        toOneRelations: (User object) => [],
        toManyRelations: (User object) => {},
        getId: (User object) => object.id,
        setId: (User object, int id) {
          object.id = id;
        },
        objectToFB: (User object, fb.Builder fbb) {
          final nameOffset =
              object.name == null ? null : fbb.writeString(object.name!);
          final countryIDOffset = object.countryID == null
              ? null
              : fbb.writeString(object.countryID!);
          final otherInfoOffset = object.otherInfo == null
              ? null
              : fbb.writeString(object.otherInfo!);
          fbb.startTable(11);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.countryCode);
          fbb.addOffset(3, countryIDOffset);
          fbb.addBool(4, object.gender);
          fbb.addInt64(8, object.dateOfBirth.millisecondsSinceEpoch);
          fbb.addOffset(9, otherInfoOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = User(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              const fb.StringReader().vTableGetNullable(buffer, rootOffset, 6),
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 8),
              const fb.StringReader().vTableGetNullable(buffer, rootOffset, 10),
              const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 12),
              DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0)),
              otherInfo: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 22));

          return object;
        }),
    Certificate: EntityDefinition<Certificate>(
        model: _entities[1],
        toOneRelations: (Certificate object) => [],
        toManyRelations: (Certificate object) => {},
        getId: (Certificate object) => object.id,
        setId: (Certificate object, int id) {
          object.id = id;
        },
        objectToFB: (Certificate object, fb.Builder fbb) {
          final infoOffset =
              object.info == null ? null : fbb.writeString(object.info!);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, infoOffset);
          fbb.addInt64(2, object.issueDate.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Certificate(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              const fb.StringReader().vTableGetNullable(buffer, rootOffset, 6),
              DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0)));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [User] entity fields to define ObjectBox queries.
class User_ {
  /// see [User.id]
  static final id = QueryIntegerProperty<User>(_entities[0].properties[0]);

  /// see [User.name]
  static final name = QueryStringProperty<User>(_entities[0].properties[1]);

  /// see [User.countryCode]
  static final countryCode =
      QueryIntegerProperty<User>(_entities[0].properties[2]);

  /// see [User.countryID]
  static final countryID =
      QueryStringProperty<User>(_entities[0].properties[3]);

  /// see [User.gender]
  static final gender = QueryBooleanProperty<User>(_entities[0].properties[4]);

  /// see [User.dateOfBirth]
  static final dateOfBirth =
      QueryIntegerProperty<User>(_entities[0].properties[5]);

  /// see [User.otherInfo]
  static final otherInfo =
      QueryStringProperty<User>(_entities[0].properties[6]);
}

/// [Certificate] entity fields to define ObjectBox queries.
class Certificate_ {
  /// see [Certificate.id]
  static final id =
      QueryIntegerProperty<Certificate>(_entities[1].properties[0]);

  /// see [Certificate.info]
  static final info =
      QueryStringProperty<Certificate>(_entities[1].properties[1]);

  /// see [Certificate.issueDate]
  static final issueDate =
      QueryIntegerProperty<Certificate>(_entities[1].properties[2]);
}
