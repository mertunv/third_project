import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:third_project/providers/rides.dart';

import '../providers/reservations.dart' as rstv;

class ReservItem extends StatefulWidget {
  final rstv.ReservedItem res;
  //final Rides rrr;

  ReservItem(this.res);

  @override
  _ReservItemState createState() => _ReservItemState();
}

class _ReservItemState extends State<ReservItem> {
  var _expanded = false;

  seatNumber(num) {
    var number = num + 1;
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.res.amount}'),
            // +
            //     ' Koltuk No: ' +
            //     '${widget.res.seats}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.res.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.res.rides.length * 20.0 + 35, 100),
              child: ListView(
                children: widget.res.rides
                    .map(
                      (ride) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            ride.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ride.seatOne.toInt() != null && ride.seatTwo == null && ride.seatThree == null ? 
                          Text(
                            '${ride.quantity}x \$${ride.seatPrice}' +
                                '\n' +
                                ' Koltuk: ' +
                                seatNumber(ride.seatOne.toInt()),
                            // ride.seatStat.,

                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ): ride.seatOne.toInt() != null && ride.seatTwo != null && ride.seatThree == null ? Text(
                            '${ride.quantity}x \$${ride.seatPrice}' +
                                '\n' +
                                ' Koltuk: ' +
                                seatNumber(ride.seatOne.toInt()) +
                                '/' +
                                seatNumber(ride.seatTwo.toInt()),
                            // ride.seatStat.,

                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ): ride.seatOne.toInt() != null && ride.seatTwo != null && ride.seatThree != null ?
                          Text(
                            '${ride.quantity}x \$${ride.seatPrice}' +
                                '\n' +
                                ' Koltuk: ' +
                                seatNumber(ride.seatOne.toInt()) +
                                '/' +
                                seatNumber(ride.seatTwo.toInt()) +
                                '/' +
                                seatNumber(ride.seatThree.toInt()),
                            // ride.seatStat.,

                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ):
                          Text(
                            '${ride.quantity}x \$${ride.seatPrice}' +
                                '\n' +
                                ' Koltuk: ' +
                                seatNumber(ride.seatOne.toInt()) +
                                '/' +
                                seatNumber(ride.seatTwo.toInt()) +
                                '/' +
                                seatNumber(ride.seatThree.toInt()),
                            // ride.seatStat.,

                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                Provider.of<rstv.Reservs>(context,
                                        listen: false)
                                    .deleteRes(widget.res.id);
                              } catch (e) {
                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Silme başarısız!',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Icon(Icons.delete_outline),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
