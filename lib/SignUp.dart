import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_grocery/StoreDetails.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  showError(BuildContext context, Object errormessage) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 5),
      builder: (context, controller) {
        return Flash.bar(
          controller: controller,
          backgroundColor: Colors.red,
          position: FlashPosition.top,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    errormessage.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  bool _isObscure1 = true;
  bool _isObscure2 = true;

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: !isKeyboard
          ? AppBar(
              titleSpacing: 12,
              leading: ModalRoute.of(context)?.canPop == true
                  ? IconButton(
                      splashColor: Colors.transparent,
                      padding: const EdgeInsets.only(left: 30.0, bottom: 15.0),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 35,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.black,
                    )
                  : null,
              title: Image.asset('images/logo-name.png'),
              backgroundColor: new Color(0xffff),
              shadowColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 90.0,
            )
          : null,
      body: Center(
          child: Column(
        children: <Widget>[
          if (!isKeyboard) SizedBox(height: 15.0),
          if (!isKeyboard)
            Container(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    text: "Get Started",
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
              width: mediaQueryData.size.width * 0.85,
            ),
          Container(
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                  text: "Create an account to start ordering",
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
            ),
            width: mediaQueryData.size.width * 0.85,
          ),
          SizedBox(height: 50),
          Container(
            width: mediaQueryData.size.width * 0.85,
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    validator: (input) {
                      if (input!.isEmpty) return 'Please enter a Name';
                    },
                    decoration: InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(height: 0.4),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff2C6846))),
                        focusColor: Color(0xff2C6846),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff2C6846),
                        )),
                        labelStyle: TextStyle(color: Color(0xff2C6846)),
                        labelText: "Full Name",
                        prefixIcon:
                            Icon(Icons.person, color: Color(0xff2C6846))),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    validator: (input) {
                      if (input!.isEmpty) return 'Pleas enter an Email';
                    },
                    decoration: InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(height: 0.4),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff2C6846))),
                        focusColor: Color(0xff2C6846),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff2C6846),
                        )),
                        labelStyle: TextStyle(color: Color(0xff2C6846)),
                        labelText: "Email",
                        prefixIcon: Icon(Icons.mail, color: Color(0xff2C6846))),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    obscureText: _isObscure1,
                    controller: _passwordController,
                    validator: (input) {
                      if (input!.length < 6)
                        return 'Provide minimum 6 character';
                    },
                    decoration: InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(height: 0.4),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff2C6846))),
                        focusColor: Color(0xff2C6846),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff2C6846),
                        )),
                        labelStyle: TextStyle(color: Color(0xff2C6846)),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure1
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xff2C6846),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure1 = !_isObscure1;
                            });
                          },
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xff2C6846))),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    obscureText: _isObscure2,
                    controller: _confirmPasswordController,
                    validator: (input) {
                      if (input!.length < 6)
                        return 'Provide minimum 6 character';
                      if (input != _passwordController.text)
                        return 'Password not match';
                    },
                    decoration: InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(height: 0.4),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff2C6846))),
                        focusColor: Color(0xff2C6846),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff2C6846),
                        )),
                        labelStyle: TextStyle(color: Color(0xff2C6846)),
                        labelText: "Confirm Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure2
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xff2C6846),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure2 = !_isObscure2;
                            });
                          },
                        ),
                        prefixIcon:
                            Icon(Icons.vpn_key, color: Color(0xff2C6846))),
                  ),
                ])),
          ),
          SizedBox(height: 30),
          ButtonTheme(
            buttonColor: Color(0xff2C6846),
            minWidth: mediaQueryData.size.width * 0.85,
            height: 60.0,
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StoreDetails(_nameController,
                        _emailController, _passwordController)));
              },
              child: Text('Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          // SignInButton(
          //       Buttons.Google,
          //       onPressed: () {
          //         // final provider =
          //         //     Provider.of<GoogleSignInProvider>(context, listen: false);
          //         // provider.login();
          //       },
          //     )
        ],
      )),
    );
  }
}
