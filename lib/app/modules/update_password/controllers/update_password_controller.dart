import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
 TextEditingController currC = TextEditingController();
 TextEditingController newC = TextEditingController();
 TextEditingController confirmC = TextEditingController();

 FirebaseAuth auth = FirebaseAuth.instance;

 void updatePassword() async{
  if(currC.text.isNotEmpty && newC.text.isNotEmpty && confirmC.text.isNotEmpty){
   if(newC.text == confirmC.text){
    isLoading.value = true;
    try{
     String emailUser = auth.currentUser!.email!;
     await auth.signInWithEmailAndPassword(email: emailUser, password: currC.text);
     await auth.currentUser!.updatePassword(newC.text);
     Get.back();
     Get.snackbar("Berhasil", "Berhasil Update Password");
    }on FirebaseAuthException catch(e){
     if(e.code == "wrong-password"){
      Get.snackbar("Terjadi Kesalahan", "Password yang dimasukkan salah");
     }else{
      Get.snackbar("Terjadi Kesalahan", "${e.code.toLowerCase()}");
     }
    }catch(e){
     Get.snackbar("Terjadi Kesalahan", "Tidak Dapat Update Password");
    }
    finally{
     isLoading.value = false;
    }

   }else{
    Get.snackbar("Terjadi Kesalahan", "Password Baru tidak cocok");
   }

  }else{
   Get.snackbar("Terjadi Kesalahan", "Semua Kolom Harus diisi");
  }
 }
}
