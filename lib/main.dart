import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wheelways/Screens/welcome_screen.dart';
import 'package:wheelways/firebase_options.dart';
import 'package:wheelways/themes/app_themes.dart';
import 'package:wheelways/widgets/bottom_navigation_bar_widget.dart';
import 'package:wheelways/pages/settings_page.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'WheelWays',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      themeMode: themeMode,
      home: (FirebaseAuth.instance.currentUser != null)
          ? const BottomNavigationBarWidget()
          : const WelcomeScreen(),
    );
  }
}