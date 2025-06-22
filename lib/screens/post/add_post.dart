import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import '../../../models/post.dart';
import '../../utils/dimensions.dart';
import '../../utils/my_color.dart';
import '../../utils/style.dart';
import '../../widget/custom_bottom_sheet.dart';
import '../../widget/default_text.dart';
import '../auth/auth_provider.dart';
import '../feed/feed_provider.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  File? _image;
  final _captionCtrl = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitPost() async {
    final username = ref.read(authProvider);
    if (_image != null && username != null) {
      final post = Post(
        username: username,
        imagePath: _image!.path,
        caption: _captionCtrl.text.trim(),
        timestamp: DateTime.now(),
      );
      await Hive.box<Post>('posts').add(post);
      ref.read(feedProvider.notifier).resetFeed();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select an image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: MyColor.secondryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, size: 30),
        ),
        titleSpacing: 0,
        title: DefaultText(
          text: "Create Post",
          textStyle: outfitifSemiBoldText,
          fontSize: Dimensions.fontExtraLarge,
          textColor: MyColor.colorBlack,
        ),
        elevation: 0,
        //backgroundColor: MyColor.secondryColor,
        foregroundColor: MyColor.colorBlack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              /// Image Preview
              GestureDetector(
                onTap: () {
                  openPopup();
                },
                child:
                    _image != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 220,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                        )
                        : DottedBorder(
                          color: MyColor.lightGreyColor,
                          strokeWidth: 1.5,
                          dashPattern: [6, 3],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            //margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              //border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/gallery.png",
                                    width: 48,
                                    height: 48,
                                  ),
                                  DefaultText(
                                    text: "Upload your photo",
                                    textStyle: outfitifSemiBoldText,
                                    fontSize: Dimensions.fontLarge,
                                  ),

                                  DefaultText(
                                    text:
                                        "Just tap here to browse your gallery\nto upload photo",
                                    textStyle: outfitifRegularText,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    textColor: MyColor.uniqueColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
              ),
              SizedBox(height: 16),

              /// Caption Input
              TextFormField(
                maxLines: 5,
                minLines: 4,
                keyboardType: TextInputType.multiline,
                controller: _captionCtrl,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) {
                  _captionCtrl.text = value;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  hintText: "Write a caption here...",
                  hintStyle: outfitifRegularText.copyWith(
                    color: MyColor.uniqueColor,
                    fontSize: Dimensions.fontLarge,
                  ),
                  //fillColor: MyColor.iconBgColor,
                  //filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColor.lightGreyColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColor.lightGreyColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColor.lightGreyColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColor.lightGreyColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (data) {},
              ),

              const SizedBox(height: 24),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitPost,
                  //icon: Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    "Post",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: MyColor.primaryColor,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openPopup() {
    return CustomBottomSheet(
      backgroundColor: MyColor.colorWhite,
      isNeedMargin: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: MyColor.primaryColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(
                  Icons.photo_library_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ).customBottomSheet(context);
  }
}
