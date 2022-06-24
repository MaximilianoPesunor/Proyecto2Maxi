import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Wikipedia search API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getAutoData() async {
    var response = await http.get(Uri.parse("https://xkcd.com/info.0.json"));

    var jsonData = jsonDecode(response.body);

    List<Comic> comics = [];

    for (var u in jsonData) {
      Comic comic = Comic(u["month"], u["num"], u["year"], u["safe_title"], u["title"], u["day"]);
      comics.add(comic);
    }
    return comics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyecto 2 Maximiliano'),
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
            future: getAutoData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(child: Text('CARGANDO API')),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(snapshot.data[i].day),
                      );
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}

class Comic {
  final String month, number, year, safe_title, title, day;
  Comic(this.month, this.number, this.year, this.safe_title, this.title, this.day);
}
