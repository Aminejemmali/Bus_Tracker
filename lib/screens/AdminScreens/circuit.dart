import 'package:flutter/material.dart';
import 'package:bustrackerapp/models/circuit.dart';  // Ensure this is the correct import path for your Circuit model
import 'package:bustrackerapp/db_functions/db_helper.dart'; // Update with your actual import path

class CircuitPage extends StatefulWidget {
  static const String id = '/CircuitPage';

  @override
  _CircuitPageState createState() => _CircuitPageState();
}

class _CircuitPageState extends State<CircuitPage> {
  List<Circuit> _circuits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCircuits();
  }

  Future<void> _loadCircuits() async {
    try {
      final circuits = await DatabaseHelper.getCircuits();  // Make sure this method is correctly implemented in your DatabaseHelper
      setState(() {
        _circuits = circuits;
        _isLoading = false;
      });
    } catch (e) {
      // Handle exceptions
      print(e);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circuits disponibles'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _circuits.length,
        itemBuilder: (context, index) {
          final circuit = _circuits[index];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(circuit.name),
                subtitle: FutureBuilder<List<String>>(
                  future: DatabaseHelper.getStationNamesForCircuit(circuit.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final stationNames = snapshot.data ?? [];
                      return Text('Stations: ${stationNames.join(', ')}');
                    }
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Delete"),
                              content: Text("Are you sure you want to delete this circuit?"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("Delete"),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    try {
                                      await DatabaseHelper.deleteCircuit(circuit.id);
                                      setState(() {
                                        _circuits.removeAt(index);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Circuit deleted successfully.'),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to delete the circuit.'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
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
          Navigator.of(context).pushNamed('/AddCircuit');
        },
        child: Icon(Icons.add),
      ),
    );
  }}