import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';

class ViewImage extends StatefulWidget {
  final List<String> imageProvider;
  final int index;

  const ViewImage({required this.imageProvider, required this.index, Key? key})
      : super(key: key);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  bool _showIcon = true;
  late List<String> _imageProvider;
  late String urlImage;
  late int _index;

  @override
  void initState() {
    super.initState();
    _imageProvider = widget.imageProvider;
    _index = widget.index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: _toggle,
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              pageController: PageController(initialPage: _index),
              scrollDirection: Axis.horizontal,
              itemCount: _imageProvider.length,
              builder: (context, index) {
                //print(index);
                urlImage = _imageProvider[index];
                return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(urlImage),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.contained * 4);
              },
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(
                // borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context).canvasColor,
              ),
              onPageChanged: (index) => setState(() {
                _index = index;
              }),
            ),
            !_showIcon
                ? const SizedBox.shrink()
                : Positioned(
                    child: InkWell(
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    left: 20,
                    top: 50,
                  ),
            !_showIcon
                ? const SizedBox.shrink()
                : Positioned(
                    child: InkWell(
                      child: Icon(
                        Icons.save_alt,
                        size: 30,
                        color: Colors.black,
                      ),
                      onTap: () {
                        //print("urlImage=$urlImage");
                        _save(urlImage);
                      },
                    ),
                    right: 20,
                    top: 50,
                  ),
            Positioned(
              child: Text(
                '${_index + 1}/${_imageProvider.length}',
                style: TextStyle(
                    fontSize: SizerUtil.deviceType == DeviceType.tablet
                        ? 7.sp
                        : 9.sp),
              ),
              bottom: 10,
              right: 10,
            )
          ],
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _showIcon = !_showIcon;
    });
  }

  _save(String _imageProvider) async {
    EasyLoading.show(status: 'Saving');
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio().get(_imageProvider,
          options: Options(responseType: ResponseType.bytes));
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
          quality: 60, name: "photo");

      EasyLoading.showSuccess('Photo saved');
      EasyLoading.dismiss();
    }
  }
}
