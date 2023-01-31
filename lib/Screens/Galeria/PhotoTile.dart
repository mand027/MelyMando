import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:melymando2/Screens/chat/widget/full_photo.dart';

class photoTile extends StatelessWidget {
  final String imgurl;
  const photoTile({super.key, required this.imgurl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: SizedBox(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullPhoto(url: imgurl),
                ),
              );
            },
            child: CachedNetworkImage(
              placeholder: (context, url) => const CircularProgressIndicator(),
              imageUrl: imgurl,
            ),
          ),
        ),
      ),
    );
  }
}
