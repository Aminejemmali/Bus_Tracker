import 'package:bustrackerapp/db_Functions/db_helper.dart';
import 'package:bustrackerapp/models/station.dart';
import 'package:bustrackerapp/screens/AdminScreens/AdminHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/sanitizers.dart';

class EditStationForm extends StatefulWidget {
  static const String id = '/EditStationForms';
  final int? stationId;

  const EditStationForm({Key? key, required this.stationId}) : super(key: key);

  @override
  _EditStationFormState createState() => _EditStationFormState();
}

class _EditStationFormState extends State<EditStationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _locationController = TextEditingController();
  final _altController = TextEditingController();
  final _lagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadStation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    _altController.dispose();
    _lagController.dispose();
    super.dispose();
  }

  Future<void> loadStation() async {
    try {
      final station = await DatabaseHelper.getStationById(widget.stationId);
      if (station != null) {
        _nameController.text = station.name;
        _addressController.text = station.address;
        _locationController.text = station.location;
        _altController.text= station.Alt.toString();
        _lagController.text=station.Lag.toString();
      } else {
        print('"Station non trouvée pour lidentifiant: ${widget.stationId}');
      }
    } catch (e) {
      print('Erreur de chargement de la station: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier la station')),
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
                decoration: const InputDecoration(labelText: 'Station localisation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une localisation de station.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _altController,
                decoration: const InputDecoration(labelText: 'Station altitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une altitude de station.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _lagController,
                decoration: const InputDecoration(labelText: 'Station longitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une longitude de station.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _editStation();
                  }
                },
                child: const Text('Enregistrer les modifications'),
              ),
            ],
          ),
        ),

    );
  }

  void _editStation() async {
    final station = Station(
      id: widget.stationId,
      name: _nameController.text,
      address: _addressController.text,
      location: _locationController.text,
      Alt: toFloat(_altController.text),
      Lag: toFloat(_lagController.text),
    );
    try {
      await DatabaseHelper.editStation(
        station.id!,
        station.name,
        station.location,
        station.address,
        station.Alt,
        station.Lag
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Station "${station.name}" Mis à jour avec succès!'),
        ),

      );
      Navigator.pushNamed(context, AdminHomeScreen.id);// Assuming you want to dismiss the form
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de la mise à jour de la station. Veuillez réessayer'),
        ),
      );
    }
  }
}
