// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProgressTableTable extends UserProgressTable
    with TableInfo<$UserProgressTableTable, UserProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _currentRankMeta = const VerificationMeta(
    'currentRank',
  );
  @override
  late final GeneratedColumn<int> currentRank = GeneratedColumn<int>(
    'current_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<int> startDate = GeneratedColumn<int>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedTechniquesJsonMeta =
      const VerificationMeta('completedTechniquesJson');
  @override
  late final GeneratedColumn<String> completedTechniquesJson =
      GeneratedColumn<String>(
        'completed_techniques_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currentRank,
    startDate,
    completedTechniquesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProgressTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_rank')) {
      context.handle(
        _currentRankMeta,
        currentRank.isAcceptableOrUnknown(
          data['current_rank']!,
          _currentRankMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentRankMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('completed_techniques_json')) {
      context.handle(
        _completedTechniquesJsonMeta,
        completedTechniquesJson.isAcceptableOrUnknown(
          data['completed_techniques_json']!,
          _completedTechniquesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProgressTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currentRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_rank'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_date'],
      )!,
      completedTechniquesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_techniques_json'],
      )!,
    );
  }

  @override
  $UserProgressTableTable createAlias(String alias) {
    return $UserProgressTableTable(attachedDatabase, alias);
  }
}

