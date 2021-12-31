import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jareb/Fenetre/crudComposant.dart';

class SearchPage extends StatefulWidget {
  SearchPage({
    Key key,
  }) : super(
    key: key,
  );

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Crudcom contactOperations = Crudcom();
  late String keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQFLite Tutorial'),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/homePage');
          },
          child: Icon(
            Icons.arrow_back, // add custom icons also
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'keyword'),
                  onChanged: (value) {
                    keyword = value;
                    setState(() {

                    });
                  },
                ),
              ),
              FutureBuilder(
                future: contactOperations.searchContacts(keyword),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print('error');
                  var data = snapshot.data;
                  return snapshot.hasData ? ContactsList(data) : new Center(child: Text('No contacts that include this keyword'),);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}