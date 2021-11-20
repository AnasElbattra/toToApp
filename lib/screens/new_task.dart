import 'package:flutter/material.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'New Task ',
        style: TextStyle(
          color: Colors.black,
            fontSize: 24
        ),
      ),
    );
  }
}
