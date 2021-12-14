class Dish {
  final int dishId;
  final String dishName;
  final int isAvailable;
  final String dishType;
  int quantity, dishPrice;

  Dish(
    this.dishId,
    this.dishName,
    this.dishPrice,
    this.isAvailable,
    this.dishType, {
    this.quantity,
  });

  factory Dish.fromMap(Map<String, dynamic> json) => Dish(
        json['dish_id'],
        json['dish_name'],
        json['dish_price'],
        json['isAvailable'],
        json['dish_type'],
      );

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
        json['dish_id'],
        json['dish_name'],
        json['dish_price'],
        json['isAvailable'],
        json['dish_type'],
      );

  get dishQuantity => quantity;

  set dishQuantity(int dishQuantity) {
    this.quantity = dishQuantity;
  }

  Map toJson() => {
        'dish_id': dishId,
        'dish_name': dishName,
        'dish_price': dishPrice,
        'isAvailable': isAvailable,
        'dish_type': dishType,
        'dish_quantity': dishQuantity,
      };
}
