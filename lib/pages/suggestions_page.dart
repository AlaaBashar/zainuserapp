import 'package:flutter/material.dart';

import '../dialog/add_suggestion_dialog.dart';
import '../export_feature.dart';
import '../models/suggestions_model.dart';
import '../network/api.dart';


class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({Key? key}) : super(key: key);

  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  List<SuggestionModel>? suggestionsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMySuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('الاقتراحات'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: onAdd,
      ),
      body: Container(
        child: suggestionsList != null
            ? ListView.builder(
                itemCount: suggestionsList!.length,
                padding: const EdgeInsets.only(bottom: 110),
                itemBuilder: (_, index) {
                  SuggestionModel model = suggestionsList![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(

                              children: const <Widget>[
                                Expanded(child: Divider()),
                                Text(
                                  " الاقتراح ",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            suggestText(labels:'عنوان الاقتراح' ,text:model.title),
                            const SizedBox(
                              height: 5.0,
                            ),
                            suggestText(labels:'تفاصيل الاقتراح' ,text:model.des),
                            const SizedBox(
                              height: 8.0,
                            ),
                            suggestText(labels:'التاريخ' ,text:dataFormat(date: model.date)),
                            const SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: const <Widget>[
                                Expanded(child: Divider()),
                                Text(
                                  " حالة الاقتراح ",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('حالة الاقتراح : ',textDirection: TextDirection.rtl,
                                  style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                                ),
                                getStatus(model),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : getCenterCircularProgress(),
      ),
    );
  }
  Widget suggestText({dynamic text, String? labels}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$labels : ',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),

        ),
        Text(
          '$text',
        ),
      ],
    );
  }
  void loadMySuggestions() async {
    suggestionsList = await Api.getSuggestions();
    setState(() {});
  }

  Widget getStatus(SuggestionModel model) {
    if (model.suggestionsStatus == SuggestionStatus.Pending) {
      return const Text(
        'قيد الانتظار',
        style: TextStyle(
          color: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (model.suggestionsStatus == SuggestionStatus.Approve) {
      return const Text(
        'الاقتراح مقبول',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (model.suggestionsStatus == SuggestionStatus.Rejected) {
      return const Text(
        'الاقتراح مرفوض',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return const SizedBox();
  }

  void onAdd() async {
    bool? result = await showDialog(
        context: context,
        builder: (_) {
          return const AddSuggestionDialog();
        });

    if (result == null) return;

    setState(() {
      suggestionsList = null;
      loadMySuggestions();
    });
  }
}
