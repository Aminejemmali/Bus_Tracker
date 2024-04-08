import 'package:bustrackerapp/screens/AdminScreens/EditBus.dart';
import 'package:flutter/material.dart';
import 'package:bustrackerapp/models/Bus.dart';
import 'package:bustrackerapp/db_Functions/db_helper.dart'; // Update with your actual import path
// Import your Bus edit and add pages

class BusesPage extends StatefulWidget {
  static const String id = '/BusesPage';

  @override
  _BusesPageState createState() => _BusesPageState();
}

class _BusesPageState extends State<BusesPage> {
  List<Bus> _buses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBuses();
  }

  Future<void> _loadBuses() async {
    try {
      final buses = await DatabaseHelper.getBuses(); // Implement this method
      setState(() {
        _buses = buses;
        _isLoading = false;
      });
    } catch (e) {
      // Handle exceptions
      print(e);
      setState(() => _isLoading = false);
    }
  }

  Future<void> deletebus(int? id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this bus?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });
                try {
                  await DatabaseHelper.deletebus(id);
                  _loadBuses();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Buses'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _buses.length,
        itemBuilder: (context, index) {
          final bus = _buses[index];
          return Padding(
              padding: EdgeInsets.all(8.0),
          child:Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(bus.registrationNumber),
              subtitle: Text('Model: ${bus.model}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
          Navigator.pushNamed(
          context,
          EditBusForm.id,
          arguments: bus.id,
          );

                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deletebus(bus.id)
                  ),
                ],
              ),
            ),
          ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/AddBus');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
