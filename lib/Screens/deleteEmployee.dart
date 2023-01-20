import 'package:flutter/material.dart';
import 'getEmployees.dart';

class deleteEmployee extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return deleteEmployeeState();
  }
}

class deleteEmployeeState extends State<deleteEmployee> {
  @override
  Widget build(BuildContext context) {
    return getemployees();
  }
}
