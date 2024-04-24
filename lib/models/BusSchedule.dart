class BusSchedule {
  final int? id;
  final int stationId;
  final int busId;
  final int circuitId;
  final String arrivalTime;
  final String departureTime;

  BusSchedule({
    this.id,
    required this.stationId,
    required this.busId,
    required this.circuitId,
    required this.arrivalTime,
    required this.departureTime,
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      id: json['id'],
      stationId: json['station_id'],
      busId: json['bus_id'],
      circuitId: json['circuit_id'],
      arrivalTime: json['arrival_time'],
      departureTime: json['departure_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_id': stationId,
      'bus_id': busId,
      'circuit_id': circuitId,
      'arrival_time': arrivalTime,
      'departure_time': departureTime,
    };
  }
}
