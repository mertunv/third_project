import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_ride_screen.dart';
import '../providers/rides.dart';

class UserRideItem extends StatelessWidget {
  final String id;
  final String rideCode;
  final String date;
  final String departureHour;

  UserRideItem(this.id, this.rideCode, this.date, this.departureHour);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text((id + '\n' + rideCode + '\n' + date + '\n' + departureHour)),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddRideScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  Provider.of<Rides>(context, listen: false).deleteRide(id);
                } catch (error) {
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
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
