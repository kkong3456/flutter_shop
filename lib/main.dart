import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/realTimeItemList.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Flutter Demo',
      theme:ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var db = FirebaseFirestore.instance;

  // Create a new user with a first and last name
  final user = <String, dynamic>{
    "first": "Ada",
    "middle":"kkong",
    "last": "Lovelace",
    "born": 1915
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:const Text('StreamBuilder test'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: addItem,
                  child: const Text("추가1")
              ),
              Container(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: addItem2,
                  child: const Text("추가2")
              ),
              Container(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: readAllItem,
                  child: const Text("읽기"),
              ),
              Container(
                height: 10,
              ),
              ElevatedButton(
                onPressed: createItem,
                child: const Text('문서생성'),
              ),
              Container(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: updateItem,
                  child: const Text("수정하기")
              ),
              Container(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: updateFieldItem,
                  child: const Text('필드수정하기')
              ),
              Container(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: timeStampUpdate,
                  child: const Text("타임스팸프")
              ),
              Container(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: deleteItem,
                  child: const Text('삭제'),
              ),
              Container(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: deleteFieldItem,
                  child: const Text('필드삭제')
              ),
              Container(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder:(context)=>const realTimeItemList()
                      )
                    );
                  },
                  child: const Text('실시간 변화 리스트로 가기')
              ),

            ],
          ),
        ),

      )

    );

  }
  void addItem(){
    db.collection("users").add(user).then((DocumentReference doc)=>print("DocumentSnapshot added with Id :${doc.id}"));
  }

  void addItem2(){
    // Add a new document with a generated id.
    final data = {"name": "Tokyo", "country": "Japan"};

    db.collection("cities").add(data).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
  }

  Future<void> readAllItem() async {
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }
//해당 컬렉션, 문서가 없으면 생성 있으면 업데이트 된다.
  createItem(){
    final city = <String, String>{
      "name": "Los Angeles",
      "state": "CA",
      "country": "USA"
    };
    db.collection("cities")
        .doc("DC")
        .set(city)
        .onError((e, _) => print("Error writing document: $e"));

    changeItemListen();
  }

  updateItem(){
    final city=<String,String>{
      'name':'Suwon',
      'state':'Kyakie-do',
      'country':'South korea'
    };
    db.collection('cities')
    .doc("LA")
    .set(city)
    .onError((e,_)=>print("Error update document : $e"));
  }

  updateFieldItem(){
    final washingtonRef = db.collection("cities").doc("LA");
    washingtonRef.update({"state": "kyungki-do"}).then(
            (value) {
              timeStampUpdate();
              print("DocumentSnapshot successfully updated!");
            },
        onError: (e) => print("Error updating document $e"));
  }

  timeStampUpdate(){
    final docRef = db.collection("cities").doc("LA");
    final updates = <String, dynamic>{
      "timestamp": FieldValue.serverTimestamp(),
    };

    docRef.update(updates).then(
            (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  deleteItem(){
    db.collection("cities").doc("DC").delete().then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );
  }

  //컬렉션 전체 삭제는 firebase console에서 하는것을 권장함
  deleteFieldItem(){
    final docRef = db.collection("cities").doc("DC");

// Remove the 'country' field from the document
    final updates = <String, dynamic>{
      "country": FieldValue.delete(),
    };

    docRef.update(updates);
  }

  changeItemListen(){
    final docRef = db.collection("cities").doc("DC");
    docRef.snapshots().listen(
          (event) => print("current data: ${event.data()}"),
      onError: (error) => print("Listen failed: $error"),
    );
  }
}

