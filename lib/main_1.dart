
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'adduser.dart';


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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final String documentId='AVKFxzCnymgruipKCGG8';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var db = FirebaseFirestore.instance;

  CollectionReference test_collection = FirebaseFirestore.instance.collection('test-collection');
  
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: addItem,
                child:const Text('추가')
              ),
              const Padding(padding: EdgeInsets.all(10)),
              ElevatedButton(
                onPressed: readItem2,
                child:Text('읽기'),
              ),
              const Padding(padding: EdgeInsets.all(10),),
              ElevatedButton(
                onPressed: updateItem,
                child: const Text('수정'),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              ElevatedButton(
                onPressed: deleteItem,
                child:const Text('삭제'),
              ),
            ],
          ),
        )

      ),
    );
  }

   addItem() {
     final item = <String, String>{
       'title': 'kkong',
       'content': '1/1',
     };
     db.collection("test-collection").add(item).then((DocumentReference doc) =>
         print('DocumentSnapshot added with ID: ${doc.id}'));
   }
  //   Future<void> addItem2(){
  //   return test_collection.add({
  //     'title':'kkongkkong',
  //     'content':'11/17',
  //   })
  //       .then((value)=>print('item added'))
  //       .catchError((err)=>print('Failt to add item'));
  // }

   readItem() {  //특정한거 한개 읽기
         db.collection('test-collection')
         .doc(widget.documentId)
         .get()
         .then((DocumentSnapshot documentSnapshot) {
       if (documentSnapshot.exists) {
         print('Document data:${documentSnapshot.data()}');
         return documentSnapshot.data();
       } else {
         print('Document does not exist on the database');
         return const Text('...loading');
       }
     });
   }

  readItem2() async { //전체읽기
    await db.collection("test-collection").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }
  //Deleting a document does not delete its subcollections!
  //Deleting collections from the client is not recommended.
  deleteItem(){
    db.collection("test-collection").doc(widget.documentId  ).delete().then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );
  }

  Future<void> updateItem() {
    return db
        .collection('test-collection')
        .doc(widget.documentId)
        .update({'title': 'Stokes and Sons'})
        .then((value) => print("Item Updated"))
        .catchError((error) => print("Failed to update item: $error"));
  }
}


