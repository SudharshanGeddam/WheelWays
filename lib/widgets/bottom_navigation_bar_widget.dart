import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wheelways/models/user_service.dart';
import 'package:wheelways/pages/admin_home.dart';
import 'package:wheelways/pages/employee_home.dart';
import 'package:wheelways/pages/profile_page.dart';
import 'package:wheelways/pages/security_home.dart';

import 'package:wheelways/pages/settings_page.dart';

class BottomNavigationBarWidget extends ConsumerStatefulWidget {
  const BottomNavigationBarWidget({super.key});

  static FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  ConsumerState<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState
    extends ConsumerState<BottomNavigationBarWidget> {
  int _currentIndex = 0;
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserRole();
  }

  Future<void> _fetchCurrentUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userModel = await UserService.getUserData(uid);
    if (!mounted) return;

    setState(() {
      _userRole = userModel?.role.toLowerCase() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userRole = _userRole;
    final Widget homeScreen = userRole.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 1000,
                  height: 100,
                  child: Lottie.asset('assets/lotties/Loading.json'),
                ),
                SizedBox(height: 12),
                Text('Loading Home... 😊'),
              ],
            ),
          )
        : (userRole == 'admin'
              ? const AdminHome()
              : userRole == 'employee'
              ? const EmployeeHome()
              : userRole == 'security'
              ? const SecurityHome()
              : Center(child: Text('Unknown role: $userRole')));

    final List<Widget> screens = [
      homeScreen,
      const ProfilePage(),
      const SettingsPage(),
    ];

    final List<String> titles = ["WheelWays", "Profile", "Settings"];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_currentIndex]), centerTitle: true),
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
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
