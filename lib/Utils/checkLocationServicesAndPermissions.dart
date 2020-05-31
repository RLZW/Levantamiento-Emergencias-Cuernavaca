import 'package:location/location.dart';

///Función que recibe un objeto Location y regresa un boleano si el servicio de ubicación y los permisos estan activados.
checkLocationServiceAndPermissions(Location location) async {
  PermissionStatus permissionGranted;
  bool _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return false;
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return false;
    }
  }

  if (_serviceEnabled & (permissionGranted == PermissionStatus.granted)) {
    return true;
  }
}
