// import 'package:flutter/material.dart';
// import 'screens/auth/login_page.dart'; // import the login page

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Community Replenishment',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const LoginPage(), // set login as home
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/signup_page.dart';
import 'screens/main_screen.dart'; // This is your tabbed screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Replenishment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/main': (context) =>
            const MainScreen(), // This is the screen with bottom tabs
      },
    );
  }
}
