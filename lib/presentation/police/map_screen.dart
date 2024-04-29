import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  
  static const _initialCameraPosition = CameraPosition(target: LatLng(19.1951, 72.9772), zoom: 17);

  late GoogleMapController _googleMapController;
  final Set<Marker> markers = {};

  @override
  void initState() {
    addMarkers();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  void addMarkers() {
    List<Map<String, dynamic>> locations = [
      {"name": "Mulund", "lat": 19.17751, "lng": 72.95188},
      {"name": "Navghar Mulund East", "lat": 19.16916, "lng": 72.96856},
      {"name": "Thane Nagar", "lat": 19.19518, "lng": 72.97727},
      {"name": "Naupada", "lat": 19.19567, "lng": 72.96835},
      {"name": "Railway Thane", "lat": 19.18918, "lng": 72.97607},
      {"name": "Rabale (MIDC)", "lat": 19.15139, "lng": 73.00148},
      {"name": "Rabale Thane-Belapur", "lat": 19.13955, "lng": 73.00199},
      {"name": "Powai", "lat": 19.11977, "lng": 72.89952},
      {"name": "Ghatkopar", "lat": 19.08752, "lng": 72.90002},
      {"name": "Kolsewadi Kalyan", "lat": 19.23054, "lng": 73.14661},
      {"name": "Khadakpada", "lat": 19.25939, "lng": 73.14335},
      {"name": "Dombivali", "lat": 19.21685, "lng": 73.08673},
      {"name": "Ambarnath West", "lat": 19.21142, "lng": 73.18926},
      {"name": "Bhandup", "lat": 19.15160, "lng": 72.93649},
      {"name": "Borivali", "lat": 19.22973, "lng": 72.85598},
    ];

    Future<void> openGoogleMaps(double latitude, double longitude) async {
      String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      final Uri url = Uri.parse(googleUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not open the map.';
      }
    }

    for (var location in locations) {
      markers.add(
        Marker(
          markerId: MarkerId(location["name"]),
          position: LatLng(location["lat"], location["lng"]),
          infoWindow: InfoWindow(
            title: location["name"] + "Police Station",
          ),
          onTap: () {
            openGoogleMaps(location["lat"], location["lng"]);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true, initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition)), child: const Icon(Icons.location_searching_rounded),),
    );
  }
}
