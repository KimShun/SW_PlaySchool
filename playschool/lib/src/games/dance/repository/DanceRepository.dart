import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:playschool/src/games/dance/model/DanceAPI.dart';

class DanceRepository {
  final String baseUrl;

  const DanceRepository({
    required this.baseUrl,
  });

  Future<File> copyAssetToFile(String assetPath, String filename) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  Future<XFile> rotateVideo(XFile inputFile) async {
    final directory = await getTemporaryDirectory();
    final outputPath = '${directory.path}/rotated_output.mov';

    final command = '-i ${inputFile.path} -vf "transpose=2" -c:a copy $outputPath';
    // await FFmpegKit.execute(command);

    return XFile(outputPath);
  }

  Future<DanceAPI> fetchDanceResult(String original, XFile record) async {
    final uri = Uri.parse("$baseUrl/exercise/dance/assessment");
    // final uri = Uri.parse("http://10.20.106.244:8000/exercise/dance/assessment");

    final originalFile = await copyAssetToFile(original, "original.mov");
    final rotatedRecordFile = await rotateVideo(record);

    final request = http.MultipartRequest("POST", uri)
      ..files.add(await http.MultipartFile.fromPath("original", originalFile.path))
      ..files.add(await http.MultipartFile.fromPath("record", rotatedRecordFile.path));

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      final responseString = await streamedResponse.stream.bytesToString();
      final data = json.decode(responseString);
      print(data);
      return DanceAPI.fromJson(data);
    } else {
      throw Exception("비디오 업로드 실패: ${streamedResponse.statusCode}");
    }
  }
}