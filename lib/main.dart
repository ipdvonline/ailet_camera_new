import 'package:ailet_camera/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      initState: (_) {},
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('IPDV Demo Camera Ailet'),
          ),
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                return Text(ctrl.message.value);
              }),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.blue,
            currentIndex: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                label: "CAMERA CHANNEL",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                label: "CAMERA PLUGIN",
              ),
            ],
            onTap: (v) {
              if (v == 0) {
                ctrl.startCameraChannel(
                  login: 'ipdv_visit',
                  password: 'visit123',
                  storeId: '6',
                  userId: '36865',
                  visitId: 'custom_visit_17434b0',
                );
                return;
              }

              ctrl.startCameraPlugin(
                login: 'ipdv_visit',
                password: 'visit123',
                storeId: '6',
                userId: '36865',
                visitId: 'custom_visit_17434b0',
              );
            },
          ),
          /*floatingActionButton: FloatingActionButton(
            onPressed: () {
              ctrl.startCamera(
                login: 'ipdv_visit',
                password: 'visit123',
                storeId: '6',
                userId: '36865',
                visitId: 'custom_visit_17434b0',
              );
            },
            child: const Icon(Icons.camera_alt),
          ),
          */
        );
      },
    );
  }
}
