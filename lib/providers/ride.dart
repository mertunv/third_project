import 'package:flutter/foundation.dart';
import 'package:third_project/providers/seat_toggle_list.dart';

class Ride with ChangeNotifier {
  final String id;
  final String departurePlace;
  final String destinationPlace;
  final String rideCode;
  final String date;
  final String departureHour;
  final String arrivalHour;
  final double seatPrice;
  final String note;
  
  int seatOne;
  int seatTwo;
  int seatThree;

  List seatStatus;
  final picUrl = 'https://pngimg.com/uploads/bus/bus_PNG8615.png';

  Ride({
    @required this.id,
    @required this.departurePlace,
    @required this.destinationPlace,
    @required this.rideCode,
    @required this.date,
    @required this.departureHour,
    @required this.arrivalHour,
    @required this.seatPrice,
    @required this.note,
    this.seatStatus,
    
    this.seatOne,
    this.seatTwo,
    this.seatThree,
  });
}
