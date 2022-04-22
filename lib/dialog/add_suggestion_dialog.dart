import 'package:flutter/material.dart';

import '../export_feature.dart';
import '../models/suggestions_model.dart';
import '../network/api.dart';
import '../network/auth.dart';
import '../widget/text_field_app.dart';


class AddSuggestionDialog extends StatefulWidget {
  const AddSuggestionDialog({Key? key}) : super(key: key);

  @override
  _AddSuggestionDialogState createState() => _AddSuggestionDialogState();
}

class _AddSuggestionDialogState extends State<AddSuggestionDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ارسال اقتراح جديد'),

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(
            color: Colors.black,
            width: 1,
          )),
      content: Container(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [

                TextFieldApp(
                  controller: titleController,
                  hintText: 'عنوان الاقتراح',
                  icon: const Icon(Icons.title),
                  validator: (str)=> str!.isEmpty ? 'هذا الحقل مطلوب' : null,
                  margin: const EdgeInsets.symmetric(horizontal: 0 , vertical: 16.0),
                ),

                TextFieldApp(
                  controller: desController,
                  hintText: 'شرح مفصل عن الاقتراح',
                  icon: const Icon(Icons.title),
                  type: TextInputType.multiline,

                  margin: const EdgeInsets.symmetric(horizontal: 0 , vertical: 16.0),

                  validator: (str)=> str!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),

                const SizedBox(height: 16.0,),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSuggestion,
                    child: const Text('اضافة اقتراح'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSuggestion() async{

    if(!formKey.currentState!.validate()) {
      return;
    }

    String title = titleController.text ;
    String des = desController.text ;


    ProgressCircleDialog.show(context);

    SuggestionModel suggestionModel = SuggestionModel();

    suggestionModel
    ..title = title
    ..des = des
    ..date = DateTime.now()
    ..suggestionsStatus = SuggestionStatus.Pending
    ..userUid = Auth.currentUser!.uid
    ..user = Auth.currentUser;


    await Api.setSuggestion(suggestionModel);

    ProgressCircleDialog.dismiss(context);

    Navigator.pop(context , true) ;

  }
}
