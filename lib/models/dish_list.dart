import 'package:food_ordering_app/models/dish.dart';

class DishList {
  final List<Dish> dishes;

  DishList({
    this.dishes,
  });

  factory DishList.fromJson(List<dynamic> parsedJson) {
    List<Dish> dishes = new List<Dish>.empty();
    dishes = parsedJson.map((i) => Dish.fromJson(i)).toList();

    return new DishList(dishes: dishes);
  }

  get length => dishes.length;

  Dish getIndex(int index) {
    return dishes[index];
  }

  Dish getById(int id) =>
      dishes.firstWhere((element) => element.dishId == id, orElse: null);
}
