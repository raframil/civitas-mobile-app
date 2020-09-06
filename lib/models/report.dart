import 'dart:io';

import 'package:flutter/foundation.dart';

class ReportLocation {
  final double latitude;
  final double longitude;
  final String address;

  const ReportLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
}

class Report {
  final String id;
  final String description;
  final ReportLocation location;
  final File photo;
  final String reportType;

  Report({
    this.id,
    @required this.description,
    @required this.location,
    this.photo,
    @required this.reportType,
  });
}
