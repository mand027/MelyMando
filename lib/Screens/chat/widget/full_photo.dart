import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class FullPhoto extends StatelessWidget {
  final String url;

  FullPhoto({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void _toastInfo(String info) {
      Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
    }

    void _saveNetworkImage() async {

      var appDocDir = await getTemporaryDirectory();
      String savePath = appDocDir.path + "foto.jpg";
      await Dio().download(url, savePath);
      final result = await ImageGallerySaver.saveFile(savePath);
      print(result);
      _toastInfo("foto descargada en galeria");
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                child:
                Text('Foto completa'), //cambiar por logo nuev
              ),
            ),
            Expanded(
              child:  FlatButton.icon(
                label: Text('', style: TextStyle(color: Colors.white, fontSize: 10)),
                onPressed: () async {
                  _saveNetworkImage();
                },
                icon: Icon(
                  Icons.file_download,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: FullPhotoScreen(url: url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {

  final String url;

  FullPhotoScreen({Key key, @required this.url}) : super(key: key);

  @override
  State createState() => FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;

  FullPhotoScreenState({Key key, @required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: PhotoView(imageProvider: NetworkImage(url)));
  }
}
