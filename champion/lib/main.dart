// import 'package:flutter/material.dart';
// import 'screens/login_page.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// // Replace with your Supabase URL and anon key
// const supabaseUrl = 'https://dcjdlufuwoxtoliwnedy.supabase.co';
// const supabaseAnonKey =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjamRsdWZ1d294dG9saXduZWR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA5MjQ2MjAsImV4cCI6MjA2NjUwMDYyMH0.cJg6_pJu0U37APHhtX9lks5h69ZlBdRGbfS3Q5FFzcU';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
// //   runApp(MyApp());
// // }

// Future<void> main() async {
//   // 1) Let Flutter bind to the engine so we can await async work
//   WidgetsFlutterBinding.ensureInitialized();

//   // 2) Initialize Supabase exactly once, before runApp()
//   await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

//   // 3) Now it’s safe to build widgets that call Supabase.instance
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Demo',
//       theme: ThemeData(primarySwatch: Colors.purple),
//       home: LoginPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_page.dart';

const supabaseUrl = 'https://dcjdlufuwoxtoliwnedy.supabase.co';
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjamRsdWZ1d294dG9saXduZWR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA5MjQ2MjAsImV4cCI6MjA2NjUwMDYyMH0.cJg6_pJu0U37APHhtX9lks5h69ZlBdRGbfS3Q5FFzcU';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Champion App',
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
