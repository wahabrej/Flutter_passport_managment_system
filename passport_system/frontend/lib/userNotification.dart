import 'package:flutter/material.dart';
import 'package:frontend/userdashboard.dart';

class UserNotification extends StatefulWidget {
  UserNotification({Key? key}) : super(key: key);

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(Userdashboard(userId: userId)); // Go back to the previous screen
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notification',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('images/wahab.png'),
            ),
          ],
        ),
        backgroundColor: Colors.white, // Optional: change the background color
        elevation: 0, // Optional: remove the shadow below the AppBar
      ),
      body: Center(
        child: Text('Your notifications will appear here.'),
      ),
    );
  }
}
