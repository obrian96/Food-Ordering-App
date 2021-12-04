import 'package:food_ordering_app/models/orders_model.dart';

class OrderServices {
  // Server Address
  static const BASE_URL = 'https://static.toiimg.com';

  static List<OrdersModel> getOrderList() {
    return [
      new OrdersModel(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 2,
      ),
      new OrdersModel(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 3,
      ),
      new OrdersModel(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 2,
      ),
      new OrdersModel(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 1,
      ),
      new OrdersModel(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 2,
      ),
      new OrdersModel(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 4,
      ),
      new OrdersModel(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 1,
      ),
      new OrdersModel(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 2,
      ),
    ];
  }
}
