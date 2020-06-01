import 'dart:convert';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:levantamiento_incidentes_cuernavaca/Utils/form_values.dart';
import 'package:levantamiento_incidentes_cuernavaca/models/formulario.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'Utils/checkConectivity.dart';
import 'Utils/checkLocationServicesAndPermissions.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Levantamiento de Emergencias Cuernavaca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Levantamiento de Incidentes Cuernavaca"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.cloud_upload),
              onPressed: () {},
            ),
          ],
        ),
        body: MyHomePage(title: 'Levantamiento de Emergencias Cuernavaca'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Variables Formulario
  final _formKey = GlobalKey<FormState>();
  String numReporte,
      horaSalida,
      horaArribo,
      direccion,
      colonia,
      numeroUnidad,
      reporteProblematica,
      nombreQuienReporta,
      observaciones,
      foto;
  int delegacion = 0,
      tipoFenomeno = 0,
      tipoServicio = 0,
      departamento = 0,
      fecha = DateTime.now().millisecondsSinceEpoch;

  LocationData ubicacion;

  ///Obtener fecha
  DateTime selectedDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  //Función para seleccionar la fecha completa, se complementa con la función selectDate la cual nos regresa año, mes y día, esta función añade horas y minutos.
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
        selectedDate = new DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, time.hour, time.minute);
        debugPrint(selectedDate.toString());
        fecha = selectedDate.millisecondsSinceEpoch;
      });
    }
  }

  uploadImage(io.File imageFile, String uploadURL) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(uploadURL);

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    print(response.toString());
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  ///Función para seleccionar Año, Mes y Día y guardarlos en selectedDate.
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _selectTime(context);
      });
  }

  ///Variables de Ubicación
  Location location = new Location();
  LocationData _locationData;

  ///Variables Image Picker
  List<io.File> images = List<io.File>();
  final picker = ImagePicker();

  getImagesWidget() {
    var imagenes = <Widget>[Container()];
    for (var image in images) {
      imagenes.add(Image.file(image, width: 300, height: 300));
    }
    return imagenes;
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      print('${io.File(pickedFile.path)}');
      images.add(io.File(pickedFile.path));
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      print('${io.File(pickedFile.path)}');
      images.add(io.File(pickedFile.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Número de reporte'),
                onSaved: (String value) {
                  numReporte = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Text(
                      "Fecha seleccionada: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute}"),
                  SizedBox(
                    width: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Icon(Icons.edit),
                  ),
                ],
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Hora de salida de la unidad'),
                onSaved: (String value) {
                  horaSalida = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Hora de arribo de la unidad'),
                onSaved: (String value) {
                  horaArribo = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dirección'),
                onSaved: (String value) {
                  direccion = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Colonia'),
                onSaved: (String value) {
                  colonia = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              DropdownButton<String>(
                hint: Text('Seleccionar Delegación'),
                isExpanded: true,
                value: lista_delegaciones[delegacion],
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    delegacion = lista_delegaciones.indexOf(newValue);
                  });
                },
                items: lista_delegaciones
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 15,
              ),
              DropdownButton<String>(
                hint: Text('Tipo de Fenómeno'),
                isExpanded: true,
                value: lista_fenomenos_geologicos[tipoFenomeno],
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    tipoFenomeno = lista_fenomenos_geologicos.indexOf(newValue);
                  });
                },
                items: lista_fenomenos_geologicos
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 15,
              ),
              DropdownButton<String>(
                hint: Text('Tipo de servicio'),
                isExpanded: true,
                value: lista_tipo_servicios[tipoServicio],
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    tipoServicio = lista_tipo_servicios.indexOf(newValue);
                  });
                },
                items: lista_tipo_servicios
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 15,
              ),
              DropdownButton<String>(
                hint: Text('Departamento (necesario)'),
                isExpanded: true,
                value: lista_departamentos[departamento],
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    departamento = lista_departamentos.indexOf(newValue);
                  });
                },
                items: lista_departamentos
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Número de Unidad'),
                onSaved: (String value) {
                  numeroUnidad = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Reporte o problemática'),
                onSaved: (String value) {
                  reporteProblematica = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Nombre de quién reporta'),
                onSaved: (String value) {
                  nombreQuienReporta = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Observaciones'),
                onSaved: (String value) {
                  observaciones = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Text(() {
                    if (ubicacion == null) {
                      return "No se ha obtenido la ubicación aún.";
                    } else {
                      return 'Ubicación ${ubicacion.latitude},${ubicacion.longitude}';
                    }
                  }()),
                  SizedBox(
                    width: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (await checkLocationServiceAndPermissions(location)) {
                        _locationData = await location.getLocation();
                        setState(() {
                          ubicacion = _locationData;
                        });
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Ubicación Actualizada ${_locationData.longitude} ${_locationData.latitude}')));
                      }
                    },
                    child: Text('Localizarme'),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: Image.file(images[index]).image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Align(
                              child: Container(
                                child: FloatingActionButton(
                                    onPressed: () {
                                      images.remove(images[index]);
                                      setState(() {});
                                    },
                                    child: Icon(Icons.delete)),
                                width: 35,
                                height: 35,
                              ),
                              alignment: Alignment.bottomRight,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              Align(
                alignment: Alignment.center,
                child: RaisedButton.icon(
                    onPressed: getImageFromGallery,
                    icon: Icon(Icons.folder),
                    label: Text('Fotografia desde Galeria (Opcional)')),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: RaisedButton.icon(
                    onPressed: getImageFromCamera,
                    icon: Icon(Icons.add_a_photo),
                    label: Text('Fotografia desde Cámara (Opcional)')),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid
                        _formKey.currentState.save();
                        bool isConnected = await checkConectivity();

                        Formulario formulario = Formulario(
                            numReporte,
                            fecha,
                            horaSalida.toString(),
                            '2',
                            direccion,
                            delegacion + 1,
                            colonia,
                            tipoFenomeno + 1,
                            tipoServicio + 1,
                            departamento + 1,
                            numeroUnidad,
                            reporteProblematica,
                            nombreQuienReporta,
                            observaciones,
                            ' ',
                            ubicacion.latitude.toString(),
                            ubicacion.longitude.toString());
                        if (isConnected) {
                          String url =
                              'https://services9.arcgis.com/fp5f46XvVGKIUi0R/ArcGIS/rest/services/Levantamiento_Emergencias/FeatureServer/0/addFeatures';
                          var map = new Map<String, dynamic>();
                          map['features'] = json.encode(formulario.toJson());
                          map['rollbackOnFailure'] = 'false';
                          map['f'] = 'pjson';
                          map['token'] = '';
                          debugPrint(json.encode(map));
                          var response = await http.post(url, body: map);
                          debugPrint('Response status: ${response.statusCode}');
                          debugPrint('Response body: ${response.body}');
                          bool success;
                          try {
                            success = json.decode(response.body)["addResults"]
                                [0]["success"];
                          } catch (e) {
                            success = false;
                          }
                          if (success) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Reporte subido con éxito.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ));
                            if (images.length != 0) {
                              int objectId =
                                  json.decode(response.body)["addResults"][0]
                                      ["objectId"];
                              String urlImage =
                                  'https://services9.arcgis.com/fp5f46XvVGKIUi0R/arcgis/rest/services/Levantamiento_Emergencias/FeatureServer/0/$objectId/addAttachment';
                              debugPrint(urlImage);
                              for (var image in images) {
                                uploadImage(image, urlImage);
                              }
                            }
                          } else {}
                        } else {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("No hay internet"),
                                content: new Text(
                                    "Parece ser que no estas conectado a internet, tu reporte y su información será guardado en el dispostivo y podrá ser subido una vez que cuentes con internet."),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("Aceptar"),
                                    onPressed: () async {
                                      await Hive.initFlutter();
                                      var box = await Hive.openBox('testBox');

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: Text('Enviar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
