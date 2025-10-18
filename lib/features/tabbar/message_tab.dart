
import 'package:flutter/material.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('U${index + 1}')),
            title: Text('User ${index + 1}'),
            subtitle: Text('Last message...'),
            onTap: () {
             
            },
          );
        },
      ),
    );
  }
}
