import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:third_project/providers/reservations.dart';
import 'dart:convert';
import '../providers/seat_select.dart';
import '../providers/seat_number_toggle.dart';
import '../providers/seat_toggle_list.dart';
import '../widgets/seats.dart';
import '../providers/ride.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';

import '../providers/rides.dart';

class RideDetailScreen extends StatefulWidget {
  static const routeName = '/ride-detail';

  @override
  _RideDetailScreenState createState() => _RideDetailScreenState();
}

class _RideDetailScreenState extends State<RideDetailScreen> {
  customBoxDecoration(isActive) {
    return BoxDecoration(
      color: isActive ? Colors.cyan : Colors.white,
    );
  }

  final _formKey = GlobalKey<FormState>();

  final _oneNode = FocusNode();
  final _twoNode = FocusNode();
  final _twoNode2 = FocusNode();
  final _threeNode = FocusNode();
  final _threeNode2 = FocusNode();
  final _threeNode3 = FocusNode();

  final _seatNumber = TextEditingController();
  final _seatNumber2 = TextEditingController();
  final _seatNumber22 = TextEditingController();
  final _seatNumber3 = TextEditingController();
  final _seatNumber33 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final rideId = ModalRoute.of(context).settings.arguments as String;
    final loadedRide = Provider.of<Rides>(
      context,
      listen: false,
    ).findById(rideId);

    final seatList = loadedRide.seatStatus;

    var seatNumber;
    var seatNumber2;
    var seatNumber3;
    var value;

    setSeatReserv(smth) {
      //List seats = [];
      seatList.add(smth);
      return seatList;
    }

    getSeatNumber(x) {
      return x;
    }

    getSeatNumber2(y) {
      return y;
    }

    getSeatNumber3(z) {
      return z;
    }

    deleteSeatOne(List l) {
      l.clear();
    }

    setTwoSeat(sm, smh) {
      // List seat = [];
      // seat.add(sm);
      // seat.add(smh);
      // //seat.insertAll(0, [sm, smh]);
      // //seat.addAll([sm, smh]);
      // return seat;
      seatList.add(sm);
      seatList.add(smh);
      return seatList;
    }

    setThreeSeat(smm, smhh, smtth) {
      List s = [];
      s.add(smm);
      s.add(smhh);
      s.add(smtth);
      return s;
    }

    @override
    void dispose() {
      _oneNode.dispose();
      _twoNode.dispose();
      _twoNode2.dispose();
      _threeNode.dispose();
      _threeNode2.dispose();
      _threeNode3.dispose();
      _seatNumber.dispose();
      _seatNumber2.dispose();
      _seatNumber3.dispose();
      _seatNumber22.dispose();
      _seatNumber33.dispose();
      super.dispose();
    }

