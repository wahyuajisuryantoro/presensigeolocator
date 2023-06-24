import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
 TextEditingController emailC = TextEditingController();
 TextEditingController passC = TextEditingController();
 RxBool isLoading = false.obs;

 FirebaseAuth auth = FirebaseAuth.instance;

 Future<void> login()async{
   if(emailC.text.isNotEmpty && passC.text.isNotEmpty) {
     isLoading.value = true;
     try{
       UserCredential userCredential = 
           await auth.signInWithEmailAndPassword(email: emailC.text, password: passC.text);
       if(userCredential.user != null){
         if(userCredential.user!.emailVerified == true){
           isLoading.value = false;
           if(passC.text == "admin12345"){
             Get.offAllNamed(Routes.NEW_PASSWORD);
           }else{
             Get.offAllNamed(Routes.HOME);
           }
         }else{
           Get.defaultDialog(
             title: "Belum verifikasi",
             middleText: "Tolong verifikasi email terlebih dahulu",
             actions: [
               OutlinedButton(onPressed: (){
                 isLoading.value = false;
                 Get.back();
               },
                   child: Text("Kembali")
               ),
               ElevatedButton(
                   onPressed: () async {
                     await userCredential.user!.sendEmailVerification();
                     isLoading.value = false;
                   },
                   child: Text(
                     "Kirim Ulang"
                   ))
             ]
           );
         }
       }

     } on FirebaseException catch (e){
       isLoading.value = false;
       if(e.code == "user-not-found"){
         Get.snackbar("Terjadi Kesalahan", "Email tidak terdaftar");
         print("No user");
       }else if(e.code == "wrong-password"){
         Get.snackbar("Terjadi Kesalahan", "Password salah");
         print("Wrong password");
       }
     }catch(e){
       isLoading.value = false;
       Get.snackbar("Terjadi Kesalahan", "Tidak dapat login");
     }
   }else{
     Get.snackbar("Terjadi Kesalahan", "Email Password harus diisi");
   }
 }
}
