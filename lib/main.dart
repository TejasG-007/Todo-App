import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo/Constant/Helper.dart';
import 'package:todo/Constant/StateHelper.dart';
import 'package:todo/Views/Home_View.dart';
import 'package:todo/Views/Login_View.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: statusBarColor));

  runApp(
  ChangeNotifierProvider(create: (_)=>StateHelper(),child: MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
          stream: _auth.authStateChanges(),
          builder: (context, authState) {
            return authState.data != null
                ? const Homeview()
                : const LoginView();
          },
        ),
    );
  }
}
