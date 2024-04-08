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
        print('Station not found for ID: ${widget.stationId}');
      }
    } catch (e) {
      print('Error loading station: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Station')),
      body: Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20),
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Station Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a station name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Station Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a station address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Station Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a station location.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _altController,
                decoration: const InputDecoration(labelText: 'Station ALT'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a station alt.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _lagController,
                decoration: const InputDecoration(labelText: 'Station LAG'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a station lag.';
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
                child: const Text('Save Changes'),
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
          content: Text('Station "${station.name}" updated successfully!'),
        ),

      );
      Navigator.pushNamed(context, AdminHomeScreen.id);// Assuming you want to dismiss the form
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update station. Please try again.'),
        ),
      );
    }
  }
}
