import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_ordering_app/forms/dish_add_form.dart';
import 'package:food_ordering_app/forms/dish_edit_form.dart';
import 'package:food_ordering_app/forms/user_detail_form.dart';
import 'package:food_ordering_app/views/admin/admin_dashboard.dart';
import 'package:food_ordering_app/views/dashboard_loader.dart';
import 'package:food_ordering_app/views/home_page.dart';
import 'package:food_ordering_app/views/landing_page.dart';
import 'package:food_ordering_app/views/login_page.dart';
import 'package:food_ordering_app/views/profile_page.dart';
import 'package:food_ordering_app/views/signup_page.dart';
import 'package:food_ordering_app/views/user/pages/user_dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Delivery App',
        routes: {
          '/': (context) => LandingPage(), // Launcher page
          '/home': (context) => HomePage(), // Home page
          '/login': (context) => LoginPage(), // Login page
          '/signup': (context) => SignUpPage(), // Sign up page
          '/dash': (context) => Dashboard(), // Dashboard
          '/adminDash': (context) => AdminDashboard(), // Admin dashboard
          '/profile': (context) => ProfileScreen(), // Profile page
          '/loadDash': (context) => DashboardLoader(),
          '/dishEditForm': (context) => DishEditForm(),
          '/dishAddForm': (context) => DishAddForm(),
          '/userDetailsForm': (context) => UserDetailForm(),
        });
  }
}
