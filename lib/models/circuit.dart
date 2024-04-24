class Circuit {
  final int? id;
  final String name;


  Circuit({
    this.id,
    required this.name,
  });

  factory Circuit.fromJson(Map<String, dynamic> json) {
    return Circuit(
      id: json['id'] as int?,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,

    };
  }
}
