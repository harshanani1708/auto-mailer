import 'package:flipr_hackathon/emailTest.dart';
import 'package:flipr_hackathon/formPage.dart';
import 'package:flipr_hackathon/homepage.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Duration get loginTime => Duration(milliseconds: 2250);

  final FirebaseAuth auth = FirebaseAuth.instance;
  late User user;
  late bool isvalid;
  late UserCredential userCredential;
  String password = "";
  String errormessage = "", mail = "18h61a0554@cvsr.ac.in";

  // String? validateemail(String email) {
  //   if (email.endsWith('@gmail.com')) {
  //     return "null";
  //   } else {
  //     return 'Enter a valid e-mail';
  //   }
  // }

  // String validatePass(String pass) {
  //   if (pass.length < 6) {
  //     return 'Password should be atleast 6 characters';
  //   } else {
  //     return "null";
  //   }
  // }

  Future<bool> fsignUp(String uname, String pwd) async {
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
        email: uname,
        password: pwd,
      );
      isvalid = true;
      print("Sign Up successfull");
    } catch (e) {
      errormessage = e.toString();
      isvalid = false;
    }
    return isvalid;
  }

  Future<bool> fsignIn(String uname, String pwd) async {
    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: uname,
        password: pwd,
      );
      isvalid = true;
      print("Sign In successfull");
    } catch (e) {
      //print(e.toString());
      errormessage = e.toString();
      isvalid = false;
    }
    return isvalid;
  }

  Future<String> passwordRecover(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return 'Something went wrong. Please try again';
    }
    return '';
  }

  Future<String> signUp(LoginData data) async {
    var resup = await fsignUp(data.name, data.password);
    password = data.password;
    if (resup != true) {
      return errormessage;
    }

    return '';
  }

  Future<String> signIn(LoginData data) async {
    var resin = await fsignIn(data.name, data.password);
    password = data.password;
    if (resin != true) {
      return errormessage;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FlutterLogin(
          theme: LoginTheme(
            primaryColor: Color(0xff5a63ad),
            //accentColor: Color(0xff5a63ad)
          ),
          title: MediaQuery.of(context).orientation == Orientation.portrait
              ? 'Auto-Mailer'
              : '',
          onSignup: signUp,
          onLogin: signIn,
          onRecoverPassword: passwordRecover,
          // userValidator: validateemail(user.email),
          // passwordValidator: validatePass,
          onSubmitAnimationCompleted: () {
            var user = userCredential.user;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          email: user!.email.toString(),
                          password: password,
                        )));
          },
          messages: LoginMessages(
            userHint: 'E-mail',
            passwordHint: 'Password',
            confirmPasswordHint: 'Confirm Password',
            loginButton: 'LOG IN',
            signupButton: 'SIGN UP',
            //forgotPasswordButton: 'Forgot password?',
            recoverPasswordButton: 'LET\'S GO',
            goBackButton: 'GO BACK',
            confirmPasswordError: 'Passwords do not match',
            recoverPasswordDescription:
                'Make sure you do not come here again and again !! :)',
            recoverPasswordSuccess:
                'Reset your password by clicking on the link sent to your mail',
          ),
        ),
      ),
    );
  }
}
