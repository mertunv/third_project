import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/rides.dart';
import '../widgets/user_ride_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/add_ride_screen.dart';

class UserRidesScreen extends StatelessWidget {
  static const routeName = '/user-rides';

  Future<void> _refreshAddedRides(BuildContext context) async {
    await Provider.of<Rides>(context, listen: false).fetchRides();
  }

  @override
  Widget build(BuildContext context) {
    final ridesData = Provider.of<Rides>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seferleriniz'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddRideScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshAddedRides(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: ridesData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserRideItem(
                  ridesData.items[i].id,
                  ridesData.items[i].rideCode,
                  ridesData.items[i].date,
                  ridesData.items[i].departureHour,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
