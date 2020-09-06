import 'package:flutter/material.dart';

import 'package:FlutterCivitas/screens/add_report_screen.dart';
import 'package:FlutterCivitas/screens/report_detail_screen.dart';
import 'package:FlutterCivitas/main.dart';
import 'package:FlutterCivitas/services/api_service.dart';

class ReportsListScreen extends StatefulWidget {
  static const routeName = '/reports_list';
  @override
  State<StatefulWidget> createState() => new ReportsListState();
}

class ReportsListState extends State<ReportsListScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future refreshList() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Denúncias efetuadas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              AboutDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: ApiService.getReportsList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final reports = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    isThreeLine: true,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        ApiUrls.BASE_API_URL + '/' + reports[index]['photo'],
                      ),
                    ),
                    title: Text(
                      reports[index]['description'],
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(reports[index]['reportType'] +
                        '\nLocal: ' +
                        reports[index]['location']['address']),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ReportDetailScreen.routeName,
                        arguments: reports[index]['_id'],
                      );
                    },
                  ),
                );
              },
              itemCount: reports.length,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddReportScreen.routeName);
        },
        child: Icon(
          Icons.new_releases,
          color: Colors.white,
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
