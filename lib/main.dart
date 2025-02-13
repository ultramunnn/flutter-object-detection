import 'package:flutter/material.dart';
import 'package:timun_object_detection/screen/HomeScreen.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timun Object Detection',
      home: HomeScreen(),
    );
  }
}
