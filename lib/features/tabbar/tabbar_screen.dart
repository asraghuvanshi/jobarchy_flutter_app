import 'package:flutter/material.dart';
import 'package:jobarchy_flutter_app/core/utils/colors.dart';
import 'package:jobarchy_flutter_app/features/tabbar/home_tab.dart';
import 'package:jobarchy_flutter_app/features/tabbar/jobs_tab.dart';
import 'package:jobarchy_flutter_app/features/tabbar/message_tab.dart';
import 'package:jobarchy_flutter_app/features/tabbar/post_screen.dart';
import 'package:jobarchy_flutter_app/features/tabbar/profile.dart';

class TabbarScreen extends StatefulWidget {
  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Gradient icon with larger size
  Widget _buildGradientIcon(IconData icon) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => AppColors.appGradient.createShader(bounds),
      child: Icon(
        icon,
        color: Colors.white,
        size: 30, 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
           HomeTab(),
          const AppliedJobsTab(),
          PostJobTab(),
          const MessagesTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF1B2735),
        child: TabBar(
          controller: _tabController,
          labelColor: AppColors.orangeColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
          tabs: [
            Tab(icon: _buildGradientIcon(Icons.work), text: 'Jobs'),
            Tab(icon: _buildGradientIcon(Icons.check_circle), text: 'Applied'),
            Tab(icon: _buildGradientIcon(Icons.add_circle), text: 'Post'),
            Tab(icon: _buildGradientIcon(Icons.message), text: 'Messages'),
            Tab(icon: _buildGradientIcon(Icons.person), text: 'Profile'),
          ],
        ),
      ),
    );
  }
}
