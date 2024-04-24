import 'package:flutter/material.dart';
import 'package:bustrackerapp/db_Functions/db_helper.dart';
import 'package:bustrackerapp/models/BusSchedule.dart';
import 'package:bustrackerapp/models/Bus.dart';
import 'package:bustrackerapp/models/circuit.dart'; // Import Circuit model

class BusPage extends StatefulWidget {
  static const String id = '/BusPage';
  final int? stationId;

  const BusPage({Key? key, required this.stationId}) : super(key: key);

  @override
  _BusPageState createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  bool _isLoading = false;
  late List<Bus> _buses;
  late List<Circuit> _circuits; // List of circuits
  int _selectedBusId = -1;
  int _selectedCircuitId = -1; // Default value for selected circuit
  final _arrivaltime = TextEditingController();
  final _departuretime = TextEditingController();

  @override
  void initState() {
    super.initState();
    _buses = [];
    _circuits = []; // Initialize circuits
    _loadBuses();
    _loadCircuits(); // Load circuits
  }

  Future<void> _loadBuses() async {
    try {
      final buses = await DatabaseHelper.getBuses();
      setState(() {
        _buses = buses;
      });

      if (_buses.isNotEmpty) {
        _selectedBusId = _buses.first.id!;
      } else {
        _selectedBusId = -1;
      }
    } catch (error) {
      print('Erreur de chargement des bus: $error');
    }
  }

  Future<void> _loadCircuits() async {
    try {
      final circuits = await DatabaseHelper.getCircuits();
      setState(() {
        _circuits = circuits;
      });

      if (_circuits.isNotEmpty) {
        _selectedCircuitId = _circuits.first.id!;
      } else {
        _selectedCircuitId = -1;
      }
    } catch (error) {
      print('Error loading circuits: $error');
    }
  }
  Future<void> _addBusSchedule(int selectedBusId) async {
    if (_arrivaltime.text.isEmpty || _departuretime.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Veuillez sélectionner à la fois l'heure d'arrivée et de départ."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Check if a circuit has been selected
    if (_selectedCircuitId == -1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Veuillez sélectionner un circuit."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseHelper.addBusSchedule(
        BusSchedule(
          stationId: widget.stationId!,
          busId: selectedBusId,
          circuitId: _selectedCircuitId,
          arrivalTime: _arrivaltime.text,
          departureTime: _departuretime.text,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Horaire de bus ajouté avec succès"),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Échec de l'ajout de l'horaire de bus"),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Horaires de bus'),
    ),
    body: _isLoading
    ? Center(child: CircularProgressIndicator())
        : Column(
    children: [
    DropdownButton<int>(
    value: _selectedBusId,
    onChanged: (int? value) {
    setState(() {
    _selectedBusId = value!;
    });
    },
    items: _buses.map((bus) {
    return DropdownMenuItem<int>(
    value: bus.id!,
    child: Text(bus.registrationNumber),
    );
    }).toList(),
    ),
    DropdownButton<int>(
    value: _selectedCircuitId,
    onChanged: (int? value) {
    setState(() {
    _selectedCircuitId = value!;
    });
    },
    items: _circuits.map((circuit) {
    return DropdownMenuItem<int>(
    value: circuit.id!,
    child: Text(circuit.name), // Assuming 'name' is a property of Circuit
    );
    }).toList(),
    ),
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text('Heure darrivée'),
    TextField(
    controller: _arrivaltime,
    onTap: () async {
    TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
    _arrivaltime.text = selectedTime.format(context);
    }
    },
    ),
    SizedBox(height: 16.0),
    Text('Heure de départ'),
    TextField(
    controller: _departuretime,
    onTap: () async {
    TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
    _departuretime.text = selectedTime.format(context);
    }
    },
    ),
    ],
    ),
    ElevatedButton(
    onPressed: () {
    _addBusSchedule(_selectedBusId);
    },
    child: Text('Ajouter un horaire'),
    ),
    Expanded(
    child: FutureBuilder<List<BusSchedule>>(
    future: DatabaseHelper.getBusSchedulesForStation(widget.stationId!),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return Center(child: Text('Aucun horaire de bus disponible'));
    } else {
    List<BusSchedule> schedules = snapshot.data!;
    return ListView.builder(
    itemCount: schedules.length,
    itemBuilder: (context, index) {
    final schedule = schedules[index];
    return Padding(
    padding: EdgeInsets.all(8.0),
    child: Card(
    elevation: 4,
      child: ListTile(
        title: Text('Bus ${schedule.busId} - Circuit ${schedule.circuitId}'),
        subtitle: Text('Arrival: ${schedule.arrivalTime}, Departure: ${schedule.departureTime}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            await DatabaseHelper.deleteBusSchedule(schedule.id!);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Schedule deleted successfully'),
            ));
            setState(() {}); // Refresh the list after deletion
          },
        ),
      ),
    ),
    );
    },
    );
    }
    },
    ),
    ),
    ],
    ),
    );
  }
}