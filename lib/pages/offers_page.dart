import 'package:flutter/material.dart';

import '../models/offers_model.dart';
import '../network/api.dart';
import '../utils.dart';


class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<OffersModel>? offersList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('العروض'),
      ),
      body: Container(
        child: offersList != null
            ? ListView.builder(
          itemCount: offersList!.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (_, index) {
            OffersModel model = offersList![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: const <Widget>[
                          Expanded(child: Divider()),
                          Text(
                            " العرض ",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      offersText(labels:'السرعة',text:model.speed ,),
                      const SizedBox(
                        height: 5.0,
                      ),
                      offersText(labels:'السعر',text:model.price ,),
                      const SizedBox(
                        height: 8.0,
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
  Widget offersText({dynamic text, String? labels}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$text',
        ),
        Text(
          '$labels : ',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),

        ),
      ],
    );
  }
  void loadMyOffers() async {
    offersList = await Api.getOffers();
    setState(() {});
  }



}
