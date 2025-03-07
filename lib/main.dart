import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tugas_akhirr/models/user_model.dart';
import 'package:tugas_akhirr/pages/home_page.dart';
import 'package:tugas_akhirr/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('settings');

  final settingsBox = Hive.box('settings');
  final isLoggedIn = settingsBox.get('isLoggedIn', defaultValue: false) as bool;
  final username = settingsBox.get('username', defaultValue: '') as String;
  final email = settingsBox.get('email', defaultValue: '') as String;

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    username: username,
    email: email,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String username;
  final String email;

  const MyApp({
    super.key,
    this.isLoggedIn = false, 
    this.username = '', 
    this.email = '', 
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? HomePage(username: username, email: email)
          : const LoginPage(),
    );
  }
}
