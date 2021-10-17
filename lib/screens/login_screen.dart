import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/auth_manager.dart';
import '../screens/home_screen.dart';
//widgets
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login_screen';

  const LoginScreen({Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
            CustomButton(
              title: 'Log In',
              onPressed: () async {
                // setState(() {
                //   showSpinner = true;
                // });
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  // ignore: unnecessary_null_comparison
                  if (user != null) {
                    String emailFormatted =
                        email.replaceAll('@', '-').replaceAll('.', '-');
                    Provider.of<AuthManager>(context, listen: false)
                        .emailFormatted = emailFormatted;
                    Provider.of<AuthManager>(context, listen: false)
                        .loggedInTrue();
                    // await Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => WelcomeScreen()),
                    //   ModalRoute.withName(WelcomeScreen.routeName),
                    // );
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, HomeScreen.routeName);
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
