import 'package:covid19_map/api.dart';
import 'package:covid19_map/constant.dart';
import 'package:covid19_map/widgets/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:simple_moment/simple_moment.dart';
import 'package:covid19_map/map.dart';

class HeaderView extends StatelessWidget {
  final String date;
  final bool isCountry;
  final String country;
  HeaderView({Key key, this.date, this.isCountry, this.country})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (isCountry) {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Các trường hợp",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF303030),
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  date,
                  style: TextStyle(
                    color: Color(0xFF3382CC),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text(
                  country,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class ViewTodo extends StatelessWidget {
  final Todo todo;
  final bool isCountry;
  final String country;
  ViewTodo({Key key, this.todo, this.isCountry, this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Moment rawDate = Moment.parse(todo.updatedAt);
    var date = rawDate.format("dd-MM-yyyy HH:mm");
    return Container(
      child: Column(
        children: <Widget>[
          HeaderView(date: date, isCountry: isCountry, country: country),
          Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 30,
                    color: kShadowColor,
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Counter(
                        color: kInfectedColor,
                        number: todo.confirmed,
                        newNumber: todo.newConfirmed,
                        title: "Nhiễm bệnh",
                      ),
                      Counter(
                        color: kDeathColor,
                        number: todo.deaths,
                        newNumber: todo.newDeaths,
                        title: "Tử vong",
                      ),
                      Counter(
                        color: kRecovercolor,
                        number: todo.recovered,
                        newNumber: todo.newRecovered,
                        title: "Bình phục",
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String country = "Việt Nam";
  String code = "vn";
  var listCountry = ['Việt Nam', 'Hoa Kì', 'Hàn Quốc'];
  var listCountryCode = ["vn", "us", "kr"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin bệnh dịch'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                      value: country,
                      items: listCountry
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          this.country = value;
                          this.code =
                              listCountryCode[listCountry.indexOf(value)];
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: fetchCovidByCountry(http.Client(),
                        "https://corona-api.com/countries/" + code),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      if (snapshot.hasData) {
                        return ViewTodo(
                            todo: snapshot.data,
                            isCountry: true,
                            country: country);
                        // return Container();
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Text(
                        "Thế giới",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  FutureBuilder(
                    future: fetchCovidWorld(http.Client()),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      return snapshot.hasData
                          ? ViewTodo(todo: snapshot.data, isCountry: false)
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
        },
        child: Icon(Icons.map),
        backgroundColor: Colors.red[400],
      ),
    );
  }
}
