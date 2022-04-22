import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import '../models/complaint_model.dart';
import '../models/ministries_model.dart';
import '../network/Fcm.dart';
import '../network/api.dart';
import '../network/auth.dart';
import '../network/constants.dart';
import '../utils.dart';
import '../widget/reusable_cached_network_image.dart';
import '../widget/text_field_app.dart';

class ComplaintPage extends StatefulWidget {
  final MinistriesModel ministriesModel;

  const ComplaintPage({Key? key, required this.ministriesModel})
      : super(key: key);

  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  TextEditingController titleController = TextEditingController();

  TextEditingController desController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  File imageFile = File('');
  FilePickerResult? filePicker;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تقديم شكوى على ${widget.ministriesModel.title} '),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ReusableCachedNetworkImage(
                    imageUrl: widget.ministriesModel.imageUrl!,
                    width: 100,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),

                Visibility(
                  visible: filePicker == null,
                  child: IconButton(
                    onPressed: onPicker,
                    icon: const Icon(Icons.add_a_photo_sharp),
                    iconSize: 70,
                  ),
                ),
                Visibility(
                  visible: filePicker != null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.file(
                      imageFile,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const Text(
                  'اضغط على الكاميرا لتحميل صورة',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFieldApp(
                  controller: titleController,
                  hintText: 'عنوان الشكوى',
                  icon: const Icon(Icons.title),
                  validator: (str) =>
                      str!.isEmpty ? 'عنوان المشكلة مطلوب' : null,
                ),
                TextFieldApp(
                  controller: desController,
                  type: TextInputType.multiline,
                  hintText: 'شرح مفصل عن الشكوى',
                  icon: const Icon(Icons.title),
                  validator: (str) =>
                      str!.isEmpty ? 'شرح عن المشكلة مطلوب' : null,
                ),
                const SizedBox(
                  height: 32.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onComplaint,
                    child: const Text('تقديم الشكوى'),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  void onPicker() async {
    filePicker = await FilePicker.platform.pickFiles();
    if (filePicker == null) return;

    setState(() {
      imageFile = File(filePicker!.files.first.path!);
    });
  }

  void onComplaint() async{

    if (imageFile.path.isEmpty) {
      showSnackBar(
        context,
        'الرجاء اختيار صورة اولا',
        isError: true,
      );
      return;
    }
    if(!formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    String title = titleController.text;
    String des = desController.text;

    ProgressCircleDialog.show(context);

    String? imageUrl = await Api.uploadFile(
      imageFile: imageFile,
      folderPath: CollectionsKey.COMPLAINTS,
    );
    if (imageUrl == null) {
      showSnackBar(
        context,
        'حدث مشكلة في رفع الملف ، الرجاء المحاولة مرة اخرى',
        isError: true,
      );
      ProgressCircleDialog.dismiss(context);
      return;
    }
    ComplaintModel complaintModel = ComplaintModel();

    complaintModel..title = title
    ..des = des
    ..userId = Auth.currentUser!.id
    ..userUid = Auth.currentUser!.uid
    ..userPhoneNumber = Auth.currentUser!.phone
    ..date = DateTime.now()
    ..username = Auth.currentUser!.name
    ..complaintStatus = ComplaintStatus.Pending
    ..ministriesId = widget.ministriesModel.id
    ..ministriesTitle = widget.ministriesModel.title
    ..imageUrl = imageUrl;

    await Api.setComplaint(complaintModel);

    Fcm.sendNotificationToAdmin('شكوى جدية', title);

    ProgressCircleDialog.dismiss(context);

    showSnackBar(context , 'تم ارسال الشكوى بنجاح');
    titleController.text = '';
    desController.text = '' ;
    setState(() {
      imageFile = File('');
      filePicker = null;
    });

  }
}
