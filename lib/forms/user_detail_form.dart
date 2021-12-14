import 'package:flutter/material.dart';
import 'package:food_ordering_app/animation/fade_animation.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/server_response.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/services/user_services.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailForm extends StatefulWidget {
  @override
  _UserDetailFormState createState() => _UserDetailFormState();
}

class _UserDetailFormState extends State<UserDetailForm> {
  static const String TAG = 'user_detail_form.dart';

  TextEditingController userId = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController pincode = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Details'),
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
        future: getProfileDetails(),
        builder: (context, snapshot) {
          switch (SoftUtils().state(snapshot)) {
            case FutureState.COMPLETE:
              return body(context, snapshot);

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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          handleDetails(context);
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget body(context, snapshot) {
    if (snapshot.data != null && (snapshot.data.apiError as ApiError) == null) {
      Log.i(TAG, '${(snapshot.data.data as UserDetails).user_email}');
    } else {
      Log.e(TAG, '${(snapshot.data.apiError as ApiError).error}');
    }
    String user_id = (snapshot.data.data as UserDetails).user_id;
    String user_email = (snapshot.data.data as UserDetails).user_email;
    String user_phno = (snapshot.data.data as UserDetails).user_phno;
    String user_addline = (snapshot.data.data as UserDetails).user_addline;
    int user_pincode = (snapshot.data.data as UserDetails).pincode;

    userId.text = user_id;
    email.text = user_email;
    phone.text = user_phno;
    address.text = user_addline;
    pincode.text = '$user_pincode';
    return SingleChildScrollView(
      child: Column(
        children: [
          // Card(
          //   child: TextField(
          //     controller: userID,
          //     style: TextStyle(
          //       color: Colors.black,
          //     ),
          //     decoration: InputDecoration(
          //       filled: true,
          //       fillColor: Color(0xffEEEEEE),
          //       labelText: "user ID*",
          //     ),
          //     onChanged: (value) {},
          //   ),
          //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
          // ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 22.0),
          //     child: Text(
          //       "generated automatically",
          //       style: TextStyle(
          //         color: Color.fromRGBO(0, 0, 0, 0.6),
          //         fontSize: 12.0,
          //       ),
          //     ),
          //   ),
          // ),

          Card(
            child: TextField(
              controller: email,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffEEEEEE),
                labelText: "Email",
              ),
              onChanged: (value) {},
            ),
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
          ),

          Card(
            child: TextField(
              controller: phone,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffEEEEEE),
                labelText: "Phone",
              ),
              onChanged: (value) {},
            ),
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
          ),

          Card(
            child: TextField(
              controller: address,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffEEEEEE),
                labelText: "Address",
              ),
              onChanged: (value) {},
            ),
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
          ),
          Card(
            child: TextField(
              controller: pincode,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffEEEEEE),
                labelText: "Pincode",
              ),
              onChanged: (value) {},
            ),
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
          ),
//              SizedBox(
//                  height: 20.0,
//              ),
          FadeAnimation(
            1.2,
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/Form.png'), fit: BoxFit.cover)),
            ),
          ),
        ],
      ),
    );
  }

  void handleDetails(BuildContext context) async {
    UserServices userServices = new UserServices();
    ApiResponse apiResponse = await userServices.user_detail_form(
        userId.text, email.text, phone.text, address.text, pincode.text);
    if (apiResponse != null && (apiResponse.apiError as ApiError) == null) {
      toast('${(apiResponse.data as ServerResponse).message}', Colors.green);
      Navigator.pop(context);
    } else {
      Log.e(TAG, '${(apiResponse.apiError as ApiError).error}');
      toast('${(apiResponse.apiError as ApiError).error}');
    }
  }

  Future getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');
    UserServices userServices = new UserServices();
    ApiResponse apiResponse = await userServices.details(userId);
    return apiResponse;
  }
}
