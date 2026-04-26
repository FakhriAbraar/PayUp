// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payup_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBillCollection on Isar {
  IsarCollection<Bill> get bills => this.collection();
}

const BillSchema = CollectionSchema(
  name: r'Bill',
  id: 7031121081258233164,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'proofImageUrl': PropertySchema(
      id: 1,
      name: r'proofImageUrl',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 2,
      name: r'title',
      type: IsarType.string,
    ),
    r'totalAmount': PropertySchema(
      id: 3,
      name: r'totalAmount',
      type: IsarType.double,
    )
  },
  estimateSize: _billEstimateSize,
  serialize: _billSerialize,
  deserialize: _billDeserialize,
  deserializeProp: _billDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'splitDetails': LinkSchema(
      id: -7692944937915562815,
      name: r'splitDetails',
      target: r'SplitDetail',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _billGetId,
  getLinks: _billGetLinks,
  attach: _billAttach,
  version: '3.1.0+1',
);

int _billEstimateSize(
  Bill object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.proofImageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _billSerialize(
  Bill object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeString(offsets[1], object.proofImageUrl);
  writer.writeString(offsets[2], object.title);
  writer.writeDouble(offsets[3], object.totalAmount);
}

Bill _billDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Bill();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  object.proofImageUrl = reader.readStringOrNull(offsets[1]);
  object.title = reader.readString(offsets[2]);
  object.totalAmount = reader.readDouble(offsets[3]);
  return object;
}

P _billDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _billGetId(Bill object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _billGetLinks(Bill object) {
  return [object.splitDetails];
}

void _billAttach(IsarCollection<dynamic> col, Id id, Bill object) {
  object.id = id;
  object.splitDetails
      .attach(col, col.isar.collection<SplitDetail>(), r'splitDetails', id);
}

extension BillQueryWhereSort on QueryBuilder<Bill, Bill, QWhere> {
  QueryBuilder<Bill, Bill, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BillQueryWhere on QueryBuilder<Bill, Bill, QWhereClause> {
  QueryBuilder<Bill, Bill, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Bill, Bill, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Bill, Bill, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Bill, Bill, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BillQueryFilter on QueryBuilder<Bill, Bill, QFilterCondition> {
  QueryBuilder<Bill, Bill, QAfterFilterCondition> dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'proofImageUrl',
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'proofImageUrl',
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proofImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proofImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proofImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proofImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'proofImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'proofImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'proofImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'proofImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proofImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> proofImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'proofImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> totalAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> totalAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> totalAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> totalAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension BillQueryObject on QueryBuilder<Bill, Bill, QFilterCondition> {}

extension BillQueryLinks on QueryBuilder<Bill, Bill, QFilterCondition> {
  QueryBuilder<Bill, Bill, QAfterFilterCondition> splitDetails(
      FilterQuery<SplitDetail> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'splitDetails');
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> splitDetailsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'splitDetails', length, true, length, true);
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> splitDetailsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'splitDetails', 0, true, 0, true);
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> splitDetailsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'splitDetails', 0, false, 999999, true);
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> splitDetailsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'splitDetails', 0, true, length, include);
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> splitDetailsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'splitDetails', length, include, 999999, true);
    });
  }

  QueryBuilder<Bill, Bill, QAfterFilterCondition> splitDetailsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'splitDetails', lower, includeLower, upper, includeUpper);
    });
  }
}

extension BillQuerySortBy on QueryBuilder<Bill, Bill, QSortBy> {
  QueryBuilder<Bill, Bill, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> sortByProofImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proofImageUrl', Sort.asc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> sortByProofImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proofImageUrl', Sort.desc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> sortByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> sortByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }
}

extension BillQuerySortThenBy on QueryBuilder<Bill, Bill, QSortThenBy> {
  QueryBuilder<Bill, Bill, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> thenByProofImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proofImageUrl', Sort.asc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> thenByProofImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proofImageUrl', Sort.desc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> thenByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<Bill, Bill, QAfterSortBy> thenByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }
}

extension BillQueryWhereDistinct on QueryBuilder<Bill, Bill, QDistinct> {
  QueryBuilder<Bill, Bill, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<Bill, Bill, QDistinct> distinctByProofImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proofImageUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bill, Bill, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bill, Bill, QDistinct> distinctByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAmount');
    });
  }
}

extension BillQueryProperty on QueryBuilder<Bill, Bill, QQueryProperty> {
  QueryBuilder<Bill, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Bill, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Bill, String?, QQueryOperations> proofImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proofImageUrl');
    });
  }

  QueryBuilder<Bill, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Bill, double, QQueryOperations> totalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAmount');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSplitDetailCollection on Isar {
  IsarCollection<SplitDetail> get splitDetails => this.collection();
}

