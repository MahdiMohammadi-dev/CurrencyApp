import 'package:app1/Currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

void main() => runApp(const Myapp());

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', ''), //Farsi
      ],
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future GetRespones(BuildContext context) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";

    var value = await http.get(Uri.parse(url));
    if (currency.isEmpty) {
      _snackedbar(context, "دیتاها لود شدند...!");
      if (value.statusCode == 200) {
        List jsonList = convert.jsonDecode(value.body);
        if (jsonList.length > 0) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              currency.add(Currency(
                id: jsonList[i]["id"],
                title: jsonList[i]["title"],
                price: jsonList[i]["price"],
                changes: jsonList[i]["changes"],
                status: jsonList[i]["status"],
              ));
            });
          }
        }
      }
    }
    return value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetRespones(context);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 4, actions: [
        Image.asset("assets/images/icon.png"),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "نرخ آنلاین ارز ",
            style: TextStyle(
                fontFamily: 'iransans',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17.0),
          ),
        ),
        Expanded(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Image.asset("assets/images/menu.png")))),
        SizedBox(
          width: 6.0,
        ),
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/q.png"),
                SizedBox(width: 10.0),
                Text(
                  "نرخ ارز آزاد چیست؟",
                  style: TextStyle(
                    fontFamily: 'iransans',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              " نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'regular',
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "نام ارز",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'regular'),
                      ),
                      Text(
                        "قیمت",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'regular'),
                      ),
                      Text(
                        "تغییر",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'regular'),
                      ),
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
              child: Container(
                width: double.infinity,
                height: height * .4,
                child: FutureBuilderMethod(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 226, 228, 226),
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                        child: TextButton.icon(
                            onPressed: () {
                              currency.clear();
                              FutureBuilderMethod(context);
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            label: Text(
                              "بروزرسانی",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'regular',
                                  color: Colors.white),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        getfarsinumber(
                          "آخرین بروزرسانی: " + gettime(),
                        ),
                        style: TextStyle(
                          fontFamily: 'regular',
                          fontSize: 9.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> FutureBuilderMethod(BuildContext context) {
    return FutureBuilder(
      future: GetRespones(context),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext cotext, int position) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MyItem(position, currency),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  if (index % 9 == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Add(),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  String gettime() {
    DateTime dateTime = DateTime.now();
    return DateFormat('kk:mm').format(dateTime);
  }

  _snackedbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            message,
            style: TextStyle(fontFamily: 'iransans'),
          )),
    );
  }
}

class MyItem extends StatelessWidget {
  int position;
  List<Currency> currency;
  MyItem(this.position, this.currency, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          borderRadius: (BorderRadius.circular(1000)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              color: Colors.black,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currency[position].title!,
              style: TextStyle(fontFamily: 'iransans', color: Colors.black),
            ),
            Text(
              getfarsinumber(currency[position].price.toString()),
              style: TextStyle(fontFamily: 'regular', color: Colors.black),
            ),
            Text(
              getfarsinumber(currency[position].changes.toString()),
              style: TextStyle(
                  fontFamily: 'iransans',
                  color: currency[position].status == "n"
                      ? Colors.red
                      : Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class Add extends StatelessWidget {
  const Add({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          borderRadius: (BorderRadius.circular(1000)),
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              color: Colors.black,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "تبلیغات",
              style: TextStyle(fontFamily: 'iransans', color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

String getfarsinumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });

  return number;
}
