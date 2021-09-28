import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reservations.dart' show Reservs;
import '../widgets/reserve_item.dart';
import '../widgets/app_drawer.dart';

class ReservsScreen extends StatelessWidget {
  static const routeName = '/reservs';

  Future<void> _refreshReservations(BuildContext context) async {
    await Provider.of<Reservs>(context, listen: false).fetchAndSetReservs();
  }

  @override
  Widget build(BuildContext context) {
    //final reservsData = Provider.of<Reservs>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Rezervasyonlarınız'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Reservs>(context, listen: false).fetchAndSetReservs(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('Hata!'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => _refreshReservations(context),
                child: Consumer<Reservs>(
                  builder: (ctx, resData, child) => ListView.builder(
                    itemCount: resData.reservs.length,
                    itemBuilder: (ctx, i) => ReservItem(resData.reservs[i]),
                  ),
                ),
              );
            }
          }
        },
      ),

      // ListView.builder(
      //   itemCount: reservsData.reservs.length,
      //   itemBuilder: (ctx, i) => OrderItem(reservsData.reservs[i]),
    );
  }
}
