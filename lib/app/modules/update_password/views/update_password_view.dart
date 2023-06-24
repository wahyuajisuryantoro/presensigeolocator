import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.currC,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password Lama",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller.newC,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password Baru",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller.confirmC,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Ketik Ulang Password Baru",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(() => ElevatedButton(onPressed: (){
            if(controller.isLoading.isFalse){
              controller.updatePassword();
            }
          },
              child: Text(controller.isLoading.isFalse ? "Update Password" : "Loading..")))
        ],
      )
    );
  }
}
