class BusSchedule {
  final int? id;
  final int stationId;
  final int busId;
  final int circuitId;
  final String arrivalTime;
  final String departureTime;
  final int	 Isdelayed;

  BusSchedule({
    this.id,
    required this.stationId,
    required this.busId,
    required this.circuitId,
    required this.arrivalTime,
    required this.departureTime,
    required this.Isdelayed,
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      id: json['id'],
      stationId: json['station_id'],
      busId: json['bus_id'],
      circuitId: json['circuit_id'],
      arrivalTime: json['arrival_time'],
      departureTime: json['departure_time'],
      Isdelayed: json['Isdelayed'],
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
      'Isdelayed':Isdelayed,
    };
  }
}
