import 'package:bustrackerapp/db_Functions/db_helper.dart';
import 'package:bustrackerapp/models/Bus.dart';
import 'package:bustrackerapp/models/station.dart';
import 'package:bustrackerapp/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';

class HomeScreen extends StatefulWidget {
  static String id = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class MarkerData {
  final LatLng location;
  final String name;
  final String type;

  MarkerData(this.location, this.name, this.type);
}

class _HomeScreenState extends State<HomeScreen> {
  List<Station> _stations = [];
  List<Bus> _buses = [];
  List<MarkerData> _Stationsmarkers = [];
  List<MarkerData> _Busesmarkers = [];
  bool _isLoading = false;
  Position? _currentPosition;
  double _currentZoom = 13.0;

  // Add a state variable to store location properties
  String _latitude = "";
  String _longitude = "";
  String _altitude = "";

  Future<void> loadStations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<Station> stations = await DatabaseHelper.getStations();
      final List<MarkerData> marks = stations.map((station) {
        return MarkerData(
            LatLng(station.Alt, station.Lag), station.name, 'station');
      }).toList();

      setState(() {
        _stations =
            stations; // Assuming you want to keep a list of Station objects
        _Stationsmarkers.clear(); // Clear existing markers
        _Stationsmarkers.addAll(marks); // Add new markers from stations
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadBuses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<Bus> buses = await DatabaseHelper.getBuses();
      final List<MarkerData> marks = buses.map((bus) {
        return MarkerData(
            LatLng(bus.Alt, bus.Lag), bus.registrationNumber, 'bus');
      }).toList();

      setState(() {
        _buses = buses; // Assuming you want to keep a list of Bus objects
        _Busesmarkers.clear(); // Clear existing markers
        _Busesmarkers.addAll(marks); // Add new markers from buses
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    loadStations();
    loadBuses();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, cannot proceed.
        return;
      }
    }

    // Check if location services are enabled.
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      // Location services are not enabled, show an alert dialog or directly open app settings
      // For a better user experience, you could first show a dialog explaining why you need them to turn on GPS
      // and then lead them to the settings if they agree.
      _showLocationServiceDialog();
    } else {
      _determinePosition();
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Services de localisation désactivés"),
          content: Text(
              "Veuillez activer les services de localisation pour utiliser cette fonctionnalité."),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Paramétres"),
              onPressed: () {
                AppSettings.openAppSettings(type: AppSettingsType.location);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Handle the case where services are disabled (suggest enabling, etc.).
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update location properties when position is available
      if (_currentPosition != null) {
        setState(() {
          _latitude = _currentPosition!.latitude.toStringAsFixed(4);
          _longitude = _currentPosition!.longitude.toStringAsFixed(4);
          _altitude = _currentPosition!.altitude.toStringAsFixed(2);
        });
      }
    } catch (e) {
      print(e); // Handle any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(40),
          children: [
            ListTile(
              title: Text(
                "Paramétres",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              leading: Icon(Icons.settings),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "Déconnexion",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              leading: Icon(Icons.logout),
              onTap: () {
                Navigator.pushReplacementNamed(context, LoginPage.id);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Bus Tracker"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadStations();
              loadBuses();
              _determinePosition(); // Refresh the stations when the button is pressed
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(), // Show loading indicator
      )
          : FlutterMap(
        options: MapOptions(
          // Use the current position if available, otherwise use a default location
          center: _currentPosition != null
              ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
              : LatLng(35.8239, 10.6145),
          zoom: _currentZoom,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.bustrackerapp',
          ),
          MarkerLayer(
            markers: [
              // Show marker at current position (if available)
              if (_currentPosition != null)
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: LatLng(
                      _currentPosition!.latitude, _currentPosition!.longitude),
                  child: Icon(Icons.location_pin, color: Colors.red),
                ),
              // Add additional markers with green color for stations
              for (final stationMarker in _Stationsmarkers)
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: stationMarker.location,
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          stationMarker.name,
                          style: TextStyle(fontSize: 12.0, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        color: Colors.yellow,
                        padding: EdgeInsets.all(4.0),
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.lightGreen,
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
              // Add additional markers with blue color for buses
              for (final busMarker in _Busesmarkers)
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: busMarker.location,
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          busMarker.name,
                          style: TextStyle(fontSize: 12.0, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        color: Colors.yellow,
                        padding: EdgeInsets.all(4.0),
                      ),
                      Icon(
                        Icons.directions_bus,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentZoom += 1.0;
            // Increase zoom level on tap
          });
        },
        child: Icon(Icons.zoom_in),
      ),
      // Display location properties below the map (optional)
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          color: const Color(0xFFFFC25C),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Latitude: $_latitude'),
              Text('Longitude: $_longitude'),
              Text('Altitude: $_altitude m'),
            ],
          ),
        ),
      ),
    );
  }
}