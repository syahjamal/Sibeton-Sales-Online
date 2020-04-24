import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';
import 'package:flutter_ecommerce/utils/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:strings/strings.dart';
import 'package:flutter_ecommerce/screens/history_detail.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

PreferenceUtil appData = new PreferenceUtil();

class _HistoryState extends State<History> {
  final dateFormat = DateFormat("dd/MM/yyyy");
  final rupiah = new NumberFormat("#,###");
  String userId = '';

  getData() async {
    appData.getVariable("user_id").then((result) {
      setState(() {
        userId = result;
        print(userId);
      });
    });
  }

  outFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
    SibWidget.loadingPageIndicator(context: context);
  }

  assignDataToVar() async {
    await getData();
  }

  void initState() {
    super.initState();
    assignDataToVar();
  }

  Widget _buildListItem(BuildContext context, Map<dynamic, dynamic> document) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HistoryDetail(
              orderID: document["order_id"],
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: const Offset(0.0, 5.0),
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Container(
              color: Colors.red[200],
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                  child: Text(
                    document['status'] == null
                        ? "-"
                        : camelize(document['status'].toLowerCase()),
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 20.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 10.0, 1.0, 5.0),
                      child: Text(
                        "Tanggal Transaksi : ",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 12.0, 5.0),
                      child: Text(
                        document['created_at_order'] == null
                            ? "-"
                            : dateFormat
                                .format(Timestamp(
                                        document['created_at_order'].seconds,
                                        document['created_at_order']
                                            .nanoseconds)
                                    .toDate())
                                .toString(),
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 5.0, 1.0, 10.0),
                      child: Text(
                        "Nomor Transaksi : ",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 12.0, 10.0),
                      child: Text(
                        document["order_id"] == null
                            ? "-"
                            : document["order_id"].toString(),
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 0.0,
                ),
                Column(
                  children: List.generate(document['item_pesanan'].length, (i) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 12.0, 5.0),
                      //barang yang di pesan
                      child: ListTile(
                        leading: Container(
                          height: 80,
                          width: 80,
                          alignment: Alignment.center,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/background.png',
                            image: document['item_pesanan'][i]['foto'],
                            fit: BoxFit.contain,
                          ),
                        ), // Gambar product
                        title: Text(document['item_pesanan'][i]['nama'] == null
                            ? "-"
                            : document['item_pesanan'][i]['nama'] +
                                " x" +
                                document['item_pesanan'][i]['jumlah_pesanan']
                                    .toString()), //Nama Product
                        subtitle: Text(document['item_pesanan'][i]
                                    ['harga_total_item'] ==
                                null
                            ? "-"
                            : rupiah.format(document['item_pesanan'][i]
                                ['harga_total_item'])), // Harga satuan
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 0.0,
                ),
                Container(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 5.0, 1.0, 10.0),
                        child: Text(
                          "Total Pembelian : ",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 5.0, 12.0, 10.0),
                        child: Text(
                          document['harga_total'] == null
                              ? "-"
                              : "Rp. " + rupiah.format(document['harga_total']),
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('orders')
            .document('ORDER' + userId)
            .snapshots(),
        builder: (context, snapshot) {
          var document = snapshot.data;
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
          } else if (snapshot.data.data == null) {
            return Center(
              child: Text("Lakukan Pembelian terlebih dahulu"),
            );
          } else {
            document['order'].sort((b, a) => Timestamp(
                    a['created_at_order'].seconds,
                    a['created_at_order'].nanoseconds)
                .toDate()
                .compareTo(Timestamp(b['created_at_order'].seconds,
                        b['created_at_order'].nanoseconds)
                    .toDate()));
            return new ListView.builder(
              itemCount: document['order'].length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, document['order'][index]),
            );
          }
        },
      ),
    );
  }
}

