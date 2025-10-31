import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 32),
            
            // Profile Options
            _buildProfileOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal[100],
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dr. Sarah Smith',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Licensed Psychologist',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '8 years of experience',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'icon': Icons.edit,
        'title': 'Edit Profile',
        'subtitle': 'Update your personal information',
      },
      {
        'icon': Icons.settings,
        'title': 'Settings',
        'subtitle': 'App preferences and notifications',
      },
      {
        'icon': Icons.security,
        'title': 'Privacy & Security',
        'subtitle': 'Manage your account security',
      },
      {
        'icon': Icons.help,
        'title': 'Help & Support',
        'subtitle': 'Get help and contact support',
      },
      {
        'icon': Icons.info,
        'title': 'About',
        'subtitle': 'App version and information',
      },
      {
        'icon': Icons.logout,
        'title': 'Logout',
        'subtitle': 'Sign out of your account',
        'color': Colors.red,
      },
    ];

    return Card(
      elevation: 2,
      child: Column(
        children: options.map((option) {
          return ListTile(
            leading: Icon(
              option['icon'] as IconData,
              color: option.containsKey('color') 
                  ? option['color'] as Color 
                  : Colors.teal[700],
            ),
            title: Text(
              option['title'] as String,
              style: TextStyle(
                color: option.containsKey('color') 
                    ? option['color'] as Color 
                    : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(option['subtitle'] as String),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Handle option tap without using print
              _handleOptionTap(context, option['title'] as String);
            },
          );
        }).toList(),
      ),
    );
  }

  void _handleOptionTap(BuildContext context, String optionTitle) {
    // Handle different option taps
    switch (optionTitle) {
      case 'Edit Profile':
        // TODO: Navigate to edit profile screen
        break;
      case 'Settings':
        // TODO: Navigate to settings screen
        break;
      case 'Privacy & Security':
        // TODO: Navigate to privacy screen
        break;
      case 'Help & Support':
        // TODO: Navigate to help screen
        break;
      case 'About':
        // TODO: Navigate to about screen
        break;
      case 'Logout':
        _showLogoutDialog(context);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement logout logic
                Navigator.of(context).pop();
                // Navigate to login screen
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}