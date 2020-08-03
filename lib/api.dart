import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';

final HttpLink _httpLink = HttpLink(
  uri: 'https://jma.staging.autismontario.com/graphql',
);

final AuthLink _authLink = AuthLink(
  getToken: () async => '',
);

final Link _link = _authLink.concat(_httpLink);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: _link,
  ),
);

final String query = """
query getSearchResults(\$languages: [String]!, \$fullText: FulltextInput, \$conditionGroup: ConditionGroupInput) {
  searchAPISearch(index_id: "default", language: \$languages, condition_group: \$conditionGroup, fulltext: \$fullText, facets: [{field: "type", min_count: 1, limit: 0, operator: "=", missing: false}, {field: "field_chapter_reference", min_count: 1, limit: 0, operator: "=", missing: false}]) {
    documents {
      ... on DefaultDoc {
        type
        title
        tm_x3b_und_title_1
        description
        custom_356
        custom_891
        custom_893
        organization_name
        custom_892
        custom_895
        custom_896
        custom_897
        custom_898
        custom_899
        custom_912
        custom_911
        custom_904
        field_chapter_reference
      }
    }
    facets {
      name
      values {
        filter
        count
      }
    }
  }
}
""";

queryVariables(String $value, String $name) =>
    {"name": $name, "value": $value, "operator": "="};

buildConditionGroup(Map $queryConditions, String $conjunction) {
  var conditions = new List();
  $queryConditions.forEach((key, value) {
    conditions.add(queryVariables(value, key));
  });
  var conditionGroup = {
    "conjunction": $conjunction,
    "conditions": conditions,
  };
  return conditionGroup;
}

final QueryOptions options = QueryOptions(
  documentNode: gql(query),
  variables: <String, dynamic>{
    "conditionGroup": {
      "conjunction": "AND",
      "groups": [
        buildConditionGroup(
          {"type": "Service Listing", "custom_896": "Accepting new clients"},
          "AND"
        ),
        buildConditionGroup({"custom_897": "At work address"}, "OR"),
        buildConditionGroup({"custom_898": "Preschool"}, "OR"),
      ]
    },
    "languages": ["en", "und"],
    "conditions": []
  },
);
