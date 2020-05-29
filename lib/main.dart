import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
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
  /** Variables Formulario */
  final _formKey = GlobalKey<FormState>();
  String num_reporte,
      fecha,
      hora_salida,
      hora_arribo,
      direccion,
      colonia,
      tipo_fenomeno,
      tipo_servicio,
      departamento,
      numero_unidad,
      reporte_problematica,
      nombre_quienreporta,
      observaciones,
      foto,
      ubicacion,
      delegacion;
  /** Obtener Fecha */
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

  /** Checar conectividad del telefono */
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
  /** Variables ubicación*/

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
                  num_reporte = value;
                },
                /* validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor llena el campo solicitado.';
                  }
                  return null;
                }, */
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
                  hora_salida = value;
                },
                /* validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor llena el campo solicitado.';
                  }
                  return null;
                }, */
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Hora de arribo de la unidad'),
                onSaved: (String value) {
                  hora_arribo = value;
                },
                /* validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor llena el campo solicitado.';
                  }
                  return null;
                }, */
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dirección'),
                onSaved: (String value) {
                  direccion = value;
                },
                /* validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor llena el campo solicitado.';
                  }
                  return null;
                }, */
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Colonia'),
                onSaved: (String value) {
                  colonia = value;
                },
                /* validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor llena el campo solicitado.';
                  }
                  return null;
                }, */
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
                items: <String>[
                  'ANTONIO BARONA',
                  'BENITO JUAREZ',
                  'EMILIANO ZAPATA',
                  'LAZARO CÁRDENAS',
                  'MARIANO MATAMOROS',
                  'MIGUEL HIDALGO',
                  'PLUTARCO ELIAS CALLES',
                  'VICENTE GUERRERO',
                  'REVOLUCIÓN'
                ].map<DropdownMenuItem<String>>((String value) {
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
                value: tipo_fenomeno,
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
                    tipo_fenomeno = newValue;
                  });
                },
                items: <String>[
                  'Geológico',
                  'Hidrometereológico',
                  'Sanitario-Ecológico',
                  'Quimico-Tecnológico',
                  'Socio organizativo',
                  'Astronómico'
                ].map<DropdownMenuItem<String>>((String value) {
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
                value: tipo_servicio,
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
                    tipo_servicio = newValue;
                  });
                },
                items: <String>[
                  'ACCIDENTE AUTOMOVILISTICO',
                  'ACCIDENTE DE TRABAJO',
                  'AMENAZA DE BOMBA',
                  'ÁRBOL COLAPSADO',
                  'ÁRBOL EN RIESGO',
                  'BARDA COLAPSADA',
                  'BARDA EN RIESGO',
                  'BARRANCA AZOLVADA',
                  'CABLES CAÍDOS',
                  'CAPTURA DE ANIMALES',
                  'CONSTRUCCIÓN EN RIESGO',
                  'CORTO CIRCUITO',
                  'DERRAME EN VÍA PÚBLICA',
                  'DERRUMBE',
                  'ELECTROCUTADO',
                  'ENJAMBRE',
                  'ESTABLECIMIENTO IRREGULAR',
                  'EXPLOSIÓN',
                  'FALSA ALARMA',
                  'FUGA DE GAS L.P.',
                  'INCENDIO CASA HABITACIÓN',
                  'INCENDIO ESTABLECIMIENTO',
                  'INCENDIO TERRENO BALDÍO',
                  'INCENDIO VEHÍCULO',
                  'INTENTO DE SUICIDIO',
                  'INUNDACIÓN CASA HABITACIÓN',
                  'INUNDACIÓN CALLE',
                  'INUNDACIÓN ESTABLECIMIENTO',
                  'NOTIFICACIÓN',
                  'OLOR AMBIENTE DESAGRADABLE Y/O CONTAMINANTE',
                  'OPERATIVO DE SEGURIDAD',
                  'POSTE COLAPSADO',
                  'POSTE EN RIESGO',
                  'QUEMA DE BASURA',
                  'RAMA COLAPSADA',
                  'RESCATE DE PERSONA',
                  'RECORRIDOS',
                  'REGISTROS EN MAL ESTADO Y/O SIN TAPADERA',
                  'SEGUIMIENTO DE EMERGENCIA',
                  'ALCANTARRILLA EN RIESGO',
                  'ANUNCIO ESPECTACULAR EN RIESGO',
                  'ANTENA EN RIESGO Y/O SIN PERMISO DE COLOCACIÓN',
                  'DRENAJE TAPADO Y/O EN RIESGO',
                  'FILTRACIONES DE AGUA',
                  'HUNDIMIENTO CINTA ASFALTICA',
                  'IMPLEMENTACIÓN MEDIDAS DE SEGURIDAD.',
                  'ESPECTACULAR EN RIESGO',
                  'OBSTRUCCION DE BARRANCA',
                  'OLOR A GAS L.P.',
                  'PANEL ELECTRICO EN RIESGO',
                  'RAMA EN RIESGO',
                  'SEGUIMIENTO DE SERVICIO',
                  'SISTEMA CAPTACIÓN DE AGUA PLUVIAL MAL ESTADO',
                  'TALUD Y/O PAREDON EN RIESGO',
                  'FUGA DE AGUA POTABLE',
                  'FUGA DE AGUA DRENAJE',
                  'INCENDIO FORESTAL',
                  'FERIA',
                  'TOMA CLANDESTINA',
                  'SISMO',
                  'OBJETO PELIGROSO EN VÍA PÚBLICA',
                  'OLOR A GASOLINA',
                  'TRONCO SECO',
                  'QUEMA DE PIROTECNIA',
                  'TRANSPORTE MATERIAL PELIGROSO',
                  'QUEMA DE PASTIZAL',
                  'SEMAFORO EN RIESGO',
                  'FUMIGACION MANIOBRAS',
                  'PERSONA LESIONADA',
                  'SIMULACROS',
                  'MANIOBRA RETIRO DE TANQUE ESTACIONARIO',
                  'SERVICIO SOCIAL',
                  'OTRO'
                ].map<DropdownMenuItem<String>>((String value) {
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
                items: <String>[
                  'DEMANDA CIUDADANA',
                  'EMERGENCIA',
                  'NOTIFICACION',
                  'OPERATIVO DE SEGURIDAD',
                  'SIMULACRO',
                  'VERIFICACION',
                  'BOMBEROS'
                ].map<DropdownMenuItem<String>>((String value) {
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
                  numero_unidad = value;
                },
                /* validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor llena el campo solicitado.';
                  }
                  return null;
                }, */
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Reporte o problemática'),
                onSaved: (String value) {
                  reporte_problematica = value;
                },
                /* validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor llena el campo solicitado.';
                  }
                  return null;
                }, */
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Nombre de quién reporta'),
                onSaved: (String value) {
                  nombre_quienreporta = value;
                },
                /*  validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor llena el campo solicitado.';
                  }
                  return null;
                }, */
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Observaciones'),
                onSaved: (String value) {
                  hora_salida = value;
                },
                /* validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor llena el campo solicitado.';
                  }
                  return null;
                }, */
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if(await _checkLocationServiceAndPermissions()){
                      _locationData = await location.getLocation();
                      ;
                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Wakanda ${_locationData.longitude} ${_locationData.latitude}')));
                    }
                    bool value = await _checkConectivity();
                    
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      _formKey.currentState.save();
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
