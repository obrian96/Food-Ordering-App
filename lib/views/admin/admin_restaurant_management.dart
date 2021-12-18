import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish_list.dart';
import 'package:food_ordering_app/services/rest_services.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/views/admin/admin_catalog_item.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminRestaurantManagement extends StatefulWidget {
  @override
  _AdminRestaurantManagement createState() => _AdminRestaurantManagement();
}

class _AdminRestaurantManagement extends State<AdminRestaurantManagement> {
  DishList futDishList;

  @override
  void initState() {
    super.initState();
  }

  Future _GetDishData() async {
    RestServices restServices = new RestServices();
    ApiResponse _apiResponse = await restServices.getDishes();
    print(_apiResponse.apiError);
    DishList dishList;
    if ((_apiResponse.apiError as ApiError) == null) {
      dishList = (_apiResponse.data as DishList);
    }
    return dishList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: new Text("Menu Management"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     constraints: BoxConstraints.expand(width: 80),
        //     icon: Icon(Icons.account_circle_rounded),
        //     iconSize: 30,
        //     // Text('View Profile', textAlign: TextAlign.center),
        //     onPressed: () {
        //       _profileHandler(context);
        //     },
        //   ),
        // ],
      ),
      body: FutureBuilder(
          future: _GetDishData(),
          builder: (context, snapshot) {
            switch (SoftUtils().state(snapshot)) {
              case FutureState.COMPLETE:
                return CatalogList(dishList: snapshot.data);
                break;

              case FutureState.UNKNOWN:
              case FutureState.ERROR:
                return Container(
                  child: Center(
                    child: Text('Unable to load data!'),
                  ),
                );

              case FutureState.LOADING:
              default:
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            }
          }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/cart');
      //   },
      //   child: Icon(Icons.shopping_cart),
      // ),
    );
  }
}

class CatalogList extends StatelessWidget {
  final DishList dishList;

  CatalogList({Key key, this.dishList});

  @override
  Widget build(BuildContext context) {
    return (dishList == null)
        ? "Nothing to show".text.xl3.make().centered()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: dishList.length,
            itemBuilder: (context, index) {
              return CatalogItemAdmin(dish: dishList.getIndex(index));
            },
          );
  }
}
