import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ForgotPasswordView'),
        centerTitle: true,
      ),
      body: ListView(
          padding: EdgeInsets.all(20),
          children: [
          TextField(
          controller: controller.emailC,
          decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder()
          )
      ),
            SizedBox(
              height: 30,
            ),
            Obx(() =>
                ElevatedButton(
                    onPressed: (){
                      if(controller.isLoading.isFalse){
                        controller.sendEmail();
                      }
                    },
                    child: Text(controller.isLoading.isFalse? "Send Reset Password" : "Loading..")
                ),
            ),
      ]
      )
    );
  }
}
