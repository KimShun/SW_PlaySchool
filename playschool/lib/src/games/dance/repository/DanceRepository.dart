import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class DanceRepository {
  Future<Map<String, dynamic>> fetchDanceResult(String original, XFile record) async {
    final uri = Uri.parse("127.0.0.1:5000/exercise/dance/assessment");

    final request = http.MultipartRequest("POST", uri)
      ..files.add(await http.MultipartFile.fromPath("original", original))
      ..files.add(await http.MultipartFile.fromPath("record", record.path));

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      final responseString = await streamedResponse.stream.bytesToString();
      return json.decode(responseString);
    } else {
      throw Exception("비디오 업로드 실패: ${streamedResponse.statusCode}");
    }
  }
}