/*//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import "package:cms/global/toast.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("HomePage"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _createData(UserModel(
                    username: "Henry",
                    age: 21,
                    adress: "London",
                  ));
                },
                child: Container(
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Create Data",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              StreamBuilder<List<UserModel>>(
                stream: _readData(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  } if(snapshot.data!.isEmpty){
                    return Center(child:Text("No Data Yet"));
                  }
                  final users = snapshot.data;
                  return Padding(padding: EdgeInsets.all(8),
                  child: Column(
                    children: users!.map((user) {
                      return ListTile(
                        leading: GestureDetector(
                          onTap: (){
                            _deleteData(user.id!);
                          },
                          child: Icon(Icons.delete),
                        ),
                        trailing: GestureDetector(
                          onTap: (){
                            _updateData(
                              UserModel(
                                id: user.id,
                                username: "John Wick",
                                adress: "Pakistan",)
                            );
                          },
                          child: Icon(Icons.update),
                        ),
                        title: Text(user.username!),
                        subtitle: Text(user.adress!),
                      );
                    }).toList()
                  ),);
                }
              ),

              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/login");
                  showToast(message: "Successfully signed out");
                },
                child: Container(
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Sign out",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Stream<List<UserModel>> _readData(){
    final userCollection = FirebaseFirestore.instance.collection("users");

    return userCollection.snapshots().map((qureySnapshot)
    => qureySnapshot.docs.map((e)
    => UserModel.fromSnapshot(e),).toList());
  }

  void _createData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    String id = userCollection.doc().id;

    final newUser = UserModel(
      username: userModel.username,
      age: userModel.age,
      adress: userModel.adress,
        id: id,
    ).toJson();

    userCollection.doc(id).set(newUser);
  }

  void _updateData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final newData = UserModel(
      username: userModel.username,
      id: userModel.id,
      adress: userModel.adress,
      age: userModel.age,
    ).toJson();

    userCollection.doc(userModel.id).update(newData);

  }

  void _deleteData(String id) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    userCollection.doc(id).delete();

  }

}

class UserModel{
  final String? username;
  final String? adress;
  final int? age;
  final String? id;

  UserModel({this.id,this.username, this.adress, this.age});


  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    return UserModel(
      username: snapshot['username'],
      adress: snapshot['adress'],
      age: snapshot['age'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "username": username,
      "age": age,
      "id": id,
      "adress": adress,
    };
  }
}*/
import 'package:cms/features/user_auth/presentation/pages/login_page.dart'; // Assuming login() leads to profile settings
import 'package:cms/features/user_auth/presentation/pages/sign_up_page.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
//import 'package:contrasave/profile.dart';
import 'package:get/get.dart';
import 'package:cms/repository.dart';
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Allow scrolling for potentially overflowing content
        child: Column(
          children: [
            Container(
  //padding: EdgeInsets.all(40), 
  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40,),
    decoration: BoxDecoration(
    color: Color.fromARGB(255, 223, 39, 39),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Row(
    children: [
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text('Expiring soon'),
      ),
      SizedBox(width: 10), // Adjust the space between the notch and text as needed
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text('Updated Contract'), // Modify the contract name here
          Text('#12345'), // Replace with the actual contract number
        ],
      ),
    ],
  ),
)

           /* Container(
              // Implement reminder feature UI here
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 223, 39, 39),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Text('Reminder Feature'), // Replace with actual reminder UI
            ),*/,
            SizedBox(height: 50),
            Container(
              // Implement status box UI here
              padding: EdgeInsets.all(100),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text('Contract Status', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 40),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Active: 10'),
                        Text('Pending: 5'),
                      ]),
                ],
              ),
            ),
            SizedBox(height: 70),
            Container(
              // Implement virtual assistant UI here
              padding: EdgeInsets.all(100),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Text('Virtual Assistant'), // Replace with actual assistant UI
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // Use BottomAppBar for bottom navigation
        elevation: 15, // Add elevation for a slight shadow effect
        color: Color.fromARGB(255, 227, 226, 226), // Set background color
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Space buttons horizontally
          children: [
            IconButton(
              icon: Icon(Icons.menu), //change to repo
              onPressed: () {Get.to(());} // Implement menu dropdown logic later, put repository
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () =>
                  Get.to(() => ()), // Navigate to profile settings
            ),
          ],
        ),
      ),
    );
  }
}
