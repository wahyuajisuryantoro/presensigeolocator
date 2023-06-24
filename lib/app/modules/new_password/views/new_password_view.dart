import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewPasswordView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            obscureText: true,
            controller: controller.newPassC,
            decoration: InputDecoration(
              labelText: "Password Baru",
              border: OutlineInputBorder()
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: (){
            controller.newPassword();
          },
              child: Text("Ganti Password"),
          )
        ],
      )
    );
  }
}
