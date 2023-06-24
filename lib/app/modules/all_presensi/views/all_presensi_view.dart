import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_pages.dart';
import '../controllers/all_presensi_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_pages.dart';
import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEMUA PRESENSI'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamAllPresence(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snap.data?.docs.length == 0 || snap.data == null) {
            return SizedBox(
              height: 150,
              child: Center(
                child: Text("Belum Ada Riwayat Absensi"),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snap.data!.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = snap.data!.docs[index].data();
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Material(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.DETAIL_PRESENSI, arguments: data),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Masuk",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(data['masuk']?['date'] == null ? "-" : "${DateFormat.Hms().format(DateTime.parse(data['masuk']['date']))}"),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Keluar", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data['keluar']?['date'] == null ? "-" : "${DateFormat.Hms().format(DateTime.parse(data['keluar']['date']))}"),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}