/*import 'package:cms/features/user_auth/presentation/pages/login_page.dart'; // Assuming login() leads to profile settings
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
}*/
