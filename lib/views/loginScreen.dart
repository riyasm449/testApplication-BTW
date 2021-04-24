import 'package:btw_test_app/utils/passwordCard.dart';
import 'package:btw_test_app/utils/phoneCard.dart';
import 'package:btw_test_app/utils/textCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _mailFeild = TextEditingController();
  bool isLoading = false;

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: (isLoading)

          /// check is loading ///
          ? Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.pink,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 300,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  PhoneCard(
                    controller: phoneField,
                    enabled: false,
                  ),
                  Text(
                    '*Phone login is disabled use mail login',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  TextCard(
                    hintText: 'Mail ID',
                    controller: _mailFeild,
                    prefixIcon: Icons.mail,
                  ),
                  PasswordCard(controller: _passwordField),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Remember Me',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Forget password?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  loginButton(),
                  Center(
                    child: Text(
                      'OR',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () async {
                        showAlertDialog(context,
                            title: 'Connection Error',
                            content: 'error in connecting to Facebook');
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.blueAccent),
                        alignment: Alignment.center,
                        child: Text(
                          'CONNECT WITH FACEBOOK',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '*Facebook login is disabled use mail login',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    ));
  }

  Widget loginButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () async {
          await login();
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: Colors.pink),
          alignment: Alignment.center,
          child: Text(
            'SIGN IN',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return true;
    else
      return false;
  }

  void login() async {
    /// checks whether the mail is empty ///
    if (_mailFeild.text.trim() == '') {
      showAlertDialog(context,
          title: 'Incomplete', content: 'Mail id is Empty');
    }

    /// checks whether the mail is valid ///
    else if (validateEmail(_mailFeild.text)) {
      showAlertDialog(context,
          title: 'Mail Id', content: 'Enter proper mail id');
    }

    /// checks whether the password is empty ///
    else if (_passwordField.text.trim() == '') {
      showAlertDialog(context,
          title: 'Incomplete', content: 'Password is empty');
    } else {
      setLoading(true);

      /// firebase login and Error handling ///
      try {
        /// trying to login ///
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _mailFeild.text.trim(),
            password: _passwordField.text.trim());
        Navigator.pushReplacementNamed(context, '/home');
        setLoading(false);
      } catch (e) {
        setLoading(false);

        /// user not found error ///
        if (e.code == 'user-not-found') {
          showAlertDialog(context,
              title: 'Login Failed', content: 'User not found');
          print('================> User not found <===================');
        }

        /// wrong password error ///
        else if (e.code == 'wrong-password') {
          showAlertDialog(context,
              title: 'Login Failed', content: 'Wrong password');
          print('================> Wrong password <===================');
        }

        /// other errors ///
        else {
          showAlertDialog(context,
              title: 'Login Failed', content: 'Something went wrong');
          print('============> ${e.code} <============');
        }
      }
    }
  }

  showAlertDialog(BuildContext context, {String title, String content}) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Colors.red),
          ),
          content: Text(content),
          actions: [
            okButton,
          ],
        );
      },
    );
  }
}
