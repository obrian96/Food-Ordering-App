import 'package:food_ordering_app/models/order_item.dart';

class Orders {
  String userId;
  List<OrderItem> orderItems;

  Orders({this.userId, this.orderItems});
}
