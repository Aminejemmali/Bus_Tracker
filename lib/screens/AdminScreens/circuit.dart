import 'package:bustrackerapp/models/ciruit.dart';
import 'package:bustrackerapp/screens/AdminScreens/EditBus.dart';
import 'package:flutter/material.dart';
import 'package:bustrackerapp/models/Bus.dart';
import 'package:bustrackerapp/db_Functions/db_helper.dart'; // Update with your actual import path
// Import your Bus edit and add pages

class CircuitPage extends StatefulWidget {
  static const String id = '/CiruitPage';

  @override
  _CircuitPageState createState() => _CircuitPageState();
}

class _CircuitPageState extends State<CircuitPage> {
  List<Circuit> _circuits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCiruits();
  }

  Future<void> _loadCiruits() async {
    try {
      final ciruits = await DatabaseHelper.getCiruits(); // Implement this method
      setState(() {
        _circuits = ciruits;
        _isLoading = false;
      });
    } catch (e) {
      // Handle exceptions
      print(e);
      setState(() => _isLoading = false);
    }
  }

 /* Future<void> deletebus(int? id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce bus ?'),
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ciruit disponibles'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _circuits.length,
        itemBuilder: (context, index) {
          final circuit = _circuits[index];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child:Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(circuit.name),
                subtitle: Text('Id: ${circuit.id}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {


                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => {}
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
