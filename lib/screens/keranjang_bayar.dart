import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';
import 'package:flutter_ecommerce/utils/loading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ecommerce/screens/keranjang_verifikasi_pembayaran.dart';
import 'package:flutter_ecommerce/models/list_bank.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KeranjangBayar extends StatefulWidget {
  KeranjangBayar({this.hargaTotal, this.namaBank, this.logoBank, this.noRek});
  final hargaTotal, namaBank, logoBank, noRek;
  @override
  _KeranjangBayarState createState() => _KeranjangBayarState();
}

PreferenceUtil appData = new PreferenceUtil();

class _KeranjangBayarState extends State<KeranjangBayar> {
  DateTime _tanglah = DateTime.now();
  String userId = '', nama = '', email = '', nomorHandphone = '', alamat = '';
  String orderId = '';
  final format = new NumberFormat("#,###");
  List<dynamic> listPesanan;
  List<Map> postPesanan = List<Map>();
  List<Map> order = List<Map>();
  getData() async {
    appData.getVariable("user_id").then((result) {
      setState(() {
        userId = result;
        getBasket();
      });
    });
  }

  assignDataToVar() async {
    await getData();
  }

  void initState() {
    super.initState();
    assignDataToVar();
  }

  getBasket() {
    Firestore.instance
        .collection("baskets")
        .document("BASKET" + userId)
        .get()
        .then((onValue) {
      setState(() {
        nama = onValue.data['nama'] ?? "";
        email = onValue.data['email'] ?? "";
        nomorHandphone = onValue.data['nomor_handphone'] ?? "";
        alamat = onValue.data['alamat'] ?? "";
        listPesanan = onValue.data['item_pesanan'];
        orderId = "INV" +
            userId.substring(17, 20) +
            DateFormat("ddhhMMmmss").format(_tanglah).toString() +
            nomorHandphone.substring(
                nomorHandphone.length - 3, nomorHandphone.length);
      });
    });
  }

  getPesanan() {
    for (int i = 0; i < listPesanan.length; i++) {
      if (listPesanan[i]['status_checkbox'] == true) {
        postPesanan.add(listPesanan[i]);
      }
    }
    order = [
      {
        'orde_id': orderId,
        'nama_bank': widget.namaBank,
        'norek_bak': widget.noRek,
        'created_at_order': DateTime.now(),
        'nama': nama,
        'nomor_handphone': nomorHandphone,
        'alamat': alamat,
        'email': email,
        'status': 'menunggu pembayaran',
        'harga_total': widget.hargaTotal,
        'item_pesanan': postPesanan,
      }
    ];
  }

  deletePesananBasket() {
    Firestore.instance
        .collection('baskets')
        .document('BASKET' + userId)
        .updateData({
      'harga_total': FieldValue.increment(-widget.hargaTotal),
      'item_pesanan': FieldValue.arrayRemove(postPesanan),
    }).whenComplete(() {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => KeranjangVerifikasiPembayaran(
            orderID: orderId,
          ),
        ),
      );
    });
  }

  addOrder() {
    // check dulu document
    Firestore.instance
        .collection("orders")
        .document("ORDER" + userId)
        .get()
        .then((onValue) {
      if (onValue.data != null) {
        Firestore.instance
            .collection("orders")
            .document("ORDER" + userId)
            .updateData({
          'order': FieldValue.arrayUnion(order),
        }).catchError((e) {
          print(e);
        }).whenComplete(() {
          deletePesananBasket();
        });
      } else {
        Firestore.instance
            .collection("orders")
            .document("ORDER" + userId)
            .setData({
          'nama': nama,
          'email': email,
          'nomor_handphone': nomorHandphone,
          'user_id': userId,
          'alamat': alamat,
          'created_at': DateTime.now(),
          'order': order,
        }).catchError((e) {
          print(e);
        }).whenComplete(() {
          deletePesananBasket();
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  outFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
    SibWidget.loadingPageIndicator(context: context);
  }

  Widget _showButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Container(
        padding: const EdgeInsets.only(left: 10.0),
        height: 45,
        width: (MediaQuery.of(context).size.width * 0.5) - 20.0,
        child: RaisedButton(
            elevation: 10.0,
            color: widget.hargaTotal > 0 ? Colors.red : Colors.grey[500],
            textColor: Colors.white,
            child: Center(
              child: Text('Bayar',
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 15.0, color: Colors.white)),
            ),
            onPressed: () {
              if (widget.hargaTotal > 0) {
                outFocus();
                getPesanan();
                addOrder();
              }
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bayar'),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 3.0),
                      child: Text(
                        "Total Tagihan",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 20.0),
                      child: Text(
                        "Rp." + format.format(widget.hargaTotal).toString(),
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // transfer
              Container(
                margin: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 12.0, 3.0),
                      child: ListTile(
                          title: Text("Transfer " + widget.namaBank),
                          trailing: Image.asset(
                            widget.logoBank,
                            width: 40,
                            height: 40,
                          )),
                    ),
                    Divider(
                      height: 0.0,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(9.0, 10.0, 12.0, 25.0),
                      child: Html(
                        data: petunjuk,
                        defaultTextStyle: TextStyle(
                          color: Color(0xff747474),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _showButton(),
    );
  }
}
