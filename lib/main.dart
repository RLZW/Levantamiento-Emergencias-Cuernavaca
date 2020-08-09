import 'dart:convert';
import 'dart:io' as io;
import 'package:levantamiento_incidentes_cuernavaca/screens/formspendientes.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:background_app_bar/background_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:levantamiento_incidentes_cuernavaca/Utils/form_values.dart';
import 'package:levantamiento_incidentes_cuernavaca/models/formulario.dart';
import 'package:levantamiento_incidentes_cuernavaca/models/formulariohive.model.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'Utils/checkConectivity.dart';
import 'Utils/checkLocationServicesAndPermissions.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  Hive.registerAdapter(FormularioHiveAdapter());

  await Hive.initFlutter();
  await Hive.openBox('formBox');

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
        home: MyHomePage(
          title: "A;FSDKLJ",
        ));
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
      foto,
      lista_inspectores = lista_inspectores_ciudadana[0];
  int delegacion = 0,
      tipoFenomeno = 0,
      tipoServicio = 0,
      departamento = 0,
      inspector_bomberos = 0,
      inspector_bomberos_apoyo = 0,
      inspector_ciudadania = 0,
      inspector_ciudadania_apoyo = 0,
      fecha = DateTime.now().millisecondsSinceEpoch;

  bool bomberosSeleccionados = false;

  LocationData ubicacion;

  ///Obtener fecha
  DateTime selectedDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  bool seleccionado = true;

  String horaTermino;

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

  Box _formBox = Hive.box('formBox');

  ///Variables Image Picker
  List<io.File> images = List<io.File>();
  List<String> images64 = List<String>();
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
      images64.add(base64.encode(io.File(pickedFile.path).readAsBytesSync()));
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      print('${io.File(pickedFile.path)}');
      images.add(io.File(pickedFile.path));
      images64.add(base64.encode(io.File(pickedFile.path).readAsBytesSync()));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.cloud_upload),
            onPressed: () async {
              bool isConnected = await checkConectivity();
              if (isConnected) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PendientesPage()));
              } else {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(
                    'No estás conectado a internet para ingresar.',
                  ),
                ));
              }
            },
          ),
        ],
      ),
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
                      "Fecha seleccionada: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute}"),
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
                decoration: InputDecoration(labelText: 'Hora de término'),
                onSaved: (String value) {
                  horaTermino = value;
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
              Text(
                'Delegación',
                style: TextStyle(
                    color: Color.fromRGBO(1, 1, 1, 0.6), fontSize: 16),
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
              Text(
                'Tipo de Fenómeno',
                style: TextStyle(
                    color: Color.fromRGBO(1, 1, 1, 0.6), fontSize: 16),
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
              Text(
                'Tipo de servicio',
                style: TextStyle(
                    color: Color.fromRGBO(1, 1, 1, 0.6), fontSize: 16),
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
              Text(
                'Departamento (Obligatorio)',
                style: TextStyle(
                    color: Color.fromRGBO(1, 1, 1, 0.6), fontSize: 16),
              ),
              DropdownButton<String>(
                hint: Text('Departamento (necesario)'),
                isExpanded: true,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                value: departamento != null
                    ? lista_departamentos[departamento]
                    : null,
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    departamento = lista_departamentos.indexOf(newValue);
                    seleccionado = true;
                    if (departamento == 6) {
                      bomberosSeleccionados = true;
                    } else {
                      bomberosSeleccionados = false;
                    }
                  });
                  debugPrint(bomberosSeleccionados.toString());
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
              Text(
                'Inspector',
                style: TextStyle(
                    color: Color.fromRGBO(1, 1, 1, 0.6), fontSize: 16),
              ),
              seleccionado
                  ? crearDropDownMenuDinamico(
                      seleccionado, bomberosSeleccionados)
                  : SizedBox(),
              SizedBox(
                height: 15,
              ),
              Text(
                'Subinspector',
                style: TextStyle(
                    color: Color.fromRGBO(1, 1, 1, 0.6), fontSize: 16),
              ),
              seleccionado
                  ? crearDropDownMenuDinamicoApoyo(
                      seleccionado, bomberosSeleccionados)
                  : SizedBox(),
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
              Column(
                children: <Widget>[
                  Text(() {
                    if (ubicacion == null) {
                      return "No se ha obtenido la ubicación aún.";
                    } else {
                      return 'Ubicación ${ubicacion.longitude},${ubicacion.latitude}';
                    }
                  }()),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: RaisedButton(
                      onPressed: () async {
                        if (await checkLocationServiceAndPermissions(
                            location)) {
                          _locationData = await location.getLocation();
                          setState(() {
                            ubicacion = _locationData;
                          });
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  'Ubicación Actualizada ${_locationData.longitude} ${_locationData.latitude}')));
                        }
                      },
                      child: Text('Localizarme'),
                    ),
                  )
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
                                      print(images64.toString());
                                      images.remove(images[index]);
                                      images64.remove(images64[index]);
                                      print(images64.toString());

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

                        if (ubicacion == null) {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("No existe ubicación"),
                                content: new Text(
                                    "Parece ser que no has presionado el botón Localizarme por lo que no hemos podido detectar tu ubicación"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("Aceptar"),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          if (true) {
                            if (bomberosSeleccionados) {
                              Formulario formulario = Formulario(
                                  numReporte,
                                  horaSalida,
                                  horaArribo,
                                  horaTermino,
                                  direccion,
                                  colonia,
                                  numeroUnidad,
                                  reporteProblematica,
                                  nombreQuienReporta,
                                  observaciones,
                                  ' ',
                                  ubicacion.longitude.toString(),
                                  ubicacion.latitude.toString(),
                                  delegacion,
                                  tipoFenomeno,
                                  tipoServicio,
                                  departamento,
                                  fecha,
                                  images,
                                  null,
                                  inspector_bomberos,
                                  null,
                                  inspector_bomberos_apoyo,
                                  lista_inspectores);

                              var map = new Map<String, dynamic>();
                              map['features'] =
                                  json.encode(formulario.toJson());
                              if (isConnected) {
                                //
                                String url =
                                    'https://services9.arcgis.com/fp5f46XvVGKIUi0R/arcgis/rest/services/Events_Cuernavaca/FeatureServer/0/addFeatures';
                                map['features'] =
                                    json.encode(formulario.toJson());
                                map['rollbackOnFailure'] = 'false';
                                map['f'] = 'pjson';
                                map['token'] = '';
                                debugPrint(json.encode(map));
                                var response = await http.post(url, body: map);

                                debugPrint(
                                    'Response status: ${response.statusCode}');
                                debugPrint('Response body: ${response.body}');
                                bool success;
                                try {
                                  success =
                                      json.decode(response.body)["addResults"]
                                          [0]["success"];
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
                                  if (images.length != 0) {
                                    int objectId =
                                        json.decode(response.body)["addResults"]
                                            [0]["objectId"];
                                    String urlImage =
                                        'https://services9.arcgis.com/fp5f46XvVGKIUi0R/arcgis/rest/services/Events_Cuernavaca/FeatureServer/0/$objectId/addAttachment';
                                    debugPrint(urlImage);
                                    for (var image in images) {
                                      uploadImage(image, urlImage);
                                    }
                                  }
                                }
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
                                            FormularioHive formularioHive =
                                                FormularioHive(
                                                    numReporte,
                                                    horaSalida,
                                                    horaArribo,
                                                    horaTermino,
                                                    direccion,
                                                    colonia,
                                                    numeroUnidad,
                                                    reporteProblematica,
                                                    nombreQuienReporta,
                                                    observaciones,
                                                    0,
                                                    ubicacion.longitude,
                                                    ubicacion.latitude,
                                                    delegacion,
                                                    tipoFenomeno,
                                                    tipoServicio,
                                                    departamento,
                                                    fecha,
                                                    images64,
                                                    null,
                                                    inspector_bomberos,
                                                    null,
                                                    inspector_bomberos_apoyo +
                                                        1,
                                                    lista_inspectores);

                                            await _formBox.add(formularioHive);
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _formBox = _formBox;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } else {
                              Formulario formulario = Formulario(
                                  numReporte,
                                  horaSalida,
                                  horaArribo,
                                  horaTermino,
                                  direccion,
                                  colonia,
                                  numeroUnidad,
                                  reporteProblematica,
                                  nombreQuienReporta,
                                  observaciones,
                                  ' ',
                                  ubicacion.longitude.toString(),
                                  ubicacion.latitude.toString(),
                                  delegacion,
                                  tipoFenomeno,
                                  tipoServicio,
                                  departamento,
                                  fecha,
                                  images,
                                  inspector_ciudadania,
                                  null,
                                  inspector_ciudadania_apoyo,
                                  null,
                                  lista_inspectores);

                              var map = new Map<String, dynamic>();
                              map['features'] =
                                  json.encode(formulario.toJson());
                              if (isConnected) {
                                //
                                String url =
                                    'https://services9.arcgis.com/fp5f46XvVGKIUi0R/arcgis/rest/services/Events_Cuernavaca/FeatureServer/0/addFeatures';
                                map['features'] =
                                    json.encode(formulario.toJson());
                                map['rollbackOnFailure'] = 'false';
                                map['f'] = 'pjson';
                                map['token'] = '';
                                debugPrint(json.encode(map));
                                var response = await http.post(url, body: map);

                                debugPrint(
                                    'Response status: ${response.statusCode}');
                                debugPrint('Response body: ${response.body}');
                                bool success;
                                try {
                                  success =
                                      json.decode(response.body)["addResults"]
                                          [0]["success"];
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
                                  if (images.length != 0) {
                                    int objectId =
                                        json.decode(response.body)["addResults"]
                                            [0]["objectId"];
                                    String urlImage =
                                        'https://services9.arcgis.com/fp5f46XvVGKIUi0R/arcgis/rest/services/Events_Cuernavaca/FeatureServer/0/$objectId/addAttachment';
                                    debugPrint(urlImage);
                                    for (var image in images) {
                                      uploadImage(image, urlImage);
                                    }
                                  }
                                }
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
                                            FormularioHive formularioHive =
                                                FormularioHive(
                                                    numReporte,
                                                    horaSalida,
                                                    horaArribo,
                                                    horaTermino,
                                                    direccion,
                                                    colonia,
                                                    numeroUnidad,
                                                    reporteProblematica,
                                                    nombreQuienReporta,
                                                    observaciones,
                                                    0,
                                                    ubicacion.longitude,
                                                    ubicacion.latitude,
                                                    delegacion,
                                                    tipoFenomeno,
                                                    tipoServicio,
                                                    departamento,
                                                    fecha,
                                                    images64,
                                                    inspector_ciudadania,
                                                    null,
                                                    inspector_ciudadania_apoyo +
                                                        1,
                                                    null,
                                                    lista_inspectores);

                                            await _formBox.add(formularioHive);
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _formBox = _formBox;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          } else {} //fINAL ELSE
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

  crearDropDownMenuDinamico(bool seleccionado, bool bomberosSeleccionados) {
    if (seleccionado) {
      if (bomberosSeleccionados) {
        return (DropdownButton<String>(
          hint: Text('Inspector qué levantó reporte (Bomberos)'),
          isExpanded: true,
          value: lista_inspectores_bomberos[inspector_bomberos],
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
              inspector_bomberos = lista_inspectores_bomberos.indexOf(newValue);
            });
          },
          items: lista_inspectores_bomberos
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
      } else {
        return (DropdownButton<String>(
          hint: Text('Inspector qué levantó reporte (Ciudadania)'),
          isExpanded: true,
          value: lista_inspectores_ciudadana[inspector_ciudadania],
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
              inspector_ciudadania =
                  lista_inspectores_ciudadana.indexOf(newValue);
            });
          },
          items: lista_inspectores_ciudadana
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
      }
    } else {
      return (SizedBox());
    }
  }

  crearDropDownMenuDinamicoApoyo(
      bool seleccionado, bool bomberosSeleccionados) {
    if (seleccionado) {
      if (bomberosSeleccionados) {
        return (DropdownButton<String>(
          hint: Text('Inspector de apoyo (Bomberos)'),
          isExpanded: true,
          value: lista_inspectores_bomberos[inspector_bomberos_apoyo],
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
              lista_inspectores = newValue;
              inspector_bomberos_apoyo =
                  lista_inspectores_bomberos.indexOf(newValue);
            });
          },
          items: lista_inspectores_bomberos
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
      } else {
        return (DropdownButton<String>(
          hint: Text('Inspector qué levantó reporte (Ciudadania)'),
          isExpanded: true,
          value: lista_inspectores_ciudadana[inspector_ciudadania_apoyo],
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
              lista_inspectores = newValue;
              inspector_ciudadania_apoyo =
                  lista_inspectores_ciudadana.indexOf(newValue);
            });
          },
          items: lista_inspectores_ciudadana
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
      }
    } else {
      return (SizedBox());
    }
  }
}
