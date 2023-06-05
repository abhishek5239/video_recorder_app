import 'package:flutter/material.dart';
import 'dart:ffi';
// import 'package:music_app/extracted.dart';
// import 'package:music_app/screens/Myotpscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:untitled/Myotpscreen.dart';

import 'fetchvideo_screen.dart';

class Mylogin extends StatefulWidget {
  static String verify = "";
  static String getopt="";
  @override
  State<Mylogin> createState() => _MyloginState();
}

class _MyloginState extends State<Mylogin> {
  TextEditingController countrycode = TextEditingController();
  String phone = "";
  bool loading=false;
  FocusNode numfocus=FocusNode();
  @override
  void initState()  {
    numfocus.requestFocus();
    countrycode.text = "+91";
    checkuser();
    // TODO: implement initState
    super.initState();
  }
Future<void> checkuser() async
{
  final user=await FirebaseAuth.instance.currentUser;
  if(user!=null && user.phoneNumber!=null)
  {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>videoplayer()) );
    print("##################################");
    print("##################################");
    print("##################################");
    print("user found");
  }
  else
  {
    print("##################################");
    print("##################################");
    print("user Not found");
  }
}
final numkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/computer.png',),fit: BoxFit.cover)
                  ),
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
                  'Please enter your valid phone number here!',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                ),

                Center(
                  child: Form(
                      key: numkey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: countrycode,
                            focusNode: numfocus,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(13),

                            ],

                            style:TextStyle(
                                fontFamily: "Poppins", fontWeight: FontWeight.w500,fontSize: 2.h),

                            decoration: InputDecoration(

                                filled: true,
                                fillColor: Color(0XFFD2D8E8).withOpacity(0.3),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 1,color:Color(0XFFD2D8E8).withOpacity(0.3) )
                                ),
                                focusedBorder:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 1,color:Color(0XFFD2D8E8).withOpacity(0.3) )
                                ),
                                hintStyle: TextStyle(
                                    fontFamily: "Poppins", fontWeight: FontWeight.w500,fontSize: 20,color:Color(0XFFD2D8E8)),
                                // border: InputBorder.none,
                                hintText: "00000 00000"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              } else if (!RegExp(r'^\+91\d{10}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
onSaved: (value){phone=value.toString();},
                          ),
                          // SizedBox(height: 5,),
                          // Text(''),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextButton(
                              onPressed: () async {
                                print("###################");
                                print("###################");
                                print("###################");
                                print(phone);

                                if(numkey.currentState!.validate())
                                  {

                                    numkey.currentState!.save();
                                    setState(() {
                                      loading=true;
                                    });
                                    await FirebaseAuth.instance.verifyPhoneNumber(
                                      phoneNumber: '${phone}',

                                      verificationCompleted:
                                          (PhoneAuthCredential credential) {
                                        Mylogin.getopt=credential.smsCode!;
                                        print("#####################");
                                        print("#####################");
                                        print("#####################");
                                        print(Mylogin.getopt);
                                        print("#####################");
                                        print("#####################");
                                      },
                                      verificationFailed: (FirebaseAuthException e) {
                                        if (e.code == 'invalid-phone-number') {
                                          print('The provided phone number is not valid.');
                                        }
                                      },
                                      codeSent: (String verificationId, int? resendToken) {
                                        Mylogin.verify = verificationId;
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>myotp()));
                                      },
                                      codeAutoRetrievalTimeout: (String verificationId) {},
                                    );
                                    setState(() {
                                      loading=false;
                                    });
                                  }
                                // Navigator.pushNamed(context, "otpscreen");

                              },
                              child: loading==false?Text(
                                'send the code',
                                style: TextStyle(color: Colors.white),
                              ):CircularProgressIndicator(),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          )
                        ],
                      )),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
