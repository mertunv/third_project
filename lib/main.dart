import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/splash_screen.dart';
import '../providers/auth.dart';

import './screens/cart_screen.dart';
import '../screens/ride_overview_screen.dart';
import '../screens/ride_detail_screen.dart';
import '../providers/rides.dart';
import '../providers/cart.dart';
import '../providers/reservations.dart';
import '../screens/reservs_screen.dart';
import '../screens/added_rides_screen.dart';
import '../screens/add_ride_screen.dart';
import '../screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Rides>(
            create: (_) => Rides('', '', []),
            update: (ctx, auth, prevRides) => Rides(
              auth.token,
              auth.userId,
              prevRides == null ? [] : prevRides.items,
            ),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Reservs>(
            create: (ctx) => Reservs('', '', []),
            update: (ctx, auth, prevReservs) => Reservs(
              auth.token,
              auth.userId,
              prevReservs == null ? [] : prevReservs.reservs,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'Hoşgeldiniz',
              theme: ThemeData(
                primarySwatch: Colors.cyan,
                accentColor: Colors.cyanAccent,
                fontFamily: 'Lato',
              ),
              home: auth.isAuthenticated
                  ? RideOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLog(),
                      builder: (ctx, authResultingSnapshot) =>
                          authResultingSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                RideDetailScreen.routeName: (ctx) => RideDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                ReservsScreen.routeName: (ctx) => ReservsScreen(),
                UserRidesScreen.routeName: (ctx) => UserRidesScreen(),
                AddRideScreen.routeName: (ctx) => AddRideScreen(),
              }),
        ));
  }
}
