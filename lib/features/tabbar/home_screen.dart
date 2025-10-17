import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLoading = true;
  List<String> jobPosts = [];
  List<String> appliedJobs = [];

  final List<Widget> _pages = [
    HomeTab(),
    AppliedJobsTab(),
    const PostJobTab(),
    const MessagesTab(),
    const ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    setState(() {
      jobPosts = List.generate(10, (index) => 'Job Post ${index + 1}');
      appliedJobs = List.generate(5, (index) => 'Applied Job ${index + 1}');
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 6,
        onPressed: () => _onItemTapped(2),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.black, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.add, size: 50, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.transparent,
        elevation: 8,
        child: Container(
          height: 60,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 70, 70, 70), Color(0xFF090A0F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, "Home", 0),
              _buildNavItem(Icons.work_outline, "Applied", 1),
              const SizedBox(width: 40), // Gap for FAB
              _buildNavItem(Icons.message_outlined, "Messages", 3),
              _buildNavItem(Icons.person_outline, "Profile", 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) => const LinearGradient(
                colors: [Colors.black, Colors.deepOrange, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white, // Base color for gradient effect
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.orange : Colors.grey[300],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tab Content Widgets
class HomeTab extends StatelessWidget {
  final List<String> jobPosts;

  const HomeTab({super.key, this.jobPosts = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobPosts.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(jobPosts[index], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Job description for ${jobPosts[index]}'),
            leading: const Icon(Icons.work, color: Colors.orange),
          ),
        );
      },
    );
  }
}

class AppliedJobsTab extends StatelessWidget {
  final List<String> appliedJobs;

  const AppliedJobsTab({super.key, this.appliedJobs = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appliedJobs.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(appliedJobs[index], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Application status for ${appliedJobs[index]}'),
            leading: const Icon(Icons.check_circle, color: Colors.orange),
          ),
        );
      },
    );
  }
}

class PostJobTab extends StatelessWidget {
  const PostJobTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Post a Job',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
    );
  }
}

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Messages',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
    );
  }
}