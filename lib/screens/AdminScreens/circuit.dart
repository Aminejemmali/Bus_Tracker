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
                subtitle: FutureBuilder<List<int>>(
                  future: DatabaseHelper.getStationIdsForCircuit(circuit.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final stationIds = snapshot.data ?? [];
                      return Text('Ids: ${stationIds.join(', ')}');
                    }
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Implement navigation to edit page
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Implement delete functionality
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
          // Implement navigation to add circuit page
          Navigator.of(context).pushNamed('/AddCircuit');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
