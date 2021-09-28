import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Seats extends StatefulWidget {
  @override
  _SeatsState createState() => _SeatsState();
}

class _SeatsState extends State<Seats> {
  final List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      children: [
        ListView.builder(
          itemBuilder: (context, index) {
            return ToggleButtons(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      Text(
                        index.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.airline_seat_recline_normal),
                    ],
                  ),
                ),
              ],
              isSelected: isSelected,
              onPressed: (int index) {
                int count = 0;
                isSelected.forEach((bool val) {
                  if (val) count++;
                });

                if (isSelected[index] && count < 1) return;

                setState(() {
                  isSelected[index] = !isSelected[index];
                });
              },
            );
          },
        )
      ],
    );
  }
}
