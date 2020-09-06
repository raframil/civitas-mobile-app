import 'package:FlutterCivitas/screens/onboard_screen.dart';
import 'package:FlutterCivitas/screens/report_detail_screen.dart';
import 'package:FlutterCivitas/screens/reports_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/reports.dart';
import './screens/add_report_screen.dart';

void main() => runApp(MyApp());

class ApiUrls {
  static const BASE_API_URL = "http://18.224.34.157:3000";
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ReportsProvider(),
      child: MaterialApp(
          title: 'Civitas',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.indigo,
            accentColor: Colors.redAccent,
          ),
          home: OnboardingScreen(),
          routes: {
            AddReportScreen.routeName: (ctx) => AddReportScreen(),
            ReportsListScreen.routeName: (ctx) => ReportsListScreen(),
            ReportDetailScreen.routeName: (ctx) => ReportDetailScreen(),
          }),
    );
  }
}
