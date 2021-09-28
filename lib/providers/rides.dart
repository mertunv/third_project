import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:third_project/providers/seat_toggle_list.dart';
import '../models/http_exception.dart';
import 'dart:convert';

import '../providers/ride.dart';

class Rides with ChangeNotifier {
  List<Ride> _items = [
    // Ride(
    //   id: 'IST->BUR',
    //   destinationPlace: 'Bursa',
    //   rideCode: 'IST->BUR',
    //   date: DateTime.now().toString(),
    //   departurePlace: 'Istanbul',
    //   departureHour: DateTime.now().toString(),
    //   arrivalHour: DateTime.now().toString(),
    //   seatPrice: 20,
    //   note: '',
    // ),
    // Ride(
    //   id: 'IST->ANK',
    //   destinationPlace: 'Ankara',
    //   rideCode: 'IST->ANK',
    //   date: DateTime.now().toString(),
    //   departurePlace: 'Istanbul',
    //   departureHour: DateTime.now().toString(),
    //   arrivalHour: DateTime.now().toString(),
    //   seatPrice: 20,
    //   note: '',
    // ),
    // Ride(
    //   id: 'IST->IZM',
    //   destinationPlace: 'Izmir',
    //   rideCode: 'IST->IZM',
    //   date: DateTime.now().toString(),
    //   departurePlace: 'Istanbul',
    //   departureHour: DateTime.now().toString(),
    //   arrivalHour: DateTime.now().toString(),
    //   seatPrice: 20,
    //   note: '',
    // ),
    // Ride(
    //   id: 'IST->ANT',
    //   destinationPlace: 'Antalya',
    //   rideCode: 'IST->ANT',
    //   date: DateTime.now().toString(),
    //   departurePlace: 'Istanbul',
    //   departureHour: DateTime.now().toString(),
    //   arrivalHour: DateTime.now().toString(),
    //   seatPrice: 20,
    //   note: '',
    // ),
  ];

  final String autherizationToken;
  final String userId;

  Rides(this.autherizationToken, this.userId, this._items);

  List<Ride> get items {
    return [..._items];
  }

  Ride findById(String id) {
    return _items.firstWhere((ri) => ri.id == id);
  }

  // List<Ride> findSeats(String id) {
  //   // return _items.firstWhere((ri) => ri.id == id);
  //   return _items
  //       .map((e) => e.seatStatus)
  //       .reduce((value, element) => value)
  //       .toList();
  // }

  Future<void> fetchRides() async {
    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides.json?auth=$autherizationToken';
    // &orderBy="destinationPlace"&equalTo=""
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Ride> dataLoaded = [];
      data.forEach((rideId, rideData) {
        dataLoaded.add(Ride(
          id: rideId,
          destinationPlace: rideData['destinationPlace'],
          rideCode: rideData['rideCode'],
          date: rideData['date'],
          departurePlace: rideData['departurePlace'],
          departureHour: rideData['departureHour'],
          arrivalHour: rideData['arrivalHour'],
          seatPrice: rideData['seatPrice'],
          note: rideData['note'],
          seatStatus: rideData['seatStatus'],
        ));
      });
      _items = dataLoaded;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addRide(Ride r) {
    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides.json?auth=$autherizationToken';
    return http
        .post(
      url,
      body: json.encode({
        'destinationPlace': r.destinationPlace,
        'rideCode': r.rideCode,
        'date': r.date,
        'departurePlace': r.departurePlace,
        'departureHour': r.departureHour,
        'arrivalHour': r.arrivalHour,
        'seatPrice': r.seatPrice,
        'note': r.note,
        'userId': userId,
        'seatStatus': isSelected,
      }),
    )
        .then((response) {
      final newRide = Ride(
        id: json.decode(response.body)['name'],
        destinationPlace: r.destinationPlace,
        rideCode: r.rideCode,
        date: r.date,
        departurePlace: r.departurePlace,
        departureHour: r.departureHour,
        arrivalHour: r.arrivalHour,
        seatPrice: r.seatPrice,
        note: r.note,
        seatStatus: r.seatStatus,
      );
      _items.add(newRide);
      notifyListeners();
    });
  }

  void updateSeatStatus(String id, Ride newRide) async {
    final rideIndex = _items.indexWhere((ri) => ri.id == id);
    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$autherizationToken';
    await http.patch(url,
        body: json.encode({
          'seatStatus': newRide.seatStatus,
        }));
    notifyListeners();
    print(rideIndex);
  }

  void updateRide(String id, Ride newRide) async {
    final rideIndex = _items.indexWhere((ri) => ri.id == id);
    if (rideIndex >= 0) {
      final url =
          'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$autherizationToken';
      await http.patch(url,
          body: json.encode({
            'destinationPlace': newRide.destinationPlace,
            'rideCode': newRide.rideCode,
            'date': newRide.date,
            'departurePlace': newRide.departurePlace,
            'departureHour': newRide.departureHour,
            'arrivalHour': newRide.arrivalHour,
            'seatPrice': newRide.seatPrice,
            'note': newRide.note,
            'seatStatus': newRide.seatStatus,
          }));
      _items[rideIndex] = newRide;
      notifyListeners();
      print(rideIndex);
    } else {
      print('...');
    }
  }

  Future<void> deleteRide(String id) async {
    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$autherizationToken';
    final existingRideIndex = _items.indexWhere((ri) => ri.id == id);
    var existingRide = _items[existingRideIndex];
    _items.removeAt(existingRideIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingRideIndex, existingRide);
      notifyListeners();
      throw HttpException('Silinemedi!');
    }
    existingRide = null;
  }
}
