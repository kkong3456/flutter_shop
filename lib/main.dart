import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/login.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream:FirebaseAuth.instance.authStateChanges(),
          builder:(BuildContext context,AsyncSnapshot<User?> snapshot){
            if(!snapshot.hasData){
              return const Login();
            }else{
              return Center(
                child:Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Text('${snapshot.data?.displayName}님 반갑습니다.'),
                  TextButton(
                    onPressed: (){
                      FirebaseAuth.instance.signOut();
                    },
                    child:const Text('로그아웃')
                  ),
                ],
              )
              );
            }
          }
        ),
      ),
    );
  }
}


