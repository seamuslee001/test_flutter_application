import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:test_flutter_application/api.dart';
import 'package:html/parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
      client: client,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  var acceptingNewClients = "Yes";
  var servicesProvided = "At work address";
  var ageGroup = "Preschool";
  var type = "learning_resource";
  var appLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          documentNode: gql(query),
          variables: queryVariables(appLanguage, type, servicesProvided,
              ageGroup, acceptingNewClients)
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          return Scaffold(
              appBar: AppBar(
                title: Text("TODO App With GraphQL"),
              ),
              body: Center(
                child: result.hasException
                    ? Text(result.exception.toString())
                    : result.loading
                    ? CircularProgressIndicator()
                    : SearchResult(list: result.data),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  refetch();
                },
                tooltip: 'New Task',
                child: Icon(Icons.add),
              ));
        });
  }

  queryVariables(language, types, servicesProvided, ageGroupsServed,
    acceptingNewClients) {
    var conditionGroupGroups = new List();
    conditionGroupGroups.add(buildConditionGroup({"type": types}, "OR"));
    var conditionGroup = {
      "conjunction": "AND",
      'groups': conditionGroupGroups,
    };
    var variables = {
      "conditions": [],
      "languages": [language, "und"],
      'conditionGroup': conditionGroup,
    };
    return variables;
  }

}

class SearchResult extends StatelessWidget {
  SearchResult({@required this.list});
  final list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list["searchAPISearch"]["documents"].length,
        itemBuilder: (BuildContext context, int index) {
          final item = list["searchAPISearch"]["documents"][index];
          return ListTile (
            onTap: () {},
            title: Container(
              padding: EdgeInsets.all(5.0),
              height: 35.0,
              child: Text(
                getTitle(item),
                style: TextStyle(
                    color: Colors.grey[850],
                    fontFamily: 'Yekan',
                    fontSize: 18.0),
              ),
            ),
            subtitle: Text(
              getDescription(item),
            ),
            trailing: Icon(Icons.arrow_right),
            contentPadding: EdgeInsets.only(top: 3.5, bottom: 3.5),
          );
        }
    );
  }
  
  getTitle(item) {
    return item['title'] ?? item["organization_name"] ?? '';
  }

  String getDescription(item) {
    var body = parse(item['custom_893'] ?? item['description'] ?? item['body'] ?? '');
    return truncateWithEllipsis(200, parse(body.body.text).documentElement.text);
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }
}

