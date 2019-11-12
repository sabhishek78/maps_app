import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
// When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MapSample(),
// When navigating to the "/second" route, build the SecondScreen widget.
        '/searchpage': (context) => SearchListExample(),

      },
      title: 'Flutter Google Maps Demo',
     // home: MapSample(),
    );
  }
}


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}
Future<String> loadCitiesFromAssets() async {
  return await rootBundle.loadString('assets/cities.json');
}
Future loadCities() async {
  String jsonString = await loadCitiesFromAssets();
  jsonResponse = json.decode(jsonString);

}

List<Map> jsonResponse;
class MapSampleState extends State<MapSample> {
  @override
  void initState() {
    super.initState();
    loadCities();

  }


  int index=0;
  final Set<Marker> _markers = {};

  Completer<GoogleMapController> _controller = Completer();
  LatLng _lastMapPosition = LatLng(12.9716,77.5946); // starting point bengaluru
  List<String>cityNames=['Bangalore','Mumbai','Delhi','Chennai','Kolkata','Jaipur'];
  List<double>latitude=[12.9716,19.0760,28.7041,13.0827,22.5726,26.9124];
  List<double>longitude=[77.5946,72.8777,77.1025,80.2707,88.3639,75.7873];
  List<LatLng>cityCoordinates=[LatLng(12.9716,77.5946),LatLng(19.0760,72.8777),LatLng(28.7041,77.5946),LatLng(13.0827,80.2707),LatLng(22.5726,88.3639),LatLng(26.9124,75.7873),];
  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'This is a Title',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }
  _onSearchButtonPressed() {
    Navigator.pushNamed(context, '/searchpage');
  }
  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }
  Widget buildBody(BuildContext ctxt, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),

      child: ListTile(

          title: Text(cityNames[index]),
          onTap: () {
            _nextCity(index);
            print(index);
          }
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child:
            Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.hybrid,
                  markers: _markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude[0],longitude[0]), zoom: 8,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget>[
                        button(_onSearchButtonPressed, Icons.search),
                        button(_onAddMarkerButtonPressed, Icons.add_location),
                        SizedBox(
                          height: 16.0,
                        ),

                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),

        ],
      ),





    );
  }

  Future<void> _nextCity(int index) async {
    // if(index==6){
    //  index=0;// reset city index
    //  }
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: cityCoordinates[index], zoom: 8,
    )));
    _lastMapPosition=cityCoordinates[index];

  }
}

