import 'package:flutter/material.dart';

//widgets
import '../widgets/custom_button.dart';
//screens
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = 'welcome_screen';

  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: const <Widget>[
                  // Hero(
                  //   tag: 'logo',
                  //   child: Container(
                  //     child: Image.asset('images/logo.png'),
                  //     height: 60.0,
                  //   ),
                  // ),
                  Text('Hello')
                ],
              ),
              const SizedBox(
                height: 48.0,
              ),
              CustomButton(
                title: 'Log In',
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },
              ),
              CustomButton(
                title: 'Register',
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.routeName);
                },
              ),
            ],
          )),
    );
  }
}
