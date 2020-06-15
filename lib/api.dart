import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyLocaiton {
  double lat;
  double long;

  MyLocaiton({this.lat, this.long});
}

class CovidInfo {
  String name;
  String address;
  double lat;
  double long;

  CovidInfo(String name, String address, double lat, double long) {
      this.name = name;
      this.address = address;
      this.lat = lat;
      this.long = long;
  }
}

class Todo {
  String updatedAt;
  int deaths;
  int confirmed;
  int recovered;
  int newConfirmed;
  int newRecovered;
  int newDeaths;

  Todo({
    this.updatedAt,
    this.deaths,
    this.confirmed,
    this.recovered,
    this.newConfirmed,
    this.newRecovered,
    this.newDeaths,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      updatedAt: json["updated_at"],
      deaths: json["deaths"],
      confirmed: json["confirmed"],
      recovered: json["recovered"],
      newConfirmed: json["new_confirmed"],
      newRecovered: json["new_recovered"],
      newDeaths: json["new_deaths"],
    );
  }
}

Future<Todo> fetchCovidWorld(http.Client client) async {
  final response = await client.get("https://corona-api.com/timeline");
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    final todos = mapResponse["data"].cast<Map<String, dynamic>>();
    final listTodos = await todos.map<Todo>((json) {
      return Todo.fromJson(json);
    }).toList();
    return listTodos[0];
  } else {
    throw Exception("UNAUTHORIZED");
  }
}

Future<Todo> fetchCovidByCountry(http.Client client, url) async {
  final response = await client.get(url);
  Map<String, dynamic> mapResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    final todos = mapResponse["data"]["timeline"].cast<Map<String, dynamic>>();
    final listTodos = await todos.map<Todo>((json) {
      return Todo.fromJson(json);
    }).toList();
    return listTodos[0];
  } else {
    throw Exception("UNAUTHORIZED");
  }
}
