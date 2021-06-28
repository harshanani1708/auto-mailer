import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipr_hackathon/formPage.dart';
import 'package:flutter/material.dart';
import 'package:mailer2/mailer.dart';
import 'package:timer_builder/timer_builder.dart';

class FutureMailsHomePage extends StatefulWidget {
  String email, password;
  FutureMailsHomePage({required this.email, required this.password});

  @override
  _FutureMailsHomePageState createState() => _FutureMailsHomePageState();
}

class _FutureMailsHomePageState extends State<FutureMailsHomePage> {
  @override
  void initState() {
    super.initState();
  }

  bool loading = false;
  sendEmail(
      to, bccList, subject, mailDate, mailTime, timespan, mailBody) async {
     String username = widget.email;
     String password = widget.password;

    var options = new GmailSmtpOptions()
      ..username = username
      ..password = password;

    var emailTransport = new SmtpTransport(options);
    var moreUsers = bccList.split(",").toList();

    var envelope = new Envelope()
      ..from = username
      ..recipients.add(to)
      ..bccRecipients.addAll(moreUsers)
      ..subject = subject
      ..text = mailBody;

    emailTransport
        .send(envelope)
        .then((envelope) => print('Email sent!'))
        .catchError((e) => print('Error occurred: $e'));

    deleteMail(mailDate + " " + mailTime, to, bccList, subject, mailDate,
        mailTime, timespan, mailBody);
  }

  deleteMail(
      id, to, bccList, subject, mailDate, mailTime, timespan, mailBody) async {
    print(id);
    String t = to;
    String bc = bccList;
    String sub = subject;
    String md = mailDate;
    String mt = mailTime;
    String ts = timespan;
    String mb = mailBody;
    await FirebaseFirestore.instance.collection("mails").doc(id).delete();

    addToHistoryMail(t, bc, sub, md, mt, ts, mb);
  }

  addToHistoryMail(
      to, bccList, subject, mailDate, mailTime, timespan, mailBody) async {
    //print(mailDate + " " + mailTime);
    await FirebaseFirestore.instance
        .collection("history-mails")
        .doc(mailDate + " " + mailTime)
        .set({
      "to": to,
      "bccList": bccList,
      "subject": subject,
      "mailDate": mailDate,
      "mailTime": mailTime,
      "timespan": timespan,
      "mailBody": mailBody,
    });

    //print("success");
  }

  addNewMail(
      to, bccList, subject, mailDate, mailTime, timespan, mailBody) async {
    await FirebaseFirestore.instance
        .collection("mails")
        .doc(mailDate + " " + mailTime)
        .set({
      "to": to,
      "bccList": bccList,
      "subject": subject,
      "mailDate": mailDate,
      "mailTime": mailTime,
      "timespan": timespan,
      "mailBody": mailBody,
    });

    //print("success");
  }

