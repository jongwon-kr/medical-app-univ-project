import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicalapp/image/image_provider.dart' as MyAppImageProvider;
import 'package:medicalapp/widget/navigation_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: ChangeNotifierProvider<MyAppImageProvider.ImageProvider>(
        // 별칭을 사용
        create: (context) => MyAppImageProvider.ImageProvider(), // 별칭을 사용
        child: const NavigationScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


/*
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medicalapp/screens/login/login_screen.dart';
import 'package:medicalapp/widget/navigation_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginScreen(),
      },
      theme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const NavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
*/