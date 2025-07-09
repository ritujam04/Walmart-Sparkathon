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
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'status': status,
  };

  static List<Champion> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => Champion.fromJson(json)).toList();
}
