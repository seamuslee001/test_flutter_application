import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:test_flutter_application/api.dart';

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

  @override
  Widget build(BuildContext context) {
    return Query(
        options: options,
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
                      : ListView.builder(
                  itemCount: result.data["searchAPISearch"]["documents"].length,
                  itemBuilder: (BuildContext context, int index) {
                    final list = result.data["searchAPISearch"]["documents"][index];
                    final title = list["title"] ?? list["organization_name"] ?? '';
                    return ListTile (
                      onTap: () {},
                      title: Container(
                        padding: EdgeInsets.all(5.0),
                        height: 35.0,
                        child: Text(
                          title,
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontFamily: 'Yekan',
                              fontSize: 18.0),
                        ),
                      ),
                      subtitle: Text(
                        list["custom_893"] ?? '',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontFamily: 'Yekan',
                            fontSize: 15.0),
                      ),
                      trailing: Icon(Icons.arrow_right),
                      contentPadding: EdgeInsets.only(top: 3.5, bottom: 3.5),
                   );
                 }
               )
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'New Task',
                child: Icon(Icons.add),
              ));
        });
  }
}

  class TaskList extends StatelessWidget {
  TaskList({@required this.list, @required this.onRefresh});

  final list;
  final onRefresh;

  @override
  Widget build(BuildContext context) {
  return Mutation(
    options: MutationOptions(documentNode: gql(query)),
    builder: (RunMutation runMutation, QueryResult result) {
      return ListView.builder(
        itemCount: this.list.length,
        itemBuilder: (context, index) {
          final task = this.list[index];
          return CheckboxListTile(
              title: Text(task['title']),
              value: task['completed'],
              onChanged: (_) {runMutation({'id': index + 1, 'completed': !task['completed']});
              onRefresh();
              });
            },
          );
        },
      );
    }
  }

