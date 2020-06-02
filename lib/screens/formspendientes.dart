import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:levantamiento_incidentes_cuernavaca/models/formulariohive.model.dart';
import 'package:transparent_image/transparent_image.dart';

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

  @override
  Widget build(BuildContext context) {
    final _formularioBox = Hive.box('formularioBox');
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Pendientes por subir"),
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
                itemCount: _formularioBox.length,
                itemBuilder: (BuildContext context, int index) {
                  var formulario =
                      _formularioBox.getAt(index) as FormularioHive;
                  debugPrint(formulario.numReporte);
                  debugPrint(formulario.images.toString());
                  if (formulario != null) {
                    return ListTile(
                        title: Text('Num Reporte: ${formulario.numReporte}'),
                        subtitle: Text('${index}'),
                        leading: formulario.images.length != 0
                            ? Image.memory(
                                base64.decode(formulario.images[0]))
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
                                    
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                debugPrint('Boton Presionado');
                                await _formularioBox.deleteAt(index);
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
