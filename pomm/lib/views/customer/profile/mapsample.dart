import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(6.462580, 100.500999), // UUM
    zoom: 17.0,
  );

  static const CameraPosition _kUUM = CameraPosition(
    bearing: 0,
    target: LatLng(6.462580, 100.500999),
    tilt: 45.0,
    zoom: 18.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Location"),
        backgroundColor: Colors.deepOrange,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          const Marker(
            markerId: MarkerId('uum'),
            position: LatLng(6.462580, 100.500999),
            infoWindow: InfoWindow(
              title: 'Utara Gadget Solution',
              snippet: 'Universiti Utara Malaysia, 06050, Kedah',
            ),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToUUM,
        label: const Text('Go to Varsity Mall'),
        icon: const Icon(Icons.location_on),
      ),
    );
  }

  Future<void> _goToUUM() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kUUM));
  }
}
