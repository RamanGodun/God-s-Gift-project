import 'dart:io';

import 'package:flutter/material.dart';

class ChooseImageWidget extends StatelessWidget {
  final String imageUrl;
  final Function() onSelectImage;
  final File? imageFile;

  ChooseImageWidget(
      {required this.imageUrl, required this.onSelectImage, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectImage,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 150,
              width: 150,
              child: imageUrl.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Icon(Icons.add_a_photo,
                          size: 90, color: Colors.black),
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
            )),
      ),
    );
  }
}

          // imageFile == null
          //     ? Padding(
          //         padding: const EdgeInsets.only(left: 10.0, right: 10),
          //         child: Container(
          //           height: 150,
          //           width: 150,
          //           decoration: BoxDecoration(
          //             border: Border.all(width: 1, color: Colors.black),
          //             borderRadius: BorderRadius.circular(15),
          //           ),
          //           child: const Icon(Icons.add_a_photo,
          //               size: 90, color: Colors.white),
          //         ),
          //       )
          //     :