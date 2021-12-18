import 'package:flutter/material.dart';
import 'package:food_ordering_app/animation/fade_animation.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/server_response.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/services/user_services.dart';
import 'package:food_ordering_app/util/image_helper.dart';
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
  TextEditingController userName = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController password = new TextEditingController();

  String callback;
  String userImage;

  UserDetails userDetails;

  int isAdmin;

  @override
  Widget build(context) {
    dynamic args = ModalRoute.of(context).settings.arguments;
    if (args.runtimeType == UserDetails) {
      userDetails = args;
    } else {
      callback = args[1];
    }
    if (callback != null) {
      Log.i(TAG, '$callback');
    }
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
        future: _getProfileDetails(),
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
          _handleDetails(context, userDetails);
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget body(context, snapshot) {
    if (snapshot.data != null &&
        (snapshot.data[0].apiError as ApiError) == null) {
      List args = snapshot.data;
      userDetails = args[0].data;
      String user_pass = args[1] ?? '';
      userImage;
      if (callback != null) {
        userImage = callback;
      } else {
        userImage = args[2] ?? '';
      }
      String user_id = userDetails.user_id;
      String user_name = userDetails.user_name;
      String user_email = userDetails.user_email;
      String user_phno = userDetails.user_phno;
      String user_addline = userDetails.user_addline;
      isAdmin = userDetails.isAdmin;

      userId.text = user_id;
      userName.text = user_name;
      email.text = user_email;
      phone.text = user_phno;
      address.text = user_addline;
      password.text = '$user_pass';
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            InkWell(
              splashColor: Colors.green,
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: EdgeInsets.all(10),
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SoftUtils().loadImage(userImage),
                ),
              ),
              onTap: () {
                _changeProfileImage();
              },
            ),
            Card(
              child: TextField(
                controller: userName,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffEEEEEE),
                  labelText: "User name",
                ),
                onChanged: (value) {},
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            ),
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
                controller: password,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffEEEEEE),
                  labelText: "Password",
                ),
                onChanged: (value) {},
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            ),
            FadeAnimation(
              1.2,
              Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/Form.png'),
                        fit: BoxFit.cover)),
              ),
            ),
          ],
        ),
      );
    } else {
      Log.e(TAG, '${(snapshot.data[0].apiError as ApiError).error}');
      toast('${(snapshot.data[0].apiError as ApiError).error}', Colors.red);
    }
  }

  void _handleDetails(context, userDetails) async {
    UserServices userServices = new UserServices();
    ApiResponse apiResponse = await userServices.updateUserDetails(
        userId.text,
        userName.text,
        userImage,
        email.text,
        phone.text,
        address.text,
        password.text);
    if (apiResponse != null && (apiResponse.apiError as ApiError) == null) {
      toast('${(apiResponse.data as ServerResponse).message}', Colors.green);
      // Navigator.pop(context);
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setString('user_image', userImage);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/profile',
        isAdmin == 1
            ? ModalRoute.withName('/adminDash')
            : ModalRoute.withName('/dash'),
        arguments: userDetails,
      );
    } else {
      Log.e(TAG, '${(apiResponse.apiError as ApiError).error}');
      toast('${(apiResponse.apiError as ApiError).error}');
    }
  }

  Future _getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');
    String userPass = prefs.getString('user_pass');
    String userImage = prefs.getString('user_image');
    UserServices userServices = new UserServices();
    ApiResponse apiResponse = await userServices.details(userId);
    return [apiResponse, userPass, userImage];
  }

  void _changeProfileImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageFromGalleryEx(
          ImageSourceType.gallery,
          nextRoute: '/userDetailForm',
        ),
      ),
    );
  }
}