    // final seatSettings = Provider.of<Rides>(
    //   context,
    //   listen: false,
    // ).updateSeatStatus(rideId, loadedRide);
    // final loadedSeats = Provider.of<Rides>(
    //   context,
    //   listen: false,
    // ).findSeats(rideId);
    final databaseReferenceTest = FirebaseDatabase.instance.reference();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedRide.destinationPlace,
        ),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
                print(isSelected[0]);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedRide.picUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Fiyat:' + ' ' + '\u20BA${loadedRide.seatPrice}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontFamily: 'roboto',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Saat:' + ' ' + loadedRide.departureHour,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontFamily: 'roboto',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Tarih:' + ' ' + loadedRide.date,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontFamily: 'roboto',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   width: double.infinity,
            //   child: Text(
            //     loadedRide.departureHour,
            //     textAlign: TextAlign.center,
            //     softWrap: true,
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
////////////////////////////////////////////////////////////////////////////////
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Lütfen Bilet Sayısı Seçin:'),
                SizedBox(
                  height: 5,
                ),
                ToggleButtons(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '1',
                            style: TextStyle(fontSize: 32),
                          ),
                          Icon(Icons.airline_seat_recline_normal),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '2',
                            style: TextStyle(fontSize: 32),
                          ),
                          Icon(Icons.airline_seat_recline_normal),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '3',
                            style: TextStyle(fontSize: 32),
                          ),
                          Icon(Icons.airline_seat_recline_normal),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(6.0),
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         '4',
                    //         style: TextStyle(fontSize: 16),
                    //       ),
                    //       Icon(Icons.airline_seat_recline_normal),
                    //     ],
                    //   ),
                    // ),
                  ],
                  onPressed: (int index) {
                    int count = 0;
                    howMany.forEach((bool val) {
                      if (val) count++;
                    });

                    if (howMany[index] && count < 1) return;

                    setState(() {
                      howMany[index] = !howMany[index];
                    });
                    // if (isSelected[index]) {
                    //   cart.addItem(loadedRide.id, loadedRide.seatPrice,
                    //       loadedRide.rideCode);
                    // } else {
                    //   cart.removeSingleItem(loadedRide.id);
                    // }

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Positioned(
                                right: -40.0,
                                top: -40.0,
                                child: InkResponse(
                                  onTap: () {
                                    setState(() {
                                      howMany[index] = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    child: Icon(Icons.close),
                                    backgroundColor: Colors.cyan,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    index == 0
                                        ? Column(
                                            children: [
                                              TextFormField(
                                                controller: _seatNumber,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'Koltuk No',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            300),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Lütfen Doldurun.';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  if (value == '1') {
                                                    seatNumber = 0;
                                                  }
                                                  if (value == '2') {
                                                    seatNumber = 1;
                                                  }
                                                  if (value == '3') {
                                                    seatNumber = 2;
                                                  }
                                                  if (value == '4') {
                                                    seatNumber = 3;
                                                  }
                                                  if (value == '5') {
                                                    seatNumber = 4;
                                                  }
                                                  if (value == '6') {
                                                    seatNumber = 5;
                                                  }
                                                  if (value == '7') {
                                                    seatNumber = 6;
                                                  }
                                                  if (value == '8') {
                                                    seatNumber = 7;
                                                  }
                                                  if (value == '9') {
                                                    seatNumber = 8;
                                                  }
                                                  if (value == '10') {
                                                    seatNumber = 9;
                                                  }
                                                  if (value == '11') {
                                                    seatNumber = 10;
                                                  }
                                                  if (value == '12') {
                                                    seatNumber = 11;
                                                  }
                                                  if (value == '13') {
                                                    seatNumber = 12;
                                                  }
                                                  if (value == '14') {
                                                    seatNumber = 13;
                                                  }
                                                  if (value == '15') {
                                                    seatNumber = 14;
                                                  }
                                                  if (value == '16') {
                                                    seatNumber = 15;
                                                  }
                                                  if (value == '17') {
                                                    seatNumber = 16;
                                                  }
                                                  if (value == '18') {
                                                    seatNumber = 17;
                                                  }
                                                  if (value == '19') {
                                                    seatNumber = 18;
                                                  }
                                                  if (value == '20') {
                                                    seatNumber = 19;
                                                  }
                                                  if (value == '21') {
                                                    seatNumber = 20;
                                                  }
                                                  if (value == '22') {
                                                    seatNumber = 21;
                                                  }
                                                  if (value == '23') {
                                                    seatNumber = 22;
                                                  }
                                                  if (value == '24') {
                                                    seatNumber = 23;
                                                  }
                                                  if (value == '25') {
                                                    seatNumber = 24;
                                                  }
                                                  if (value == '26') {
                                                    seatNumber = 25;
                                                  }
                                                  if (value == '27') {
                                                    seatNumber = 26;
                                                  }
                                                  if (value == '28') {
                                                    seatNumber = 27;
                                                  }
                                                  if (value == '29') {
                                                    seatNumber = 28;
                                                  }
                                                  if (value == '30') {
                                                    seatNumber = 29;
                                                  }
                                                  if (value == '31') {
                                                    seatNumber = 30;
                                                  }
                                                  if (value == '32') {
                                                    seatNumber = 31;
                                                  }
                                                  if (value == '33') {
                                                    seatNumber = 32;
                                                  }
                                                  if (value == '34') {
                                                    seatNumber = 33;
                                                  }
                                                  if (value == '35') {
                                                    seatNumber = 34;
                                                  }
                                                  if (value == '36') {
                                                    seatNumber = 35;
                                                  }
                                                  if (value == '37') {
                                                    seatNumber = 36;
                                                  }
                                                  if (value == '38') {
                                                    seatNumber = 37;
                                                  }
                                                  if (value == '39') {
                                                    seatNumber = 38;
                                                  }
                                                  if (value == '40') {
                                                    seatNumber = 39;
                                                  }
                                                  print(value);
                                                },
                                                focusNode: _oneNode,
                                                // onSaved: (value) {
                                                //   if (value == '4') {
                                                //     seatNumber = 3;
                                                //   }
                                                // },
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    howMany[index] =
                                                        !howMany[index];
                                                    isSelected[seatNumber]
                                                            ['isActive'] =
                                                        !isSelected[seatNumber]
                                                            ['isActive'];
                                                    // if (isSelected[seatNumber]
                                                    //     ['isActive']) {}
                                                  });
                                                  print(seatNumber);
                                                  // loadedRide.seatStatus[
                                                  //     seatNumber] = false;
                                                  cart.addItem(
                                                    loadedRide.id,
                                                    loadedRide.seatPrice,
                                                    loadedRide.rideCode,
                                                    loadedRide.seatStatus =
                                                        setSeatReserv(loadedRide
                                                                .seatStatus[
                                                            seatNumber]),
                                                    loadedRide.id,
                                                    loadedRide.seatOne =
                                                        getSeatNumber(
                                                            seatNumber),
                                                  );
                                                  await Navigator.of(context)
                                                      .pushNamed(
                                                          CartScreen.routeName);
                                                  //loadedRide.seatStatus.clear();
                                                  // deleteSeatOne(
                                                  //     loadedRide.seatStatus);
                                                  // loadedRide.seatStatus =
                                                  //     setSeatReserv(
                                                  //         loadedRide.seatStatus[
                                                  //             seatNumber]);
                                                },
                                                child: Text('Koltuk Ayır'),
                                              ),
                                            ],
                                          )
                                        : index == 1
                                            ? Column(
                                                children: [
                                                  TextFormField(
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return 'Lütfen Doldurun.';
                                                      }
                                                      return null;
                                                    },
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: _seatNumber,
                                                    decoration: InputDecoration(
                                                      labelText: 'Koltuk No',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(300),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      if (value == '1') {
                                                        seatNumber = 0;
                                                      }
                                                      if (value == '2') {
                                                        seatNumber = 1;
                                                      }
                                                      if (value == '3') {
                                                        seatNumber = 2;
                                                      }
                                                      if (value == '4') {
                                                        seatNumber = 3;
                                                      }
                                                      if (value == '5') {
                                                        seatNumber = 4;
                                                      }
                                                      if (value == '6') {
                                                        seatNumber = 5;
                                                      }
                                                      if (value == '7') {
                                                        seatNumber = 6;
                                                      }
                                                      if (value == '8') {
                                                        seatNumber = 7;
                                                      }
                                                      if (value == '9') {
                                                        seatNumber = 8;
                                                      }
                                                      if (value == '10') {
                                                        seatNumber = 9;
                                                      }
                                                      if (value == '11') {
                                                        seatNumber = 10;
                                                      }
                                                      if (value == '12') {
                                                        seatNumber = 11;
                                                      }
                                                      if (value == '13') {
                                                        seatNumber = 12;
                                                      }
                                                      if (value == '14') {
                                                        seatNumber = 13;
                                                      }
                                                      if (value == '15') {
                                                        seatNumber = 14;
                                                      }
                                                      if (value == '16') {
                                                        seatNumber = 15;
                                                      }
                                                      if (value == '17') {
                                                        seatNumber = 16;
                                                      }
                                                      if (value == '18') {
                                                        seatNumber = 17;
                                                      }
                                                      if (value == '19') {
                                                        seatNumber = 18;
                                                      }
                                                      if (value == '20') {
                                                        seatNumber = 19;
                                                      }
                                                      if (value == '21') {
                                                        seatNumber = 20;
                                                      }
                                                      if (value == '22') {
                                                        seatNumber = 21;
                                                      }
                                                      if (value == '23') {
                                                        seatNumber = 22;
                                                      }
                                                      if (value == '24') {
                                                        seatNumber = 23;
                                                      }
                                                      if (value == '25') {
                                                        seatNumber = 24;
                                                      }
                                                      if (value == '26') {
                                                        seatNumber = 25;
                                                      }
                                                      if (value == '27') {
                                                        seatNumber = 26;
                                                      }
                                                      if (value == '28') {
                                                        seatNumber = 27;
                                                      }
                                                      if (value == '29') {
                                                        seatNumber = 28;
                                                      }
                                                      if (value == '30') {
                                                        seatNumber = 29;
                                                      }
                                                      if (value == '31') {
                                                        seatNumber = 30;
                                                      }
                                                      if (value == '32') {
                                                        seatNumber = 31;
                                                      }
                                                      if (value == '33') {
                                                        seatNumber = 32;
                                                      }
                                                      if (value == '34') {
                                                        seatNumber = 33;
                                                      }
                                                      if (value == '35') {
                                                        seatNumber = 34;
                                                      }
                                                      if (value == '36') {
                                                        seatNumber = 35;
                                                      }
                                                      if (value == '37') {
                                                        seatNumber = 36;
                                                      }
                                                      if (value == '38') {
                                                        seatNumber = 37;
                                                      }
                                                      if (value == '39') {
                                                        seatNumber = 38;
                                                      }
                                                      if (value == '40') {
                                                        seatNumber = 39;
                                                      }
                                                      print(value);
                                                    },
                                                    focusNode: _twoNode,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return 'Lütfen Doldurun.';
                                                      }
                                                      return null;
                                                    },
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: _seatNumber22,
                                                    decoration: InputDecoration(
                                                      labelText: 'Koltuk No',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(300),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      if (value == '1') {
                                                        seatNumber2 = 0;
                                                      }
                                                      if (value == '2') {
                                                        seatNumber2 = 1;
                                                      }
                                                      if (value == '3') {
                                                        seatNumber2 = 2;
                                                      }
                                                      if (value == '4') {
                                                        seatNumber2 = 3;
                                                      }
                                                      if (value == '5') {
                                                        seatNumber2 = 4;
                                                      }
                                                      if (value == '6') {
                                                        seatNumber2 = 5;
                                                      }
                                                      if (value == '7') {
                                                        seatNumber2 = 6;
                                                      }
                                                      if (value == '8') {
                                                        seatNumber2 = 7;
                                                      }
                                                      if (value == '9') {
                                                        seatNumber2 = 8;
                                                      }
                                                      if (value == '10') {
                                                        seatNumber2 = 9;
                                                      }
                                                      if (value == '11') {
                                                        seatNumber2 = 10;
                                                      }
                                                      if (value == '12') {
                                                        seatNumber2 = 11;
                                                      }
                                                      if (value == '13') {
                                                        seatNumber2 = 12;
                                                      }
                                                      if (value == '14') {
                                                        seatNumber2 = 13;
                                                      }
                                                      if (value == '15') {
                                                        seatNumber2 = 14;
                                                      }
                                                      if (value == '16') {
                                                        seatNumber2 = 15;
                                                      }
                                                      if (value == '17') {
                                                        seatNumber2 = 16;
                                                      }
                                                      if (value == '18') {
                                                        seatNumber2 = 17;
                                                      }
                                                      if (value == '19') {
                                                        seatNumber2 = 18;
                                                      }
                                                      if (value == '20') {
                                                        seatNumber2 = 19;
                                                      }
                                                      if (value == '21') {
                                                        seatNumber2 = 20;
                                                      }
                                                      if (value == '22') {
                                                        seatNumber2 = 21;
                                                      }
                                                      if (value == '23') {
                                                        seatNumber2 = 22;
                                                      }
                                                      if (value == '24') {
                                                        seatNumber2 = 23;
                                                      }
                                                      if (value == '25') {
                                                        seatNumber2 = 24;
                                                      }
                                                      if (value == '26') {
                                                        seatNumber2 = 25;
                                                      }
                                                      if (value == '27') {
                                                        seatNumber2 = 26;
                                                      }
                                                      if (value == '28') {
                                                        seatNumber2 = 27;
                                                      }
                                                      if (value == '29') {
                                                        seatNumber2 = 28;
                                                      }
                                                      if (value == '30') {
                                                        seatNumber2 = 29;
                                                      }
                                                      if (value == '31') {
                                                        seatNumber2 = 30;
                                                      }
                                                      if (value == '32') {
                                                        seatNumber2 = 31;
                                                      }
                                                      if (value == '33') {
                                                        seatNumber2 = 32;
                                                      }
                                                      if (value == '34') {
                                                        seatNumber2 = 33;
                                                      }
                                                      if (value == '35') {
                                                        seatNumber2 = 34;
                                                      }
                                                      if (value == '36') {
                                                        seatNumber2 = 35;
                                                      }
                                                      if (value == '37') {
                                                        seatNumber2 = 36;
                                                      }
                                                      if (value == '38') {
                                                        seatNumber2 = 37;
                                                      }
                                                      if (value == '39') {
                                                        seatNumber2 = 38;
                                                      }
                                                      if (value == '40') {
                                                        seatNumber2 = 39;
                                                      }
                                                      print(value);
                                                    },
                                                    focusNode: _twoNode2,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        howMany[index] =
                                                            !howMany[index];
                                                        isSelected[seatNumber]
                                                                ['isActive'] =
                                                            !isSelected[
                                                                    seatNumber]
                                                                ['isActive'];
                                                        isSelected[seatNumber2]
                                                                ['isActive'] =
                                                            !isSelected[
                                                                    seatNumber2]
                                                                ['isActive'];
                                                        // if (isSelected[seatNumber]
                                                        //     ['isActive']) {}
                                                      });
                                                      print(seatNumber);
                                                      print(seatNumber2);
                                                      // loadedRide.seatStatus[
                                                      //     seatNumber] = false;

                                                      cart.add2Item(
                                                        loadedRide.id,
                                                        loadedRide.seatPrice,
                                                        loadedRide.rideCode,
                                                        loadedRide.seatStatus =
                                                            setTwoSeat(
                                                                loadedRide
                                                                        .seatStatus[
                                                                    seatNumber],
                                                                loadedRide
                                                                        .seatStatus[
                                                                    seatNumber2]),
                                                        loadedRide.id,
                                                        loadedRide.seatOne = getSeatNumber(seatNumber),
                                                        loadedRide.seatTwo = getSeatNumber2(seatNumber2),
                                                      );

                                                      await Navigator.of(
                                                              context)
                                                          .pushNamed(CartScreen
                                                              .routeName);

                                                      // loadedRide.seatStatus =
                                                      //     setSeatReserv(
                                                      //         loadedRide.seatStatus[
                                                      //             seatNumber]);
                                                    },
                                                    child: Text('Koltuk Ayır'),
                                                  ),
                                                ],
                                              )
                                            : index == 2
                                                ? Column(
                                                    children: [
                                                      TextFormField(
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Lütfen Doldurun.';
                                                          }
                                                          return null;
                                                        },
                                                        controller: _seatNumber,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Koltuk No',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        300),
                                                          ),
                                                        ),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (value) {
                                                          if (value == '1') {
                                                            seatNumber = 0;
                                                          }
                                                          if (value == '2') {
                                                            seatNumber = 1;
                                                          }
                                                          if (value == '3') {
                                                            seatNumber = 2;
                                                          }
                                                          if (value == '4') {
                                                            seatNumber = 3;
                                                          }
                                                          if (value == '5') {
                                                            seatNumber = 4;
                                                          }
                                                          if (value == '6') {
                                                            seatNumber = 5;
                                                          }
                                                          if (value == '7') {
                                                            seatNumber = 6;
                                                          }
                                                          if (value == '8') {
                                                            seatNumber = 7;
                                                          }
                                                          if (value == '9') {
                                                            seatNumber = 8;
                                                          }
                                                          if (value == '10') {
                                                            seatNumber = 9;
                                                          }
                                                          if (value == '11') {
                                                            seatNumber = 10;
                                                          }
                                                          if (value == '12') {
                                                            seatNumber = 11;
                                                          }
                                                          if (value == '13') {
                                                            seatNumber = 12;
                                                          }
                                                          if (value == '14') {
                                                            seatNumber = 13;
                                                          }
                                                          if (value == '15') {
                                                            seatNumber = 14;
                                                          }
                                                          if (value == '16') {
                                                            seatNumber = 15;
                                                          }
                                                          if (value == '17') {
                                                            seatNumber = 16;
                                                          }
                                                          if (value == '18') {
                                                            seatNumber = 17;
                                                          }
                                                          if (value == '19') {
                                                            seatNumber = 18;
                                                          }
                                                          if (value == '20') {
                                                            seatNumber = 19;
                                                          }
                                                          if (value == '21') {
                                                            seatNumber = 20;
                                                          }
                                                          if (value == '22') {
                                                            seatNumber = 21;
                                                          }
                                                          if (value == '23') {
                                                            seatNumber = 22;
                                                          }
                                                          if (value == '24') {
                                                            seatNumber = 23;
                                                          }
                                                          if (value == '25') {
                                                            seatNumber = 24;
                                                          }
                                                          if (value == '26') {
                                                            seatNumber = 25;
                                                          }
                                                          if (value == '27') {
                                                            seatNumber = 26;
                                                          }
                                                          if (value == '28') {
                                                            seatNumber = 27;
                                                          }
                                                          if (value == '29') {
                                                            seatNumber = 28;
                                                          }
                                                          if (value == '30') {
                                                            seatNumber = 29;
                                                          }
                                                          if (value == '31') {
                                                            seatNumber = 30;
                                                          }
                                                          if (value == '32') {
                                                            seatNumber = 31;
                                                          }
                                                          if (value == '33') {
                                                            seatNumber = 32;
                                                          }
                                                          if (value == '34') {
                                                            seatNumber = 33;
                                                          }
                                                          if (value == '35') {
                                                            seatNumber = 34;
                                                          }
                                                          if (value == '36') {
                                                            seatNumber = 35;
                                                          }
                                                          if (value == '37') {
                                                            seatNumber = 36;
                                                          }
                                                          if (value == '38') {
                                                            seatNumber = 37;
                                                          }
                                                          if (value == '39') {
                                                            seatNumber = 38;
                                                          }
                                                          if (value == '40') {
                                                            seatNumber = 39;
                                                          }
                                                          print(value);
                                                        },
                                                        focusNode: _threeNode,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            _seatNumber2,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Koltuk No',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        300),
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Lütfen Doldurun.';
                                                          }
                                                          return null;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (value) {
                                                          if (value == '1') {
                                                            seatNumber2 = 0;
                                                          }
                                                          if (value == '2') {
                                                            seatNumber2 = 1;
                                                          }
                                                          if (value == '3') {
                                                            seatNumber2 = 2;
                                                          }
                                                          if (value == '4') {
                                                            seatNumber2 = 3;
                                                          }
                                                          if (value == '5') {
                                                            seatNumber2 = 4;
                                                          }
                                                          if (value == '6') {
                                                            seatNumber2 = 5;
                                                          }
                                                          if (value == '7') {
                                                            seatNumber2 = 6;
                                                          }
                                                          if (value == '8') {
                                                            seatNumber2 = 7;
                                                          }
                                                          if (value == '9') {
                                                            seatNumber2 = 8;
                                                          }
                                                          if (value == '10') {
                                                            seatNumber2 = 9;
                                                          }
                                                          if (value == '11') {
                                                            seatNumber2 = 10;
                                                          }
                                                          if (value == '12') {
                                                            seatNumber2 = 11;
                                                          }
                                                          if (value == '13') {
                                                            seatNumber2 = 12;
                                                          }
                                                          if (value == '14') {
                                                            seatNumber2 = 13;
                                                          }
                                                          if (value == '15') {
                                                            seatNumber2 = 14;
                                                          }
                                                          if (value == '16') {
                                                            seatNumber2 = 15;
                                                          }
                                                          if (value == '17') {
                                                            seatNumber2 = 16;
                                                          }
                                                          if (value == '18') {
                                                            seatNumber2 = 17;
                                                          }
                                                          if (value == '19') {
                                                            seatNumber2 = 18;
                                                          }
                                                          if (value == '20') {
                                                            seatNumber2 = 19;
                                                          }
                                                          if (value == '21') {
                                                            seatNumber2 = 20;
                                                          }
                                                          if (value == '22') {
                                                            seatNumber2 = 21;
                                                          }
                                                          if (value == '23') {
                                                            seatNumber2 = 22;
                                                          }
                                                          if (value == '24') {
                                                            seatNumber2 = 23;
                                                          }
                                                          if (value == '25') {
                                                            seatNumber2 = 24;
                                                          }
                                                          if (value == '26') {
                                                            seatNumber2 = 25;
                                                          }
                                                          if (value == '27') {
                                                            seatNumber2 = 26;
                                                          }
                                                          if (value == '28') {
                                                            seatNumber2 = 27;
                                                          }
                                                          if (value == '29') {
                                                            seatNumber2 = 28;
                                                          }
                                                          if (value == '30') {
                                                            seatNumber2 = 29;
                                                          }
                                                          if (value == '31') {
                                                            seatNumber2 = 30;
                                                          }
                                                          if (value == '32') {
                                                            seatNumber2 = 31;
                                                          }
                                                          if (value == '33') {
                                                            seatNumber2 = 32;
                                                          }
                                                          if (value == '34') {
                                                            seatNumber2 = 33;
                                                          }
                                                          if (value == '35') {
                                                            seatNumber2 = 34;
                                                          }
                                                          if (value == '36') {
                                                            seatNumber2 = 35;
                                                          }
                                                          if (value == '37') {
                                                            seatNumber2 = 36;
                                                          }
                                                          if (value == '38') {
                                                            seatNumber2 = 37;
                                                          }
                                                          if (value == '39') {
                                                            seatNumber2 = 38;
                                                          }
                                                          if (value == '40') {
                                                            seatNumber2 = 39;
                                                          }
                                                          print(value);
                                                        },
                                                        focusNode: _threeNode2,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            _seatNumber3,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Lütfen Doldurun.';
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Koltuk No',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        300),
                                                          ),
                                                        ),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (value) {
                                                          if (value == '1') {
                                                            seatNumber3 = 0;
                                                          }
                                                          if (value == '2') {
                                                            seatNumber3 = 1;
                                                          }
                                                          if (value == '3') {
                                                            seatNumber3 = 2;
                                                          }
                                                          if (value == '4') {
                                                            seatNumber3 = 3;
                                                          }
                                                          if (value == '5') {
                                                            seatNumber3 = 4;
                                                          }
                                                          if (value == '6') {
                                                            seatNumber3 = 5;
                                                          }
                                                          if (value == '7') {
                                                            seatNumber3 = 6;
                                                          }
                                                          if (value == '8') {
                                                            seatNumber3 = 7;
                                                          }
                                                          if (value == '9') {
                                                            seatNumber3 = 8;
                                                          }
                                                          if (value == '10') {
                                                            seatNumber3 = 9;
                                                          }
                                                          if (value == '11') {
                                                            seatNumber3 = 10;
                                                          }
                                                          if (value == '12') {
                                                            seatNumber3 = 11;
                                                          }
                                                          if (value == '13') {
                                                            seatNumber3 = 12;
                                                          }
                                                          if (value == '14') {
                                                            seatNumber3 = 13;
                                                          }
                                                          if (value == '15') {
                                                            seatNumber3 = 14;
                                                          }
                                                          if (value == '16') {
                                                            seatNumber3 = 15;
                                                          }
                                                          if (value == '17') {
                                                            seatNumber3 = 16;
                                                          }
                                                          if (value == '18') {
                                                            seatNumber3 = 17;
                                                          }
                                                          if (value == '19') {
                                                            seatNumber3 = 18;
                                                          }
                                                          if (value == '20') {
                                                            seatNumber3 = 19;
                                                          }
                                                          if (value == '21') {
                                                            seatNumber3 = 20;
                                                          }
                                                          if (value == '22') {
                                                            seatNumber3 = 21;
                                                          }
                                                          if (value == '23') {
                                                            seatNumber3 = 22;
                                                          }
                                                          if (value == '24') {
                                                            seatNumber3 = 23;
                                                          }
                                                          if (value == '25') {
                                                            seatNumber3 = 24;
                                                          }
                                                          if (value == '26') {
                                                            seatNumber3 = 25;
                                                          }
                                                          if (value == '27') {
                                                            seatNumber3 = 26;
                                                          }
                                                          if (value == '28') {
                                                            seatNumber3 = 27;
                                                          }
                                                          if (value == '29') {
                                                            seatNumber3 = 28;
                                                          }
                                                          if (value == '30') {
                                                            seatNumber3 = 29;
                                                          }
                                                          if (value == '31') {
                                                            seatNumber3 = 30;
                                                          }
                                                          if (value == '32') {
                                                            seatNumber3 = 31;
                                                          }
                                                          if (value == '33') {
                                                            seatNumber3 = 32;
                                                          }
                                                          if (value == '34') {
                                                            seatNumber3 = 33;
                                                          }
                                                          if (value == '35') {
                                                            seatNumber3 = 34;
                                                          }
                                                          if (value == '36') {
                                                            seatNumber3 = 35;
                                                          }
                                                          if (value == '37') {
                                                            seatNumber3 = 36;
                                                          }
                                                          if (value == '38') {
                                                            seatNumber3 = 37;
                                                          }
                                                          if (value == '39') {
                                                            seatNumber3 = 38;
                                                          }
                                                          if (value == '40') {
                                                            seatNumber3 = 39;
                                                          }
                                                          print(value);
                                                        },
                                                        focusNode: _threeNode3,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            howMany[index] =
                                                                !howMany[index];
                                                            isSelected[seatNumber]
                                                                    [
                                                                    'isActive'] =
                                                                !isSelected[
                                                                        seatNumber]
                                                                    [
                                                                    'isActive'];
                                                            isSelected[seatNumber2]
                                                                    [
                                                                    'isActive'] =
                                                                !isSelected[
                                                                        seatNumber2]
                                                                    [
                                                                    'isActive'];
                                                            isSelected[seatNumber3]
                                                                    [
                                                                    'isActive'] =
                                                                !isSelected[
                                                                        seatNumber3]
                                                                    [
                                                                    'isActive'];
                                                            // if (isSelected[seatNumber]
                                                            //     ['isActive']) {}
                                                          });
                                                          print(seatNumber);
                                                          // loadedRide.seatStatus[
                                                          //     seatNumber] = false;
                                                          cart.add3Item(
                                                            loadedRide.id,
                                                            loadedRide
                                                                .seatPrice,
                                                            loadedRide.rideCode,
                                                            loadedRide.seatStatus = setThreeSeat(
                                                                loadedRide
                                                                        .seatStatus[
                                                                    seatNumber],
                                                                loadedRide
                                                                        .seatStatus[
                                                                    seatNumber2],
                                                                loadedRide
                                                                        .seatStatus[
                                                                    seatNumber3]),
                                                            loadedRide.id,
                                                            loadedRide.seatOne = getSeatNumber(seatNumber),
                                                            loadedRide.seatTwo = getSeatNumber2(seatNumber2),
                                                            loadedRide.seatThree = getSeatNumber3(seatNumber3)
                                                          );
                                                          await Navigator.of(
                                                                  context)
                                                              .pushNamed(
                                                                  CartScreen
                                                                      .routeName);
                                                          // loadedRide.seatStatus =
                                                          //     setSeatReserv(
                                                          //         loadedRide.seatStatus[
                                                          //             seatNumber]);
                                                        },
                                                        child:
                                                            Text('Koltuk Ayır'),
                                                      ),
                                                    ],
                                                  )
                                                : null,
                                    // Padding(
                                    //     padding:
                                    //         const EdgeInsets.all(8.0),
                                    //     child: RaisedButton(
                                    //       child: Text("Koltuk Ayır"),
                                    //       onPressed: () {
                                    //         if (_formKey.currentState
                                    //             .validate()) {
                                    //           _formKey.currentState
                                    //               .save();
                                    //         }
                                    //       },
                                    //     ),
                                    //   )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  isSelected: howMany,
                  fillColor: Colors.cyan,
                  selectedColor: Colors.white,
                  splashColor: Colors.cyan[100],
                  borderRadius: BorderRadius.circular(200),
                  //borderWidth: 5,
                ),
              ],
            ),
