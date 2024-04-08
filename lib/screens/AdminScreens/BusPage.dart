import 'package:flutter/material.dart';
import 'package:bustrackerapp/db_Functions/db_helper.dart';
import 'package:bustrackerapp/models/BusSchedule.dart';
import 'package:bustrackerapp/models/Bus.dart';

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
  int _selectedBusId = -1;
  final _arrivaltime = TextEditingController();
  final _departuretime = TextEditingController();// Default value for the selected bus ID

  @override
  void initState() {
    super.initState();
    _buses = []; // Initialize _buses as an empty list
    _loadBuses(); // Load the list of buses
  }

  Future<void> _loadBuses() async {
    try {
      final buses = await DatabaseHelper.getBuses(); // Assume this method retrieves a list of buses
      setState(() {
        _buses = buses;
      });

      // Set default value for _selectedBusId if buses list is not empty
      if (_buses.isNotEmpty) {
        _selectedBusId= _buses.first.id!;
      } else {
        _selectedBusId = -1;
      }
    } catch (error) {
      print('Error loading buses: $error');
    }
  }



  Future<void> _addBusSchedule(int selectedBusId) async {
    // Check if the arrival and departure times have been set
    if (_arrivaltime.text.isEmpty || _departuretime.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please select both arrival and departure times."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return; // Exit the function if any of the fields are empty
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseHelper.addBusSchedule(
        BusSchedule(
          stationId: widget.stationId!,
          busId: selectedBusId,
          arrivalTime: _arrivaltime.text, // Use .text to get the string
          departureTime: _departuretime.text, // Use .text to get the string
        ),
      );
      // Assuming you want to do something after successfully adding the schedule
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Bus schedule added successfully"),
      ));
    } catch (error) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to add bus schedule"),
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
        title: Text('Bus Schedules'),
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
                value: bus.id, // Assuming bus.id is unique
                child: Text(bus.registrationNumber),
              );
            }).toList(),
          ),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Arrival Time'),
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
              Text('Departure Time'),
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
            child: Text('Add Schedule'),
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
                  return Center(child: Text('No bus schedules available'));
                } else {
                  List<BusSchedule> schedules = snapshot.data!;
                  return ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];
                      return Padding(
                          padding: EdgeInsets.all(8.0),
                      child:Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(
                            'Bus: ${schedule.busId}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Arrival Time: ${schedule.arrivalTime}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Departure Time: ${schedule.departureTime}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirm Deletion'),
                                        content: Text('Are you sure you want to delete this bus schedule?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Delete'),
                                            onPressed: () async {
                                              Navigator.of(context).pop(); // Close the dialog
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              try {
                                                await DatabaseHelper.deleteBusSchedule(schedule.id!);
                                                // Reload bus schedules after deletion
                                                final updatedSchedules = await DatabaseHelper.getBusSchedulesForStation(widget.stationId!);
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              } catch (error) {
                                                print(error);
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
                                },
                              ),
                            ],
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
