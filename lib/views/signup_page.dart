import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_ordering_app/animation/fade_animation.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/services/user_services.dart';
import 'package:food_ordering_app/widgets/msg_toast.dart';
import 'package:uuid/uuid.dart';

class SignupPage extends StatelessWidget {
  TextEditingController cUserId = new TextEditingController();
  TextEditingController cName = new TextEditingController();
  TextEditingController cEmail = new TextEditingController();
  TextEditingController cPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Create new uuid object to generate uuid for default user id
    var uuidObj = Uuid();
    // Generate uuid from uuid object v4
    var uuid = uuidObj.v4();
    // Set first 8 digits of uuid to default user id
    cUserId.text = uuid.substring(0, 8);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Create an account, It's free",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  FadeAnimation(
                    1.2,
                    makeInput(
                      label: "User ID",
                      controllerVal: cUserId,
                    ),
                  ),
                  FadeAnimation(
                    1.2,
                    makeInput(
                      label: "Name",
                      controllerVal: cName,
                    ),
                  ),
                  FadeAnimation(
                    1.2,
                    makeInput(
                      label: "Email",
                      controllerVal: cEmail,
                    ),
                  ),
                  FadeAnimation(
                      1.3,
                      makeInput(
                          label: "Password",
                          controllerVal: cPassword,
                          obscureText: true)),
                  FadeAnimation(
                    1.4,
                    makeInput(
                      label: "Confirm Password",
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              FadeAnimation(
                  1.5,
                  Container(
                    padding: EdgeInsets.only(top: 1, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: () {
                        handleSignup(context);
                      },
                      color: Colors.greenAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  )),
              FadeAnimation(
                  1.6,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?"),
                      Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({label, controllerVal, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: controllerVal,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void handleSignup(BuildContext context) async {
    if (cUserId.text.isNotEmpty &&
        cName.text.isNotEmpty &&
        cEmail.text.isNotEmpty &&
        cPassword.text.isNotEmpty) {
      UserServices userServices = new UserServices();
      ApiResponse _apiResponse = await userServices.signup(
        cUserId.text,
        cName.text,
        cEmail.text,
        cPassword.text,
      );

      print(_apiResponse.ApiError);
      if ((_apiResponse.ApiError as ApiError) == null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          ModalRoute.withName('/login'),
        );
      } else {
        msgToast("ERROR: " + _apiResponse.ApiError);
      }
    } else {
      msgToast("Fields must not empty!");
    }
  }
}
