import 'package:FlutterCivitas/models/place.dart';
import 'package:flutter/material.dart';
import 'package:FlutterCivitas/services/api_service.dart';
import 'package:FlutterCivitas/main.dart';
import './map_screen.dart';

class ReportDetailScreen extends StatelessWidget {
  static const routeName = '/report-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da denúncia'),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: ApiService.getReport(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  var report = snapshot.data['report'];

                  var latitude = double.parse(report['location']['latitude']);
                  var longitude = double.parse(report['location']['longitude']);

                  var locationModel = new PlaceLocation(
                      latitude: latitude, longitude: longitude);
                  return Column(
                    children: <Widget>[
                      Container(
                        height: 250,
                        width: double.infinity,
                        child: Image.network(
                          ApiUrls.BASE_API_URL + '/' + report['photo'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        report['reportType'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        report['location']['address'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        report['description'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      FlatButton(
                        child: Text('Visualizar no Mapa'),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (ctx) => MapScreen(
                                initialLocation: locationModel,
                                isSelecting: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return AlertDialog(
                    title: Text('Um erro aconteceu'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                              'Não foi possível recuperar os dados dessa denúncia'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Voltar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              }
              return Center(
                heightFactor: 10,
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
