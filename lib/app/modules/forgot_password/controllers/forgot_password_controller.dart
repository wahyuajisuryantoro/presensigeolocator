import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {

 TextEditingController emailC = TextEditingController();
 RxBool isLoading = false.obs;

 FirebaseAuth auth = FirebaseAuth.instance;

 void sendEmail()async{
   if(emailC.text.isNotEmpty){
     isLoading.value = true;
     try{
       await auth.sendPasswordResetEmail(email: emailC.text);
       Get.snackbar("Berhasil", "Kami telah mengirim link reset password");
     }catch (e){
       Get.snackbar("Terjadi Kesalahan", "Tidak Dapat Mengirim Link Email Reset Password");
     }finally{
       isLoading.value = false;
     }
   }
   }

}
