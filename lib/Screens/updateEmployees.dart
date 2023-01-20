import 'dart:convert';

import 'package:employee_management/Screens/employeeDrawer.dart';
import 'package:employee_management/Screens/registerEmployee.dart';
import 'package:flutter/material.dart';
import '../Model/EmployeeModel.dart';
import 'package:http/http.dart' as http;

class updateEmployee extends StatefulWidget {
  EmployeeModel employee;
  @override
  State<StatefulWidget> createState() {
    return updateEmployeeState(employee);
  }

  updateEmployee(this.employee);
}

Future<EmployeeModel> updateEmployees(
    EmployeeModel emp, BuildContext context) async {
  Uri Url = "http://localhost:8080/updateemployee" as Uri;
  var response = await http.post(Url,
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "firstName": emp.firstName as String,
        "lastName": emp.lastName as String,
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

class updateEmployeeState extends State<updateEmployee> {
  final minimunPadding = 5.0;
  EmployeeModel employee = EmployeeModel();
  TextEditingController employeeNumber;
  bool _isEnabled = false;
  TextEditingController firstController;
  TextEditingController lastController;
  late Future<List<EmployeeModel>> employees;

  updateEmployeeState(this.employee)
      : employeeNumber = TextEditingController(text: employee.id.toString()),
        firstController = TextEditingController(text: employee.firstName),
        lastController = TextEditingController(text: employee.lastName);

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.subtitle2;

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Update Employee"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Container(
        child: Padding(
            padding: EdgeInsets.all(minimunPadding * 2),
            child: ListView(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: minimunPadding, bottom: minimunPadding),
                child: TextFormField(
                    style: textStyle,
                    controller: employeeNumber,
                    enabled: _isEnabled,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter your name';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Employee ID',
                        hintText: 'Enter Employee ID',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)))),
              ),
              ElevatedButton(
                  onPressed: () async {
                    String firstName = firstController.text;
                    String lastName = lastController.text;
                    EmployeeModel emp = new EmployeeModel();
                    emp.id = employee.id;
                    emp.firstName = firstController.text;
                    emp.lastName = lastController.text;
                    EmployeeModel employees =
                        await updateEmployees(emp, context);
                    setState(() {
                      employee = employees;
                    });
                  },
                  child: Text('Update Details'))
            ])),
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
