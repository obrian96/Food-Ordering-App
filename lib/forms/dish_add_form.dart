import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_ordering_app/animation/fade_animation.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/services/rest_services.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:velocity_x/src/flutter/padding.dart';

class DishAddForm extends StatefulWidget {
  @override
  _DishAddFormState createState() => _DishAddFormState();
}

class _DishAddFormState extends State<DishAddForm> {
  // TextEditingController DishID=new TextEditingController();
  TextEditingController dishName = new TextEditingController();
  TextEditingController dishPrice = new TextEditingController();
  TextEditingController adminId = new TextEditingController();

  //int IsAvailable = 0;  String colorGroupValue = '';
  String valueChoose;
  List listItem = ['starter', 'main course', 'dessert', 'snack', 'beverage'];

  String userId, dishImage;

  @override
  Widget build(BuildContext context) {
    String base64Image = ModalRoute.of(context).settings.arguments;
    dishImage = base64Image;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xff409439),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add Dish'),
        centerTitle: true,
        // actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.memory(
                base64.decode(base64Image.split(',').last),
                width: 150,
                height: 150,
                fit: BoxFit.fitHeight,
                gaplessPlayback: true,
              ),
            ).p16(),
            Card(
              child: TextField(
                controller: dishName,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffEEEEEE),
                  labelText: "Dish name",
                ),
                onChanged: (value) {},
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            ),
            Card(
              child: TextField(
                controller: dishPrice,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffEEEEEE),
                  labelText: "Dish Price",
                ),
                onChanged: (value) {},
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            ),
            Card(
              child: DropdownButton(
                hint: Text("Select Dish Type"),
                dropdownColor: Colors.white,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                isExpanded: true,
                underline: SizedBox(),
                style: TextStyle(color: Colors.black, fontSize: 15),
                value: valueChoose,
                onChanged: (newValue) {
                  setState(() {
                    valueChoose = newValue;
                  });
                },
                items: listItem.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            ),
            // Card(
            //   child: TextField(
            //     controller: adminId,
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //     decoration: InputDecoration(
            //       filled: true,
            //       fillColor: Color(0xffEEEEEE),
            //       labelText: "admin ID",
            //     ),
            //     onChanged: (value) {},
            //   ),
            //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            // ),
            FadeAnimation(
              1.2,
              Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/food.png'),
                        fit: BoxFit.fitHeight)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (dishName.text.isNotEmpty && dishPrice.text.isNotEmpty) {
            _handleDishAdd(context);
          } else {
            toast('Fields must not empty!', Colors.red);
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }

  void _handleDishAdd(BuildContext context) async {
    const int isAdmin = 1;
    RestServices restServices = new RestServices();
    userId = await SoftUtils().getUserId();
    ApiResponse _apiResponse = await restServices.addDish(
      dishImage,
      // DishID.text,
      dishName.text,
      int.parse(dishPrice.text),
      valueChoose,
      userId,
    );

    if ((_apiResponse.apiError as ApiError) == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/loadDash',
        ModalRoute.withName('/loadDash'),
        arguments: isAdmin,
      );
    } else {
      toast("Dish Adding Failed!", Colors.red);
    }
  }
}
