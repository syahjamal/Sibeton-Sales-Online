import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';
import 'package:flutter_ecommerce/utils/loading.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ecommerce/screens/keranjang_pembayaran.dart';

class KeranjangPengiriman extends StatefulWidget {
  KeranjangPengiriman({this.hargaTotal});
  final hargaTotal;
  @override
  _KeranjangPengirimanState createState() => _KeranjangPengirimanState();
}

PreferenceUtil appData = new PreferenceUtil();

class _KeranjangPengirimanState extends State<KeranjangPengiriman> {
  TextEditingController namaController = TextEditingController();
  TextEditingController nomorHandphoneController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final format = new NumberFormat("#,###");
  final _formKey = GlobalKey<FormState>();
  String userId = '', nama = '', email = '', nomorHandphone = '', alamat = '';

  getData() async {
    appData.getVariable("user_id").then((result) {
      setState(() {
        userId = result;
        Firestore.instance
            .collection('baskets')
            .document('BASKET' + userId)
            .get()
            .then((onValue) {
          setState(() {
            nama = onValue.data['nama'] ?? '';
            email = onValue.data['email'] ?? '';
            nomorHandphone = onValue.data['nomor_handphone'] ?? '';
            alamat = onValue.data['alamat'] ?? '';

            namaController.text = nama;
            emailController.text = email;
            nomorHandphoneController.text = nomorHandphone;
            alamatController.text = alamat;
          });
        });
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

  updateData() {
    Firestore.instance.collection("users").document(userId).updateData({
      'nama': namaController.text,
      'nomor_handphone': nomorHandphoneController.text,
      'alamat': alamatController.text,
    }).whenComplete(() {
      Firestore.instance
          .collection("baskets")
          .document('BASKET' + userId)
          .updateData({
        'nama': namaController.text,
        'nomor_handphone': nomorHandphoneController.text,
        'alamat': alamatController.text,
      }).whenComplete(() {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KeranjangPembayaran(
              hargaTotal: widget.hargaTotal,
            ),
          ),
        );
      });
    });
  }

  outFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
    SibWidget.loadingPageIndicator(context: context);
  }

  Widget _showButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 45,
            width: (MediaQuery.of(context).size.width * 0.5) - 20.0,
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Total Harga
                Text('Total Harga',
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.normal)),
                Text("Rp." + format.format(widget.hargaTotal).toString(),
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            height: 45,
            width: (MediaQuery.of(context).size.width * 0.5) - 20.0,
            child: RaisedButton(
                elevation: 10.0,
                color: widget.hargaTotal > 0 ? Colors.red : Colors.grey[500],
                textColor: Colors.white,
                child: Center(
                  child: Text('Pilih Pembayaran',
                      textAlign: TextAlign.center,
                      style:
                          new TextStyle(fontSize: 15.0, color: Colors.white)),
                ),
                onPressed: () {
                  if (widget.hargaTotal > 0) {
                    if (_formKey.currentState.validate()) {
                      // ketika ada fungsi onsaved bisa langsung dipakai
                      _formKey.currentState.save();
                      outFocus();
                      updateData();
                    }
                  }
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0))),
          ),
        ],
      ),
    );
  }

  Widget titleInput(title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 25, 15, 10),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Comfortaa',
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengiriman'),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  titleInput("Nama Lengkap*"),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 15, right: 15),
                    //Nama Lengkap
                    child: TextFormField(
                        controller: namaController,
                        decoration: new InputDecoration(
                            hintStyle: new TextStyle(
                                color: Colors.grey[300],
                                fontFamily: 'Comfortaa',
                                fontSize: 15.0),
                            hintText: "Nama Lengkap",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                          return null;
                        }),
                  ),
                  titleInput("Email*"),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 15, right: 15),
                    //Nama Lengkap
                    child: TextFormField(
                        controller: emailController,
                        decoration: new InputDecoration(
                            hintStyle: new TextStyle(
                                color: Colors.grey[300],
                                fontFamily: 'Comfortaa',
                                fontSize: 15.0),
                            hintText: "example@gmail.com",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                          return null;
                        }),
                  ),
                  titleInput("Nomor Handphone*"),
                  Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: TextFormField(
                        controller: nomorHandphoneController,
                        keyboardType: TextInputType.phone,
                        decoration: new InputDecoration(
                            hintStyle: new TextStyle(
                                color: Colors.grey[300],
                                fontFamily: 'Comfortaa',
                                fontSize: 15.0),
                            hintText: "089607029XXX",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                          return null;
                        }),
                  ),
                  titleInput("Alamat Lengkap*"),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: TextFormField(
                        controller: alamatController,
                        keyboardType: TextInputType.text,
                        maxLines: 3,
                        decoration: new InputDecoration(
                            hintStyle: new TextStyle(
                                color: Colors.grey[300],
                                fontFamily: 'Comfortaa',
                                fontSize: 15.0),
                            hintText: "Alamat",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                          return null;
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _showButton(),
    );
  }
}
