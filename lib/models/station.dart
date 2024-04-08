import 'dart:ffi';

class Station {
  final int? id;
  final String name;
  final String address;
  final String location;
  final double Alt;
  final double Lag;

  Station({
     this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.Alt,
    required this.Lag,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['station_id'] as int?,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      address: json['address'] ?? '',
      Alt: json['alt'] ?? 0.0,
      Lag: json['lag'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'station_id': id,
      'name': name,
      'location': location,
      'address': address,
      'alt': Alt,
      'lag': Lag,
    };
  }
}
