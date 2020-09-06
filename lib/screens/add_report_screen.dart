import 'dart:io';
import 'package:FlutterCivitas/models/report.dart';
import 'package:FlutterCivitas/services/api_service.dart';
import 'package:flutter/material.dart';
import '../widgets/image_input.dart';
import '../widgets/location_input.dart';
import 'package:FlutterCivitas/helpers/location_helper.dart';
import 'package:FlutterCivitas/screens/reports_list_screen.dart';

class AddReportScreen extends StatefulWidget {
  static const routeName = '/add-place';
  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  bool _isLoading = false;
  final _descriptionController = TextEditingController();
  File _pickedImage;
  ReportLocation _pickedLocation;
  String _dropdownValue;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = ReportLocation(latitude: lat, longitude: lng);
  }

  void _savePlace() async {
    if (_descriptionController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null ||
        _dropdownValue == null) {
      showDialog(
          builder: (context) => AlertDialog(
                title: Text('Um erro ocorreu'),
                content: Text(
                    'Você precisa preencher todos os campos, enviar uma foto e adicionar a localização antes de enviar uma denúncia'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: (Text('Ok')))
                ],
              ),
          context: context);
      return;
    }
    final address = await LocationHelper.getPlaceAddress(
        _pickedLocation.latitude, _pickedLocation.longitude);

    var reportLocation = new ReportLocation(
        latitude: _pickedLocation.latitude,
        longitude: _pickedLocation.longitude,
        address: address);

    var report = new Report(
      description: _descriptionController.text,
      location: reportLocation,
      reportType: _dropdownValue,
    );

    setState(() {
      _isLoading = true;
    });

    ApiService.createReport(report, _pickedImage).then((res) {
      setState(() {
        _isLoading = false;
      });
      String title, text;
      if (res) {
        title = "Tudo certo!";
        text = "Denúncia enviada com sucesso";
      } else {
        title = "Algo deu errado...";
        text = "Um erro ocorreu ao tentar submeter essa denúncia";
      }
      showDialog(
          builder: (context) => AlertDialog(
                title: Text(title),
                content: Text(text),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          ReportsListScreen.routeName,
                          (Route<dynamic> route) => false);
                    },
                    child: (Text('Ok')),
                  )
                ],
              ),
          context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova ocorrência'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: DropdownButton<String>(
                        hint: new Text("Selecione um tipo de problema"),
                        value: _dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        isExpanded: true,
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        /*underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),*/
                        onChanged: (String newValue) {
                          setState(() {
                            _dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          'Infração de Trânsito',
                          'Iluminação Pública',
                          'Manutenção de Ruas',
                          'Outros'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      autocorrect: true,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Descrição do problema',
                          hintText:
                              'Descreva detalhadamente o problema encontrado'),
                      controller: _descriptionController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: [
                          new TextSpan(
                              text: 'Precisamos que envie uma boa foto '),
                          new TextSpan(
                              text: 'detalhada ',
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                          new TextSpan(text: 'do local'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(text: 'Selecione a localização '),
                          new TextSpan(
                              text: 'exata',
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(_selectPlace),
                    SizedBox(
                      height: 40,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton.icon(
                            label: Text(
                              'Registrar denúncia',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _savePlace,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            color: Colors.indigoAccent,
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
