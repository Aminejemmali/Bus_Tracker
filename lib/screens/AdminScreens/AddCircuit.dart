import 'package:bustrackerapp/models/Bus.dart';
import 'package:bustrackerapp/models/ciruit.dart';
import 'package:bustrackerapp/screens/AdminScreens/AdminHome.dart';
import 'package:bustrackerapp/screens/AdminScreens/circuit.dart';
import 'package:flutter/material.dart';// Import your Station model
import 'package:bustrackerapp/db_Functions/db_helper.dart'; // Import your DatabaseHelper

class AddCircuit extends StatefulWidget {
  const AddCircuit({Key? key}) : super(key: key);
  static String id = '/AddCircuit';

  @override
  _AddCircuit createState() => _AddCircuit();
}

class _AddCircuit extends State<AddCircuit> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
 // final _modelController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
   // _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Circuit')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Circuit Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Circuit Name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              /*TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Bus Model'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Bus Model.';
                  }
                  return null;
                },
              ),*/
            // const SizedBox(height: 10.0),

              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addcircuit();
                  }
                },
                child: const Text('Add Circuit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addcircuit() async {
    final circuit =Circuit(
    name: _nameController.text );
    try {
      await DatabaseHelper.addCircuit(circuit);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ciruit "${circuit.name}" added successfully!'),
        ),
      );

      Navigator.pushNamed(context, CircuitPage.id);// Assuming you want to dismiss the form
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add ciruit. Please try again.'),
        ),
      );
    }
  }
}