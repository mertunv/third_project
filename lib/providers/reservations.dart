import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import 'dart:convert';

import '../providers/ride.dart';
import '../providers/rides.dart';
import '../providers/cart.dart';

class ReservedItem {
  final String id;
  final double amount;
  final List<CartItem> rides;
  final DateTime dateTime;
  List<CartItem> seats;
  String kimlikId;
  int seatOne;
  int seatTwo;
  int seatThree;

  ReservedItem({
    @required this.id,
    @required this.amount,
    @required this.rides,
    @required this.dateTime,
    this.seats,
    this.kimlikId,
    this.seatOne,
    this.seatTwo,
    this.seatThree,
  });
}

class Reservs with ChangeNotifier {
  List<ReservedItem> _reserv = [];
  final String authToken;
  final String userId;

  Reservs(this.authToken, this.userId, this._reserv);

  List<ReservedItem> get reservs {
    return [..._reserv];
  }

  ReservedItem findById(String id) {
    return _reserv.firstWhere((ri) => ri.id == id);
  }

  Future<void> fetchAndSetReservs() async {
    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/reservations/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<ReservedItem> loadedRides = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((rideId, rideData) {
      loadedRides.add(
        ReservedItem(
          id: rideId,
          amount: rideData['amount'],
          dateTime: DateTime.parse(rideData['dateTime']),
          rides: (rideData['rides'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  seatPrice: item['price'],
                  seatStat: item['seatStat'],
                  seatOne: item['seatOne'],
                  seatTwo: item['seatTwo'],
                  seatThree: item['seatThree'],
                ),
              )
              .toList(),
        ),
      );
    });
    _reserv = loadedRides.reversed.toList();
    notifyListeners();
  }

