import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/seat_toggle_list.dart';
import '../widgets/seats.dart';
import '../providers/ride.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';

import '../providers/rides.dart';

class SelectSeatNumber extends StatefulWidget {
  @override
  _SelectSeatNumberState createState() => _SelectSeatNumberState();
}

class _SelectSeatNumberState extends State<SelectSeatNumber> {
  List<bool> toggly = [false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return null;
  }
}
