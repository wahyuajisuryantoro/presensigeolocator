import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        Map<String, dynamic> dataResponse = await _determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          String address =
              "${placemarks[0].name}, ${placemarks[0].subLocality},${placemarks[0].locality}";
          await updatePosition(position, address);
          double distance = Geolocator.distanceBetween(
              -7.5218645, 110.2244956, position.latitude, position.longitude);
          await presensi(position, address, distance);

          ///Get.snackbar("Berhasil", "Anda telah mengisi daftar hadir");
        } else {
          Get.snackbar("Terjadi Kesalahan", dataResponse["message"]);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime now = DateTime.now();
    String todayDocId = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di Luar Area";

    if (distance <= 200) {
      status = "Di Dalam Area";
    }

    if (snapPresence.docs.length == 0) {
      /// Belum pernah absen dan set absen masuk pertama kali
      await Get.defaultDialog(
          title: "Validasi Presensi",
          middleText: "Apakah anda yakin mengisi daftar hadir (MASUK) sekarang ?",
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("Batal")),
            ElevatedButton(
                onPressed: () async {
                  await colPresence.doc(todayDocId).set({
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance
                    },
                  });
                  Get.back();
                  Get.snackbar("Berhasil", "Anda telah mengisi daftar hadir");
                },
                child: Text("Ya"))
          ]);
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocId).get();

      if (todayDoc.exists == true) {
        Map<String, dynamic>? datePresenceNow = todayDoc.data();
        if (datePresenceNow?["keluar"] != null) {
          //sudah absen masuk dan keluar
          Get.snackbar("INFORMASI PENTING",
              "Anda telah absen masuk dan keluar, tidak dapat absen kembali, tidak dapat mengubah data kembali");
        } else {
          //absen keluar
          await Get.defaultDialog(
              title: "Validasi Presensi",
              middleText:
                  "Apakah anda yakin mengisi daftar hadir (KELUAR) sekarang ?",
              actions: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: Text("Batal")),
                ElevatedButton(
                    onPressed: () async {
                      await colPresence.doc(todayDocId).update({
                        "keluar": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": status,
                          "distance": distance
                        },
                      });
                      Get.back();
                      Get.snackbar(
                          "Berhasil", "Anda telah mengisi daftar hadir KELUAR");
                    },
                    child: Text("Ya"))
              ]);
        }
      } else {
        //absen masuk
        await Get.defaultDialog(
            title: "Validasi Presensi",
            middleText:
                "Apakah anda yakin mengisi daftar hadir (MASUK) sekarang ?",
            actions: [
              OutlinedButton(onPressed: () => Get.back(), child: Text("Batal")),
              ElevatedButton(
                  onPressed: () async {
                    await colPresence.doc(todayDocId).set({
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance
                      },
                    });
                    Get.back();
                    Get.snackbar("Berhasil", "Anda telah mengisi daftar hadir MASUK");
                  },
                  child: Text("Ya"))
            ]);
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;

    firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address
    });
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        "message": "Kesalahan pada GPS",
        "error": true,
      };

      ///return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          "message": "Izin menggunakan GPS ditolak",
          "error": true,
        };
        //return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message": "Settingan tidak mendapatkan akses GPS",
        "error": true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false,
    };
  }
}
