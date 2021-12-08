class Dish {
  final int dishId;
  final String dishName;
  final int dishPrice;
  final int isAvailable;
  final String dishType;
  final String dishRestId;

  Dish(
    this.dishId,
    this.dishName,
    this.dishPrice,
    this.isAvailable,
    this.dishType,
    this.dishRestId,
  );

  factory Dish.fromMap(Map<String, dynamic> json) => Dish(
        json['dish_id'],
        json['dish_name'],
        json['dish_price'],
        json['isAvailable'],
        json['dish_type'],
        json['dish_rest_id'],
      );

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
        json['dish_id'],
        json['dish_name'],
        json['dish_price'],
        json['isAvailable'],
        json['dish_type'],
        json['dish_rest_id'],
      );
}
