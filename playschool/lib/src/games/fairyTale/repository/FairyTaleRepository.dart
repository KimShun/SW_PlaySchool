import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:playschool/src/games/fairyTale/model/FairyTaleResult.dart'; // for basename

class FairyTaleRepository {
  final String baseUrl;

  const FairyTaleRepository ({
    required this.baseUrl,
  });

  Future<FairyTaleResult> createFairyBook(String content, String userUID, XFile? img) async {
    // final uri = Uri.parse('$baseUrl/make/fairyBook'); // 서버 주소로 변경
    final uri = Uri.parse("http://10.20.107.22:8001/make/fairyBook");

    final request = http.MultipartRequest('POST', uri)
      ..fields['content_line'] = content
      ..fields['userUID'] = userUID;

    if (img != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'img',
        img.path,
        filename: basename(img.path)),
      );
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return FairyTaleResult.fromJson(json.decode(responseBody));
    } else {
      throw Exception("오류가 발생했습니다. 다시 시도해주세요.");
    }
  }
}