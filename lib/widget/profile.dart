import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:medicalapp/image/image_provider.dart' as MyAppImageProvider;

class profile extends StatefulWidget {
  final User loggedInUser;

  profile({Key? key, required this.loggedInUser}) : super(key: key);


  @override
  State<profile> createState() => _Y_LoginState();
}

class _Y_LoginState extends State<profile> {
  final messageTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 3;
    final imageProvider =
        Provider.of<MyAppImageProvider.ImageProvider>(context, listen: false);

    return Column(
      children: [
        Container(
          child: GestureDetector(
            onTap: () {
              _showBottomSheet();
            },
            child: Container(
              width: imageSize,
              height: imageSize,

              decoration: BoxDecoration(

                shape: BoxShape.circle,
                color: Color.fromARGB(255, 58, 56, 56),
              ),
              child: imageProvider.image != null // 이미지가 선택되었는지 확인
                  ? ClipOval(
                      child: Image.file(
                        File(imageProvider.image!.path), // 이미지를 표시합니다.
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: imageSize,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  _showBottomSheet() {
    final picker = ImagePicker();
    final imageProvider =
        Provider.of<MyAppImageProvider.ImageProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            IconButton(
              onPressed: () async {
                final multiImage = await picker.pickMultiImage();
                if (multiImage.isNotEmpty) {
                  imageProvider.setImage(multiImage.first); // 첫 번째 이미지를 업데이트
                  setState(() {}); // 화면을 다시 그립니다.
                }
                Navigator.pop(context); // 이미지를 선택한 후 바텀 시트를 닫습니다.
              },

              icon: Icon(

                Icons.add_photo_alternate_outlined,
                size: 30,
                color: Colors.black,
              ),
            )
          ],
        );
      },
    );
  }
}
