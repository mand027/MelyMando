import 'package:flutter/material.dart';
import 'package:mel_y_mando/Screens/chat/widget/full_photo.dart';

class photoTile extends StatelessWidget {
  final String imgurl;
  photoTile({this.imgurl});

  @override
  Widget build(BuildContext context) {

    return Container(

      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(1),
              child: SizedBox(
                    height: 175,
                    width: 350,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FullPhoto(url: imgurl)));
                      },
                      child:
                      imgurl!= null ?
                      Image.network(imgurl):
                      Text(imgurl),
                    )
                  )
            ),
          ],
        ),
      ),
    );
  }
}