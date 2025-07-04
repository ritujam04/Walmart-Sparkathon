class Champion {
  final int id;
  final String name;
  final String address;
  final bool status;

  Champion({
    required this.id,
    required this.name,
    required this.address,
    required this.status,
  });

  factory Champion.fromJson(Map<String, dynamic> json) {
    return Champion(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      status: json['status'],
    );
  }
}
