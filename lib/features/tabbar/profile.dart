
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(radius: 50, child: Text('U')),
            SizedBox(height: 16),
            Text('User Name', style: TextStyle(fontSize: 24)),
            Text('user@example.com'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Edit profile
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}