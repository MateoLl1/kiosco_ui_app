// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_session_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSessionConfigCollection on Isar {
  IsarCollection<AppSessionConfig> get appSessionConfigs => this.collection();
}

const AppSessionConfigSchema = CollectionSchema(
  name: r'AppSessionConfig',
  id: -8344443541836433280,
  properties: {
    r'agenciaId': PropertySchema(
      id: 0,
      name: r'agenciaId',
      type: IsarType.long,
    ),
    r'agenciaNombre': PropertySchema(
      id: 1,
      name: r'agenciaNombre',
      type: IsarType.string,
    ),
    r'role': PropertySchema(
      id: 2,
      name: r'role',
      type: IsarType.string,
      enumMap: _AppSessionConfigroleEnumValueMap,
    ),
  },

  estimateSize: _appSessionConfigEstimateSize,
  serialize: _appSessionConfigSerialize,
  deserialize: _appSessionConfigDeserialize,
  deserializeProp: _appSessionConfigDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _appSessionConfigGetId,
  getLinks: _appSessionConfigGetLinks,
  attach: _appSessionConfigAttach,
  version: '3.3.2',
);

int _appSessionConfigEstimateSize(
  AppSessionConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.agenciaNombre;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.role.name.length * 3;
  return bytesCount;
}

void _appSessionConfigSerialize(
  AppSessionConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.agenciaId);
  writer.writeString(offsets[1], object.agenciaNombre);
  writer.writeString(offsets[2], object.role.name);
}

AppSessionConfig _appSessionConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSessionConfig(
    agenciaId: reader.readLongOrNull(offsets[0]),
    agenciaNombre: reader.readStringOrNull(offsets[1]),
    role:
        _AppSessionConfigroleValueEnumMap[reader.readStringOrNull(
          offsets[2],
        )] ??
        AppRole.admin,
  );
  object.id = id;
  return object;
}

P _appSessionConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (_AppSessionConfigroleValueEnumMap[reader.readStringOrNull(
                offset,
              )] ??
              AppRole.admin)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AppSessionConfigroleEnumValueMap = {
  r'guardia': r'guardia',
  r'kiosco': r'kiosco',
  r'turnero': r'turnero',
  r'admin': r'admin',
};
const _AppSessionConfigroleValueEnumMap = {
  r'guardia': AppRole.guardia,
  r'kiosco': AppRole.kiosco,
  r'turnero': AppRole.turnero,
  r'admin': AppRole.admin,
};

Id _appSessionConfigGetId(AppSessionConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSessionConfigGetLinks(AppSessionConfig object) {
  return [];
}

void _appSessionConfigAttach(
  IsarCollection<dynamic> col,
  Id id,
  AppSessionConfig object,
) {
  object.id = id;
}

extension AppSessionConfigQueryWhereSort
    on QueryBuilder<AppSessionConfig, AppSessionConfig, QWhere> {
  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSessionConfigQueryWhere
    on QueryBuilder<AppSessionConfig, AppSessionConfig, QWhereClause> {
  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AppSessionConfigQueryFilter
    on QueryBuilder<AppSessionConfig, AppSessionConfig, QFilterCondition> {
  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'agenciaId'),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'agenciaId'),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'agenciaId', value: value),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'agenciaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'agenciaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'agenciaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'agenciaNombre'),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'agenciaNombre'),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'agenciaNombre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'agenciaNombre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'agenciaNombre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'agenciaNombre',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'agenciaNombre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'agenciaNombre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'agenciaNombre',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'agenciaNombre',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'agenciaNombre', value: ''),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  agenciaNombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'agenciaNombre', value: ''),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  roleEqualTo(AppRole value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  roleGreaterThan(
    AppRole value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  roleLessThan(
    AppRole value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  roleBetween(
    AppRole lower,
    AppRole upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'role',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  roleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  roleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  roleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  roleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'role',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  roleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'role', value: ''),
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterFilterCondition>
  roleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'role', value: ''),
      );
    });
  }
}

extension AppSessionConfigQueryObject
    on QueryBuilder<AppSessionConfig, AppSessionConfig, QFilterCondition> {}

extension AppSessionConfigQueryLinks
    on QueryBuilder<AppSessionConfig, AppSessionConfig, QFilterCondition> {}

extension AppSessionConfigQuerySortBy
    on QueryBuilder<AppSessionConfig, AppSessionConfig, QSortBy> {
  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  sortByAgenciaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agenciaId', Sort.asc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  sortByAgenciaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agenciaId', Sort.desc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  sortByAgenciaNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agenciaNombre', Sort.asc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  sortByAgenciaNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agenciaNombre', Sort.desc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy> sortByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  sortByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }
}

extension AppSessionConfigQuerySortThenBy
    on QueryBuilder<AppSessionConfig, AppSessionConfig, QSortThenBy> {
  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  thenByAgenciaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agenciaId', Sort.asc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  thenByAgenciaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agenciaId', Sort.desc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  thenByAgenciaNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agenciaNombre', Sort.asc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  thenByAgenciaNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agenciaNombre', Sort.desc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy> thenByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QAfterSortBy>
  thenByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }
}

extension AppSessionConfigQueryWhereDistinct
    on QueryBuilder<AppSessionConfig, AppSessionConfig, QDistinct> {
  QueryBuilder<AppSessionConfig, AppSessionConfig, QDistinct>
  distinctByAgenciaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'agenciaId');
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QDistinct>
  distinctByAgenciaNombre({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'agenciaNombre',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSessionConfig, AppSessionConfig, QDistinct> distinctByRole({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'role', caseSensitive: caseSensitive);
    });
  }
}

extension AppSessionConfigQueryProperty
    on QueryBuilder<AppSessionConfig, AppSessionConfig, QQueryProperty> {
  QueryBuilder<AppSessionConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSessionConfig, int?, QQueryOperations> agenciaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'agenciaId');
    });
  }

  QueryBuilder<AppSessionConfig, String?, QQueryOperations>
  agenciaNombreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'agenciaNombre');
    });
  }

  QueryBuilder<AppSessionConfig, AppRole, QQueryOperations> roleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'role');
    });
  }
}
