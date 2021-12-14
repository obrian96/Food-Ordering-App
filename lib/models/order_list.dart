import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/models/order_item.dart';

class OrderList {
  List<OrderItem> orderItems;
  List<Dish> dishList;

  OrderList([this.orderItems, this.dishList]);

  factory OrderList.fromJson(Map<String, dynamic> json) =>
      OrderList(json['order_items'], json['dish_list']);

  Map<String, dynamic> toJson() => {
        'order_items': orderItems,
        'dish_list': dishList,
      };
}
