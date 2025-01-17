import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish_list.dart';
import 'package:food_ordering_app/services/rest_services.dart';

class DashboardLoader extends StatefulWidget {
  @override
  _DashboardLoaderState createState() => _DashboardLoaderState();
}

class _DashboardLoaderState extends State<DashboardLoader> {
  int args;

  @override
  void initState() {
    super.initState();
    getDishData();
  }

  void getDishData() async {
    RestServices restServices = new RestServices();
    ApiResponse _apiResponse = await restServices.getDishes();
    print(_apiResponse.apiError);
    DishList dishList;
    if ((_apiResponse.apiError as ApiError) == null) {
      dishList = (_apiResponse.data as DishList);
    }
    if (args == 1) {
      Navigator.pushReplacementNamed(
        context,
        '/adminDash',
        arguments: dishList,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/dash',
        arguments: dishList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as int;
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
