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
        title: const Text('الاقتراحات'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text('السرعة : ${model.speed}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('السعر : ${model.price}'),
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

  void loadMyOffers() async {
    offersList = await Api.getOffers();
    setState(() {});
  }



}
