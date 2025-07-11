// import 'package:flutter/material.dart';

// class CreateAccountPage extends StatefulWidget {
//   @override
//   _CreateAccountPageState createState() => _CreateAccountPageState();
// }

// class _CreateAccountPageState extends State<CreateAccountPage> {
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _pinCodeController = TextEditingController();

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _pinCodeController.dispose();
//     super.dispose();
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300, width: 1),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           hintText: hintText,
//           prefixIcon: Icon(icon, color: Colors.grey),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8B5CF6),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(32.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // Create Account Header
//                 const Icon(
//                   Icons.person_add,
//                   size: 50,
//                   color: Color(0xFF8B5CF6),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Create Account',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 32),

//                 // Full Name Field
//                 _buildInputField(
//                   controller: _fullNameController,
//                   hintText: 'Full Name',
//                   icon: Icons.person_outline,
//                 ),

//                 // Email Field
//                 _buildInputField(
//                   controller: _emailController,
//                   hintText: 'Email',
//                   icon: Icons.email_outlined,
//                   keyboardType: TextInputType.emailAddress,
//                 ),

//                 // Phone Number Field
//                 _buildInputField(
//                   controller: _phoneController,
//                   hintText: 'Phone Number',
//                   icon: Icons.phone_outlined,
//                   keyboardType: TextInputType.phone,
//                 ),

//                 // Address Field
//                 _buildInputField(
//                   controller: _addressController,
//                   hintText: 'Address',
//                   icon: Icons.location_on_outlined,
//                   maxLines: 2,
//                 ),

//                 // Pin Code Field
//                 _buildInputField(
//                   controller: _pinCodeController,
//                   hintText: 'Pin Code',
//                   icon: Icons.pin_drop_outlined,
//                   keyboardType: TextInputType.number,
//                 ),

//                 // Google Map Frame
//                 Container(
//                   height: 200,
//                   width: double.infinity,
//                   margin: const EdgeInsets.only(bottom: 24),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF3F4F6),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade300, width: 1),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Stack(
//                       children: [
//                         // Placeholder for Google Map
//                         Container(
//                           width: double.infinity,
//                           height: double.infinity,
//                           color: Colors.grey.shade200,
//                           child: const Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.map_outlined,
//                                 size: 50,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Google Map',
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               Text(
//                                 'Tap to select location',
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Tap overlay
//                         Positioned.fill(
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: () {
//                                 // Handle map tap - you can integrate Google Maps here
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'Map tapped - integrate Google Maps here',
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Save Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Handle save logic here
//                       print('Full Name: ${_fullNameController.text}');
//                       print('Email: ${_emailController.text}');
//                       print('Phone: ${_phoneController.text}');
//                       print('Address: ${_addressController.text}');
//                       print('Pin Code: ${_pinCodeController.text}');

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Account created successfully!'),
//                         ),
//                       );

//                       // Navigate back to login page
//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF8B5CF6),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: const Text(
//                       'Save',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8B5CF6), // Purple background
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20.0),
//             child: Container(
//               width: double.infinity,
//               constraints: const BoxConstraints(maxWidth: 400),
//               padding: const EdgeInsets.all(32.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Welcome Champion Title
//                   const Text(
//                     'Welcome Champion',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 40),

//                   // Email Field
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F4F6),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                     ),
//                     child: TextField(
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: const InputDecoration(
//                         hintText: 'Email',
//                         prefixIcon: Icon(
//                           Icons.email_outlined,
//                           color: Colors.grey,
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Password Field
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F4F6),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                     ),
//                     child: TextField(
//                       controller: _passwordController,
//                       obscureText: !_isPasswordVisible,
//                       decoration: InputDecoration(
//                         hintText: 'Password',
//                         prefixIcon: const Icon(
//                           Icons.lock_outline,
//                           color: Colors.grey,
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible
//                                 ? Icons.visibility_outlined
//                                 : Icons.visibility_off_outlined,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPasswordVisible = !_isPasswordVisible;
//                             });
//                           },
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 32),

//                   // Login Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Handle login logic here
//                         print('Email: ${_emailController.text}');
//                         print('Password: ${_passwordController.text}');

