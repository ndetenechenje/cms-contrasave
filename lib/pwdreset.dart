import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cms/features/user_auth/presentation/pages/login_page.dart';
import 'package:get/get.dart';

class PasswordReset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Password Reset'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        // Allow scrolling if content overflows
        padding: EdgeInsets.symmetric(horizontal: 20.0), // Add padding
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0), // Add spacing
              Text(
                'Enter your registered email address',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0), // Add spacing
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0), // Add spacing
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print(
                        'Sending password reset email to ${_emailController.text}');
                    Get.snackbar(
                      'Success!',
                      'A password reset link has been sent to your email.',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 5),
                    );
                    Get.to(LoginPage());
                  }
                },
                child: Text('Send Reset Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
