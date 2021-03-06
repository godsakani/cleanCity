import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTrash extends StatefulWidget {
  @override
  _MapTrashState createState() => _MapTrashState();
}

class _MapTrashState extends State<MapTrash> {
  Set<Marker> yourMarkers = {};
  ///defining the map Controller
  late GoogleMapController myController;

  ///setting the marker
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  //Creating a method for the marker
  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(specify['location'].latitude, specify['location'].longitude),
        infoWindow: InfoWindow(title: 'Trash', snippet: specify['address']));

    ///setting the state of the method
    setState(() {
      markers[markerId] = marker;
    });
  }

  //getting location from firebase

  getMarkerData() async {
    QuerySnapshot firestorDoc =
        await FirebaseFirestore.instance.collection("data").get();
    // DocumentSnapshot firebaseData = firestor.data.docs();
    ///list to hold the loop
    List<DocumentSnapshot> firebaseDocument = firestorDoc.docs;

    ///looping through the list
    for (int i = 0; i < firebaseDocument.length; i++) {

      ///print("data from firesote is ${firebaseDocument[i]["location"].latitude}");

      ///Getting the markers
      MarkerId markerId = MarkerId(firebaseDocument[i].id);
      yourMarkers.add(
        Marker(
          markerId: markerId,
          position: LatLng(firebaseDocument[i]["location"].latitude,
              firebaseDocument[i]["location"].longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: firebaseDocument[i]["addresses"]),
        ),
      );

      /// print("your markers set is : $yourMarkers");
      setState(() {});
    }
  }

  ///Getting the main branch of the children widget
  void initState() {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Setting the markers
    Set<Marker> setMarkers() {
      return yourMarkers;
    }
/*
    Set<Marker> getMarker() {
      return <Marker>[
        Marker(
            markerId: MarkerId("Rest Locate"),
            position: LatLng(4.161385512444317, 9.287080154746542),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'Rest'))
      ].toSet();
    }

 */

    return Scaffold(
        body: GoogleMap(
          markers: setMarkers(),
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(4.161385512444317, 9.287080154746542),
            zoom: 14.0,
          ),
          //calling the controller
          onMapCreated: (GoogleMapController controller) {
            myController = controller;
          },
        )
    );
  }
}
