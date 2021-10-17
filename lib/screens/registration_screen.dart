import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';
import 'package:pharmacy_app/providers/auth_manager.dart';
import 'package:provider/provider.dart';

//widgets
import '../widgets/custom_button.dart';
//screens
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = 'registration_screen';

  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _addUserInfo = FirebaseDatabase.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool showSpinner = false;
  String email = '';
  String password = '';

  LocationData currentPosition;
  String name, contact, address, area, city, areaPin, latitude, longitude;
  DateTime dateTime;
  Location location = Location();

  bool _submit() {
    // getLoc();
    debugPrint("$name+$contact+$email+$address+$city+$area");
    final isValid = _formKey.currentState.validate();

    if (!isValid) {
      return false;
    }
    _formKey.currentState.save();
    return true;
  }

  @override
  void initState() {
    super.initState();
    getLoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        labelText: "Your Name",
                        border: OutlineInputBorder(),
                      ),
                      enableSuggestions: true,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: "Contact Number",
                        border: OutlineInputBorder(),
                      ),
                      enableSuggestions: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Required";
                        } else if (value.length != 10) {
                          return "Enter a valid contact";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          contact = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      enableSuggestions: true,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        Pattern pattern =
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
                        RegExp regex = RegExp(pattern);
                        if (value.isEmpty) {
                          return "Required";
                        } else if (!regex.hasMatch(value)) {
                          return "Enter valid Email";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.pin),
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      enableSuggestions: true,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Required";
                        } else if (value.length < 6) {
                          return "Password should contain at least 6 characters";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  if (address != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.pin_drop_outlined),
                          labelText: "Address",
                          hintText: "101, Rose Villa",
                          border: OutlineInputBorder(),
                        ),
                        initialValue: address,
                        enableSuggestions: true,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                      ),
                    ),
                  if (area != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.map),
                          labelText: "Area",
                          border: OutlineInputBorder(),
                        ),
                        initialValue: area,
                        enableSuggestions: true,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            area = value;
                          });
                        },
                      ),
                    ),
                  if (city != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_city),
                          labelText: "City",
                          border: OutlineInputBorder(),
                        ),
                        enableSuggestions: true,
                        initialValue: city,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                      ),
                    ),
                  if (areaPin != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: "Area Pin",
                          border: OutlineInputBorder(),
                        ),
                        enableSuggestions: true,
                        initialValue: areaPin,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            areaPin = value;
                          });
                        },
                      ),
                    ),
                  CustomButton(
                    title: 'Register',
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      if (_submit()) {
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (newUser != null) {
                            debugPrint("Make a new user in realtime");
                            String emailFormatted =
                                email.replaceAll('@', '-').replaceAll('.', '-');
                            Provider.of<AuthManager>(context, listen: false)
                                .emailFormatted = emailFormatted;
                            _addUserInfo
                                .reference()
                                .child('users')
                                .child(emailFormatted)
                                .set({
                              'email': email,
                              'name': name,
                              'address': address,
                              'area': area,
                              'city': city,
                              'areaPin': areaPin,
                              'contact': contact,
                              'latitude': latitude,
                              'longitude': longitude
                            });
                            Navigator.pop(context);
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          }

                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentPosition = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      // print("${currentLocation.longitude} : ${currentLocation.longitude}");

      if (mounted) {
        setState(() {
          dateTime = DateTime.now();
          // _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
          currentPosition = currentLocation;
          latitude = currentPosition.latitude.toString();
          longitude = currentPosition.longitude.toString();
          _getAddress(currentPosition.latitude, currentPosition.longitude)
              .then((value) {
            setState(() {
              debugPrint(value.first.locality); //city
              debugPrint(value.first.subLocality); //area

              debugPrint("area ${value.first.postalCode}");
              area = area ?? value.first.subLocality;
              city = city ?? value.first.locality;
              areaPin = areaPin ?? value.first.postalCode;
              address = address ?? value.first.addressLine;
            });
          });
        });
      }
    });
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }
}
