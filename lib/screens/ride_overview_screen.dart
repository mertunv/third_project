import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/rides_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
import '../screens/cart_screen.dart';
import '../providers/rides.dart';
import '../providers/ad.dart' as a;
import '../screens/added_rides_screen.dart';

enum FilterOptions {
  Add,
}

class RideOverviewScreen extends StatefulWidget {
  @override
  _RideOverviewScreenState createState() => _RideOverviewScreenState();
}

class _RideOverviewScreenState extends State<RideOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _loading = false;
  var auth = Auth();

  Future<void> _refreshAddedRides(BuildContext context) async {
    await Provider.of<Rides>(context, listen: false).fetchRides();
  }

  Future<void> _addRides(BuildContext context) async {
    Navigator.of(context).pushReplacementNamed(UserRidesScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _loading = true;
      });

      Provider.of<Rides>(context).fetchRides().then((_) {
        setState(() {
          _loading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Merhaba'),
        actions: <Widget>[
          a.isAd == true
              ? IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(UserRidesScreen.routeName);
                  },
                  color: Theme.of(context).primaryTextTheme.button.color,
                )
              : Divider(),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshAddedRides(context),
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RidesGrid(),
      ),
    );
  }
}
