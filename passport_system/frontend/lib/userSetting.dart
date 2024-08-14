import 'package:flutter/material.dart';

class UserSetting extends StatelessWidget {
  const UserSetting({Key? key})
      : super(key: key); // Use Key? key with nullable syntax.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use Scaffold to provide a basic structure like AppBar, Body, etc.
      appBar: AppBar(
        title: Text('Apply'), // Add a title to the AppBar if needed.
      ),
      body: Center(
        child: Text('Apply Page'), // Example content.
      ),
    );
  }
}