  Future<void> deleteRes(String id) async {
    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/reservations/$userId/$id.json?auth=$authToken';
    final index = _reserv.indexWhere((reservs) => reservs.id == id);
    var existingRideRes = _reserv[index];
    final url2 =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/reservations/$userId/$id/rides/0.json?auth=$authToken';
    final response2 = await http.get(url2);
    final extractedData = json.decode(response2.body);
    var rId = extractedData['kimlikId'];
    var seatOne = extractedData['seatOne'];
    var seatTwo = extractedData['seatTwo'];
    var seatThree = extractedData['seatThree'];
    if (seatOne != null && seatTwo == null && seatThree == null) {
      updateSeatStatus(rId, seatOne);
    } else if (seatOne != null && seatTwo != null && seatThree == null) {
      update2SeatStatus(rId, seatOne, seatTwo);
    } else if (seatOne != null && seatTwo != null && seatThree != null) {
      update3SeatStatus(rId, seatOne, seatTwo, seatThree);
    }
    print('seat one: ' +
        seatOne.toString() +
        '/' +
        'seat two: ' +
        seatTwo.toString() +
        '/' +
        'seat three: ' +
        seatThree.toString());
    print(index.toString());
    _reserv.removeAt(index);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _reserv.insert(index, existingRideRes);
      notifyListeners();
      throw HttpException('Silinemedi!');
    }
    existingRideRes = null;
  }

  // List<Ride> _items = [];

  // Set deleted seat to true
  // void updateSeatStatus(String id, int key, int key2, int key3) async {
  //   // final url =
  //   //     'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$authToken';
  //   // await http.patch(url,
  //   //     body: json.encode({
  //   //       'seatStatus':
  //   //           reserved.map((e) => e.seatStat).reduce((value, element) => value),
  //   //     }));
  //   // print('i am iron man' +
  //   //     ' ' +
  //   //     reserved.map((e) => e.seatStat).toString() +
  //   //     ' ' +
  //   //     'i am iron man');
  //   // notifyListeners();

  //   final url2 =
  //       'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id/seatStatus.json?auth=$authToken';
  //   final response2 = await http.get(url2);
  //   final extractedData = json.decode(response2.body);
  //   //extractedData[key] = extractedData[key];
  //   extractedData[key]['isActive'] = !extractedData[key]['isActive'];

  //   extractedData[key2]['isActive'] = !extractedData[key2]['isActive'];
  //   extractedData[key3]['isActive'] = !extractedData[key3]['isActive'];
  //   print(extractedData);

  //   final url =
  //       'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$authToken';
  //   await http.patch(url, body: json.encode({'seatStatus': extractedData}));
  //   // print('i am iron man' +
  //   //     ' ' +
  //   //     reserved.map((e) => e.seatStat).toString() +
  //   //     ' ' +
  //   //     'i am iron man');
  //   notifyListeners();
  // }

  void updateSeatStatus(String id, int key) async {
    // final url =
    //     'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$authToken';
    // await http.patch(url,
    //     body: json.encode({
    //       'seatStatus':
    //           reserved.map((e) => e.seatStat).reduce((value, element) => value),
    //     }));
    // print('i am iron man' +
    //     ' ' +
    //     reserved.map((e) => e.seatStat).toString() +
    //     ' ' +
    //     'i am iron man');
    // notifyListeners();

    final url2 =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id/seatStatus.json?auth=$authToken';
    final response2 = await http.get(url2);
    final extractedData = json.decode(response2.body);
    //extractedData[key] = extractedData[key];
    extractedData[key]['isActive'] = !extractedData[key]['isActive'];
    print(extractedData);
    print(key);

    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$authToken';
    await http.patch(url, body: json.encode({'seatStatus': extractedData}));
    // print('i am iron man' +
    //     ' ' +
    //     reserved.map((e) => e.seatStat).toString() +
    //     ' ' +
    //     'i am iron man');
    notifyListeners();
  }

  void update2SeatStatus(String id, int key1, int key2) async {
    // List keys = [key1, key2];
    // keys.add(key1);
    // keys.add(key2);
    final url2 =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id/seatStatus.json?auth=$authToken';
    final response2 = await http.get(url2);
    final extractedData = json.decode(response2.body);

    //extractedData[key] = extractedData[key];
    // keys.forEach((element) {
    //   extractedData[element]['isActive'] =
    //       !extractedData[element]['isActive'];
    //   print(element);
    // });
    // for (var key = 0; key <= keys.length; key++) {
    //   extractedData[keys[key]]['isActive'] =
    //       !extractedData[keys[key]]['isActive'];
    //   print(keys[key]);
    // }
    extractedData[key1]['isActive'] = !extractedData[key1]['isActive'];
    extractedData[key2]['isActive'] = !extractedData[key2]['isActive'];

    print(extractedData);

    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$authToken';
    await http.patch(url, body: json.encode({'seatStatus': extractedData}));
    notifyListeners();
  }

  void update3SeatStatus(String id, int key1, int key2, int key3) async {
    final url2 =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id/seatStatus.json?auth=$authToken';
    final response2 = await http.get(url2);
    final extractedData = json.decode(response2.body);
    extractedData[key1]['isActive'] = !extractedData[key1]['isActive'];
    extractedData[key2]['isActive'] = !extractedData[key2]['isActive'];
    extractedData[key3]['isActive'] = !extractedData[key3]['isActive'];

    print(extractedData);

    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$authToken';
    await http.patch(url, body: json.encode({'seatStatus': extractedData}));
    notifyListeners();
  }

  // Set deleted seat to false
  void updateStatusAfterDelete(String id, int key) async {
    final url2 =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id/seatStatus.json?auth=$authToken';
    final response2 = await http.get(url2);
    final extractedData = json.decode(response2.body);
    //extractedData[key] = extractedData[key];
    extractedData[key]['isActive'] = !extractedData[key]['isActive'];
    print(extractedData);

    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$authToken';
    await http.patch(url, body: json.encode({'seatStatus': extractedData}));
    notifyListeners();
  }

  // void updateSeatStatus(String id) async {
  //   print('ride id: ' + id);
  // }

  Ride rides;

  Future<void> addReservation(List<CartItem> reservCart, double total) async {
    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/reservations/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'rides': reservCart
            .map((ri) => {
                  'id': ri.id,
                  'title': ri.title,
                  'quantity': ri.quantity,
                  'price': ri.seatPrice,
                  'seatStat': ri.seatStat,
                  'kimlikId': ri.id,
                  'seatOne': ri.seatOne,
                  'seatTwo': ri.seatTwo,
                  'seatThree': ri.seatThree,
                })
            .toList(),
      }),
    );
    _reserv.insert(
      0,
      ReservedItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        rides: reservCart,
        kimlikId: reservCart.map((e) => e.kimlik).toString(),
      ),
    );

    // var rideId = reservCart.contains('kimlik');
    // var rideId = reservCart.indexWhere((element) => element.kimlik != '');
    var rideId =
        reservCart.map((e) => e.kimlik).reduce((value, element) => value);
    var key =
        reservCart.map((e) => e.seatOne).reduce((value, element) => value);

    var key2 =
        reservCart.map((e) => e.seatTwo).reduce((value, element) => value);
    var key3 =
        reservCart.map((e) => e.seatThree).reduce((value, element) => value);

    // updateSeatStatus(rideId, key, key2, key3);
    //updateSeatStatus(rideId, key);

    //print(key + key2 + key3);
    // var seatSt = reservCart.map((e) => e.seatStat);
    if (key != null && key2 == null && key3 == null) {
      updateSeatStatus(rideId, key);
    } else if (key != null && key2 != null && key3 == null) {
      update2SeatStatus(rideId, key, key2);
    } else if (key != null && key2 != null && key3 != null) {
      update3SeatStatus(rideId, key, key2, key3);
    }
    // else if (key != null && key2 != null && key3 != null) {

    // }
    //updateSeatStatus(rideId, key);
    print('resItemId: ' + json.decode(response.body)['name']);
    print('rideId: ' + rideId.toString());
    print('key: ' +
        key.toString() +
        ' / ' +
        'key2: ' +
        key2.toString() +
        ' / ' +
        'key3: ' +
        key3.toString());
    notifyListeners();
  }

  Future<void> add2Reservation(List<CartItem> reservCart, double total) async {
    final url =
        'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/reservations/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'rides': reservCart
            .map((ri) => {
                  'id': ri.id,
                  'title': ri.title,
                  'quantity': ri.quantity,
                  'price': ri.seatPrice,
                  'seatStat': ri.seatStat,
                  'kimlikId': ri.id,
                  'seatOne': ri.seatOne,
                  'seatTwo': ri.seatTwo,
                })
            .toList(),
      }),
    );
    _reserv.insert(
      0,
      ReservedItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        rides: reservCart,
        kimlikId: reservCart.map((e) => e.kimlik).toString(),
      ),
    );
    var rideId =
        reservCart.map((e) => e.kimlik).reduce((value, element) => value);
    var key1 =
        reservCart.map((e) => e.seatOne).reduce((value, element) => value);
    var key2 =
        reservCart.map((e) => e.seatTwo).reduce((value, element) => value);
    update2SeatStatus(rideId, key1, key2);
    print('resItemId: ' + json.decode(response.body)['name']);
    print('rideId: ' + rideId.toString());
    notifyListeners();
  }
}
