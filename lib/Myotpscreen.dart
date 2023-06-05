import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:music_app/screens/phnonelogin.dart';
import 'package:pinput/pinput.dart';
import 'package:untitled/fetchvideo_screen.dart';
import 'package:untitled/phnonelogin.dart';

class myotp extends StatefulWidget {
  const myotp({Key? key}) : super(key: key);

  @override
  State<myotp> createState() => _myotpState();
}

class _myotpState extends State<myotp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String otp = '123456'; // OTP value to insert
  TextEditingController otpController = TextEditingController(text: Mylogin.getopt);
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var pincode = "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
      // backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 40, right: 40),
          alignment: Alignment.center,
          // decoration: const BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/computer.png',
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Phone Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Please enter your valid OTP here!',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //   height: 55,
                //   decoration: BoxDecoration(
                //       border: Border.all(width: 1, color: Colors.grey),
                //       borderRadius: BorderRadius.circular(10)),
                //   child: Row(
                //     children: [],
                //   ),
                // ),
                Pinput(
                  controller:otpController ,
                  length: 6,
                  showCursor: true,
                  onChanged: (value) {
                    pincode = value;
                    print(pincode);
                  },

                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: TextButton(
                    onPressed: () async {
                      // Create a PhoneAuthCredential with the code
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: Mylogin.verify,
                                smsCode: pincode);

                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);


                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Success'),duration: Duration(seconds: 2),));

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>videoplayer()));

                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('enter valid otp'),duration: Duration(seconds: 2),));
                        print(e);
                        print(pincode);
                      }
                    },
                    child: Text(
                      'verify the code',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Edit the phone number?",
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
