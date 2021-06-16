import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mel_y_mando/Screens/chat/widget/full_photo.dart';

class photoTile extends StatelessWidget {
  final String imgurl;
  photoTile({this.imgurl});

  @override
  Widget build(BuildContext context) {

    return Container(

      child: Card(
        child:
            Padding(
              padding: const EdgeInsets.all(1),
              child: SizedBox(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FullPhoto(url: imgurl)));
                      },
                      child:
                      imgurl!= null ?
                      CachedNetworkImage(
                        placeholder: (context, url) => CircularProgressIndicator(),
                        imageUrl: imgurl,
                      ):
                      Text(imgurl),
                    )
                  )
            ),
      ),
    );
  }
}