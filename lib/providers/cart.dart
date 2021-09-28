import 'package:flutter/foundation.dart';
import '../providers/seat_toggle_list.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double seatPrice;
  List seatStat;
  var kimlik;
  int seatOne;
  int seatTwo;
  int seatThree;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.seatPrice,
    this.seatStat,
    this.kimlik,
    this.seatOne,
    this.seatTwo,
    this.seatThree,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.seatPrice * cartItem.quantity;
    });
    return total;
  }

  setId(String someId) {
    return someId;
  }

  void addItem(
    String rideId,
    double price,
    String title,
    List seatOcc,
    String kim,
    int seatOne
  ) {
    if (_items.containsKey(rideId)) {
      _items.update(
        rideId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          seatPrice: existingCartItem.seatPrice,
          quantity: existingCartItem.quantity + 1,
          seatStat: existingCartItem.seatStat,
          kimlik: rideId,
          seatOne: seatOne,
        ),
      );
    } else {
      _items.putIfAbsent(
        rideId,
        () => CartItem(
          id: rideId,
          title: title,
          seatPrice: price,
          quantity: 1,
          seatStat: isSelected,
          kimlik: rideId,
          seatOne: seatOne,
        ),
      );
    }
    kim = rideId;
    print(kim + ' : ' + 'kim');
    notifyListeners();
  }

  void add2Item(
    String rideId,
    double price,
    String title,
    List seatOcc,
    String kim,
    int seatOne,
    int seatTwo
  ) {
    if (_items.containsKey(rideId)) {
      _items.update(
        rideId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          seatPrice: existingCartItem.seatPrice,
          quantity: existingCartItem.quantity + 2,
          seatStat: existingCartItem.seatStat,
          kimlik: rideId,
          seatOne: seatOne,
          seatTwo: seatTwo,
        ),
      );
    } else {
      _items.putIfAbsent(
        rideId,
        () => CartItem(
          id: rideId,
          title: title,
          seatPrice: price,
          quantity: 2,
          seatStat: isSelected,
          kimlik: rideId,
          seatOne: seatOne,
          seatTwo: seatTwo,
        ),
      );
    }
    kim = rideId;
    print(kim + ' : ' + 'kim');
    notifyListeners();
  }

  void add3Item(
    String rideId,
    double price,
    String title,
    List seatOcc,
    String kim,
    int seatOne,
    int seatTwo,
    int seatThree
  ) {
    if (_items.containsKey(rideId)) {
      _items.update(
        rideId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          seatPrice: existingCartItem.seatPrice,
          quantity: existingCartItem.quantity + 3,
          seatStat: existingCartItem.seatStat,
          kimlik: rideId,
          seatOne: seatOne,
          seatTwo: seatTwo,
          seatThree: seatThree,
        ),
      );
    } else {
      _items.putIfAbsent(
        rideId,
        () => CartItem(
          id: rideId,
          title: title,
          seatPrice: price,
          quantity: 3,
          seatStat: isSelected,
          kimlik: rideId,
          seatOne: seatOne,
          seatTwo: seatTwo,
          seatThree: seatThree,
        ),
      );
    }
    kim = rideId;
    print(kim + ' : ' + 'kim');
    notifyListeners();
  }

  void removeItem(String rideId) {
    _items.remove(rideId);
    notifyListeners();
  }

  void removeSingleItem(String rideId) {
    if (!_items.containsKey(rideId)) {
      return;
    }
    if (_items[rideId].quantity > 1) {
      _items.update(
          rideId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                seatPrice: existingCartItem.seatPrice,
                quantity: existingCartItem.quantity - 1,
                seatStat: existingCartItem.seatStat,
                kimlik: rideId,
              ));
    } else {
      _items.remove(rideId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
