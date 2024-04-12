import 'package:bustrackerapp/screens/AdminScreens/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:bustrackerapp/models/station.dart'; // Import your Station model
import 'package:bustrackerapp/db_Functions/db_helper.dart';
import 'package:validators/sanitizers.dart'; // Import your DatabaseHelper

class AddStationForm extends StatefulWidget {
  const AddStationForm({Key? key}) : super(key: key);
  static String id = '/AddStationForm';

  @override
  _AddStationFormState createState() => _AddStationFormState();
}

class _AddStationFormState extends State<AddStationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _locationController = TextEditingController();
  final _altController = TextEditingController();
  final _lagController = TextEditingController();



  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    _altController.dispose();
    _lagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une station')),
      body: Form(
        key: _formKey,

          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(20),
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom de la station'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un nom de station.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Adresse de la station'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une adresse de station.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Emplacement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un emplacement.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _altController,
                decoration: const InputDecoration(labelText: 'Altitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une altitude.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _lagController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une longitude.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addStation();
                  }
                },
                child: const Text('Ajouter une station'),
              ),
            ],
          ),
        ),

    );
  }

  void _addStation() async {
    final station = Station(
      name: _nameController.text,
      address: _addressController.text,
      location: _locationController.text,
      Alt: toFloat(_altController.text),
      Lag: toFloat(_lagController.text),
    );
    try {
      await DatabaseHelper.addStation(station);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Station "${station.name}"ajouté avec succès !'),
        ),
      );

      Navigator.pushNamed(context, AdminHomeScreen.id);// Assuming you want to dismiss the form
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de lajout de la station. Veuillez réessayer.'),
        ),
      );
    }
  }
}