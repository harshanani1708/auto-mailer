import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  late String mailDate, mailTime, mailBody, timespan;
  var selected;
  String to = "";
  String bccList = "";
  String subject = "";
  bool loading = false;

  dynamic selectTimeSpan(String timespan) {
    if (timespan == 'CSE') {
      return timespan;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //print(DateTime.now());

    super.initState();
  }

  void addMail(
      to, bccList, subject, mailDate, mailTime, timespan, mailBody) async {
    setState(() {
      loading = true;
    });
    await FirebaseFirestore.instance
        .collection("mails")
        .doc(mailDate.toString() + ":00")
        .set({
      "to": to,
      "bccList": bccList,
      "subject": subject,
      "mailDate": mailDate.toString().substring(0, 10),
      "mailTime": mailTime.toString().substring(11, 16) + ":00",
      "timespan": timespan,
      "mailBody": mailBody,
    });

    setState(() {
      loading = false;
    });

    //print("success");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading == true
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("Let us know the Mail Details!",
                          style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 30.0,
                            color: Color(0xff5a63ad),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: Color(0xff5a63ad),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 15),
                              blurRadius: 27,
                              color: Colors.black38,
                            )
                          ]),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                cursorColor: Colors.white60,
                                decoration: InputDecoration(
                                  labelText: 'To:',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  hoverColor: Colors.white,
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                                maxLength: 30,
                                maxLines: 1,
                                onChanged: (value) {
                                  setState(() {
                                    to = value;
                                  });
                                },
                                validator: (val) {
                                  if (val == "" || val == null) {
                                    return 'Event Name is Required';
                                  }
                                  //evename = val.trim();
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'bcc',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  hoverColor: Colors.white,
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                                maxLines: 2,
                                maxLength: 100,
                                onChanged: (value) {
                                  setState(() {
                                    bccList = value;
                                  });
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Subject:',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  hoverColor: Colors.white,
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                                maxLines: 2,
                                maxLength: 100,
                                onChanged: (value) {
                                  setState(() {
                                    subject = value;
                                  });
                                },
                                validator: (val) {
                                  if (val == "" || val == null) {
                                    return 'Description is Required.';
                                  }
                                  //evedesc = val.trim();
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 15.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0)),
                                      ),
                                      child: DateTimePicker(
                                        type:
                                            DateTimePickerType.dateTimeSeparate,
                                        dateMask: 'dd.MM.yyyy',
                                        style: TextStyle(
                                            decorationColor: Colors.white),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                        icon: Icon(
                                          Icons.event,
                                          color: Color(0xff5a63ad),
                                        ),
                                        dateLabelText: 'Date',
                                        timeFieldWidth:
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        timeLabelText: "Time (24-Hr)",
                                        onChanged: (val) =>
                                            mailDate = val.trim(),
                                        validator: (val) {
                                          mailTime = val.toString().trim();
                                          if (mailDate
                                                  .trim()
                                                  .substring(0, 10)
                                                  .compareTo(DateTime.now()
                                                      .toString()
                                                      .substring(0, 10)) <
                                              0) {
                                            return 'Incorrect Date';
                                          }

                                          return null;
                                        },
                                        onSaved: (val) => val = '',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      //color: Colors.white,
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0))),
                                      child: DropdownButtonFormField(
                                        items: [
                                          '20 sec',
                                          '30 sec',
                                          'Weekly',
                                          'monthly',
                                          'yearly',
                                        ]
                                            .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(
                                                  '$e',
                                                  style: TextStyle(
                                                      color: Color(0xff5a63ad)),
                                                )))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            timespan = value.toString().trim();
                                          });
                                        },
                                        validator: (val) {
                                          if (val == null || val == '') {
                                            return 'Time Span Is Required';
                                          }
                                          timespan = val.toString().trim();
                                          return null;
                                        },
                                        hint: Text('Select TimeSpan',
                                            style: TextStyle(
                                                color: Color(0xff5a63ad))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Body:',
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        focusColor: Colors.white,
                                        hoverColor: Colors.white,
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      ),
                                      maxLines: 1,
                                      //maxLength: 20,
                                      onChanged: (value) {
                                        setState(() {
                                          mailBody = value;
                                        });
                                      },
                                      validator: (val) {
                                        if (val == "" || val == null) {
                                          return 'Name Is Required';
                                        }
                                        mailBody = val.trim();
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addMail(to, bccList, subject, mailDate, mailTime,
                              timespan, mailBody);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: MediaQuery.of(context).size.width * 0.5,
                        margin: EdgeInsets.only(top: 10.0, bottom: 30.0),
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            gradient: new LinearGradient(colors: [
                              Color.fromARGB(255, 255, 136, 34),
                              Color.fromARGB(255, 255, 177, 41)
                            ]),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                offset: Offset(0, 15),
                                blurRadius: 27,
                              )
                            ]),
                        child: Text('Add Mail'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
