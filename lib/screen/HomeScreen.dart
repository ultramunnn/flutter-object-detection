import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:timun_object_detection/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWorking = false;
  CameraImage? imgCamera;
  late CameraController cameraController;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameraController = CameraController(
      cameras[0], // Menggunakan kamera pertama yang tersedia
      ResolutionPreset.medium,
    );

    await cameraController.initialize();
    if (!mounted) return;

    setState(() {
      isCameraInitialized = true;
    });

    // Mulai stream gambar dari kamera
    cameraController.startImageStream((imageFromStream) {
      if (!isWorking) {
        setState(() {
          isWorking = true;
          imgCamera = imageFromStream;
        });
      }
    });
  }

  void stopCamera() {
    if (cameraController.value.isStreamingImages) {
      cameraController.stopImageStream();
    }
    cameraController.dispose();
    setState(() {
      isCameraInitialized = false;
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/jarvis.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Area Kamera
            Positioned(
              top: 12,
              child: Container(
                height: 400, // Ukuran pas dengan camera.jpg
                width: 600,
                child: isCameraInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            16), // Opsional: Tambahkan efek border
                        child: AspectRatio(
                          aspectRatio: cameraController.value.aspectRatio,
                          child: FittedBox(
                            fit: BoxFit
                                .cover, // Pastikan kamera mengisi area tanpa distorsi
                            child: SizedBox(
                              width: cameraController.value.previewSize!.height,
                              height: cameraController.value.previewSize!.width,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationZ(
                                    3.1415927 / 2), // Rotasi 90 derajat
                                child: CameraPreview(cameraController),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Image.asset(
                        "assets/camera.jpg",
                        fit: BoxFit.cover,
                        width: 600,
                        height: 400,
                      ),
              ),
            ),

            // Tombol Start & Off Kamera
            Positioned(
              bottom: 50,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      if (!isCameraInitialized) {
                        initCamera();
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Start Camera",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () {
                      if (isCameraInitialized) {
                        stopCamera();
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Off Camera",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
