import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';
import 'package:flutter_ecommerce/utils/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ecommerce/screens/konfirmasi_pembayaran.dart';

class HistoryDetail extends StatefulWidget {
  HistoryDetail({this.orderID});
  final orderID;
  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

PreferenceUtil appData = new PreferenceUtil();

class _HistoryDetailState extends State<HistoryDetail> {
  final dateFormat = DateFormat("dd/MM/yyyy");
  final rupiah = new NumberFormat("#,###");
  int index;
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
    print(widget.orderID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Detail'),
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
            for (int i = 0; i < document['order'].length; i++) {
              if (document['order'][i]['order_id'] == widget.orderID) {
                index = i;
                print(index);
              }
            }
            if (document['order'][index]['status'] == 'menunggu pembayaran') {
              return ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 10.0),
                        child: Center(
                          child: Text(
                            "Segera selesaikan pembayaran anda",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 2.0, 12.0, 10.0),
                              child: Text(
                                "Transfer ke nomor Rekening :",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  document['order'][index]['logo_bank'],
                                  width: 50,
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 2.0, 12.0, 10.0),
                                  child: Text(
                                    document['order'][index]['norek_bank'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 8.0, 12.0, 2.0),
                              child: Text(
                                  "a/n " +
                                      document['order'][index]['owner_bank'],
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[600],
                                  )),
                            ),
                            // salin norek
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  new ClipboardData(
                                      text: document['order'][index]
                                          ['norek_bank']),
                                ).then((result) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Berhasil menyalin No Rek'),
                                    duration: Duration(seconds: 3),
                                  ));
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 3.0, 12.0, 10.0),
                                child: Text("Salin No. Rek ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.red,
                                      decoration: TextDecoration.underline,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 2.0, 12.0, 10.0),
                              child: Text(
                                "Jumlah yang harus dibayar :",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 2.0, 12.0, 10.0),
                              child: Text(
                                "Rp. " +
                                    rupiah
                                        .format(document['order'][index]
                                            ['harga_total'])
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 10.0, 12.0, 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey[400],
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[800],
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Perhatian :",
                                        style: TextStyle(color: Colors.red)),
                                    TextSpan(
                                      text:
                                          " Transfer tepat sampai 3 digit terakhir \nPerbedaan digit akan menghambat verifikasi",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  new ClipboardData(
                                      text: document['order'][index]
                                              ['harga_total']
                                          .toString()),
                                ).then((result) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Berhasil menyalin jumlah'),
                                    duration: Duration(seconds: 3),
                                  ));
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 10.0, 12.0, 10.0),
                                child: Text("Salin jumlah ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.red,
                                      decoration: TextDecoration.underline,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                      Column(
                        children: List.generate(
                            document['order'][index]['item_pesanan'].length,
                            (i) {
                          return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 12.0, 5.0),
                            //barang yang di pesan
                            child: ListTile(
                              leading: Container(
                                height: 80,
                                width: 80,
                                alignment: Alignment.center,
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/background.png',
                                  image: document['order'][index]
                                      ['item_pesanan'][i]['foto'],
                                  fit: BoxFit.contain,
                                ),
                              ), // Gambar product
                              title: Text(document['order'][index]
                                          ['item_pesanan'][i]['nama'] ==
                                      null
                                  ? "-"
                                  : document['order'][index]['item_pesanan'][i]
                                          ['nama'] +
                                      " x" +
                                      document['order'][index]['item_pesanan']
                                              [i]['jumlah_pesanan']
                                          .toString()), //Nama Product
                              subtitle: Text(document['order'][index]
                                              ['item_pesanan'][i]
                                          ['harga_total_item'] ==
                                      null
                                  ? "-"
                                  : rupiah.format(document['order'][index]
                                          ['item_pesanan'][i]
                                      ['harga_total_item'])), // Harga satuan
                            ),
                          );
                        }),
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 10.0),
                        child: Center(
                          child: Text(
                            "Unggah bukti pembayaran untuk memudahkan verifikasi ",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                              elevation: 10.0,
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Center(
                                child: Text('Konfirmasi Pembayaran',
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                        fontSize: 15.0, color: Colors.white)),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => KonfirmasiPembayaran(
                                      orderID: widget.orderID,
                                    ),
                                  ),
                                );
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0))),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Container();
            }
          }
        },
      ),
    );
  }
}
