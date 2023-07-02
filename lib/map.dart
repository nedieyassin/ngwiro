import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ngwiro/service/data_store.dart';

class CenterMap extends StatefulWidget {
  const CenterMap({super.key});

  @override
  State<CenterMap> createState() => CenterMapState();
}

class CenterMapState extends State<CenterMap> {
  DataStore store = DataStore();
  Set<Marker> markers = {};
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kSalimaCords = CameraPosition(
    target: LatLng(-13.77952531821596, 34.4587470714553),
    zoom: 10,
  );

  @override
  void initState() {
    super.initState();
    getMarkers();
  }

  getMarkers() async {
    var hcs = await store.getHealthCenters();
    setState(() {
      markers.addAll(hcs!
          .where((hc) => hc['lat'] != null && hc['long'] != null)
          .map<Marker>((hc) {
        return Marker(
          markerId: MarkerId('${hc['id']}'),
          position: LatLng(
            double.tryParse(hc['lat']) ?? 0,
            double.tryParse(hc['long']) ?? 0,
          ),
          infoWindow: InfoWindow(title: hc['name'], snippet: hc['phone_number']),
          icon: BitmapDescriptor.defaultMarker,
        );
      }).toSet());
    });
    // });
  }

  // -13.77952531821596, 34.4587470714553

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Centers'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kSalimaCords,
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Colors.white,
                child: FutureBuilder(
                    future: store.getHealthCenters(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                            children: ((snap.data ?? []) as List)
                                .map((hc) => ListTile(
                                      onTap: () {},
                                      title: Text(hc['name']),
                                      subtitle: Text(
                                          '${hc['district']['name']} - ${hc['phone_number']}'),
                                      trailing: IconButton(
                                        onPressed: () {
                                          if (hc['lat'] != null &&
                                              hc['long'] != null) {
                                            _goTo(
                                              lat: double.tryParse(hc['lat']),
                                              lng: double.tryParse(hc['long']),
                                            );
                                            Navigator.pop(context);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.location_searching_outlined,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        );
                      }

                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text('No data available'),
                        ),
                      );
                    }),
              );
            },
          );
        },
        label: const Text('Health Centers'),
        icon: const Icon(Icons.location_on),
      ),
    );
  }

  Future<void> _goTo({lat = 0, lng = 0}) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition location = CameraPosition(
      bearing: 0,
      target: LatLng(lat, lng),
      zoom: 19.151926040649414,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(location));
  }
}
