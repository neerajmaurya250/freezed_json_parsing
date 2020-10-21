import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

part 'main.freezed.dart';

part 'main.g.dart';

@freezed
abstract class Person with _$Person {
  const factory Person({int id, String name, String username, String email}) =
      _Person;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}

Future<List<Person>> getHttp() async {
  Dio dio = Dio();

  final url = 'https://jsonplaceholder.typicode.com/users';
  Response response = await dio.get('$url');
  print(response.data);
  return compute(parsePhotos, response.data);
}

List<Person> parsePhotos(dynamic responseBody) {
  try {
    final parsed = responseBody as List<dynamic>;
    return parsed.map<Person>((json) => Person.fromJson(json)).toList();
  } catch (e) {
    print(e);
  }
  return [];
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Person>>(
          future: getHttp(),
          builder: (context, snapshot) {
            print('/-/-/-/-//-/-/-/-/-/-/-/-/-/-/-/-/-/-//-/-/-/-/-/-/-/-' +
                snapshot.data.toString());
            List<Person> p = snapshot.data;
            return snapshot.hasData
                ? NameList(
                    person: snapshot.data,
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class NameList extends StatelessWidget {
  final List<Person> person;

  const NameList({Key key, this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: person.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text(person[index].id.toString()),
              Text(person[index].name),
              Text(person[index].email),
            ],
          );
        });
  }
}
