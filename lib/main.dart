import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi/app/controllers/page_index_controller.dart';

import 'app/routes/app_pages.dart';

import 'package:presensi/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  final pageC = Get.put(PageIndexController(), permanent: true);
  runApp(
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        print(snapshot.data);
        return GetMaterialApp(
          title: "Application",
          initialRoute: snapshot.data !=null ? Routes.HOME : Routes.LOGIN,
          getPages: AppPages.routes,
        );
      }
    ),
  );
}
