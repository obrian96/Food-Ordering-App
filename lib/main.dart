import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'forms/dish_add_form.dart';
import 'forms/dish_edit_form.dart';
import 'forms/user_detail_form.dart';
import 'views/dashboard_loader.dart';
import 'views/home_page.dart';
import 'views/landing_page.dart';
import 'views/login_page.dart';
import 'views/profile_page.dart';
import 'views/restaurant/admin_dashboard.dart';
import 'views/user/user_dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Food Delivery App', routes: {
      '/': (context) => LandingPage(),
      '/home': (context) => HomePage(),
      '/login': (context) => LoginPage(),
      '/dash': (context) => Dashboard(),
      '/admindash': (context) => AdminDashboard(),
      '/profile': (context) => ProfileScreen(),
      '/loadDash': (context) => DashboardLoader(),
      '/dishEditForm': (context) => DishEditForm(),
      '/dishAddForm': (context) => DishAddForm(),
      '/userDetailsForm': (context) => UserDetailForm(),
      // '/signup' : (context) => SignupPage(),
    });
  }
}
