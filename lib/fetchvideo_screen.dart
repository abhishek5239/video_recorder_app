import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/functions_widgets/get_locationfun.dart';
import 'package:untitled/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:untitled/showallvideos_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class videoplayer extends StatefulWidget {
  const videoplayer({Key? key}) : super(key: key);

  @override
  State<videoplayer> createState() => _videoplayerState();
}

class _videoplayerState extends State<videoplayer> {

FirebaseFirestore db=FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage_inst = FirebaseStorage.instance;
  bool loader1=false;
  bool location=false;
  bool colorchange=false;
  bool play=false;
  bool loader = false;
  late VideoPlayerController videoPlayerController;
  String videolocation="";
  String videolnk="";
  bool selectvideo=false;
  String imgname="";
  File? videofile;
  final videofromcam = ImagePicker();

  Future<void> _pickvideo() async {
    final XFile? video =
        await videofromcam.pickVideo(source: ImageSource.camera);

    videofile = File(video!.path);
     imgname = video.name;
    try {
      videoPlayerController = VideoPlayerController.file(videofile!)
        ..initialize().then((_) {
          // videoPlayerController.setLooping(true);
          setState(() {
            // loader=true;
          });
          // videoPlayerController!.play();
          // firebaseStorage_inst.ref(imgname).putFile(videofile!);
       // Reference reference=await firebaseStorage_inst.ref(imgname).getDownloadURL()
        });
    } catch (e) {
      print(e);
    }
  }
  TextEditingController titletextcnt=TextEditingController();
  TextEditingController desctextcnt=TextEditingController();
  TextEditingController cattextcnt=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player App"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 20),
              child: Column(
                children: [
                  videofile != null
                      ? Stack(
                    children: [
                      videoPlayerController!.value.isInitialized
                          ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          height: 300,
                          child: VideoPlayer(videoPlayerController!),
                        ),
                      )
                          : Container(),
                      Positioned(
                        top: 100,
                        left: 80,
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [


                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                                // border: Border.all(width: 2,)
                              ),
                              child: TextButton(
                                onPressed: () {
                                  videoPlayerController.seekTo(Duration(
                                      seconds:
                                      videoPlayerController.value.position.inSeconds -
                                          10));
                                },
                                child: Icon(Icons.rotate_left,size: 30,color: Colors.white,),),
                            ),
                            Padding(padding: EdgeInsets.all(2)),

                            play==false?Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                                // border: Border.all(width: 2,)
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      play=true;
                                    });
                                    videoPlayerController.play();
                                  },
                                  child: Icon(Icons.play_arrow,size: 30, color: Colors.white,)),
                            ):Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                                // border: Border.all(width: 2,)
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      play=false;
                                    });
                                    videoPlayerController.pause();
                                  },
                                  child: Icon(Icons.pause,size: 30,color: Colors.white,)),
                            ),
                            Padding(padding: EdgeInsets.all(2)),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                                // border: Border.all(width: 2,)
                              ),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent

                                    // Background color
                                  ),
                                  onPressed: () {
                                    videoPlayerController.seekTo(Duration(
                                        seconds:
                                        videoPlayerController.value.position.inSeconds +
                                            10));
                                  },
                                  child: Icon(Icons.rotate_right,size: 30,color: Colors.white,)),
                            )
                          ],
                        ),),
                      Positioned(
                          bottom: 0,
                          width: MediaQuery.of(context).size.width,
                          child: VideoProgressIndicator(
                            videoPlayerController,
                            allowScrubbing: false,
                            colors: VideoProgressColors(
                                backgroundColor: Colors.blueGrey,
                                bufferedColor: Colors.blueGrey,
                                playedColor: Colors.blueAccent),
                          ))
                    ],
                  )
                      : Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: TextButton(
                        onPressed: () {
                          _pickvideo();
                        },
                        child: Text("upload button")),
                  ),


                  SizedBox(height: 10,),
                  if(videofile!=null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [


                        loader==false?TextButton (
                        style: TextButton.styleFrom(
                            backgroundColor: selectvideo==false?Colors.blue:Colors.green
                        ),
                        onPressed: () async{
                          setState(() {
                            selectvideo=true;
                            loader=true;
                          });

                         await firebaseStorage_inst.ref(imgname).putFile(videofile!);

                          videolnk= await firebaseStorage_inst.ref(imgname).getDownloadURL();
                          setState(() {
                            loader=false;
                          });
                          print(videolnk);

                        }, child: selectvideo==false?Text("Confirm uploaded video",style: TextStyle(color: Colors.white),):Icon(Icons.check,color: Colors.white,),

                      ):Center(child: CircularProgressIndicator(),)],
                    ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: titletextcnt,
                    decoration: InputDecoration(
                        focusColor: Colors.green,
                        labelText: "Video Titile",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        filled: true,
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        // fillColor: Colors.lightBlueAccent,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: desctextcnt,
                    decoration: InputDecoration(
                        focusColor: Colors.green,
                        labelText: "Video Description",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        filled: true,
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        // fillColor: Colors.lightBlueAccent,
                        border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(10.0),

                            borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: cattextcnt,
                    decoration: InputDecoration(
                        focusColor: Colors.green,
                        labelText: "Video Category",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        filled: true,
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        // fillColor: Colors.lightBlueAccent,
                        border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(10.0),

                            borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                  SizedBox(height: 10,),
                  loader1==false?TextButton(onPressed: ()async {
                    setState(() {
                      loader1=true;
                      // location=true;
                      // videolocation=address[0].locality!;
                    });
                    Position position=await GetLocation.determinePosition();
                    List<Placemark> address=await placemarkFromCoordinates(position.latitude, position.longitude);
                    // print();
                    setState(() {
                      loader1=false;
                      location=true;
                      videolocation=address[0].locality!;
                    });

                  }, child:Row(children: [
                    Icon(Icons.location_on,color: location==true?Colors.green:Colors.blueAccent),
                    Text(location==false?"Get video location":"Got video location",style: TextStyle(color: location==true?Colors.green:Colors.blueAccent),)
                  ],)):CircularProgressIndicator(),
                  SizedBox(height: 20,),
                  Center(child: TextButton(onPressed: (){

                    setState(() {
                      videofile=null;
                      location=false;
                      selectvideo=false;
                    });

                    final data={
                      "video_category":cattextcnt.text,
                      "video_desc":desctextcnt.text,
                      "video_link":videolnk,
                      "video_location":videolocation,
                      "video_title":titletextcnt.text
                    };
                    db.collection("video_storage").add(data);
                    titletextcnt.clear();
                    cattextcnt.clear();
                    desctextcnt.clear();
                    setState(() {
                    colorchange=true;
                    });

                  }, child: Text(colorchange==false?"Submit":"Submitted",style: TextStyle(color: Colors.white),),
                    style: TextButton.styleFrom(backgroundColor: colorchange==false?Colors.blue:Colors.green),
                  )),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Getvideo()));
                  }, child: Text("show all videos"))

                  // TextButton(onPressed: (){
                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>getlocationofphone()));
                  // }, child: Text("Get location")),
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }
}
