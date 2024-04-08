import 'package:bustrackerapp/models/Bus.dart';
import 'package:bustrackerapp/screens/AdminScreens/AdminHome.dart';
import 'package:flutter/material.dart';// Import your Station model
import 'package:bustrackerapp/db_Functions/db_helper.dart'; // Import your DatabaseHelper

class AddBus extends StatefulWidget {
  const AddBus({Key? key}) : super(key: key);
  static String id = '/AddBus';

  @override
  _AddBus createState() => _AddBus();
}

class _AddBus extends State<AddBus> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _modelController = TextEditingController();


  @override
  void dispose() {
    _numberController.dispose();
    _modelController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bus')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Bus Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Bus Registred Number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Bus Model'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Bus Model.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),

              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addbus();
                  }
                },
                child: const Text('Add Bus'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addbus() async {
    final bus =Bus(id: 0,
        registrationNumber: _numberController.text,
        model: _modelController.text
    );
    try {
      await DatabaseHelper.addbus(bus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bus "${bus.registrationNumber}" added successfully!'),
        ),
      );

      Navigator.pushNamed(context, AdminHomeScreen.id);// Assuming you want to dismiss the form
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add station. Please try again.'),
        ),
      );
    }
  }
}