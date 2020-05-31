import 'package:connectivity/connectivity.dart';

///Funcion que checa si el teléfono esta conectado a internet (Wifi o Mobile) y regresa un booleano dependiendo el resultado.
checkConectivity() async {
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
