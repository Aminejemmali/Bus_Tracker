import 'package:flutter/material.dart';
import 'package:bustrackerapp/models/circuit.dart';
import 'package:bustrackerapp/models/station.dart'; // Import your Station model
import 'package:bustrackerapp/db_Functions/db_helper.dart'; // Import your DatabaseHelper
import 'package:bustrackerapp/screens/AdminScreens/circuit.dart';

class AddCircuit extends StatefulWidget {
  const AddCircuit({Key? key}) : super(key: key);
  static String id = '/AddCircuit';

  @override
  _AddCircuit createState() => _AddCircuit();
}

class _AddCircuit extends State<AddCircuit> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  List<Station> _stations = [];
  List<int> _selectedStations = [];

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadStations() async {
    final stations = await DatabaseHelper.getStations(); // Implement this method to fetch stations
    setState(() {
      _stations = stations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un circuit')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom du circuit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un nom de circuit.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Text('Sélectionnez les stations:', style: Theme.of(context).textTheme.subtitle1),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _stations.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_stations[index].name),
                    value: _selectedStations.contains(_stations[index].id),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedStations.add(_stations[index].id!);
                        } else {
                          _selectedStations.remove(_stations[index].id);
                        }
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addCircuit();
                  }
                },
                child: const Text('Ajouter un circuit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCircuit() async {
    final circuit = Circuit(name: _nameController.text);
    try {
      // Add the circuit to the circuits table and get back the new circuit ID
      final circuitId = await DatabaseHelper.addCircuit(circuit);
      if (circuitId == null) {
        throw Exception("Failed to add circuit, no ID returned.");
      }

      // Add the selected stations to the circuitstations table
      await DatabaseHelper.addCircuitStation(circuitId, _selectedStations);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Circuit "${circuit.name}" ajouté avec succès !'),
        ),
      );

      // Assuming you want to navigate to the CircuitPage after addition
      Navigator.pushNamed(context, CircuitPage.id);
    } catch (e) {
      print('Error when adding a circuit: $e'); // Log error to console for better debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de l\'ajout du circuit. Veuillez réessayer. Error: $e'),
        ),
      );
    }
  }

}