//                         // You can add your login logic here
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Login button pressed!'),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF8B5CF6),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Login',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Icon(Icons.arrow_forward, size: 18),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // New Account Text
//                   GestureDetector(
//                     onTap: () {
//                       // Navigate to create account page
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CreateAccountPage(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'New account',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color(0xFF8B5CF6),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Main app to run the login page
// void main() {
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

// import 'package:flutter/material.dart';
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
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Champion App',
//       home: LoginPage(), // <- your login/create‑account flow
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class CreateAccountPage extends StatefulWidget {
//   @override
//   _CreateAccountPageState createState() => _CreateAccountPageState();
// }

// class _CreateAccountPageState extends State<CreateAccountPage> {
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _pinCodeController = TextEditingController();

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _pinCodeController.dispose();
//     super.dispose();
//   }

// Future<void> _saveAccount() async {
//   final name = _fullNameController.text.trim();
//   final email = _emailController.text.trim();
//   final phone = _phoneController.text.trim();
//   final address = _addressController.text.trim();
//   final pinCode = _pinCodeController.text.trim();

//   if ([name, email, phone, address, pinCode].any((e) => e.isEmpty)) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
//     return;
//   }

//   final response = await Supabase.instance.client
//       .from('DEMO_CHAMPION')
//       .insert({
//         'name': name,
//         'email': email,
//         'phone': phone,
//         'address': address,
//         'pin_code': pinCode,
//       })
//       .execute();

//   if (response.error != null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: ${response.error!.message}')),
//     );
//   } else {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Account created successfully!')));
//     Navigator.pop(context);
//   }
// }

//   Future<void> _saveAccount() async {
//     final client = Supabase.instance.client;
//     final record = {
//       'name': _fullNameController.text.trim(),
//       'email': _emailController.text.trim(),
//       'phone': _phoneController.text.trim(),
//       'address': _addressController.text.trim(),
//       'pin_code': _pinCodeController.text.trim(),
//     };

//     // try {
//     //   // insert and return the created row
//     //   final inserted = await client
//     //       .from('Champion_Data')
//     //       .insert(record)
//     //       .select()
//     //       .maybeSingle();

//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     const SnackBar(content: Text('Account created successfully!')),
//     //   );
//     //   Navigator.pop(context);
//     // } on PostgrestException catch (err) {
//     //   ScaffoldMessenger.of(
//     //     context,
//     //   ).showSnackBar(SnackBar(content: Text('Error: ${err.message}')));
//     // } catch (e) {
//     //   ScaffoldMessenger.of(
//     //     context,
//     //   ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
//     // }

//     try {
//       final inserted = await client
//           .from('Champion_Data')
//           .insert(record)
//           .select() // make sure you’re asking Supabase to return the new row
//           .maybeSingle(); // you should get back a Map<String, dynamic> or null

//       print('🎉 Insert response: $inserted');
//       // If inserted is null, Supabase returned nothing ─ it might mean RLS blocked you.

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Account created successfully!')),
//       );
//       Navigator.pop(context);
//     } on PostgrestException catch (err) {
//       print('💥 PostgrestException: ${err.message}');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: ${err.message}')));
//     } catch (e) {
//       print('⚠️ Unexpected error: $e');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
//     }
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300, width: 1),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           hintText: hintText,
//           prefixIcon: Icon(icon, color: Colors.grey),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8B5CF6),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(32.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 const Icon(
//                   Icons.person_add,
//                   size: 50,
//                   color: Color(0xFF8B5CF6),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Create Account',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 _buildInputField(
//                   controller: _fullNameController,
//                   hintText: 'Full Name',
//                   icon: Icons.person_outline,
//                 ),
//                 _buildInputField(
//                   controller: _emailController,
//                   hintText: 'Email',
//                   icon: Icons.email_outlined,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 _buildInputField(
//                   controller: _phoneController,
//                   hintText: 'Phone Number',
//                   icon: Icons.phone_outlined,
//                   keyboardType: TextInputType.phone,
//                 ),
//                 _buildInputField(
//                   controller: _addressController,
//                   hintText: 'Address',
//                   icon: Icons.location_on_outlined,
//                   maxLines: 2,
//                 ),
//                 _buildInputField(
//                   controller: _pinCodeController,
//                   hintText: 'Pin Code',
//                   icon: Icons.pin_drop_outlined,
//                   keyboardType: TextInputType.number,
//                 ),
//                 // Google Map placeholder omitted for brevity
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _saveAccount,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF8B5CF6),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: const Text(
//                       'Save',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     final email = _emailController.text.trim();
//     if (email.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Please enter email')));
//       return;
//     }

//     Future<void> _login() async {
//       final email = _emailController.text.trim();
//       if (email.isEmpty) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Please enter email')));
//         return;
//       }

//       try {
//         // Query for a single record matching the email
//         final user = await Supabase.instance.client
//             .from('Champion_Data')
//             .select()
//             .eq('email', email)
//             .maybeSingle();

//         if (user != null) {
//           // Existing user
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => NextPage()),
//           );
//         } else {
//           // Non-registered user
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Account not found. Please create an account.'),
//             ),
//           );
//         }
//       } on PostgrestException catch (err) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error: ${err.message}')));
//       } catch (e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8B5CF6),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20.0),
//             child: Container(
//               width: double.infinity,
//               constraints: const BoxConstraints(maxWidth: 400),
//               padding: const EdgeInsets.all(32.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Welcome Champion',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   // Email Field
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F4F6),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                     ),
//                     child: TextField(
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: const InputDecoration(
//                         hintText: 'Email',
//                         prefixIcon: Icon(
//                           Icons.email_outlined,
//                           color: Colors.grey,
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Password Field (not used in Supabase table)
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F4F6),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                     ),
//                     child: TextField(
//                       controller: _passwordController,
//                       obscureText: !_isPasswordVisible,
//                       decoration: InputDecoration(
//                         hintText: 'Password',
//                         prefixIcon: const Icon(
//                           Icons.lock_outline,
//                           color: Colors.grey,
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible
//                                 ? Icons.visibility_outlined
//                                 : Icons.visibility_off_outlined,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPasswordVisible = !_isPasswordVisible;
//                             });
//                           },
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF8B5CF6),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Login',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Icon(Icons.arrow_forward, size: 18),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CreateAccountPage(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'New account',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color(0xFF8B5CF6),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NextPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Next Page')),
//       body: Center(child: Text('Welcome to the next page!')),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'create_account_page.dart'; // import your CreateAccountPage

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   void _goToCreate() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const CreateAccountPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8B5CF6),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Container(
//               width: double.infinity,
//               constraints: const BoxConstraints(maxWidth: 400),
//               padding: const EdgeInsets.all(32),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Welcome Champion',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F4F6),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                     ),
//                     child: TextField(
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: const InputDecoration(
//                         hintText: 'Email',
//                         prefixIcon: Icon(
//                           Icons.email_outlined,
//                           color: Colors.grey,
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   GestureDetector(
//                     onTap: _goToCreate,
//                     child: const Text(
//                       'New account',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color(0xFF8B5CF6),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'create_account_page.dart';
import 'home_page.dart'; // new page after login
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _login() async {
  //   final email = _emailController.text.trim();
  //   final password = _passwordController.text;

  //   if (email.isEmpty || password.isEmpty) {
  //     _showSnack("Please enter email & password");
  //     return;
  //   }

  //   setState(() => _loading = true);
  //   final uri = Uri.parse('http://127.0.0.1:8000/login');
  //   final resp = await http.post(
  //     uri,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email, 'password': password}),
  //   );
  //   setState(() => _loading = false);

  //   if (resp.statusCode == 200) {
  //     final body = jsonDecode(resp.body);
  //     if (body['message'] == 'Log in successfully') {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => const HomePage()),
  //       );
  //     } else {
  //       _showSnack("Check your email or password");
  //     }
  //   } else {
  //     _showSnack("Server error: ${resp.statusCode}");
  //   }
  // }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnack("Please enter email & password");
      return;
    }

    setState(() => _loading = true);

    try {
      final uri = Uri.parse('http://localhost:8000/login');

      // Log timestamp before request
      debugPrint("Login request start: ${DateTime.now()}");

      final resp = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10)); // <-- 10s timeout

      // Log timestamp after response
      debugPrint("Login response received: ${DateTime.now()}");

      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);
        if (body['message'] == 'Login successful') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage(championEmail: email)),
          );
          return;
        } else {
          _showSnack("Check your email or password");
        }
      } else {
        _showSnack("Server error: ${resp.statusCode}");
      }
    } on TimeoutException {
      _showSnack("Request timed out. Please try again.");
    } catch (e) {
      _showSnack("An error occurred: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _goToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateAccountPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B5CF6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome Champion',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email field
                  _buildInputField(
                    controller: _emailController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  _buildInputField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login', style: TextStyle(fontSize: 18)),
                    ),
                  ),

                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _goToCreate,
                    child: const Text(
                      'New account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
