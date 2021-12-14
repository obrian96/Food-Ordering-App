class Order {
  int id, status, totalPrice;
  String userId, startDate, endDate;

  Order(this.id, this.userId, this.status, this.totalPrice, this.startDate,
      this.endDate);

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(json['id'], json['user_id'], json['status'],
        json['total_price'], json['start_date'], json['end_date']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'status': status,
        'total_price': totalPrice,
        'start_date': startDate,
        'end_date': endDate,
      };
}