class UserProgressTableData extends DataClass
    implements Insertable<UserProgressTableData> {
  /// Auto-incrementing primary key.
  final int id;

  /// Current belt rank as enum index into [BeltRank].
  final int currentRank;

  /// Date when the user started tracking, stored as epoch milliseconds.
  final int startDate;

  /// JSON-encoded map of technique ID → completion status.
  ///
  /// Example: `{"seiken_chudan_tsuki": true, "mae_geri": false}`
  final String completedTechniquesJson;
  const UserProgressTableData({
    required this.id,
    required this.currentRank,
    required this.startDate,
    required this.completedTechniquesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_rank'] = Variable<int>(currentRank);
    map['start_date'] = Variable<int>(startDate);
    map['completed_techniques_json'] = Variable<String>(
      completedTechniquesJson,
    );
    return map;
  }

  UserProgressTableCompanion toCompanion(bool nullToAbsent) {
    return UserProgressTableCompanion(
      id: Value(id),
      currentRank: Value(currentRank),
      startDate: Value(startDate),
      completedTechniquesJson: Value(completedTechniquesJson),
    );
  }

  factory UserProgressTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressTableData(
      id: serializer.fromJson<int>(json['id']),
      currentRank: serializer.fromJson<int>(json['currentRank']),
      startDate: serializer.fromJson<int>(json['startDate']),
      completedTechniquesJson: serializer.fromJson<String>(
        json['completedTechniquesJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentRank': serializer.toJson<int>(currentRank),
      'startDate': serializer.toJson<int>(startDate),
      'completedTechniquesJson': serializer.toJson<String>(
        completedTechniquesJson,
      ),
    };
  }

  UserProgressTableData copyWith({
    int? id,
    int? currentRank,
    int? startDate,
    String? completedTechniquesJson,
  }) => UserProgressTableData(
    id: id ?? this.id,
    currentRank: currentRank ?? this.currentRank,
    startDate: startDate ?? this.startDate,
    completedTechniquesJson:
        completedTechniquesJson ?? this.completedTechniquesJson,
  );
  UserProgressTableData copyWithCompanion(UserProgressTableCompanion data) {
    return UserProgressTableData(
      id: data.id.present ? data.id.value : this.id,
      currentRank: data.currentRank.present
          ? data.currentRank.value
          : this.currentRank,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      completedTechniquesJson: data.completedTechniquesJson.present
          ? data.completedTechniquesJson.value
          : this.completedTechniquesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressTableData(')
          ..write('id: $id, ')
          ..write('currentRank: $currentRank, ')
          ..write('startDate: $startDate, ')
          ..write('completedTechniquesJson: $completedTechniquesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, currentRank, startDate, completedTechniquesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressTableData &&
          other.id == this.id &&
          other.currentRank == this.currentRank &&
          other.startDate == this.startDate &&
          other.completedTechniquesJson == this.completedTechniquesJson);
}

class UserProgressTableCompanion
    extends UpdateCompanion<UserProgressTableData> {
  final Value<int> id;
  final Value<int> currentRank;
  final Value<int> startDate;
  final Value<String> completedTechniquesJson;
  const UserProgressTableCompanion({
    this.id = const Value.absent(),
    this.currentRank = const Value.absent(),
    this.startDate = const Value.absent(),
    this.completedTechniquesJson = const Value.absent(),
  });
  UserProgressTableCompanion.insert({
    this.id = const Value.absent(),
    required int currentRank,
    required int startDate,
    this.completedTechniquesJson = const Value.absent(),
  }) : currentRank = Value(currentRank),
       startDate = Value(startDate);
  static Insertable<UserProgressTableData> custom({
    Expression<int>? id,
    Expression<int>? currentRank,
    Expression<int>? startDate,
    Expression<String>? completedTechniquesJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentRank != null) 'current_rank': currentRank,
      if (startDate != null) 'start_date': startDate,
      if (completedTechniquesJson != null)
        'completed_techniques_json': completedTechniquesJson,
    });
  }

  UserProgressTableCompanion copyWith({
    Value<int>? id,
    Value<int>? currentRank,
    Value<int>? startDate,
    Value<String>? completedTechniquesJson,
  }) {
    return UserProgressTableCompanion(
      id: id ?? this.id,
      currentRank: currentRank ?? this.currentRank,
      startDate: startDate ?? this.startDate,
      completedTechniquesJson:
          completedTechniquesJson ?? this.completedTechniquesJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentRank.present) {
      map['current_rank'] = Variable<int>(currentRank.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<int>(startDate.value);
    }
    if (completedTechniquesJson.present) {
      map['completed_techniques_json'] = Variable<String>(
        completedTechniquesJson.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressTableCompanion(')
          ..write('id: $id, ')
          ..write('currentRank: $currentRank, ')
          ..write('startDate: $startDate, ')
          ..write('completedTechniquesJson: $completedTechniquesJson')
          ..write(')'))
        .toString();
  }
}

class $BeltAdvancementTableTable extends BeltAdvancementTable
    with TableInfo<$BeltAdvancementTableTable, BeltAdvancementTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeltAdvancementTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fromRankMeta = const VerificationMeta(
    'fromRank',
  );
  @override
  late final GeneratedColumn<int> fromRank = GeneratedColumn<int>(
    'from_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toRankMeta = const VerificationMeta('toRank');
  @override
  late final GeneratedColumn<int> toRank = GeneratedColumn<int>(
    'to_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, fromRank, toRank, date, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'belt_advancement_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BeltAdvancementTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_rank')) {
      context.handle(
        _fromRankMeta,
        fromRank.isAcceptableOrUnknown(data['from_rank']!, _fromRankMeta),
      );
    } else if (isInserting) {
      context.missing(_fromRankMeta);
    }
    if (data.containsKey('to_rank')) {
      context.handle(
        _toRankMeta,
        toRank.isAcceptableOrUnknown(data['to_rank']!, _toRankMeta),
      );
    } else if (isInserting) {
      context.missing(_toRankMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BeltAdvancementTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BeltAdvancementTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fromRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_rank'],
      )!,
      toRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_rank'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $BeltAdvancementTableTable createAlias(String alias) {
    return $BeltAdvancementTableTable(attachedDatabase, alias);
  }
}

class BeltAdvancementTableData extends DataClass
    implements Insertable<BeltAdvancementTableData> {
  /// Auto-incrementing primary key.
  final int id;

  /// Belt rank before advancement (enum index).
  final int fromRank;

  /// Belt rank after advancement (enum index).
  final int toRank;

  /// Date of advancement, stored as epoch milliseconds.
  final int date;

  /// Optional notes about the grading.
  final String? notes;
  const BeltAdvancementTableData({
    required this.id,
    required this.fromRank,
    required this.toRank,
    required this.date,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_rank'] = Variable<int>(fromRank);
    map['to_rank'] = Variable<int>(toRank);
    map['date'] = Variable<int>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  BeltAdvancementTableCompanion toCompanion(bool nullToAbsent) {
    return BeltAdvancementTableCompanion(
      id: Value(id),
      fromRank: Value(fromRank),
      toRank: Value(toRank),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory BeltAdvancementTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BeltAdvancementTableData(
      id: serializer.fromJson<int>(json['id']),
      fromRank: serializer.fromJson<int>(json['fromRank']),
      toRank: serializer.fromJson<int>(json['toRank']),
      date: serializer.fromJson<int>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromRank': serializer.toJson<int>(fromRank),
      'toRank': serializer.toJson<int>(toRank),
      'date': serializer.toJson<int>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  BeltAdvancementTableData copyWith({
    int? id,
    int? fromRank,
    int? toRank,
    int? date,
    Value<String?> notes = const Value.absent(),
  }) => BeltAdvancementTableData(
    id: id ?? this.id,
    fromRank: fromRank ?? this.fromRank,
    toRank: toRank ?? this.toRank,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
  );
  BeltAdvancementTableData copyWithCompanion(
    BeltAdvancementTableCompanion data,
  ) {
    return BeltAdvancementTableData(
      id: data.id.present ? data.id.value : this.id,
      fromRank: data.fromRank.present ? data.fromRank.value : this.fromRank,
      toRank: data.toRank.present ? data.toRank.value : this.toRank,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BeltAdvancementTableData(')
          ..write('id: $id, ')
          ..write('fromRank: $fromRank, ')
          ..write('toRank: $toRank, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fromRank, toRank, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BeltAdvancementTableData &&
          other.id == this.id &&
          other.fromRank == this.fromRank &&
          other.toRank == this.toRank &&
          other.date == this.date &&
          other.notes == this.notes);
}

class BeltAdvancementTableCompanion
    extends UpdateCompanion<BeltAdvancementTableData> {
  final Value<int> id;
  final Value<int> fromRank;
  final Value<int> toRank;
  final Value<int> date;
  final Value<String?> notes;
  const BeltAdvancementTableCompanion({
    this.id = const Value.absent(),
    this.fromRank = const Value.absent(),
    this.toRank = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  });
  BeltAdvancementTableCompanion.insert({
    this.id = const Value.absent(),
    required int fromRank,
    required int toRank,
    required int date,
    this.notes = const Value.absent(),
  }) : fromRank = Value(fromRank),
       toRank = Value(toRank),
       date = Value(date);
  static Insertable<BeltAdvancementTableData> custom({
    Expression<int>? id,
    Expression<int>? fromRank,
    Expression<int>? toRank,
    Expression<int>? date,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromRank != null) 'from_rank': fromRank,
      if (toRank != null) 'to_rank': toRank,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
    });
  }

  BeltAdvancementTableCompanion copyWith({
    Value<int>? id,
    Value<int>? fromRank,
    Value<int>? toRank,
    Value<int>? date,
    Value<String?>? notes,
  }) {
    return BeltAdvancementTableCompanion(
      id: id ?? this.id,
      fromRank: fromRank ?? this.fromRank,
      toRank: toRank ?? this.toRank,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromRank.present) {
      map['from_rank'] = Variable<int>(fromRank.value);
    }
    if (toRank.present) {
      map['to_rank'] = Variable<int>(toRank.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeltAdvancementTableCompanion(')
          ..write('id: $id, ')
          ..write('fromRank: $fromRank, ')
          ..write('toRank: $toRank, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $TrainingSessionTableTable extends TrainingSessionTable
    with TableInfo<$TrainingSessionTableTable, TrainingSessionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingSessionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, durationMinutes, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_session_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingSessionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingSessionTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingSessionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $TrainingSessionTableTable createAlias(String alias) {
    return $TrainingSessionTableTable(attachedDatabase, alias);
  }
}

class TrainingSessionTableData extends DataClass
    implements Insertable<TrainingSessionTableData> {
  /// Auto-incrementing primary key.
  final int id;

  /// Date of the training session, stored as epoch milliseconds.
  final int date;

  /// Duration of the session in minutes.
  final int durationMinutes;

  /// Optional notes about the session.
  final String? notes;
  const TrainingSessionTableData({
    required this.id,
    required this.date,
    required this.durationMinutes,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<int>(date);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  TrainingSessionTableCompanion toCompanion(bool nullToAbsent) {
    return TrainingSessionTableCompanion(
      id: Value(id),
      date: Value(date),
      durationMinutes: Value(durationMinutes),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory TrainingSessionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingSessionTableData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<int>(date),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  TrainingSessionTableData copyWith({
    int? id,
    int? date,
    int? durationMinutes,
    Value<String?> notes = const Value.absent(),
  }) => TrainingSessionTableData(
    id: id ?? this.id,
    date: date ?? this.date,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    notes: notes.present ? notes.value : this.notes,
  );
  TrainingSessionTableData copyWithCompanion(
    TrainingSessionTableCompanion data,
  ) {
    return TrainingSessionTableData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSessionTableData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, durationMinutes, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingSessionTableData &&
          other.id == this.id &&
          other.date == this.date &&
          other.durationMinutes == this.durationMinutes &&
          other.notes == this.notes);
}

class TrainingSessionTableCompanion
    extends UpdateCompanion<TrainingSessionTableData> {
  final Value<int> id;
  final Value<int> date;
  final Value<int> durationMinutes;
  final Value<String?> notes;
  const TrainingSessionTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
  });
  TrainingSessionTableCompanion.insert({
    this.id = const Value.absent(),
    required int date,
    required int durationMinutes,
    this.notes = const Value.absent(),
  }) : date = Value(date),
       durationMinutes = Value(durationMinutes);
  static Insertable<TrainingSessionTableData> custom({
    Expression<int>? id,
    Expression<int>? date,
    Expression<int>? durationMinutes,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (notes != null) 'notes': notes,
    });
  }

  TrainingSessionTableCompanion copyWith({
    Value<int>? id,
    Value<int>? date,
    Value<int>? durationMinutes,
    Value<String?>? notes,
  }) {
    return TrainingSessionTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSessionTableCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $CardReviewStateTableTable extends CardReviewStateTable
    with TableInfo<$CardReviewStateTableTable, CardReviewStateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardReviewStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _easeFactorMeta = const VerificationMeta(
    'easeFactor',
  );
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
    'ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextReviewDateMeta = const VerificationMeta(
    'nextReviewDate',
  );
  @override
  late final GeneratedColumn<int> nextReviewDate = GeneratedColumn<int>(
    'next_review_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReviewDateMeta = const VerificationMeta(
    'lastReviewDate',
  );
  @override
  late final GeneratedColumn<int> lastReviewDate = GeneratedColumn<int>(
    'last_review_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalReviewsMeta = const VerificationMeta(
    'totalReviews',
  );
  @override
  late final GeneratedColumn<int> totalReviews = GeneratedColumn<int>(
    'total_reviews',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctReviewsMeta = const VerificationMeta(
    'correctReviews',
  );
  @override
  late final GeneratedColumn<int> correctReviews = GeneratedColumn<int>(
    'correct_reviews',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    cardId,
    easeFactor,
    interval,
    repetitions,
    nextReviewDate,
    lastReviewDate,
    totalReviews,
    correctReviews,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_review_state_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardReviewStateTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
        _easeFactorMeta,
        easeFactor.isAcceptableOrUnknown(data['ease_factor']!, _easeFactorMeta),
      );
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('next_review_date')) {
      context.handle(
        _nextReviewDateMeta,
        nextReviewDate.isAcceptableOrUnknown(
          data['next_review_date']!,
          _nextReviewDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextReviewDateMeta);
    }
    if (data.containsKey('last_review_date')) {
      context.handle(
        _lastReviewDateMeta,
        lastReviewDate.isAcceptableOrUnknown(
          data['last_review_date']!,
          _lastReviewDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastReviewDateMeta);
    }
    if (data.containsKey('total_reviews')) {
      context.handle(
        _totalReviewsMeta,
        totalReviews.isAcceptableOrUnknown(
          data['total_reviews']!,
          _totalReviewsMeta,
        ),
      );
    }
    if (data.containsKey('correct_reviews')) {
      context.handle(
        _correctReviewsMeta,
        correctReviews.isAcceptableOrUnknown(
          data['correct_reviews']!,
          _correctReviewsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId};
  @override
  CardReviewStateTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardReviewStateTableData(
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      easeFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease_factor'],
      )!,
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      nextReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_review_date'],
      )!,
      lastReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_review_date'],
      )!,
      totalReviews: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_reviews'],
      )!,
      correctReviews: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_reviews'],
      )!,
    );
  }

  @override
  $CardReviewStateTableTable createAlias(String alias) {
    return $CardReviewStateTableTable(attachedDatabase, alias);
  }
}

class CardReviewStateTableData extends DataClass
    implements Insertable<CardReviewStateTableData> {
  /// Flashcard ID (primary key). Links to flashcard content data.
  final String cardId;

  /// SM-2 ease factor (default 2.5, minimum 1.3).
  final double easeFactor;

  /// Days until next review.
  final int interval;

  /// Number of consecutive correct answers.
  final int repetitions;

  /// Next review date, stored as epoch milliseconds.
  final int nextReviewDate;

  /// Last review date, stored as epoch milliseconds.
  final int lastReviewDate;

  /// Total number of reviews for this card.
  final int totalReviews;

  /// Number of correct reviews for this card.
  final int correctReviews;
  const CardReviewStateTableData({
    required this.cardId,
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.nextReviewDate,
    required this.lastReviewDate,
    required this.totalReviews,
    required this.correctReviews,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval'] = Variable<int>(interval);
    map['repetitions'] = Variable<int>(repetitions);
    map['next_review_date'] = Variable<int>(nextReviewDate);
    map['last_review_date'] = Variable<int>(lastReviewDate);
    map['total_reviews'] = Variable<int>(totalReviews);
    map['correct_reviews'] = Variable<int>(correctReviews);
    return map;
  }

  CardReviewStateTableCompanion toCompanion(bool nullToAbsent) {
    return CardReviewStateTableCompanion(
      cardId: Value(cardId),
      easeFactor: Value(easeFactor),
      interval: Value(interval),
      repetitions: Value(repetitions),
      nextReviewDate: Value(nextReviewDate),
      lastReviewDate: Value(lastReviewDate),
      totalReviews: Value(totalReviews),
      correctReviews: Value(correctReviews),
    );
  }

  factory CardReviewStateTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardReviewStateTableData(
      cardId: serializer.fromJson<String>(json['cardId']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      interval: serializer.fromJson<int>(json['interval']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      nextReviewDate: serializer.fromJson<int>(json['nextReviewDate']),
      lastReviewDate: serializer.fromJson<int>(json['lastReviewDate']),
      totalReviews: serializer.fromJson<int>(json['totalReviews']),
      correctReviews: serializer.fromJson<int>(json['correctReviews']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'interval': serializer.toJson<int>(interval),
      'repetitions': serializer.toJson<int>(repetitions),
      'nextReviewDate': serializer.toJson<int>(nextReviewDate),
      'lastReviewDate': serializer.toJson<int>(lastReviewDate),
      'totalReviews': serializer.toJson<int>(totalReviews),
      'correctReviews': serializer.toJson<int>(correctReviews),
    };
  }

  CardReviewStateTableData copyWith({
    String? cardId,
    double? easeFactor,
    int? interval,
    int? repetitions,
    int? nextReviewDate,
    int? lastReviewDate,
    int? totalReviews,
    int? correctReviews,
  }) => CardReviewStateTableData(
    cardId: cardId ?? this.cardId,
    easeFactor: easeFactor ?? this.easeFactor,
    interval: interval ?? this.interval,
    repetitions: repetitions ?? this.repetitions,
    nextReviewDate: nextReviewDate ?? this.nextReviewDate,
    lastReviewDate: lastReviewDate ?? this.lastReviewDate,
    totalReviews: totalReviews ?? this.totalReviews,
    correctReviews: correctReviews ?? this.correctReviews,
  );
  CardReviewStateTableData copyWithCompanion(
    CardReviewStateTableCompanion data,
  ) {
    return CardReviewStateTableData(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      easeFactor: data.easeFactor.present
          ? data.easeFactor.value
          : this.easeFactor,
      interval: data.interval.present ? data.interval.value : this.interval,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      nextReviewDate: data.nextReviewDate.present
          ? data.nextReviewDate.value
          : this.nextReviewDate,
      lastReviewDate: data.lastReviewDate.present
          ? data.lastReviewDate.value
          : this.lastReviewDate,
      totalReviews: data.totalReviews.present
          ? data.totalReviews.value
          : this.totalReviews,
      correctReviews: data.correctReviews.present
          ? data.correctReviews.value
          : this.correctReviews,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardReviewStateTableData(')
          ..write('cardId: $cardId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('interval: $interval, ')
          ..write('repetitions: $repetitions, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('lastReviewDate: $lastReviewDate, ')
          ..write('totalReviews: $totalReviews, ')
          ..write('correctReviews: $correctReviews')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    cardId,
    easeFactor,
    interval,
    repetitions,
    nextReviewDate,
    lastReviewDate,
    totalReviews,
    correctReviews,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardReviewStateTableData &&
          other.cardId == this.cardId &&
          other.easeFactor == this.easeFactor &&
          other.interval == this.interval &&
          other.repetitions == this.repetitions &&
          other.nextReviewDate == this.nextReviewDate &&
          other.lastReviewDate == this.lastReviewDate &&
          other.totalReviews == this.totalReviews &&
          other.correctReviews == this.correctReviews);
}

class CardReviewStateTableCompanion
    extends UpdateCompanion<CardReviewStateTableData> {
  final Value<String> cardId;
  final Value<double> easeFactor;
  final Value<int> interval;
  final Value<int> repetitions;
  final Value<int> nextReviewDate;
  final Value<int> lastReviewDate;
  final Value<int> totalReviews;
  final Value<int> correctReviews;
  final Value<int> rowid;
  const CardReviewStateTableCompanion({
    this.cardId = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.interval = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.lastReviewDate = const Value.absent(),
    this.totalReviews = const Value.absent(),
    this.correctReviews = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardReviewStateTableCompanion.insert({
    required String cardId,
    this.easeFactor = const Value.absent(),
    this.interval = const Value.absent(),
    this.repetitions = const Value.absent(),
    required int nextReviewDate,
    required int lastReviewDate,
    this.totalReviews = const Value.absent(),
    this.correctReviews = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : cardId = Value(cardId),
       nextReviewDate = Value(nextReviewDate),
       lastReviewDate = Value(lastReviewDate);
  static Insertable<CardReviewStateTableData> custom({
    Expression<String>? cardId,
    Expression<double>? easeFactor,
    Expression<int>? interval,
    Expression<int>? repetitions,
    Expression<int>? nextReviewDate,
    Expression<int>? lastReviewDate,
    Expression<int>? totalReviews,
    Expression<int>? correctReviews,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (interval != null) 'interval': interval,
      if (repetitions != null) 'repetitions': repetitions,
      if (nextReviewDate != null) 'next_review_date': nextReviewDate,
      if (lastReviewDate != null) 'last_review_date': lastReviewDate,
      if (totalReviews != null) 'total_reviews': totalReviews,
      if (correctReviews != null) 'correct_reviews': correctReviews,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardReviewStateTableCompanion copyWith({
    Value<String>? cardId,
    Value<double>? easeFactor,
    Value<int>? interval,
    Value<int>? repetitions,
    Value<int>? nextReviewDate,
    Value<int>? lastReviewDate,
    Value<int>? totalReviews,
    Value<int>? correctReviews,
    Value<int>? rowid,
  }) {
    return CardReviewStateTableCompanion(
      cardId: cardId ?? this.cardId,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      repetitions: repetitions ?? this.repetitions,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
      totalReviews: totalReviews ?? this.totalReviews,
      correctReviews: correctReviews ?? this.correctReviews,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (nextReviewDate.present) {
      map['next_review_date'] = Variable<int>(nextReviewDate.value);
    }
    if (lastReviewDate.present) {
      map['last_review_date'] = Variable<int>(lastReviewDate.value);
    }
    if (totalReviews.present) {
      map['total_reviews'] = Variable<int>(totalReviews.value);
    }
    if (correctReviews.present) {
      map['correct_reviews'] = Variable<int>(correctReviews.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardReviewStateTableCompanion(')
          ..write('cardId: $cardId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('interval: $interval, ')
          ..write('repetitions: $repetitions, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('lastReviewDate: $lastReviewDate, ')
          ..write('totalReviews: $totalReviews, ')
          ..write('correctReviews: $correctReviews, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptTableTable extends QuizAttemptTable
    with TableInfo<$QuizAttemptTableTable, QuizAttemptTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetRankMeta = const VerificationMeta(
    'targetRank',
  );
  @override
  late final GeneratedColumn<int> targetRank = GeneratedColumn<int>(
    'target_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isMockExamMeta = const VerificationMeta(
    'isMockExam',
  );
  @override
  late final GeneratedColumn<bool> isMockExam = GeneratedColumn<bool>(
    'is_mock_exam',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_mock_exam" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctAnswersMeta = const VerificationMeta(
    'correctAnswers',
  );
  @override
  late final GeneratedColumn<int> correctAnswers = GeneratedColumn<int>(
    'correct_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryScoresJsonMeta =
      const VerificationMeta('categoryScoresJson');
  @override
  late final GeneratedColumn<String> categoryScoresJson =
      GeneratedColumn<String>(
        'category_scores_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _weakAreasJsonMeta = const VerificationMeta(
    'weakAreasJson',
  );
  @override
  late final GeneratedColumn<String> weakAreasJson = GeneratedColumn<String>(
    'weak_areas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    targetRank,
    isMockExam,
    totalQuestions,
    correctAnswers,
    durationSeconds,
    categoryScoresJson,
    weakAreasJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempt_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAttemptTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('target_rank')) {
      context.handle(
        _targetRankMeta,
        targetRank.isAcceptableOrUnknown(data['target_rank']!, _targetRankMeta),
      );
    } else if (isInserting) {
      context.missing(_targetRankMeta);
    }
    if (data.containsKey('is_mock_exam')) {
      context.handle(
        _isMockExamMeta,
        isMockExam.isAcceptableOrUnknown(
          data['is_mock_exam']!,
          _isMockExamMeta,
        ),
      );
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('correct_answers')) {
      context.handle(
        _correctAnswersMeta,
        correctAnswers.isAcceptableOrUnknown(
          data['correct_answers']!,
          _correctAnswersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswersMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('category_scores_json')) {
      context.handle(
        _categoryScoresJsonMeta,
        categoryScoresJson.isAcceptableOrUnknown(
          data['category_scores_json']!,
          _categoryScoresJsonMeta,
        ),
      );
    }
    if (data.containsKey('weak_areas_json')) {
      context.handle(
        _weakAreasJsonMeta,
        weakAreasJson.isAcceptableOrUnknown(
          data['weak_areas_json']!,
          _weakAreasJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizAttemptTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttemptTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      targetRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_rank'],
      )!,
      isMockExam: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_mock_exam'],
      )!,
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
      correctAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answers'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      categoryScoresJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_scores_json'],
      )!,
      weakAreasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weak_areas_json'],
      )!,
    );
  }

  @override
  $QuizAttemptTableTable createAlias(String alias) {
    return $QuizAttemptTableTable(attachedDatabase, alias);
  }
}

class QuizAttemptTableData extends DataClass
    implements Insertable<QuizAttemptTableData> {
  /// Auto-incrementing primary key.
  final int id;

  /// Timestamp of the quiz attempt, stored as epoch milliseconds.
  final int timestamp;

  /// Target belt rank for this quiz (enum index).
  final int targetRank;

  /// Whether this was a mock grading exam.
  final bool isMockExam;

  /// Total number of questions in the quiz.
  final int totalQuestions;

  /// Number of correctly answered questions.
  final int correctAnswers;

  /// Duration of the quiz in seconds.
  final int durationSeconds;

  /// JSON-encoded map of category → score percentage.
  ///
  /// Example: `{"terminology": 0.85, "kihon": 0.92}`
  final String categoryScoresJson;

  /// JSON-encoded list of weak area identifiers.
  ///
  /// Example: `["terminology", "kata_sequences"]`
  final String weakAreasJson;
  const QuizAttemptTableData({
    required this.id,
    required this.timestamp,
    required this.targetRank,
    required this.isMockExam,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.durationSeconds,
    required this.categoryScoresJson,
    required this.weakAreasJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<int>(timestamp);
    map['target_rank'] = Variable<int>(targetRank);
    map['is_mock_exam'] = Variable<bool>(isMockExam);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['correct_answers'] = Variable<int>(correctAnswers);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['category_scores_json'] = Variable<String>(categoryScoresJson);
    map['weak_areas_json'] = Variable<String>(weakAreasJson);
    return map;
  }

  QuizAttemptTableCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      targetRank: Value(targetRank),
      isMockExam: Value(isMockExam),
      totalQuestions: Value(totalQuestions),
      correctAnswers: Value(correctAnswers),
      durationSeconds: Value(durationSeconds),
      categoryScoresJson: Value(categoryScoresJson),
      weakAreasJson: Value(weakAreasJson),
    );
  }

  factory QuizAttemptTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttemptTableData(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      targetRank: serializer.fromJson<int>(json['targetRank']),
      isMockExam: serializer.fromJson<bool>(json['isMockExam']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      correctAnswers: serializer.fromJson<int>(json['correctAnswers']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      categoryScoresJson: serializer.fromJson<String>(
        json['categoryScoresJson'],
      ),
      weakAreasJson: serializer.fromJson<String>(json['weakAreasJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<int>(timestamp),
      'targetRank': serializer.toJson<int>(targetRank),
      'isMockExam': serializer.toJson<bool>(isMockExam),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'correctAnswers': serializer.toJson<int>(correctAnswers),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'categoryScoresJson': serializer.toJson<String>(categoryScoresJson),
      'weakAreasJson': serializer.toJson<String>(weakAreasJson),
    };
  }

  QuizAttemptTableData copyWith({
    int? id,
    int? timestamp,
    int? targetRank,
    bool? isMockExam,
    int? totalQuestions,
    int? correctAnswers,
    int? durationSeconds,
    String? categoryScoresJson,
    String? weakAreasJson,
  }) => QuizAttemptTableData(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    targetRank: targetRank ?? this.targetRank,
    isMockExam: isMockExam ?? this.isMockExam,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    correctAnswers: correctAnswers ?? this.correctAnswers,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    categoryScoresJson: categoryScoresJson ?? this.categoryScoresJson,
    weakAreasJson: weakAreasJson ?? this.weakAreasJson,
  );
  QuizAttemptTableData copyWithCompanion(QuizAttemptTableCompanion data) {
    return QuizAttemptTableData(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      targetRank: data.targetRank.present
          ? data.targetRank.value
          : this.targetRank,
      isMockExam: data.isMockExam.present
          ? data.isMockExam.value
          : this.isMockExam,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      correctAnswers: data.correctAnswers.present
          ? data.correctAnswers.value
          : this.correctAnswers,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      categoryScoresJson: data.categoryScoresJson.present
          ? data.categoryScoresJson.value
          : this.categoryScoresJson,
      weakAreasJson: data.weakAreasJson.present
          ? data.weakAreasJson.value
          : this.weakAreasJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptTableData(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('targetRank: $targetRank, ')
          ..write('isMockExam: $isMockExam, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('categoryScoresJson: $categoryScoresJson, ')
          ..write('weakAreasJson: $weakAreasJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    targetRank,
    isMockExam,
    totalQuestions,
    correctAnswers,
    durationSeconds,
    categoryScoresJson,
    weakAreasJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttemptTableData &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.targetRank == this.targetRank &&
          other.isMockExam == this.isMockExam &&
          other.totalQuestions == this.totalQuestions &&
          other.correctAnswers == this.correctAnswers &&
          other.durationSeconds == this.durationSeconds &&
          other.categoryScoresJson == this.categoryScoresJson &&
          other.weakAreasJson == this.weakAreasJson);
}

class QuizAttemptTableCompanion extends UpdateCompanion<QuizAttemptTableData> {
  final Value<int> id;
  final Value<int> timestamp;
  final Value<int> targetRank;
  final Value<bool> isMockExam;
  final Value<int> totalQuestions;
  final Value<int> correctAnswers;
  final Value<int> durationSeconds;
  final Value<String> categoryScoresJson;
  final Value<String> weakAreasJson;
  const QuizAttemptTableCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.targetRank = const Value.absent(),
    this.isMockExam = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.categoryScoresJson = const Value.absent(),
    this.weakAreasJson = const Value.absent(),
  });
  QuizAttemptTableCompanion.insert({
    this.id = const Value.absent(),
    required int timestamp,
    required int targetRank,
    this.isMockExam = const Value.absent(),
    required int totalQuestions,
    required int correctAnswers,
    required int durationSeconds,
    this.categoryScoresJson = const Value.absent(),
    this.weakAreasJson = const Value.absent(),
  }) : timestamp = Value(timestamp),
       targetRank = Value(targetRank),
       totalQuestions = Value(totalQuestions),
       correctAnswers = Value(correctAnswers),
       durationSeconds = Value(durationSeconds);
  static Insertable<QuizAttemptTableData> custom({
    Expression<int>? id,
    Expression<int>? timestamp,
    Expression<int>? targetRank,
    Expression<bool>? isMockExam,
    Expression<int>? totalQuestions,
    Expression<int>? correctAnswers,
    Expression<int>? durationSeconds,
    Expression<String>? categoryScoresJson,
    Expression<String>? weakAreasJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (targetRank != null) 'target_rank': targetRank,
      if (isMockExam != null) 'is_mock_exam': isMockExam,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (correctAnswers != null) 'correct_answers': correctAnswers,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (categoryScoresJson != null)
        'category_scores_json': categoryScoresJson,
      if (weakAreasJson != null) 'weak_areas_json': weakAreasJson,
    });
  }

  QuizAttemptTableCompanion copyWith({
    Value<int>? id,
    Value<int>? timestamp,
    Value<int>? targetRank,
    Value<bool>? isMockExam,
    Value<int>? totalQuestions,
    Value<int>? correctAnswers,
    Value<int>? durationSeconds,
    Value<String>? categoryScoresJson,
    Value<String>? weakAreasJson,
  }) {
    return QuizAttemptTableCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      targetRank: targetRank ?? this.targetRank,
      isMockExam: isMockExam ?? this.isMockExam,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      categoryScoresJson: categoryScoresJson ?? this.categoryScoresJson,
      weakAreasJson: weakAreasJson ?? this.weakAreasJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (targetRank.present) {
      map['target_rank'] = Variable<int>(targetRank.value);
    }
    if (isMockExam.present) {
      map['is_mock_exam'] = Variable<bool>(isMockExam.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (correctAnswers.present) {
      map['correct_answers'] = Variable<int>(correctAnswers.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (categoryScoresJson.present) {
      map['category_scores_json'] = Variable<String>(categoryScoresJson.value);
    }
    if (weakAreasJson.present) {
      map['weak_areas_json'] = Variable<String>(weakAreasJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptTableCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('targetRank: $targetRank, ')
          ..write('isMockExam: $isMockExam, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('categoryScoresJson: $categoryScoresJson, ')
          ..write('weakAreasJson: $weakAreasJson')
          ..write(')'))
        .toString();
  }
}

class $ReviewSessionTableTable extends ReviewSessionTable
    with TableInfo<$ReviewSessionTableTable, ReviewSessionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewSessionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardsReviewedMeta = const VerificationMeta(
    'cardsReviewed',
  );
  @override
  late final GeneratedColumn<int> cardsReviewed = GeneratedColumn<int>(
    'cards_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    cardsReviewed,
    correctCount,
    durationSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_session_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewSessionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('cards_reviewed')) {
      context.handle(
        _cardsReviewedMeta,
        cardsReviewed.isAcceptableOrUnknown(
          data['cards_reviewed']!,
          _cardsReviewedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cardsReviewedMeta);
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctCountMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewSessionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewSessionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      cardsReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cards_reviewed'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
    );
  }

  @override
  $ReviewSessionTableTable createAlias(String alias) {
    return $ReviewSessionTableTable(attachedDatabase, alias);
  }
}

class ReviewSessionTableData extends DataClass
    implements Insertable<ReviewSessionTableData> {
  /// Auto-incrementing primary key.
  final int id;

  /// Timestamp of the session, stored as epoch milliseconds.
  final int timestamp;

  /// Number of cards reviewed in this session.
  final int cardsReviewed;

  /// Number of cards answered correctly.
  final int correctCount;

  /// Duration of the session in seconds.
  final int durationSeconds;
  const ReviewSessionTableData({
    required this.id,
    required this.timestamp,
    required this.cardsReviewed,
    required this.correctCount,
    required this.durationSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<int>(timestamp);
    map['cards_reviewed'] = Variable<int>(cardsReviewed);
    map['correct_count'] = Variable<int>(correctCount);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    return map;
  }

  ReviewSessionTableCompanion toCompanion(bool nullToAbsent) {
    return ReviewSessionTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      cardsReviewed: Value(cardsReviewed),
      correctCount: Value(correctCount),
      durationSeconds: Value(durationSeconds),
    );
  }

  factory ReviewSessionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewSessionTableData(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      cardsReviewed: serializer.fromJson<int>(json['cardsReviewed']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<int>(timestamp),
      'cardsReviewed': serializer.toJson<int>(cardsReviewed),
      'correctCount': serializer.toJson<int>(correctCount),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
    };
  }

  ReviewSessionTableData copyWith({
    int? id,
    int? timestamp,
    int? cardsReviewed,
    int? correctCount,
    int? durationSeconds,
  }) => ReviewSessionTableData(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    cardsReviewed: cardsReviewed ?? this.cardsReviewed,
    correctCount: correctCount ?? this.correctCount,
    durationSeconds: durationSeconds ?? this.durationSeconds,
  );
  ReviewSessionTableData copyWithCompanion(ReviewSessionTableCompanion data) {
    return ReviewSessionTableData(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      cardsReviewed: data.cardsReviewed.present
          ? data.cardsReviewed.value
          : this.cardsReviewed,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewSessionTableData(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('cardsReviewed: $cardsReviewed, ')
          ..write('correctCount: $correctCount, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, timestamp, cardsReviewed, correctCount, durationSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewSessionTableData &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.cardsReviewed == this.cardsReviewed &&
          other.correctCount == this.correctCount &&
          other.durationSeconds == this.durationSeconds);
}

class ReviewSessionTableCompanion
    extends UpdateCompanion<ReviewSessionTableData> {
  final Value<int> id;
  final Value<int> timestamp;
  final Value<int> cardsReviewed;
  final Value<int> correctCount;
  final Value<int> durationSeconds;
  const ReviewSessionTableCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.cardsReviewed = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  });
  ReviewSessionTableCompanion.insert({
    this.id = const Value.absent(),
    required int timestamp,
    required int cardsReviewed,
    required int correctCount,
    required int durationSeconds,
  }) : timestamp = Value(timestamp),
       cardsReviewed = Value(cardsReviewed),
       correctCount = Value(correctCount),
       durationSeconds = Value(durationSeconds);
  static Insertable<ReviewSessionTableData> custom({
    Expression<int>? id,
    Expression<int>? timestamp,
    Expression<int>? cardsReviewed,
    Expression<int>? correctCount,
    Expression<int>? durationSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (cardsReviewed != null) 'cards_reviewed': cardsReviewed,
      if (correctCount != null) 'correct_count': correctCount,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
    });
  }

  ReviewSessionTableCompanion copyWith({
    Value<int>? id,
    Value<int>? timestamp,
    Value<int>? cardsReviewed,
    Value<int>? correctCount,
    Value<int>? durationSeconds,
  }) {
    return ReviewSessionTableCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      cardsReviewed: cardsReviewed ?? this.cardsReviewed,
      correctCount: correctCount ?? this.correctCount,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (cardsReviewed.present) {
      map['cards_reviewed'] = Variable<int>(cardsReviewed.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewSessionTableCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('cardsReviewed: $cardsReviewed, ')
          ..write('correctCount: $correctCount, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProgressTableTable userProgressTable =
      $UserProgressTableTable(this);
  late final $BeltAdvancementTableTable beltAdvancementTable =
      $BeltAdvancementTableTable(this);
  late final $TrainingSessionTableTable trainingSessionTable =
      $TrainingSessionTableTable(this);
  late final $CardReviewStateTableTable cardReviewStateTable =
      $CardReviewStateTableTable(this);
  late final $QuizAttemptTableTable quizAttemptTable = $QuizAttemptTableTable(
    this,
  );
  late final $ReviewSessionTableTable reviewSessionTable =
      $ReviewSessionTableTable(this);
  late final ProgressDao progressDao = ProgressDao(this as AppDatabase);
  late final ReviewDao reviewDao = ReviewDao(this as AppDatabase);
  late final QuizDao quizDao = QuizDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProgressTable,
    beltAdvancementTable,
    trainingSessionTable,
    cardReviewStateTable,
    quizAttemptTable,
    reviewSessionTable,
  ];
}

typedef $$UserProgressTableTableCreateCompanionBuilder =
    UserProgressTableCompanion Function({
      Value<int> id,
      required int currentRank,
      required int startDate,
      Value<String> completedTechniquesJson,
    });
typedef $$UserProgressTableTableUpdateCompanionBuilder =
    UserProgressTableCompanion Function({
      Value<int> id,
      Value<int> currentRank,
      Value<int> startDate,
      Value<String> completedTechniquesJson,
    });

class $$UserProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentRank => $composableBuilder(
    column: $table.currentRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedTechniquesJson => $composableBuilder(
    column: $table.completedTechniquesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentRank => $composableBuilder(
    column: $table.currentRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedTechniquesJson => $composableBuilder(
    column: $table.completedTechniquesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentRank => $composableBuilder(
    column: $table.currentRank,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get completedTechniquesJson => $composableBuilder(
    column: $table.completedTechniquesJson,
    builder: (column) => column,
  );
}

class $$UserProgressTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProgressTableTable,
          UserProgressTableData,
          $$UserProgressTableTableFilterComposer,
          $$UserProgressTableTableOrderingComposer,
          $$UserProgressTableTableAnnotationComposer,
          $$UserProgressTableTableCreateCompanionBuilder,
          $$UserProgressTableTableUpdateCompanionBuilder,
          (
            UserProgressTableData,
            BaseReferences<
              _$AppDatabase,
              $UserProgressTableTable,
              UserProgressTableData
            >,
          ),
          UserProgressTableData,
          PrefetchHooks Function()
        > {
  $$UserProgressTableTableTableManager(
    _$AppDatabase db,
    $UserProgressTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentRank = const Value.absent(),
                Value<int> startDate = const Value.absent(),
                Value<String> completedTechniquesJson = const Value.absent(),
              }) => UserProgressTableCompanion(
                id: id,
                currentRank: currentRank,
                startDate: startDate,
                completedTechniquesJson: completedTechniquesJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int currentRank,
                required int startDate,
                Value<String> completedTechniquesJson = const Value.absent(),
              }) => UserProgressTableCompanion.insert(
                id: id,
                currentRank: currentRank,
                startDate: startDate,
                completedTechniquesJson: completedTechniquesJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProgressTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProgressTableTable,
      UserProgressTableData,
      $$UserProgressTableTableFilterComposer,
      $$UserProgressTableTableOrderingComposer,
      $$UserProgressTableTableAnnotationComposer,
      $$UserProgressTableTableCreateCompanionBuilder,
      $$UserProgressTableTableUpdateCompanionBuilder,
      (
        UserProgressTableData,
        BaseReferences<
          _$AppDatabase,
          $UserProgressTableTable,
          UserProgressTableData
        >,
      ),
      UserProgressTableData,
      PrefetchHooks Function()
    >;
typedef $$BeltAdvancementTableTableCreateCompanionBuilder =
    BeltAdvancementTableCompanion Function({
      Value<int> id,
      required int fromRank,
      required int toRank,
      required int date,
      Value<String?> notes,
    });
typedef $$BeltAdvancementTableTableUpdateCompanionBuilder =
    BeltAdvancementTableCompanion Function({
      Value<int> id,
      Value<int> fromRank,
      Value<int> toRank,
      Value<int> date,
      Value<String?> notes,
    });

class $$BeltAdvancementTableTableFilterComposer
    extends Composer<_$AppDatabase, $BeltAdvancementTableTable> {
  $$BeltAdvancementTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromRank => $composableBuilder(
    column: $table.fromRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toRank => $composableBuilder(
    column: $table.toRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BeltAdvancementTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BeltAdvancementTableTable> {
  $$BeltAdvancementTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromRank => $composableBuilder(
    column: $table.fromRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toRank => $composableBuilder(
    column: $table.toRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BeltAdvancementTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BeltAdvancementTableTable> {
  $$BeltAdvancementTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fromRank =>
      $composableBuilder(column: $table.fromRank, builder: (column) => column);

  GeneratedColumn<int> get toRank =>
      $composableBuilder(column: $table.toRank, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$BeltAdvancementTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BeltAdvancementTableTable,
          BeltAdvancementTableData,
          $$BeltAdvancementTableTableFilterComposer,
          $$BeltAdvancementTableTableOrderingComposer,
          $$BeltAdvancementTableTableAnnotationComposer,
          $$BeltAdvancementTableTableCreateCompanionBuilder,
          $$BeltAdvancementTableTableUpdateCompanionBuilder,
          (
            BeltAdvancementTableData,
            BaseReferences<
              _$AppDatabase,
              $BeltAdvancementTableTable,
              BeltAdvancementTableData
            >,
          ),
          BeltAdvancementTableData,
          PrefetchHooks Function()
        > {
  $$BeltAdvancementTableTableTableManager(
    _$AppDatabase db,
    $BeltAdvancementTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BeltAdvancementTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BeltAdvancementTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BeltAdvancementTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> fromRank = const Value.absent(),
                Value<int> toRank = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => BeltAdvancementTableCompanion(
                id: id,
                fromRank: fromRank,
                toRank: toRank,
                date: date,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fromRank,
                required int toRank,
                required int date,
                Value<String?> notes = const Value.absent(),
              }) => BeltAdvancementTableCompanion.insert(
                id: id,
                fromRank: fromRank,
                toRank: toRank,
                date: date,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BeltAdvancementTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BeltAdvancementTableTable,
      BeltAdvancementTableData,
      $$BeltAdvancementTableTableFilterComposer,
      $$BeltAdvancementTableTableOrderingComposer,
      $$BeltAdvancementTableTableAnnotationComposer,
      $$BeltAdvancementTableTableCreateCompanionBuilder,
      $$BeltAdvancementTableTableUpdateCompanionBuilder,
      (
        BeltAdvancementTableData,
        BaseReferences<
          _$AppDatabase,
          $BeltAdvancementTableTable,
          BeltAdvancementTableData
        >,
      ),
      BeltAdvancementTableData,
      PrefetchHooks Function()
    >;
typedef $$TrainingSessionTableTableCreateCompanionBuilder =
    TrainingSessionTableCompanion Function({
      Value<int> id,
      required int date,
      required int durationMinutes,
      Value<String?> notes,
    });
typedef $$TrainingSessionTableTableUpdateCompanionBuilder =
    TrainingSessionTableCompanion Function({
      Value<int> id,
      Value<int> date,
      Value<int> durationMinutes,
      Value<String?> notes,
    });

class $$TrainingSessionTableTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingSessionTableTable> {
  $$TrainingSessionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrainingSessionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingSessionTableTable> {
  $$TrainingSessionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrainingSessionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingSessionTableTable> {
  $$TrainingSessionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$TrainingSessionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrainingSessionTableTable,
          TrainingSessionTableData,
          $$TrainingSessionTableTableFilterComposer,
          $$TrainingSessionTableTableOrderingComposer,
          $$TrainingSessionTableTableAnnotationComposer,
          $$TrainingSessionTableTableCreateCompanionBuilder,
          $$TrainingSessionTableTableUpdateCompanionBuilder,
          (
            TrainingSessionTableData,
            BaseReferences<
              _$AppDatabase,
              $TrainingSessionTableTable,
              TrainingSessionTableData
            >,
          ),
          TrainingSessionTableData,
          PrefetchHooks Function()
        > {
  $$TrainingSessionTableTableTableManager(
    _$AppDatabase db,
    $TrainingSessionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingSessionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingSessionTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TrainingSessionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => TrainingSessionTableCompanion(
                id: id,
                date: date,
                durationMinutes: durationMinutes,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int date,
                required int durationMinutes,
                Value<String?> notes = const Value.absent(),
              }) => TrainingSessionTableCompanion.insert(
                id: id,
                date: date,
                durationMinutes: durationMinutes,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrainingSessionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrainingSessionTableTable,
      TrainingSessionTableData,
      $$TrainingSessionTableTableFilterComposer,
      $$TrainingSessionTableTableOrderingComposer,
      $$TrainingSessionTableTableAnnotationComposer,
      $$TrainingSessionTableTableCreateCompanionBuilder,
      $$TrainingSessionTableTableUpdateCompanionBuilder,
      (
        TrainingSessionTableData,
        BaseReferences<
          _$AppDatabase,
          $TrainingSessionTableTable,
          TrainingSessionTableData
        >,
      ),
      TrainingSessionTableData,
      PrefetchHooks Function()
    >;
typedef $$CardReviewStateTableTableCreateCompanionBuilder =
    CardReviewStateTableCompanion Function({
      required String cardId,
      Value<double> easeFactor,
      Value<int> interval,
      Value<int> repetitions,
      required int nextReviewDate,
      required int lastReviewDate,
      Value<int> totalReviews,
      Value<int> correctReviews,
      Value<int> rowid,
    });
typedef $$CardReviewStateTableTableUpdateCompanionBuilder =
    CardReviewStateTableCompanion Function({
      Value<String> cardId,
      Value<double> easeFactor,
      Value<int> interval,
      Value<int> repetitions,
      Value<int> nextReviewDate,
      Value<int> lastReviewDate,
      Value<int> totalReviews,
      Value<int> correctReviews,
      Value<int> rowid,
    });

class $$CardReviewStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $CardReviewStateTableTable> {
  $$CardReviewStateTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReviewDate => $composableBuilder(
    column: $table.lastReviewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctReviews => $composableBuilder(
    column: $table.correctReviews,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardReviewStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CardReviewStateTableTable> {
  $$CardReviewStateTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReviewDate => $composableBuilder(
    column: $table.lastReviewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctReviews => $composableBuilder(
    column: $table.correctReviews,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardReviewStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardReviewStateTableTable> {
  $$CardReviewStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastReviewDate => $composableBuilder(
    column: $table.lastReviewDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctReviews => $composableBuilder(
    column: $table.correctReviews,
    builder: (column) => column,
  );
}

class $$CardReviewStateTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardReviewStateTableTable,
          CardReviewStateTableData,
          $$CardReviewStateTableTableFilterComposer,
          $$CardReviewStateTableTableOrderingComposer,
          $$CardReviewStateTableTableAnnotationComposer,
          $$CardReviewStateTableTableCreateCompanionBuilder,
          $$CardReviewStateTableTableUpdateCompanionBuilder,
          (
            CardReviewStateTableData,
            BaseReferences<
              _$AppDatabase,
              $CardReviewStateTableTable,
              CardReviewStateTableData
            >,
          ),
          CardReviewStateTableData,
          PrefetchHooks Function()
        > {
  $$CardReviewStateTableTableTableManager(
    _$AppDatabase db,
    $CardReviewStateTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardReviewStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardReviewStateTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CardReviewStateTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> cardId = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> nextReviewDate = const Value.absent(),
                Value<int> lastReviewDate = const Value.absent(),
                Value<int> totalReviews = const Value.absent(),
                Value<int> correctReviews = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardReviewStateTableCompanion(
                cardId: cardId,
                easeFactor: easeFactor,
                interval: interval,
                repetitions: repetitions,
                nextReviewDate: nextReviewDate,
                lastReviewDate: lastReviewDate,
                totalReviews: totalReviews,
                correctReviews: correctReviews,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cardId,
                Value<double> easeFactor = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                required int nextReviewDate,
                required int lastReviewDate,
                Value<int> totalReviews = const Value.absent(),
                Value<int> correctReviews = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardReviewStateTableCompanion.insert(
                cardId: cardId,
                easeFactor: easeFactor,
                interval: interval,
                repetitions: repetitions,
                nextReviewDate: nextReviewDate,
                lastReviewDate: lastReviewDate,
                totalReviews: totalReviews,
                correctReviews: correctReviews,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardReviewStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardReviewStateTableTable,
      CardReviewStateTableData,
      $$CardReviewStateTableTableFilterComposer,
      $$CardReviewStateTableTableOrderingComposer,
      $$CardReviewStateTableTableAnnotationComposer,
      $$CardReviewStateTableTableCreateCompanionBuilder,
      $$CardReviewStateTableTableUpdateCompanionBuilder,
      (
        CardReviewStateTableData,
        BaseReferences<
          _$AppDatabase,
          $CardReviewStateTableTable,
          CardReviewStateTableData
        >,
      ),
      CardReviewStateTableData,
      PrefetchHooks Function()
    >;
typedef $$QuizAttemptTableTableCreateCompanionBuilder =
    QuizAttemptTableCompanion Function({
      Value<int> id,
      required int timestamp,
      required int targetRank,
      Value<bool> isMockExam,
      required int totalQuestions,
      required int correctAnswers,
      required int durationSeconds,
      Value<String> categoryScoresJson,
      Value<String> weakAreasJson,
    });
typedef $$QuizAttemptTableTableUpdateCompanionBuilder =
    QuizAttemptTableCompanion Function({
      Value<int> id,
      Value<int> timestamp,
      Value<int> targetRank,
      Value<bool> isMockExam,
      Value<int> totalQuestions,
      Value<int> correctAnswers,
      Value<int> durationSeconds,
      Value<String> categoryScoresJson,
      Value<String> weakAreasJson,
    });

class $$QuizAttemptTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAttemptTableTable> {
  $$QuizAttemptTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetRank => $composableBuilder(
    column: $table.targetRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMockExam => $composableBuilder(
    column: $table.isMockExam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryScoresJson => $composableBuilder(
    column: $table.categoryScoresJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weakAreasJson => $composableBuilder(
    column: $table.weakAreasJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizAttemptTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAttemptTableTable> {
  $$QuizAttemptTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetRank => $composableBuilder(
    column: $table.targetRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMockExam => $composableBuilder(
    column: $table.isMockExam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryScoresJson => $composableBuilder(
    column: $table.categoryScoresJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weakAreasJson => $composableBuilder(
    column: $table.weakAreasJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizAttemptTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAttemptTableTable> {
  $$QuizAttemptTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get targetRank => $composableBuilder(
    column: $table.targetRank,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMockExam => $composableBuilder(
    column: $table.isMockExam,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryScoresJson => $composableBuilder(
    column: $table.categoryScoresJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weakAreasJson => $composableBuilder(
    column: $table.weakAreasJson,
    builder: (column) => column,
  );
}

class $$QuizAttemptTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizAttemptTableTable,
          QuizAttemptTableData,
          $$QuizAttemptTableTableFilterComposer,
          $$QuizAttemptTableTableOrderingComposer,
          $$QuizAttemptTableTableAnnotationComposer,
          $$QuizAttemptTableTableCreateCompanionBuilder,
          $$QuizAttemptTableTableUpdateCompanionBuilder,
          (
            QuizAttemptTableData,
            BaseReferences<
              _$AppDatabase,
              $QuizAttemptTableTable,
              QuizAttemptTableData
            >,
          ),
          QuizAttemptTableData,
          PrefetchHooks Function()
        > {
  $$QuizAttemptTableTableTableManager(
    _$AppDatabase db,
    $QuizAttemptTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<int> targetRank = const Value.absent(),
                Value<bool> isMockExam = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<int> correctAnswers = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> categoryScoresJson = const Value.absent(),
                Value<String> weakAreasJson = const Value.absent(),
              }) => QuizAttemptTableCompanion(
                id: id,
                timestamp: timestamp,
                targetRank: targetRank,
                isMockExam: isMockExam,
                totalQuestions: totalQuestions,
                correctAnswers: correctAnswers,
                durationSeconds: durationSeconds,
                categoryScoresJson: categoryScoresJson,
                weakAreasJson: weakAreasJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int timestamp,
                required int targetRank,
                Value<bool> isMockExam = const Value.absent(),
                required int totalQuestions,
                required int correctAnswers,
                required int durationSeconds,
                Value<String> categoryScoresJson = const Value.absent(),
                Value<String> weakAreasJson = const Value.absent(),
              }) => QuizAttemptTableCompanion.insert(
                id: id,
                timestamp: timestamp,
                targetRank: targetRank,
                isMockExam: isMockExam,
                totalQuestions: totalQuestions,
                correctAnswers: correctAnswers,
                durationSeconds: durationSeconds,
                categoryScoresJson: categoryScoresJson,
                weakAreasJson: weakAreasJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizAttemptTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizAttemptTableTable,
      QuizAttemptTableData,
      $$QuizAttemptTableTableFilterComposer,
      $$QuizAttemptTableTableOrderingComposer,
      $$QuizAttemptTableTableAnnotationComposer,
      $$QuizAttemptTableTableCreateCompanionBuilder,
      $$QuizAttemptTableTableUpdateCompanionBuilder,
      (
        QuizAttemptTableData,
        BaseReferences<
          _$AppDatabase,
          $QuizAttemptTableTable,
          QuizAttemptTableData
        >,
      ),
      QuizAttemptTableData,
      PrefetchHooks Function()
    >;
typedef $$ReviewSessionTableTableCreateCompanionBuilder =
    ReviewSessionTableCompanion Function({
      Value<int> id,
      required int timestamp,
      required int cardsReviewed,
      required int correctCount,
      required int durationSeconds,
    });
typedef $$ReviewSessionTableTableUpdateCompanionBuilder =
    ReviewSessionTableCompanion Function({
      Value<int> id,
      Value<int> timestamp,
      Value<int> cardsReviewed,
      Value<int> correctCount,
      Value<int> durationSeconds,
    });

class $$ReviewSessionTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewSessionTableTable> {
  $$ReviewSessionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardsReviewed => $composableBuilder(
    column: $table.cardsReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewSessionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewSessionTableTable> {
  $$ReviewSessionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardsReviewed => $composableBuilder(
    column: $table.cardsReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewSessionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewSessionTableTable> {
  $$ReviewSessionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get cardsReviewed => $composableBuilder(
    column: $table.cardsReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );
}

class $$ReviewSessionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewSessionTableTable,
          ReviewSessionTableData,
          $$ReviewSessionTableTableFilterComposer,
          $$ReviewSessionTableTableOrderingComposer,
          $$ReviewSessionTableTableAnnotationComposer,
          $$ReviewSessionTableTableCreateCompanionBuilder,
          $$ReviewSessionTableTableUpdateCompanionBuilder,
          (
            ReviewSessionTableData,
            BaseReferences<
              _$AppDatabase,
              $ReviewSessionTableTable,
              ReviewSessionTableData
            >,
          ),
          ReviewSessionTableData,
          PrefetchHooks Function()
        > {
  $$ReviewSessionTableTableTableManager(
    _$AppDatabase db,
    $ReviewSessionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewSessionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewSessionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewSessionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<int> cardsReviewed = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
              }) => ReviewSessionTableCompanion(
                id: id,
                timestamp: timestamp,
                cardsReviewed: cardsReviewed,
                correctCount: correctCount,
                durationSeconds: durationSeconds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int timestamp,
                required int cardsReviewed,
                required int correctCount,
                required int durationSeconds,
              }) => ReviewSessionTableCompanion.insert(
                id: id,
                timestamp: timestamp,
                cardsReviewed: cardsReviewed,
                correctCount: correctCount,
                durationSeconds: durationSeconds,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewSessionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewSessionTableTable,
      ReviewSessionTableData,
      $$ReviewSessionTableTableFilterComposer,
      $$ReviewSessionTableTableOrderingComposer,
      $$ReviewSessionTableTableAnnotationComposer,
      $$ReviewSessionTableTableCreateCompanionBuilder,
      $$ReviewSessionTableTableUpdateCompanionBuilder,
      (
        ReviewSessionTableData,
        BaseReferences<
          _$AppDatabase,
          $ReviewSessionTableTable,
          ReviewSessionTableData
        >,
      ),
      ReviewSessionTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProgressTableTableTableManager get userProgressTable =>
      $$UserProgressTableTableTableManager(_db, _db.userProgressTable);
  $$BeltAdvancementTableTableTableManager get beltAdvancementTable =>
      $$BeltAdvancementTableTableTableManager(_db, _db.beltAdvancementTable);
  $$TrainingSessionTableTableTableManager get trainingSessionTable =>
      $$TrainingSessionTableTableTableManager(_db, _db.trainingSessionTable);
  $$CardReviewStateTableTableTableManager get cardReviewStateTable =>
      $$CardReviewStateTableTableTableManager(_db, _db.cardReviewStateTable);
  $$QuizAttemptTableTableTableManager get quizAttemptTable =>
      $$QuizAttemptTableTableTableManager(_db, _db.quizAttemptTable);
  $$ReviewSessionTableTableTableManager get reviewSessionTable =>
      $$ReviewSessionTableTableTableManager(_db, _db.reviewSessionTable);
}
