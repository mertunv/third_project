import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/ride_detail_screen.dart';
import '../providers/ride.dart';
import '../providers/cart.dart';

class RideItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<Ride>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              RideDetailScreen.routeName,
              arguments: ride.id,
            );
          },
          child: Image.network(
            ride.picUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Ride>(
            // builder: (ctx, product, _) => IconButton(
            //   icon: Icon(
            //     product.isFavorite ? Icons.favorite : Icons.favorite_border,
            //   ),
            //   color: Theme.of(context).accentColor,
            //   onPressed: () {
            //     product.toggleFavoriteStatus();
            //   },
            // ),
            builder: (ctx, product, _) => Text(
              'Saat' +
                  ' ' +
                  ride.departureHour +
                  ' / ' +
                  'Tarih' +
                  ' ' +
                  ride.date,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          title: Text(
            ride.destinationPlace,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                RideDetailScreen.routeName,
                arguments: ride.id,
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
