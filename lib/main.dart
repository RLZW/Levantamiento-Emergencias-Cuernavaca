import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:levantamiento_incidentes_cuernavaca/Utils/form_values.dart';
import 'package:location/location.dart';

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
      fecha,
      horaSalida,
      horaArribo,
      direccion,
      colonia,
      tipoFenomeno,
      tipoServicio,
      departamento,
      numeroUnidad,
      reporteProblematica,
      nombreQuienReporta,
      observaciones,
      foto,
      delegacion;
  LocationData ubicacion;

  ///Obtener fecha
  DateTime selectedDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
        selectedDate = new DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, time.hour, time.minute);
      });
    }
  }

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

  ///Checar Conectividad Teléfono
  _checkConectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      //I am not connected to any network.
      return false;
    }
  }

  ///Variables de Ubicación
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _checkLocationServiceAndPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print(false);
        return false;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print(false);
        return false;
      }
    }

    if (_serviceEnabled & (_permissionGranted == PermissionStatus.granted)) {
      print(true);
      return true;
    }
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
                    child: Text('Cambiar Fecha'),
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
                value: delegacion,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    delegacion = newValue;
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
                value: tipoFenomeno,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    tipoFenomeno = newValue;
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
                value: tipoServicio,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    tipoServicio = newValue;
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
                value: departamento,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    departamento = newValue;
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
                  horaSalida = value;
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
                      if (await _checkLocationServiceAndPermissions()) {
                        _locationData = await location.getLocation();
                        setState(() {
                          ubicacion = _locationData;
                        });
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Wakanda ${_locationData.longitude} ${_locationData.latitude}')));
                      }
                    },
                    child: Text('Localizarme'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid
                      _formKey.currentState.save();
                      bool isConnected = await _checkConectivity();
                      if (isConnected) {
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
                                  onPressed: () {
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
            ],
          ),
        ),
      ),
    );
  }
}
