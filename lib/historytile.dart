import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class HistoryTile extends StatelessWidget {
  final String totxt, subtxt, date, time;

  const HistoryTile(
      {Key? key,
      required this.totxt,
      required this.subtxt,
      required this.date,
      required this.time})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        height: 150.0,
        width: 420.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Text(
                totxt,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.white,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Text(
                subtxt,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  date,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            color: Color(0xff5a63ad),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 15),
                blurRadius: 27,
                color: Colors.black38,
              )
            ]),
      ),
    );
  }
}
