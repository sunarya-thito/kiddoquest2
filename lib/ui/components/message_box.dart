import 'package:flutter/material.dart';
import 'package:kiddoquest2/assets/theme.dart';

class MessageBox extends StatelessWidget {
  final String message;

  const MessageBox(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: colorStrongYellow,
          border: Border.all(
            color: Colors.black,
            width: 5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 10),
              blurRadius: 0,
            ),
          ]),
      padding: EdgeInsets.all(32),
      child: Text(message),
    );
  }
}