  Widget build(BuildContext context) {
    var remaining;
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("mails").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false ||
                      snapshot.data!.docs.length == 0)
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Yet To be Mailed ! ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 730.0,
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            // itemCount: 1,
                            itemBuilder: (context, index) {
                              String to = snapshot.data!.docs[index]["to"];
                              String bccList =
                                  snapshot.data!.docs[index]["bccList"];
                              String subject =
                                  snapshot.data!.docs[index]["subject"];
                              String mailDate =
                                  snapshot.data!.docs[index]["mailDate"];
                              String mailTime =
                                  snapshot.data!.docs[index]["mailTime"];
                              String mailBody =
                                  snapshot.data!.docs[index]["mailBody"];
                              String timespan =
                                  snapshot.data!.docs[index]["timespan"];
                              // String to = "harshadinu21@gmail.com";
                              // String bccList =
                              //     "18h61a0520@cvsr.ac.in,18h61a0521@cvsr.ac.in";
                              // String subject = "Demo";
                              // String mailDate = "2021-06-27";
                              // String mailTime = "00:05";
                              // String mailBody = "Hii Ra";
                              // String timespan = "20 sec";
                              var dur;
                              var y = int.parse(mailDate.substring(0, 4));

                              var m = int.parse(mailDate.substring(5, 7));

                              var d = int.parse(mailDate.substring(8, 10));

                              var hrs = int.parse(mailTime.substring(0, 2));

                              var ms = int.parse(mailTime.substring(3, 5));

                              var secs = int.parse(mailTime.substring(6, 8));

                              var timer = DateTime(y, m, d, hrs, ms, secs);
                              if (timespan == '30 sec') {
                                dur = Duration(seconds: 30);
                              } else if (timespan == '20 sec') {
                                dur = Duration(seconds: 20);
                              } else if (timespan == 'Weekly') {
                                dur = Duration(days: 7);
                              } else if (timespan == 'monthly') {
                                dur = Duration(days: 30);
                              } else {
                                dur = Duration(days: 365);
                              }
                              //print(dur);
                              //print(timer);
                              return TimerBuilder.scheduled([timer],
                                  builder: (context) {
                                var now = DateTime.now();
                                var reached = now.compareTo(timer) >= 0;

                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200.0,
                                  // color: Colors.green,
                                  child: Center(
                                    child: !reached
                                        ? TimerBuilder.periodic(
                                            Duration(seconds: 1),
                                            alignment: Duration.zero,
                                            builder: (context) {
                                            var now = DateTime.now();
                                            remaining = timer.difference(now);
                                            // print(remaining.toString().substring(1, 7));
                                            // print(Duration.zero.toString().substring(1, 7));
                                            print(remaining);

                                            if (remaining
                                                    .toString()
                                                    .substring(0, 8) ==
                                                Duration.zero
                                                    .toString()
                                                    .substring(0, 8)) {
                                              sendEmail(
                                                  to,
                                                  bccList,
                                                  subject,
                                                  mailDate,
                                                  mailTime,
                                                  timespan,
                                                  mailBody);

                                              timer = DateTime.now().add(dur);

                                              String myFormat(DateTime time) {
                                                // return the "yyyy-MM-dd HH:mm:ss" format
                                                String year =
                                                    time.year.toString();

                                                String month =
                                                    time.month.toString();
                                                // convert 0, 1, 2, 3, ..., 9 to 00, 01, 02, 03, ..., 09
                                                if (month.length < 2) {
                                                  month = "0" + month;
                                                }

                                                String day =
                                                    time.day.toString();
                                                // convert 0, 1, 2, 3, ..., 9 to 00, 01, 02, 03, ..., 09
                                                if (day.length < 2) {
                                                  day = "0" + day;
                                                }

                                                String hour =
                                                    time.hour.toString();
                                                // convert 0, 1, 2, 3, ..., 9 to 00, 01, 02, 03, ..., 09
                                                if (hour.length < 2) {
                                                  hour = "0" + hour;
                                                }

                                                String minute =
                                                    time.minute.toString();
                                                // convert 0, 1, 2, 3, ..., 9 to 00, 01, 02, 03, ..., 09
                                                if (minute.length < 2) {
                                                  minute = "0" + minute;
                                                }

                                                String second =
                                                    time.second.toString();
                                                // convert 0, 1, 2, 3, ..., 9 to 00, 01, 02, 03, ..., 09
                                                if (second.length < 2) {
                                                  second = "0" + second;
                                                }

                                                return "$year-$month-$day $hour:$minute:$second";
                                              }

                                              String time = myFormat(timer);
                                              //print(time);
                                              var l = time.split(" ");
                                              //print(l);
                                              mailDate = l[0];
                                              mailTime = l[1];
                                              //print(mailDate);
                                              // print(mailTime);
                                              addNewMail(
                                                  to,
                                                  bccList,
                                                  subject,
                                                  mailDate,
                                                  mailTime,
                                                  timespan,
                                                  mailBody);
                                            }
                                            return Padding(
                                              padding: EdgeInsets.all(20.0),
                                              child: Container(
                                                height: 150.0,
                                                width: 420.0,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      child: Text(
                                                        to,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      child: Text(
                                                        subject,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text(
                                                          mailDate,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          mailTime,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                25.0)),
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
                                          })
                                        : Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Container(
                                              height: 150.0,
                                              width: 420.0,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(10),
                                                    margin: EdgeInsets.all(10),
                                                    child: Text(
                                                      to,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(10),
                                                    margin: EdgeInsets.all(10),
                                                    child: Text(
                                                      subject,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        mailDate,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        mailTime,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              25.0)),
                                                  color: Color(0xff5a63ad),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(0, 15),
                                                      blurRadius: 27,
                                                      color: Colors.black38,
                                                    )
                                                  ]),
                                            ),
                                          ),
                                  ),
                                );
                              });
                            }),
                      ),
                    ],
                  );
                })),
      ),
      floatingActionButton: Container(
        width: 80.0,
        height: 80.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FormPage()));
          },
          backgroundColor: Colors.amber,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 50.0,
          ),
          elevation: 8,
        ),
      ),
    );
  }
}
