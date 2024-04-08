class Bus {
  final int? id;
  final String registrationNumber;
  final String model;

  Bus({
    this.id,
    required this.registrationNumber,
    required this.model,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['bus_id'] as int?,
      registrationNumber: json['registration_number'],
      model: json['model'],
    );
  }
}
