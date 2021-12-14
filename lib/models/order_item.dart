class OrderItem {
  int id, orderId, itemId, quantity, price;

  OrderItem(this.id, this.orderId, this.itemId, this.quantity, this.price);

  factory OrderItem.fromMap(Map<String, dynamic> json) {
    return OrderItem(json['id'], json['order_id'], json['item_id'],
        json['quantity'], json['price']);
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(json['id'], json['order_id'], json['item_id'],
        json['quantity'], json['price']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'item_id': orderId,
        'quantity': quantity,
        'price': price,
      };
}
