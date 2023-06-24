

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({Key? key}) : super(key: key);
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user["nip"];
    controller.nameC.text = user["name"];
    controller.emailC.text = user["email"];
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpdateProfile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            readOnly: true,
            controller: controller.nipC,
            decoration: InputDecoration(
                labelText: "NIP",
                border: OutlineInputBorder()
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            readOnly: true,
            controller: controller.emailC,
            decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder()
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.nameC,
            decoration: InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder()
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text("Photo Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(builder: (c){
                if(c.image !=null){
                  return Column(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Image.file(File(c.image!.path), fit: BoxFit.cover,),
                        ),
                      ),
                    ],
                  );
                }else{
                  if(user["profile"] != null){
                    return Column(
                      children: [
                        ClipOval(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Image.network(
                              user["profile"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(onPressed: (){
                          controller.deleteProfile(user["uid"]);
                        }, child: Text("Hapus"))
                      ],
                    );
                  }else{
                    return Text("No Image");
                  }
                }
              }
              ),
              TextButton(onPressed: (){
                controller.pickImage();
              }, child: Text("Pilih"))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: (){
                controller.updateProfile(user["uid"]);
              },
              child: Text(
                  "Update Profile"
              ))
        ],
      )
    );
  }
}
