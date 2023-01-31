import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:melymando2/Screens/chat/widget/loading.dart';
import 'package:melymando2/models/userdata.dart';
import 'package:provider/provider.dart';

import 'PhotoTile.dart';

class GaleriaList extends StatefulWidget {
  final String peerId;
  final String currentId;

  const GaleriaList({Key? key, required this.peerId, required this.currentId})
      : super(key: key);

  @override
  _GaleriaListState createState() =>
      _GaleriaListState(peerId: peerId, currentId: currentId);
}

class _GaleriaListState extends State<GaleriaList> {
  _GaleriaListState({Key? key, required this.peerId, required this.currentId});

  String peerId;
  String currentId;
  late File imageFile;
  bool isLoading = false;
  late String imageUrl;
  int columns = 2;

  Future uploadImg() async {
    // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    // StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
    //     "kwL4hNyQXthTGIxm6dIuV5FNu3F3-xFuRlESDQdfkp8uj9bO2JiymUr12/$fileName.jpg");
    // StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    // taskSnapshot.ref.getDownloadURL().then((downloadUrl) async {
    //   await DatabaseServiceF(uid: currentId, otheruid: peerId)
    //       .addPhotos(downloadUrl);
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
  }

  Future getImage(bool galeria) async {
    var image;
    if (galeria) {
      image = await ImagePicker().getImage(source: ImageSource.gallery);
    } else if (!galeria) {
      image = await ImagePicker().getImage(source: ImageSource.camera);
    }
    final File file = File(image.path);
    imageFile = file;

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadImg();
    }
  }

  bool cerrarOpcion = false;
  ImageSelectOption(BuildContext context) async {
    isLoading = false;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      minimumSize: const Size(88, 44),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      backgroundColor: Colors.blue,
    );
    if (cerrarOpcion == true) {
      Navigator.pop(context);
      cerrarOpcion = false;
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Información'),
            content: const Text(
              '¿De dónde quieres elegir tu imagen?',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              maxLines: 20,
            ),
            actions: <Widget>[
              TextButton(
                style: flatButtonStyle,
                child: const Text('Galería'),
                onPressed: () {
                  getImage(true);
                  Navigator.pop(context);
                },
              ),
              TextButton(
                style: flatButtonStyle,
                child: const Text('Cámara'),
                onPressed: () {
                  getImage(false);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      minimumSize: const Size(88, 44),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      backgroundColor: Colors.blue,
    );
    UserData misDatos = Provider.of<UserData>(context);
    List<dynamic> photos = misDatos.fotoURLS;

    var itemCountHelp = 0;
    if (photos.isEmpty) {
      itemCountHelp = 0;
    } else {
      itemCountHelp = photos.length;
    }

    if (isLoading) {
      return const Loading();
    } else {
      return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (columns == 1) {
                    columns = 1;
                  } else {
                    columns -= 1;
                  }
                });
              },
              heroTag: null,
              child: const Icon(Icons.zoom_in),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  columns += 1;
                });
              },
              heroTag: null,
              child: const Icon(Icons.zoom_out),
            )
          ],
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          titleSpacing: 18.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Nuestra Galeria',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  style: flatButtonStyle,
                  label: const Text(
                    'Subir Foto',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  onPressed: () async {
                    //ImageSelectOption(context);
                  },
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        body: itemCountHelp > 0
            ? GridView.count(
                crossAxisCount: columns,
                children: List.generate(
                  itemCountHelp,
                  (index) {
                    return Center(
                      child: photoTile(
                        imgurl: photos[(itemCountHelp - index - 1)],
                      ),
                    );
                  },
                ),
              )
            : const Center(
                child: Text("Aun no hay fotos"),
              ),
      );
    }
  }
}
