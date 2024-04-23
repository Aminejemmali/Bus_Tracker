class CircuitStation {
  final int circuitId;
  final int stationId;

  CircuitStation({
    required this.circuitId,
    required this.stationId,
  });

  factory CircuitStation.fromJson(Map<String, dynamic> json) {
    return CircuitStation(
      circuitId: json['circuit_id'] as int,
      stationId: json['station_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circuit_id': circuitId,
      'station_id': stationId,
    };
  }
}
