import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:FlutterCivitas/main.dart';
import 'package:dio/dio.dart';
import 'package:FlutterCivitas/models/report.dart';

class ApiService {
  static Future<dynamic> _get(String url) async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }
  }

  static Future<List<dynamic>> getReportsList() async {
    return await _get('${ApiUrls.BASE_API_URL}/reports');
  }

  static Future<dynamic> getReport(String id) async {
    return await _get('${ApiUrls.BASE_API_URL}/reports/$id');
  }

  static Future<dynamic> createReport(Report report, filePath) async {
    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    try {
      FormData formData = new FormData.fromMap(
        {
          "description": report.description,
          "reportType": report.reportType,
          "latitude": report.location.latitude,
          "longitude": report.location.longitude,
          "address": report.location.address,
          "photo": MultipartFile.fromFileSync(filePath.path)
        },
      );
      var response = await dio.post(
        '${ApiUrls.BASE_API_URL}/reports',
        data: formData,
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
