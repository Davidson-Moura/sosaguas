import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import '../models/reports/report.dart';
import '../storages/report_storage.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreen createState() => _MapScreen();
}
class _MapScreen extends State<MapScreen>{
  late GoogleMapController mapController;
  late Future<List<Report>> reports = ReportStorage().GetAll();
  Set<Marker> _markers = {};

  final LatLng _initialPosition = LatLng(-22.85198603239048, -43.34481351078501);

  @override
  void initState() {
    super.initState();
    reports = ReportStorage().GetAll();
  }

  Set<Marker> _createMarkers(List<Report> reports) {
    Set<Marker> markers = {
      Marker(
        markerId: MarkerId('initialPosition'),
        position: _initialPosition,
        infoWindow: InfoWindow(title: 'Localização Inicial'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      )
    };

    for (var report in reports) {
      markers.add(
        Marker(
          markerId: MarkerId(report.id.toString()), // ID único para cada marcador
          position: LatLng(report.lat, report.lng),
          infoWindow: InfoWindow(title: report.title),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            report.reportType == ReportType.Flood ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue,
          ),
        ),
      );
    }

    _markers = markers;

    return _markers;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Report>>(
        future: reports,
        builder: (context, snapshot) {
          _markers = _createMarkers(snapshot.data!);

          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
            markers: _markers,
          );
        }
    );
  }

}