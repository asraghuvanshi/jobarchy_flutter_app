import 'package:flutter/material.dart';

class AppliedJobsTab extends StatelessWidget {
  const AppliedJobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Posts')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Job Title ${index + 1}'),
              subtitle: Text('Company Name • Location'),
              trailing: IconButton(
                icon: Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
              onTap: () {
              },
            ),
          );
        },
      ),
    );
  }
}
