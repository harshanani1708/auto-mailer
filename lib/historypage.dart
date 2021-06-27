import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipr_hackathon/historytile.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('history-mails').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false || snapshot.data!.docs.length == 0)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "No Information :(",
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            );
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Container(
                    child: HistoryTile(
                      totxt: snapshot.data!.docs[index]["to"],
                      subtxt: snapshot.data!.docs[index]["subject"],
                      date: snapshot.data!.docs[index]["mailDate"],
                      time: snapshot.data!.docs[index]["mailTime"],
                    ),
                  ),
                );
              });
        });
  }
}
