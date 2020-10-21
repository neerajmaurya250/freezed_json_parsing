import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
part 'main.freezed.dart';
part 'main.g.dart';


@freezed
abstract class Person with _$Person {

  const factory Person({
    int id,
    String name,
    String username,
    String email
  }) = _Person;
  factory Person.fromJson(Map<String, dynamic> json) =>  _$PersonFromJson(json);
}

Future getHttp() async {
  Dio dio = Dio();

    final url = 'https://jsonplaceholder.typicode.com/users';
    Response response = await dio.get('$url/2');
    print(response.data);
    return Person.fromJson(response.data);

}

// Future parsePhotos(dynamic responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   return parsed.map<Person>((json) => Person.fromJson(json)).toList();
// }

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
        child: FutureBuilder(
          future: getHttp(),
          builder: ( _ , snapshot){
            print('/-/-/-/-//-/-/-/-/-/-/-/-/-/-/-/-/-/-//-/-/-/-/-/-/-/-'+snapshot.data.toString());
            Person p = snapshot.data;
            return Center(
                child:Text(p.email));
          },
        ),
      ),
    );
  }
}
