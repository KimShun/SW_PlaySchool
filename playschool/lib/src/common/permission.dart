// import 'package:permission_handler/permission_handler.dart';
//
// Future<void> requestPermission() async {
//   final camStatus = await Permission.camera.status;
//   final micStatus = await Permission.microphone.status;
//
//   print("Camera: $camStatus, Microphone: $micStatus");
//
//   if (camStatus.isDenied || camStatus.isRestricted) {
//     await Permission.camera.request();
//   }
//
//   if (micStatus.isDenied || micStatus.isRestricted) {
//     await Permission.microphone.request();
//   }
//
//   if (await Permission.camera.isPermanentlyDenied ||
//       await Permission.microphone.isPermanentlyDenied) {
//     print("권한 영구 거부됨 → 설정으로 유도 필요");
//     // openAppSettings();  // 유도 가능
//   }
// }