import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

Future<geo.Position?> determinePositionAndroid() async {
  PermissionStatus _permissionGranted;
  _permissionGranted = await Permission.location.status;
  if (_permissionGranted == PermissionStatus.granted) {
    loc.Location location = new loc.Location();
    location.changeSettings(accuracy: loc.LocationAccuracy.low);
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    var _locationData = await location.getLocation();
    return geo.Position(
        longitude: _locationData.longitude!,
        latitude: _locationData.latitude!,
        timestamp: null,
        accuracy: _locationData.accuracy!,
        altitude: _locationData.altitude!,
        heading: _locationData.heading!,
        speed: _locationData.speed!,
        speedAccuracy: _locationData.speedAccuracy!);
  } else
    return null;
}

Future<geo.Position> determinePositionIos() async {
  loc.Location location = new loc.Location();
  location.changeSettings(accuracy: loc.LocationAccuracy.low);

  bool _serviceEnabled;
  loc.PermissionStatus _permissionGranted;
  loc.LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == loc.PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != loc.PermissionStatus.granted) {
      return Future.error('Location permissions are denied');
    }
  }

  _locationData = await location.getLocation();
  return geo.Position(
      longitude: _locationData.longitude!,
      latitude: _locationData.latitude!,
      timestamp: null,
      accuracy: _locationData.accuracy!,
      altitude: _locationData.altitude!,
      heading: _locationData.heading!,
      speed: _locationData.speed!,
      speedAccuracy: _locationData.speedAccuracy!);
}
