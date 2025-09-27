import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheelways/Screens/login_screen.dart';

/// A simple ThemeMode provider. The app's root MaterialApp must listen to this
/// provider for the theme changes to take effect across the app.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('isDarkMode') ?? false;
    setState(() => _isDark = saved);
    ref.read(themeModeProvider.notifier).state = saved ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _setTheme(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', dark);
    setState(() => _isDark = dark);
    ref.read(themeModeProvider.notifier).state = dark ? ThemeMode.dark : ThemeMode.light;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Theme updated: ${dark ? "Dark" : "Light"}')),
    );
  }

  Future<void> _confirmSignOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user signed in')));
      return;
    }

    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sign out')),
        ],
      ),
    );

    if (shouldSignOut != true) return;

    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to sign out')));
    }
  }

  void _showLicenses() {
    showLicensePage(
      context: context,
      applicationName: 'WheelWays',
      applicationVersion: '1.0.0',
      applicationLegalese: '© WheelWays',
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return  ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(user?.email ?? 'Not signed in'),
            trailing: TextButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              onPressed: user == null ? null : _confirmSignOut,
            ),
          ),
          const Divider(),
          SwitchListTile(
            value: _isDark,
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle app theme'),
            secondary: const Icon(Icons.brightness_6),
            onChanged: (v) => _setTheme(v),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Licenses & About'),
            subtitle: const Text('View open source licenses and app info'),
            onTap: _showLicenses,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Clear local preferences'),
            subtitle: const Text('Reset saved theme preference'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('isDarkMode');
              await _setTheme(false);
            },
          ),
        ],

    );
  }
}