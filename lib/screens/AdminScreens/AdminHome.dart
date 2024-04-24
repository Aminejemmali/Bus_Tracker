import 'package:bustrackerapp/screens/AdminScreens/circuit.dart';
import 'package:bustrackerapp/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:bustrackerapp/models/station.dart';
import 'package:bustrackerapp/db_Functions/db_helper.dart';
import 'BusPage.dart';
import 'EditStation.dart';
import 'AddStation.dart';

class AdminHomeScreen extends StatefulWidget {
  static const String id = '/AdminHomeScreen';

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Station> _stations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadStations();
  }

  Future<void> loadStations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stations = await DatabaseHelper.getStations();
      setState(() {
        _stations = stations;
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteStation(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer cette station ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });
                try {
                  await DatabaseHelper.deleteStation(id);
                  loadStations();
                } catch (error) {
                  print(error);
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: const Color(0xFFFFC25C),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            backgroundColor: const Color(0xFFFFC25C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Stations'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement search functionality here
              },
            ),
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                // Implement sorting functionality here
              },
            ),
            IconButton(
              icon: Icon(Icons.directions_bus),
              onPressed: () {
                // Navigate to the buses page
                Navigator.of(context).pushNamed('/BusesPage');
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFFFC25C),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.route),
                title: Text('Circuit'),
                onTap: () {
                  Navigator.pushNamed(context, CircuitPage.id);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, LoginPage.id);
                },
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 20,),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _stations.isEmpty
                  ? Center(
                child: Text('Aucune station disponible. Ajoutez-en quelques-unes!'),
              )
                  : ListView.builder(
                itemCount: _stations.length,
                itemBuilder: (context, index) {
                  final station = _stations[index];
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(station.name),
                        subtitle: Text(station.address),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.bus_alert),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  BusPage.id,
                                  arguments: station.id,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  EditStationForm.id,
                                  arguments: station.id,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                deleteStation(station.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddStationForm.id);
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFFFFC25C),
        ),
      ),
    );
  }
}