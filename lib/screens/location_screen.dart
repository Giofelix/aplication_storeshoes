import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng? _currentPosition;
  bool _isLoading = false;
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      // Verifica si los servicios de ubicación están activados
      bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        throw 'Los servicios de ubicación están desactivados. Actívalos en la configuración.';
      }

      // Verifica y solicita permisos si es necesario
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'El usuario denegó el permiso de ubicación.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Permiso de ubicación denegado permanentemente. Actívalo en la configuración.';
      }

      // Obtiene la ubicación actual con alta precisión
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Mueve el mapa a la ubicación obtenida después de que la UI esté lista
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _mapController.mapEventStream != null) {
          _mapController.move(_currentPosition!, 15.0);
        }
      });

    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error obteniendo ubicación: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubicación en Tiempo Real")),
      body: Stack(
        children: [
          _currentPosition != null
              ? FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition!,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.prueba',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition!,
                    width: 80.0,
                    height: 80.0,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          )
              : const Center(child: Text("Presiona el botón para obtener la ubicación")),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _requestLocationPermission,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Obtener Ubicación"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
