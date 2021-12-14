import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/user.dart';
import 'package:food_ordering_app/services/rest_services.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/widgets/card_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminOrderManagement extends StatefulWidget {
  @override
  _AdminOrderManagementState createState() => _AdminOrderManagementState();
}

class _AdminOrderManagementState extends State<AdminOrderManagement> {
  static const String TAG = 'admin_order_management.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: getOrderedUserList(),
        builder: (context, snapshot) {
          switch (SoftUtils.state(snapshot)) {
            case SoftUtils.COMPLETE:
              return Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    User user = snapshot.data[index];
                    return CardView(
                      name: user.user_name,
                      image: user.user_image,
                    );
                  },
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                ),
              );

            case SoftUtils.UNKNOWN:
            case SoftUtils.ERROR:
              return Container(
                child: Center(
                  child: Text('Unable to load data!'),
                ),
              );

            case SoftUtils.LOADING:
            default:
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      ),
    );
  }

  Future getOrderedUserList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');
    RestServices restServices = new RestServices();
    ApiResponse apiResponse = await restServices.getOrderedUserList(userId);
    List<User> userList = [];
    if (apiResponse != null && (apiResponse.apiError as ApiError) == null) {
      userList = apiResponse.data;
    } else {
      Log.e(TAG, '${(apiResponse.data as ApiError).error}');
    }
    return userList;
  }
}
