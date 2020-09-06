import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/place.dart';
import 'package:FlutterCivitas/services/api_service.dart';

class ReportsProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> fetchAndSetReports() async {
    final dataList = await ApiService.getReportsList();
    print(dataList);
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['description'],
            problemType: item['reportType'],
            image: File(item['photo']),
            location: PlaceLocation(
              latitude: item['latitude'],
              longitude: item['longitude'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
