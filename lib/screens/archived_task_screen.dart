import 'package:flutter/material.dart';

class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Archived Task ',
        style: TextStyle(
            color: Colors.black,
            fontSize: 24
        ),
      ),
    );
  }
}
