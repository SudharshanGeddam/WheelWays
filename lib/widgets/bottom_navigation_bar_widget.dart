import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wheelways/models/user_provider.dart';
import 'package:wheelways/pages/admin_home.dart';
import 'package:wheelways/pages/employee_home.dart';
import 'package:wheelways/pages/security_home.dart';
import 'package:wheelways/pages/profile_page.dart';
import 'package:wheelways/pages/settings_page.dart';

class BottomNavigationBarWidget extends ConsumerStatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  ConsumerState<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState
    extends ConsumerState<BottomNavigationBarWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userRole = user?.role?.toLowerCase() ?? '';
    
    Widget homeScreen;
    if (userRole.isEmpty) {
      homeScreen = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Loading Home... 😊'),
          ],
        ),
      );
    } else {
      switch (userRole) {
        case 'admin':
          homeScreen = const AdminHome();
          break;
        case 'employee':
          homeScreen = const EmployeeHome();
          break;
        case 'security':
          homeScreen = const SecurityHome();
          break;
        default:
          homeScreen = Center(
            child: Text('Unknown role: $userRole'),
          );
      }
    }

    final List<Widget> screens = [
      homeScreen,
      const ProfilePage(),
      const SettingsPage(),
    ];

    final List<String> titles = ["WheelWays", "Profile", "Settings"];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_currentIndex])),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
