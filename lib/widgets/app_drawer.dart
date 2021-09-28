import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/reservs_screen.dart';
import '../screens/added_rides_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  var auth = Auth();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Merhaba!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.directions_bus_outlined),
            title: Text('Seferler'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.confirmation_num_outlined),
            title: Text('Biletlerim'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ReservsScreen.routeName);
            },
          ),
          Divider(),
          //auth.adminGet == true
          //auth.adminUser()
          // auth.adminGet()
          //     ? ListTile(
          //         leading: Icon(Icons.add_road_outlined),
          //         title: Text('Sefer Ekle'),
          //         onTap: () {
          //           Navigator.of(context)
          //               .pushReplacementNamed(UserRidesScreen.routeName);
          //         },
          //       )
          //     : Divider(),
          // Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app_outlined),
            title: Text('Cıkıs Yap'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
