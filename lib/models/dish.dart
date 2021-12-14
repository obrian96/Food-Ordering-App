class Dish {
  final int dishId;
  final String dishName;
  int dishPrice;
  String dishImage;
  final int isAvailable;
  final String dishType;
  int quantity, totalPrice, subtotalPrice;

  Dish(this.dishId, this.dishName, this.dishPrice, this.dishImage,
      this.quantity, this.isAvailable, this.dishType);

  factory Dish.fromMap(Map<String, dynamic> json) => Dish(
        json['dish_id'],
        json['dish_name'],
        json['dish_price'],
        json['dish_image'],
        json['dish_quantity'],
        json['isAvailable'],
        json['dish_type'],
      );

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
        json['dish_id'],
        json['dish_name'],
        json['dish_price'],
        json['dish_image'],
        json['dish_quantity'],
        json['isAvailable'],
        json['dish_type'],
      );

  set dishQuantity(int dishQuantity) {
    this.quantity = dishQuantity;
  }

  int getSubtotalPrice() {
    return (this.dishPrice * this.quantity);
  }

  Map toJson() => {
        'dish_id': dishId,
        'dish_name': dishName,
        'dish_price': dishPrice,
        'dish_image': dishImage,
        'dish_quantity': quantity,
        'isAvailable': isAvailable,
        'dish_type': dishType,
      };
}
