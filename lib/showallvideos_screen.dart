import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class Getvideo extends StatefulWidget {
  const Getvideo({Key? key}) : super(key: key);

  @override
  State<Getvideo> createState() => _GetvideoState();
}

class _GetvideoState extends State<Getvideo> {
  final CollectionReference product=FirebaseFirestore.instance.collection("video_storage");



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>
        (
        stream: product.snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> streamsnapshot)
          {
              if(streamsnapshot.hasData)
                {
                  return ListView.separated(itemBuilder: (context,index)
                      {
                        final DocumentSnapshot documentsnapshot =
                        streamsnapshot.data!.docs[index];
                        return videodata_widget( documentsnapshot: documentsnapshot);

                      },
                      separatorBuilder: (context,_)=>SizedBox(height: 10,), itemCount: streamsnapshot.data!.docs.length);
                }
              return Center(child: CircularProgressIndicator(),);
          }
      )
    );
  }
}

class videodata_widget extends StatefulWidget {
  final DocumentSnapshot documentsnapshot;
  const videodata_widget({
    required this.documentsnapshot,
    super.key,
  });

  @override
  State<videodata_widget> createState() => _videodata_widgetState();
}

class _videodata_widgetState extends State<videodata_widget> {
  late VideoPlayerController videoPlayerController;
  void getvideo()
  {
    videoPlayerController=VideoPlayerController.network(widget.documentsnapshot["video_link"])..initialize().then((_) => {});
  }
  @override
  void initState() {
    // TODO: implement initState
    getvideo();
    super.initState();
  }
  bool play=false;
  bool thumbsup=false;
  bool thumbsdown=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
      children:[
        AspectRatio(
          aspectRatio: 3/2,
          child: VideoPlayer(videoPlayerController),
        ),
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
            )),

      ]

          ),
          Text("${widget.documentsnapshot["video_title"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),


          SizedBox(height: 10,),
          Text("${widget.documentsnapshot["video_desc"]}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
          SizedBox(height: 10,),
          Row(
            children: [
              Text("#${widget.documentsnapshot["video_category"]}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
              SizedBox(width: 50,),
              Text("${widget.documentsnapshot["video_location"]}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
              SizedBox(width: 20,),
              IconButton(onPressed: (){setState(() {
                thumbsup=true;
                thumbsdown=false;
              });},
              icon: Icon(thumbsup==false?Icons.thumb_up_alt_outlined:Icons.thumb_up,color: Colors.green,),
              ),
              // SizedBox(width: 10,),
              IconButton(onPressed: (){setState(() {
                thumbsup=false;
                thumbsdown=true;
              });},
                icon: Icon(thumbsdown==false?Icons.thumb_down_alt_outlined:Icons.thumb_down,color: Colors.red,),
              ),
            ],
          )


          // getvideo(documentsnapshot),




        ],
      ),
    );
  }
}
