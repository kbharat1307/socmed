import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:socmed/user_profile_page.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  Future<void> _login() async {
    final _firebaseAuth = FirebaseAuth.instance;
    print('trying to send code');
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+911234567890',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (phoneAuthCredential) {
        print('verification completed');
      },
      verificationFailed: (exception) {
        print('verification failed');
      },
      codeSent: (String verificationId, int? resendToken) async {
        print('code sent');
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = '123456';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await _firebaseAuth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (verId) {
        print('auto retieval timeouted');
      },
    );
  }

  bool _validate = true;
  String _errorMessage = 'Value Can\'t Be Empty';
  bool _sendOTPEnabled = false;
  bool _enterOTPEnabled = false;
  bool _verifyOTPEnabled = false;
  bool _resendOTPEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Join Now'),
      ),
      //backgroundColor: Colors.greenAccent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xFF00203FFF),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 150,
                child: TextFormField(
                  autofocus: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  onChanged: (value) {
                    setState(
                      () {
                        if (value.length < 10) {
                          print(
                            value,
                          );
                          print(_validate);
                          _validate = false;
                          _sendOTPEnabled = false;
                          _verifyOTPEnabled = false;
                          _resendOTPEnabled = false;
                          _errorMessage = 'Please enter valid mobile number';
                        } else {
                          _validate = true;
                          _sendOTPEnabled = true;
                        }
                      },
                    );
                  },
                  decoration: InputDecoration(
                    errorText: _validate ? null : _errorMessage,
                    errorMaxLines: 2,
                    //helperText: 'Helper Text',
                    // border: OutlineInputBorder(),
                    prefix: Text('+91'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: _sendOTPEnabled
                    ? () async {
                        await Firebase.initializeApp();

                        await _login();
                        setState(() {
                          _sendOTPEnabled = false;
                          _verifyOTPEnabled = true;
                          _resendOTPEnabled = true;
                          _enterOTPEnabled = true;
                        });
                        print(
                          'Send OTP Button Pressed',
                        );
                        FocusScope.of(context).requestFocus(FocusNode());
                        Fluttertoast.showToast(
                          msg: "OTP Requested",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Color(0xFF38618c),
                  //  fixedSize: Size(50, 20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Send OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: PinCodeTextField(
                  enabled: _enterOTPEnabled,
                  //enableActiveFill: true,
                  pinTheme: PinTheme(
                    disabledColor: Colors.grey,
                    selectedColor: Colors.black,
                    inactiveColor: Colors.black,
                    activeColor: Colors.blue,
                    fieldWidth: 40,
                  ),
                  appContext: context,
                  keyboardType: TextInputType.numberWithOptions(),
                  pastedTextStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  onChanged: (value) {
                    print(value);
                    print(_enterOTPEnabled.toString());
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive OTP?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'RESEND',
                      style: TextStyle(
                        fontSize: 18,
                        color: _resendOTPEnabled ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: _resendOTPEnabled
                        ? () {
                            print('Resend Button clicked!');
                          }
                        : null,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _verifyOTPEnabled
                    ? () {
                        print(
                          'OTP Verified button pressed',
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Color(0xFF38618c),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Login Code