////////////////////////////////////////////////////////////////////////////////
            SizedBox(
              height: 10,
            ),
            Text('Otobüsteki Koltuk Durumu: Mavi Rezerve, Beyaz Boş'),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Wrap(
                  spacing: 10.0,
                  runSpacing: 20.0,
                  //children: loadedRide.seatStatus
                  children: loadedRide.seatStatus
                      .map(
                        (option) => new Container(
                          height: 90,
                          width: 75,
                          child: ToggleButtons(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  children: [
                                    Text(
                                      option['title'],
                                      style: TextStyle(fontSize: 32),
                                    ),
                                    Icon(Icons.airline_seat_recline_normal),
                                  ],
                                ),
                              ),
                            ],
                            isSelected: [
                              option['isActive'],
                            ],
                            onPressed: (context) {
                              option['isActive'] = !option['isActive'];
                              // setState(() {
                              //   option['isActive'] = !option['isActive'];
                              // });
                            },
                            // (context) {
                            //   // var index = 0;
                            //   // var seatsSt = isSelected.asMap();
                            //   // var stat = seatsSt[index];

                            //   // print(stat);

                            //   // int count = 0;
                            //   // option.forEach((bool val) {
                            //   //   if (val) count++;
                            //   // });

                            //   // if (isSelected[index]['isActive'] && count < 1)
                            //   //   return;
                            //   var idOfRide = loadedRide.id;
                            //   final url =
                            //       'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$idOfRide/seatStatus.json?';

                            //   setSeat(smth) {
                            //     List seats = [];
                            //     seats.add(smth);
                            //     return seats;
                            //   }

                            //   // List<ReservedItem> get reservs {
                            //   //   return [..._reserv];
                            //   // }

                            //   setState(() {
                            //     option['isActive'] = !option['isActive'];
                            //     // loadedRide.seatStatus =
                            //     //     setSeat(option['title']);
                            //     // databaseReferenceTest
                            //     //     .child(
                            //     //       'https://ztourismapp-default-rtdb.europe-west1.firebasedatabase.app/rides/$id.json?auth=$authToken',
                            //     //     )
                            //     //     .onValue
                            //     //     .listen((event) {
                            //     //   var snapshot = event.snapshot;
                            //     //   //snapshot.option['title']['isActive']
                            //     // });
                            //  //   http.patch(url,
                            //  //       body: json.encode({
                            //  //         'seatStatus': setSeat(option['title']),
                            //  //       }));
                            //   });
                            //   if (option['isActive']) {
                            //     print(option['title'] + ' ' + 'is selected');
                            //     // index = option['isActive'];
                            //     cart.addItem(
                            //       loadedRide.id,
                            //       loadedRide.seatPrice,
                            //       loadedRide.rideCode,
                            //       loadedRide.seatStatus =
                            //           setSeat(option['title']),
                            //       loadedRide.id,
                            //     );
                            //     // Provider.of<Rides>(
                            //     //   ,
                            //     //   listen: false,
                            //     // ).updateSeatStatus(rideId, loadedRide);
                            //     loadedRide.seatStatus =
                            //         setSeat(option['title']);
                            //     print(loadedRide.id + ' : ' + 'id');
                            //     print(setSeat(option['title']));
                            //   } else {
                            //     cart.removeSingleItem(loadedRide.id);
                            //     print(option['title'] + ' ' + 'is unselected');
                            //   }
                            // },
                            borderRadius: BorderRadius.circular(200),
                            fillColor: Colors.cyan,
                            selectedColor: Colors.white,
                            splashColor: Colors.cyan[100],
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),

            // Container(
            //   child: GridView.count(
            //     crossAxisCount: 4,
            //     children: [
            //       ListView.builder(
            //         itemCount: isSelected.length,
            //         itemBuilder: (context, index) {
            //           return ToggleButtons(
            //             children: <Widget>[
            //               Padding(
            //                 padding: const EdgeInsets.all(6.0),
            //                 child: Column(
            //                   children: [
            //                     ListTile(
            //                       title: Text(isSelected[index].toString()),
            //                       //style: TextStyle(fontSize: 16),
            //                     ),
            //                     Icon(Icons.airline_seat_recline_normal),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //             isSelected: isSelected,
            //             onPressed: (int index) {
            //               int count = 0;
            //               isSelected.forEach((bool val) {
            //                 if (val) count++;
            //               });

            //               if (isSelected[index] && count < 1) return;

            //               setState(() {
            //                 isSelected[index] = !isSelected[index];
            //               });
            //             },
            //           );
            //         },
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
