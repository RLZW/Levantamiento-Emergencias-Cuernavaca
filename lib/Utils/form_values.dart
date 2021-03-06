const lista_delegaciones = <String>[
  'Seleccionar...',
  'ANTONIO BARONA',
  'BENITO JUAREZ',
  'EMILIANO ZAPATA',
  'LAZARO CÁRDENAS',
  'MARIANO MATAMOROS',
  'MIGUEL HIDALGO',
  'PLUTARCO ELIAS CALLES',
  'VICENTE GUERRERO',
  'REVOLUCIÓN'
];

const lista_fenomenos_geologicos = <String>[
  'Seleccionar...',
  'Geológico',
  'Hidrometereológico',
  'Sanitario-Ecológico',
  'Quimico-Tecnológico',
  'Socio organizativo',
  'Astronómico'
];

const lista_tipo_servicios = <String>[
  'Seleccionar...',
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
  'OTRO',
];

const lista_departamentos = <String>[
  'Seleccionar...',
  'DEMANDA CIUDADANA',
  'EMERGENCIA',
  'NOTIFICACION',
  'OPERATIVO DE SEGURIDAD',
  'SIMULACRO',
  'VERIFICACION',
  'BOMBEROS'
];

const lista_inspectores_ciudadana = <String>[
  'Seleccionar…',
  'Lic. Gonzalo Alberto Barquin Granados',
  'Juan José Diaz Flores',
  'Luis Fernando Delgado Villalpando',
  'Félix E. Arce Ávila',
  'José Luis Martínez Beltrán',
  'Luis Neri Argandar',
  'Hidalia Benitez Hernández',
  'Ricardo Ruíz Salgado',
  'José Luis Hidalgo Arroyo',
  'José Antonio Salazar Herrera',
  'Rogelio Juárez López',
  'José Luis Diaz Sánchez',
  'Melesio Najera Ortuño',
  'Araceli Ramírez Álvarez',
  'Jorge Armando Rangel Montesinos',
  'Marco Antonio Vazquez Menhumea',
  'Aarón Gleason Álvarez',
  'Cesareo Ranfla Rodriguez',
  'Andrea Hernández Monroy',
  'Victor Manuel Salgado',
  'Luis Omar Garcia Santamaria',
  'Marcos Benigno Neri Argandar',
  'Lino Salinas Fausto',
  'Guzmán Colín Raúl Alejandro',
  'Breton Perez Luis Noe'
];

const lista_inspectores_bomberos = <String>[
  'Seleccionar...',
  'Abarca Hernández David Iván',
  'Adame Solórzano Agustín',
  'Aguilar Allora Sergio',
  'Aguilar Mares Moisés',
  'Álvarez Vallejo David Alejandro',
  'Antúnez López Javier',
  'Aragón Ceja Jesús Enrique',
  'Arellano Santos Santiago',
  'Balcázar Ronces César',
  'Barrera Espinosa Máximo Antonio',
  'Bautista Flores Santiago',
  'Bautista Mendiola Norberto',
  'Beltrán Bustos José Luis',
  'Camacho Barrios Ignacio Aguileo',
  'Camacho Jiménez Carlos',
  'Carlos Robles Einstein Isaí',
  'Cristerna Zagal Christian Liliana',
  'Cuevas Cortés Cristiahm Enrique',
  'Díaz Villamil Andrea',
  'Espada Manzanarez Héctor Omar',
  'Estrada Cruz Erik Jaime',
  'Fernández Montiel Jessica',
  'Flores Carballo Griselda',
  'Flores Martínez Jaime Isidro',
  'Flores Ocampo Alejandro',
  'Galindo Gómez Julián',
  'García Medina Cesar',
  'García Ortiz Victor Manuel',
  'Gómez Chávez Gustavo',
  'Gómez Vargas Eduardo',
  'González Montes de Oca Jesús Alfonso',
  'Hernández Benítez Mario',
  'Hernández Girón Julio César',
  'Hernández López Alberto Antonio',
  'Keyko Nieto Martínez',
  'Ledezma Mejía María Griselda',
  'Manríquez Aguilar Esteban',
  'Martínez Alonzo Ma. Guadalupe',
  'Martínez Álvarez Raúl',
  'Martínez Díaz Oscar',
  'Martínez Santiaguillo Ricardo Raziel',
  'Molina Hernández Abril Michel',
  'Mondragón Cuevas Gabriel',
  'Montoya del Carmen Hugo Antonio',
  'Ocampo Álvarez Édgar Fernando',
  'Orcazas Franco Asael',
  'Ortiz Chávez Rodolfo',
  'Ortiz Quintero Adán',
  'Perfecto Bahena Salvador',
  'Perfecto Delgado José Francisco',
  'Posada Millán Ricardo',
  'Salgado Reyes Jesús Eduardo',
  'Sánchez Ramírez José Francisco',
  'Soler Pérez Alberto',
  'Solórzano Muñoz José Daniel',
  'Vara Vargas César',
  'Vázquez Corral Carlos',
  'Orihuela Marin Carlos Javier',
  'Amador Herrera Felipe',
  'Barragán Martínez Sergio Antonio',
  'Bautista Flores Arturo',
  'Campos Álvarez Jorge Ivan',
  'Castañeda Hernández Ruben',
  'Cortes Salgado Ignacio',
  'Cristerna Zagal Juan Carlos',
  'Díaz Martínez Christian Omar',
  'Domínguez Gómez Fernando',
  'Flores Martínez Francisco Manuel',
  'Flores Martínez Francisco Manuel',
  'García Escobar Andrés Honey',
  'García García Manuel Ramón',
  'García Rodríguez José Iván',
  'Girón Dávila Daniel',
  'González Gómez Jorge ',
  'Hernández Monroy Ricardo ',
  'Julián García Ricardo',
  'Manzanarez Millan Abel',
  'Ortíz Bahena Benjamín',
  'Quintana Morales Victor Manuel',
  'Ramos González Hugo',
  'Ramos González Moisés',
  'Ramos González Raúl',
  'Robles Díaz Francisco Manuel',
  'Rojas Estrada Alejandro',
  'Rosas Axomulco Bulmaro',
  'Sánchez Rojas Freddy',
  'Vega Pérez Gabriel',
];
