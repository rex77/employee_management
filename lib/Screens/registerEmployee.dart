import 'dart:convert';
import 'dart:ui';
import '../Model/EmployeeModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class registerEmployee extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return registerEmployeeState();
  }
}

Future<EmployeeModel> registerEmployees(
    String firstName, String lastName, BuildContext context) async {
  Uri url = Uri.parse("http://localhost:8080/addemployee");
  var response = await http.post(url,
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "firstName": firstName,
        "lastName": lastName,
      }));

  String responseString = response.body;
  if (response.statusCode == 200) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
              title: 'Backend Response', content: response.body);
        });
  }

  return employeeModelJson(responseString);
}

class registerEmployeeState extends State<registerEmployee> {
  final minimunPadding = 5.0;

  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.subtitle2;
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Employee"),
      ),
      body: Form(
        child: Padding(
          padding: EdgeInsets.all(minimunPadding * 2),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: minimunPadding, bottom: minimunPadding),
                child: TextFormField(
                    style: textStyle,
                    controller: firstController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter your name';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter Your First Name',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)))),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: minimunPadding, bottom: minimunPadding),
                  child: TextFormField(
                    style: textStyle,
                    controller: lastController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter your name';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      hintText: 'Enter Your Last Name',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  )),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () async {
                  String firstName = firstController.text;
                  String lastName = lastController.text;
                  registerEmployees(firstName, lastName, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialog({
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          this.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: this.actions,
        content: Text(
          this.content,
          style: Theme.of(context).textTheme.bodyText1,
        ));
  }
}
