import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginView'),
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
            height: 20,
          ),
          TextField(
            controller: controller.passC,
            obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder()
              )
          ),
          SizedBox(
            height: 30,
          ),
          Obx(() =>
              ElevatedButton(
                  onPressed: () async{
                    if(controller.isLoading.isFalse){
                      await controller.login();
                    }
                  },
                  child: Text(controller.isLoading.isFalse? "Login" : "Loading..")
              ),
          ),
          TextButton(
              onPressed: ()=> Get.toNamed(Routes.FORGOT_PASSWORD)
              , child: Text("Lupa Password"))
        ],
      )
    );
  }
}
