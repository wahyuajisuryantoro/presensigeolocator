import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;
        await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text);
        UserCredential pegawaiCredential = await auth
            .createUserWithEmailAndPassword(
            email: emailC.text, password: "admin12345");
        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "job" : jobC.text,
            "email": emailC.text,
            "uid": uid,
            "role": "pegawai",
            "createdAt": DateTime.now().toIso8601String()
          });

          await pegawaiCredential.user!.sendEmailVerification();
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: emailAdmin, password: passAdminC.text);

          Get.back();
          Get.snackbar("Berhasil", "Berhasil Menambahkan Pegawai");
        }
      } on FirebaseException catch (e) {
        if (e.code == "weak password") {
          Get.snackbar("Terjadi Kesalahan", "Password terlalu lemah");
          print("weak password");
        } else if (e.code == "email-already-in-use") {
          Get.snackbar("Terjadi Kesalahan", "Email sudah terdaftar");
          print("Acc is usage");
        } else if (e.code == "wrong password") {
          Get.snackbar("Terjadi Kesalahan", "Password Salah");
        } else {
          Get.snackbar("Terjadi Kesalahan", "${e.code}");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai");
        print(e);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan",
          "Password Admin Harus Di Isi untuk keperluan validasi");
    }
  }

  void addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty&&
        jobC.text.isNotEmpty) {
      Get.defaultDialog(
        title: "Validasi Admin",
        content: Column(
          children: [
            Text("Masukkan Password untuk validasi admin"),
            TextField(
              controller: passAdminC,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await prosesAddPegawai();
            },
            child: Text("Tambahkan Pegawai"),
          ),
        ],
      );
    } else {
      Get.snackbar("Terjadi Kesalahan", "NIP, nama, job dan email harus diisi");
    }
  }
}