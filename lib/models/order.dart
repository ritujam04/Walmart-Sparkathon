class Order {
  final int id;
  final String orderStatus;
  final double totalAmount;
  final String createdAt;
  final String deliveryAddress;
  final String qrToken;

  Order({
    required this.id,
    required this.orderStatus,
    required this.totalAmount,
    required this.createdAt,
    required this.deliveryAddress,
    required this.qrToken,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderStatus: json['order_status'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      createdAt: json['created_at'],
      deliveryAddress: json['delivery_address'] ?? '',
      qrToken: json['qr_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_status': orderStatus,
    'total_amount': totalAmount,
    'created_at': createdAt,
    'delivery_address': deliveryAddress,
    'qr_token': qrToken,
  };

  static List<Order> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => Order.fromJson(json)).toList();
}
