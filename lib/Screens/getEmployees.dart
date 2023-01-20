import 'dart:convert';

import 'package:employee_management/Screens/deleteEmployee.dart';
import 'package:employee_management/Screens/updateEmployees.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'employeeDrawer.dart';
import '../Model/EmployeeModel.dart';
import 'package:http/http.dart' as http;

class getemployees extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return getAllEmployeesState();
  }
}

class getAllEmployeesState extends State<getemployees> {
  List<EmployeeModel> employees = [];

  // Future<List<EmployeeModel>> getEmployees() async {
  //   List<EmployeeModel> employees = [
  //     EmployeeModel(firstName: 'a', lastName: 'b', id: 1),
  //     EmployeeModel(firstName: 'c', lastName: 'd', id: 2)
  //   ];

  //   return employees;
  // }

  Future<List<EmployeeModel>> getEmployees() async {
    var data =
        await http.get(Uri.parse('http://localhost:8080/getallemployees'));
    var jsonData = json.decode(data.body);

    List<EmployeeModel> employees = [];
    for (var e in jsonData) {
      EmployeeModel employee = EmployeeModel();
      employee.id = e["id"];
      employee.firstName = e["firstName"];
      employee.lastName = e["lastName"];
      employees.add(employee);
    }

    return employees;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Employees Details"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => employeeDrawer()));
            },
          ),
        ),
        body: Container(
          child: FutureBuilder(
            future: getEmployees(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(child: Center(child: Icon(Icons.error)));
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: const Text('ID  First Name  Last Name'),
                        subtitle: Text(
                            '${snapshot.data[index].id}    ${snapshot.data[index].firstName}    ${snapshot.data[index].lastName}'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(snapshot.data[index])));
                        });
                  });
            },
          ),
        ));
  }
}

class DetailPage extends StatelessWidget {
  EmployeeModel employee;
  DetailPage(this.employee);

  deleteEmployee1(EmployeeModel employee) async {
    final url = Uri.parse('http://localhost:8080/deleteemployee');
    final request = http.Request("DELETE", url);
    request.headers
        .addAll(<String, String>{"Content-type": "application/json"});
    request.body = jsonEncode(employee);
    final response = await request.send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(employee.firstName as String), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => employeeDrawer()));
          },
        )
      ]),
      body: Container(
        child: Text(
            'FirstName: ${employee.firstName}   LastName: ${employee.lastName}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          deleteEmployee1(employee);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => deleteEmployee()));
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.delete),
      ),
    );
  }
}