const SplitDetailSchema = CollectionSchema(
  name: r'SplitDetail',
  id: -2260461936062202784,
  properties: {
    r'amountToPay': PropertySchema(
      id: 0,
      name: r'amountToPay',
      type: IsarType.double,
    ),
    r'isPaid': PropertySchema(
      id: 1,
      name: r'isPaid',
      type: IsarType.bool,
    ),
    r'personName': PropertySchema(
      id: 2,
      name: r'personName',
      type: IsarType.string,
    )
  },
  estimateSize: _splitDetailEstimateSize,
  serialize: _splitDetailSerialize,
  deserialize: _splitDetailDeserialize,
  deserializeProp: _splitDetailDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _splitDetailGetId,
  getLinks: _splitDetailGetLinks,
  attach: _splitDetailAttach,
  version: '3.1.0+1',
);

int _splitDetailEstimateSize(
  SplitDetail object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.personName.length * 3;
  return bytesCount;
}

void _splitDetailSerialize(
  SplitDetail object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amountToPay);
  writer.writeBool(offsets[1], object.isPaid);
  writer.writeString(offsets[2], object.personName);
}

SplitDetail _splitDetailDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SplitDetail();
  object.amountToPay = reader.readDouble(offsets[0]);
  object.id = id;
  object.isPaid = reader.readBool(offsets[1]);
  object.personName = reader.readString(offsets[2]);
  return object;
}

P _splitDetailDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _splitDetailGetId(SplitDetail object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _splitDetailGetLinks(SplitDetail object) {
  return [];
}

void _splitDetailAttach(
    IsarCollection<dynamic> col, Id id, SplitDetail object) {
  object.id = id;
}

extension SplitDetailQueryWhereSort
    on QueryBuilder<SplitDetail, SplitDetail, QWhere> {
  QueryBuilder<SplitDetail, SplitDetail, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SplitDetailQueryWhere
    on QueryBuilder<SplitDetail, SplitDetail, QWhereClause> {
  QueryBuilder<SplitDetail, SplitDetail, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<SplitDetail, SplitDetail, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SplitDetailQueryFilter
    on QueryBuilder<SplitDetail, SplitDetail, QFilterCondition> {
  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      amountToPayEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountToPay',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      amountToPayGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountToPay',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      amountToPayLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountToPay',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      amountToPayBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountToPay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition> isPaidEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPaid',
        value: value,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      personNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      personNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      personNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      personNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'personName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      personNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      personNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      personNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      personNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'personName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      personNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'personName',
        value: '',
      ));
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterFilterCondition>
      personNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'personName',
        value: '',
      ));
    });
  }
}

extension SplitDetailQueryObject
    on QueryBuilder<SplitDetail, SplitDetail, QFilterCondition> {}

extension SplitDetailQueryLinks
    on QueryBuilder<SplitDetail, SplitDetail, QFilterCondition> {}

extension SplitDetailQuerySortBy
    on QueryBuilder<SplitDetail, SplitDetail, QSortBy> {
  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> sortByAmountToPay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountToPay', Sort.asc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> sortByAmountToPayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountToPay', Sort.desc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> sortByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.asc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> sortByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.desc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> sortByPersonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.asc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> sortByPersonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.desc);
    });
  }
}

extension SplitDetailQuerySortThenBy
    on QueryBuilder<SplitDetail, SplitDetail, QSortThenBy> {
  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> thenByAmountToPay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountToPay', Sort.asc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> thenByAmountToPayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountToPay', Sort.desc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> thenByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.asc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> thenByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.desc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> thenByPersonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.asc);
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QAfterSortBy> thenByPersonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.desc);
    });
  }
}

extension SplitDetailQueryWhereDistinct
    on QueryBuilder<SplitDetail, SplitDetail, QDistinct> {
  QueryBuilder<SplitDetail, SplitDetail, QDistinct> distinctByAmountToPay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountToPay');
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QDistinct> distinctByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaid');
    });
  }

  QueryBuilder<SplitDetail, SplitDetail, QDistinct> distinctByPersonName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'personName', caseSensitive: caseSensitive);
    });
  }
}

extension SplitDetailQueryProperty
    on QueryBuilder<SplitDetail, SplitDetail, QQueryProperty> {
  QueryBuilder<SplitDetail, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SplitDetail, double, QQueryOperations> amountToPayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountToPay');
    });
  }

  QueryBuilder<SplitDetail, bool, QQueryOperations> isPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaid');
    });
  }

  QueryBuilder<SplitDetail, String, QQueryOperations> personNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personName');
    });
  }
}
