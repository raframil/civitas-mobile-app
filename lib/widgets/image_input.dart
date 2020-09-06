import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            _takePicture();
          },
          child: Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: _storedImage == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        'Foto não enviada',
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                : Image.file(
                    _storedImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
        ),
        /*Container(
          child: FlatButton.icon(
            icon: Icon(Icons.camera_alt),
            label: Text('Tirar Foto'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
        
        _storedImage != null
            ? Container(
                width: 150,
                height: 170,
                child: Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )

                //alignment: Alignment.center,
                )
            : Text(
                'Foto ainda não enviada',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),*/
      ],
    );
  }
}
