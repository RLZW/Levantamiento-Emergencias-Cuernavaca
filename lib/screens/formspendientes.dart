import 'dart:convert';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:levantamiento_incidentes_cuernavaca/models/formulariohive.model.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class PendientesPage extends StatefulWidget {
  @override
  _PendientesPageState createState() => _PendientesPageState();
}

class _PendientesPageState extends State<PendientesPage> {
  @override
  void initState() {
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  uploadImage(String imageFile, String uploadURL) async {
    var uri = Uri.parse(uploadURL);
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile.fromBytes(
        'file', base64.decode(imageFile),
        filename: TimeOfDay.now().toString() + '.jpg');
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    print(response.toString());
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formBox = Hive.box('formBox');
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: BackgroundFlexibleSpaceBar(
              background: Image.asset(
            'assets/images/emergencias.jpeg',
            fit: BoxFit.cover,
          )),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.update),
                onPressed: () {
                  (context as Element).reassemble();
                })
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _formBox.length,
                itemBuilder: (BuildContext context, int index) {
                  var formulario =
                      _formBox.getAt(index) as FormularioHive;
                  debugPrint(formulario.numReporte);
                  debugPrint(formulario.images.toString());
                  if (formulario != null) {
                    return ListTile(
                        title: Text('Num Reporte: ${formulario.numReporte}'),
                        subtitle: Text('${index}'),
                        leading: formulario.images.length != 0
                            ? Image.memory(base64.decode(formulario.images[0]))
                            : Opacity(
                                opacity: 0.45,
                                child: Image.asset('assets/images/noimage.png'),
                              ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.cloud_upload),
                              onPressed: () async {
                                setState(
                                  () async {
                                    String url =
                                        'https://services9.arcgis.com/fp5f46XvVGKIUi0R/arcgis/rest/services/Events_Cuernavaca/FeatureServer/0/addFeatures';
                                    var map = new Map<String, dynamic>();
                                    map['features'] =
                                        json.encode(formulario.toJson());
                                    map['rollbackOnFailure'] = 'false';
                                    map['f'] = 'pjson';
                                    map['token'] = '';
                                    debugPrint(json.encode(map));
                                    var response =
                                        await http.post(url, body: map);
                                    debugPrint(
                                        'Response status: ${response.statusCode}');
                                    debugPrint(
                                        'Response body: ${response.body}');
                                    bool success;
                                    try {
                                      success = json.decode(
                                              response.body)["addResults"][0]
                                          ["success"];
                                    } catch (e) {
                                      success = false;
                                    }
                                    if (success) {
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          'Reporte subido con éxito.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                      ));
                                      if (formulario.images.length != 0) {
                                        int objectId = json.decode(
                                                response.body)["addResults"][0]
                                            ["objectId"];
                                        String urlImage =
                                            'https://services9.arcgis.com/fp5f46XvVGKIUi0R/arcgis/rest/services/Events_Cuernavaca/FeatureServer/0/$objectId/addAttachment';
                                        debugPrint(urlImage);
                                        for (var image in formulario.images) {
                                          uploadImage(image, urlImage);
                                        }
                                      }
                                      await _formBox.deleteAt(index);
                                    }
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                debugPrint('Boton Presionado');
                                await _formBox.deleteAt(index);
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Eliminado con éxito recarga la pantalla para verificar.',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ));
                  }
                },
              ),
            )
          ],
        ));
  }
}
