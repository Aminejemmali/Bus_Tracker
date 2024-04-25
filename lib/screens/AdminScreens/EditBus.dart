import 'package:bustrackerapp/db_Functions/db_helper.dart';
import 'package:bustrackerapp/models/bus.dart';
import 'package:bustrackerapp/models/station.dart';
import 'package:bustrackerapp/screens/AdminScreens/AdminHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/sanitizers.dart';

class EditBusForm extends StatefulWidget {
  static const String id = '/EditBusForm';
  final int? busId;

  const EditBusForm({Key? key, required this.busId}) : super(key: key);

  @override
  _EditBusFormState createState() => _EditBusFormState();
}

class _EditBusFormState extends State<EditBusForm> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _modelController = TextEditingController();
  final _altController = TextEditingController();
  final _lagController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadbus();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _modelController.dispose();
    _altController.dispose();
    _lagController.dispose();
    super.dispose();
  }

  Future<void> loadbus() async {
    try {
      final station = await DatabaseHelper.getBusById(widget.busId);
      if (station != null) {
        _numberController.text = station.registrationNumber;
        _modelController.text = station.model;
        _altController.text= station.Alt.toString();
        _lagController.text=station.Lag.toString();


      } else {
        print('Bus non trouvé pour lID: ${widget.busId}');
      }
    } catch (e) {
      print('Erreur de chargement du bus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le bus')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Numéro de bus'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un numéro de bus.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Modèle de bus'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un modèle de bus.';
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
              const SizedBox(height: 10.0),

              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _editBus();
                  }
                },
                child: const Text('Enregistrer les modifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editBus() async {
    final bus = Bus(
      id: widget.busId,
      registrationNumber: _numberController.text,
      model: _modelController.text,
      Alt: toFloat(_altController.text),
      Lag: toFloat(_lagController.text),

    );
    try {
      await DatabaseHelper.editBus(
        bus.id!,
        bus.registrationNumber,
        bus.model,
        bus.Alt,
        bus.Lag

      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bus  "${bus.registrationNumber}"mis à jour avec succès!'),
        ),

      );
      Navigator.pushNamed(context, AdminHomeScreen.id);// Assuming you want to dismiss the form
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de la mise à jour du bus. Veuillez réessayer'),
        ),
      );
    }
  }
}
