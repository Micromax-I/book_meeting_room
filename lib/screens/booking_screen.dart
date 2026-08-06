import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/cab_model.dart';
import '../widget/common_app_bar.dart';

class BookingScreen extends StatefulWidget {
  final CabModel cabModel;

  const BookingScreen({super.key, required this.cabModel});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.cabModel.vehiclenumber,
        showBack: false,
      ),
      body: Expanded(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(28.6139, 77.2090),
            zoom: 14,
          ),
        ),
      )
    );
  }
}
