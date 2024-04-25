class Bus {
  final int? id;
  final String registrationNumber;
  final String model;
  final double Alt;
  final double Lag;

  Bus({
    this.id,
    required this.registrationNumber,
    required this.model,
    required this.Alt,
    required this.Lag
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['bus_id'] as int?,
      registrationNumber: json['registration_number'],
      model: json['model'],
      Alt: json['alt'] ?? 0.0,
      Lag: json['lag'] ?? 0.0,
    );

  }
  Map<String, dynamic> toJson() {
    return {
      'bus_id': id,
      'registration_number': registrationNumber,
    'model' : model,
      'alt': Alt,
      'lag': Lag,
    };
}}
