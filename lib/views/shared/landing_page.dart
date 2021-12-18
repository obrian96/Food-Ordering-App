import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/services/user_services.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static const String TAG = 'landing_page.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getDetails(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              Log.e(TAG, '1) ${snapshot.error}');
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              List args = snapshot.data;
              UserDetails userDetails = args[0];
              return Stack(
                children: [
                  ClipPath(
                    child: Container(color: Color(0xfffeb324)),
                    clipper: GetClipper(),
                  ),
                  Positioned(
                    width: 375.0,
                    top: MediaQuery.of(context).size.height / 3.5,
                    child: Column(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child:
                                SoftUtils().loadProfileImage(snapshot.data[1]),
                          ),
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                              color: Color(0xfffeb324),
                              // image: DecorationImage(
                              //   fit: BoxFit.cover,
                              // ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(75.0)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 7.2,
                                    color: Colors.black,
                                    spreadRadius: 0.2)
                              ]),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          userDetails.user_name,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          userDetails.user_email,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40.0),
                        FloatingActionButton.extended(
                          backgroundColor: const Color(0xfffeb324),
                          foregroundColor: Colors.black,
                          splashColor: const Color(0xfffdd835),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/loadDash',
                              arguments: userDetails.isAdmin,
                            );
                          },
                          label: Text(
                            '        Continue        ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        FloatingActionButton.extended(
                          backgroundColor: const Color(0xfffeb324),
                          foregroundColor: Colors.black,
                          splashColor: const Color(0xfffdd835),
                          onPressed: () {
                            _logoutHandler(context);
                          },
                          label: Text(
                            '         Log Out         ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future _getDetails(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profileImage = await SoftUtils().getUserImage();
    String userId = (prefs.getString("user_id") ?? "");
    if (userId.isEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      UserServices userServices = new UserServices();
      ApiResponse apiResponse = await userServices.details(userId);
      // Log.e(TAG, '2) ' + (_apiResponse.ApiError as ApiError).error);
      if ((apiResponse.apiError as ApiError) == null) {
        return [apiResponse.data as UserDetails, profileImage];
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('user_id');
        Navigator.pushReplacementNamed(context, '/home');
        toast("invalid Login State!");
      }
    }
    return [null, profileImage];
  }

  void _logoutHandler(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_id');
    Navigator.pushReplacementNamed(context, '/home');
    toast("Logged Out!", Colors.deepOrange);
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height / 2.0);
    path.lineTo(size.width + 480, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
