import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/rides.dart';
import '../widgets/ride_item.dart';

class RidesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ridesData = Provider.of<Rides>(context);
    final rides = ridesData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: rides.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: rides[i],
        child: RideItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
