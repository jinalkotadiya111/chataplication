import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaveImage extends StatefulWidget {

  var fileurl="";
  SaveImage({required this.fileurl});

  @override
  State<SaveImage> createState() => _SaveImageState();
}

class _SaveImageState extends State<SaveImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SaveImage"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Image.network(widget.fileurl),
              ),
              ElevatedButton(onPressed: () async{
                var response = await Dio().get(
                    widget.fileurl,
                    options: Options(responseType: ResponseType.bytes));
                final result = await ImageGallerySaver.saveImage(
                    Uint8List.fromList(response.data),
                    quality: 60,
                    name: widget.fileurl);
                print(result);
              },
                  child: Text("dwonload"))
            ],
          ),
        ),
      ),
    );
  }
}
