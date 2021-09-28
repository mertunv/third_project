import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ride.dart';
import '../providers/rides.dart';

class AddRideScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _AddRideScreenState createState() => _AddRideScreenState();
}

class _AddRideScreenState extends State<AddRideScreen> {
  final _startNode = FocusNode();
  final _finishNode = FocusNode();
  final _rideCodeNode = FocusNode();
  final _dateNode = FocusNode();
  final _departureHourNode = FocusNode();
  final _arrivalHourNode = FocusNode();
  final _seatPriceNode = FocusNode();
  final _noteNode = FocusNode();

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _editedRide = Ride(
    id: null,
    departurePlace: '',
    rideCode: '0',
    note: '',
    destinationPlace: '',
    date: '',
    departureHour: '',
    arrivalHour: '',
    seatPrice: 0,
  );
  var _initValues = {
    'departurePlace': '',
    'destinationPlace': '',
    'rideCode': '',
    'date': '',
    'departureHour': '',
    'arrivalHour': '',
    'seatPrice': 0,
    'note': '',
  };
  var _isInit = true;
  var _loading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final rideId = ModalRoute.of(context).settings.arguments as String;
      if (rideId != null) {
        _editedRide =
            Provider.of<Rides>(context, listen: false).findById(rideId);
        _initValues = {
          'departurePlace': _editedRide.departurePlace,
          'destinationPlace': _editedRide.departurePlace,
          'rideCode': _editedRide.rideCode,
          'date': _editedRide.date,
          'departureHour': _editedRide.departureHour,
          'arrivalHour': _editedRide.arrivalHour,
          'seatPrice': _editedRide.seatPrice,
          'note': _editedRide.note,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _finishNode.dispose();
    _startNode.dispose();
    _rideCodeNode.dispose();
    _dateNode.dispose();
    _departureHourNode.dispose();
    _arrivalHourNode.dispose();
    _seatPriceNode.dispose();
    _noteNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    setState(() {
      _loading = true;
    });

    if (_editedRide.id != null) {
      await Provider.of<Rides>(context, listen: false)
          .updateRide(_editedRide.id, _editedRide);
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Rides>(context, listen: false).addRide(_editedRide).then((_) {
        setState(() {
          _loading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sefer Ekle/Düzenle'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['departurePlace'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(300),
                        ),
                        labelText: 'Baslangıç Yeri',
                        prefixIcon: Icon(Icons.bus_alert_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_finishNode);
                      },
                      onSaved: (value) {
                        _editedRide = Ride(
                          departurePlace: value,
                          destinationPlace: _editedRide.destinationPlace,
                          rideCode: _editedRide.rideCode,
                          date: _editedRide.date,
                          departureHour: _editedRide.departureHour,
                          arrivalHour: _editedRide.arrivalHour,
                          seatPrice: _editedRide.seatPrice,
                          note: _editedRide.note,
                          id: _editedRide.id,
                        );
                      },
                    ),
                    Divider(),
                    TextFormField(
                      initialValue: _initValues['destinationPlace'],
                      decoration: InputDecoration(
                        labelText: 'Varıs Yeri',
                        prefixIcon: Icon(Icons.bus_alert_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(300),
                        ),
                      ),
                      focusNode: _finishNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_rideCodeNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Lütfen Doldurun.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedRide = Ride(
                          departurePlace: _editedRide.departurePlace,
                          destinationPlace: value,
                          rideCode: _editedRide.rideCode,
                          date: _editedRide.date,
                          departureHour: _editedRide.departureHour,
                          arrivalHour: _editedRide.arrivalHour,
                          seatPrice: _editedRide.seatPrice,
                          note: _editedRide.note,
                          id: _editedRide.id,
                        );
                      },
                    ),
                    Divider(),
                    TextFormField(
                      initialValue: _initValues['rideCode'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(300),
                        ),
                        labelText: 'Kodu',
                        prefixIcon: Icon(Icons.pin_drop_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _rideCodeNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_dateNode);
                      },
                      onSaved: (value) {
                        _editedRide = Ride(
                          departurePlace: _editedRide.departurePlace,
                          destinationPlace: _editedRide.destinationPlace,
                          rideCode: value,
                          date: _editedRide.date,
                          departureHour: _editedRide.departureHour,
                          arrivalHour: _editedRide.arrivalHour,
                          seatPrice: _editedRide.seatPrice,
                          note: _editedRide.note,
                          id: _editedRide.id,
                        );
                      },
                    ),
                    Divider(),
                    TextFormField(
                      initialValue: _initValues['date'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(300),
                        ),
                        labelText: 'Tarih',
                        prefixIcon: Icon(Icons.date_range_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _dateNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_departureHourNode);
                      },
                      onSaved: (value) {
                        _editedRide = Ride(
                          departurePlace: _editedRide.departurePlace,
                          destinationPlace: _editedRide.destinationPlace,
                          rideCode: _editedRide.rideCode,
                          date: value,
                          departureHour: _editedRide.departureHour,
                          arrivalHour: _editedRide.arrivalHour,
                          seatPrice: _editedRide.seatPrice,
                          note: _editedRide.note,
                          id: _editedRide.id,
                        );
                      },
                    ),
                    Divider(),
                    TextFormField(
                      initialValue: _initValues['departureHour'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(300),
                        ),
                        labelText: 'Kalkıs Saati',
                        prefixIcon: Icon(Icons.hourglass_top_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _departureHourNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_arrivalHourNode);
                      },
                      onSaved: (value) {
                        _editedRide = Ride(
                          departurePlace: _editedRide.departurePlace,
                          destinationPlace: _editedRide.destinationPlace,
                          rideCode: _editedRide.rideCode,
                          date: _editedRide.date,
                          departureHour: value,
                          arrivalHour: _editedRide.arrivalHour,
                          seatPrice: _editedRide.seatPrice,
                          note: _editedRide.note,
                          id: _editedRide.id,
                        );
                      },
                    ),
                    Divider(),
                    TextFormField(
                      initialValue: _initValues['arrivalHour'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(300),
                        ),
                        labelText: 'Varıs Saati',
                        prefixIcon: Icon(Icons.hourglass_bottom_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _arrivalHourNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedRide = Ride(
                          departurePlace: _editedRide.departurePlace,
                          destinationPlace: _editedRide.destinationPlace,
                          rideCode: _editedRide.rideCode,
                          date: _editedRide.date,
                          departureHour: _editedRide.departureHour,
                          arrivalHour: value,
                          seatPrice: _editedRide.seatPrice,
                          note: _editedRide.note,
                          id: _editedRide.id,
                        );
                      },
                    ),
                    Divider(),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        labelText: 'Ücret',
                        prefixIcon: Icon(Icons.attach_money_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(300),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Fiyat Girin.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Lütfen bir sayı girin.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Lütfen sıfırdan büyük bir sayı girin.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedRide = Ride(
                          departurePlace: _editedRide.departurePlace,
                          destinationPlace: _editedRide.destinationPlace,
                          rideCode: _editedRide.rideCode,
                          date: _editedRide.date,
                          departureHour: _editedRide.departureHour,
                          arrivalHour: _editedRide.arrivalHour,
                          seatPrice: double.parse(value),
                          note: _editedRide.note,
                          id: _editedRide.id,
                        );
                      },
                    ),
                    Divider(),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'Not',
                        prefixIcon: Icon(Icons.note_add_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(300),
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Lütfen Not Yazınız.';
                        }
                        if (value.length < 10) {
                          return 'En az 10 karakter olmalı.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedRide = Ride(
                          departurePlace: _editedRide.departurePlace,
                          destinationPlace: _editedRide.destinationPlace,
                          rideCode: _editedRide.rideCode,
                          date: _editedRide.date,
                          departureHour: _editedRide.departureHour,
                          arrivalHour: _editedRide.arrivalHour,
                          seatPrice: _editedRide.seatPrice,
                          note: value,
                          id: _editedRide.id,
                        );
                      },
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: <Widget>[
                    //     Container(
                    //       width: 100,
                    //       height: 100,
                    //       margin: EdgeInsets.only(
                    //         top: 8,
                    //         right: 10,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           width: 1,
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                    //       child: _imageUrlController.text.isEmpty
                    //           ? Text('Enter a URL')
                    //           : FittedBox(
                    //               child: Image.network(
                    //                 _imageUrlController.text,
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             ),
                    //     ),
                    //     Expanded(
                    //       child: TextFormField(
                    //         decoration: InputDecoration(labelText: 'Image URL'),
                    //         keyboardType: TextInputType.url,
                    //         textInputAction: TextInputAction.done,
                    //         controller: _imageUrlController,
                    //         focusNode: _imageUrlFocusNode,
                    //         onFieldSubmitted: (_) {
                    //           _saveForm();
                    //         },
                    //         validator: (value) {
                    //           if (value.isEmpty) {
                    //             return 'Please enter an image URL.';
                    //           }
                    //           if (!value.startsWith('http') &&
                    //               !value.startsWith('https')) {
                    //             return 'Please enter a valid URL.';
                    //           }
                    //           if (!value.endsWith('.png') &&
                    //               !value.endsWith('.jpg') &&
                    //               !value.endsWith('.jpeg')) {
                    //             return 'Please enter a valid image URL.';
                    //           }
                    //           return null;
                    //         },
                    //         onSaved: (value) {
                    //           _editedRide = Ride(
                    //             departurePlace: _editedRide.departurePlace,
                    //             destinationPlace: _editedRide.departurePlace,
                    //             rideCode: _editedRide.rideCode,
                    //             date: _editedRide.date,
                    //             departureHour: _editedRide.departureHour,
                    //             arrivalHour: _editedRide.arrivalHour,
                    //             seatPrice: _editedRide.seatPrice,
                    //             note: _editedRide.note,
                    //             id: _editedRide.id,
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
