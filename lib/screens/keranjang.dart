import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ecommerce/utils/loading.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';

class Keranjang extends StatefulWidget {
  @override
  _KeranjangState createState() => _KeranjangState();
}

PreferenceUtil appData = new PreferenceUtil();

class _KeranjangState extends State<Keranjang> {
  final format = new NumberFormat("#,###");
  List<dynamic> getItemPesanan;
  List<Map> getShoppingItems;
  List<Map> postShoppingItems;
  String userId = '';
  int hargaTotalItem;
  // TextEditingController jumlahController = TextEditingController();

  getData() async {
    appData.getVariable("user_id").then((result) {
      setState(() {
        userId = result;
        print(userId);
        // getProduk(userId);
      });
    });
  }

  getProduk(userId) async {
    Firestore.instance
        .collection('baskets')
        .document('BASKET' + userId)
        .get()
        .then((onValue) {
      setState(() {
        getItemPesanan = onValue.data['item_pesanan'];
      });
    }).catchError((e) {
      print(e);
    });
  }

  searchItemPesanan(idProduk, jumlahPemesanan) {
    for (int i = 0; i < getItemPesanan.length; i++) {
      if (getItemPesanan[i]['id_produk'] == idProduk) {
        setState(() {
          getShoppingItems = [
            {
              'created_at_item': getItemPesanan[i]['created_at_item'],
              'id_produk': getItemPesanan[i]['id_produk'],
              'foto': getItemPesanan[i]['foto'],
              'nama': getItemPesanan[i]['nama'],
              'harga': getItemPesanan[i]['harga'],
              'jumlah_pesanan': getItemPesanan[i]['jumlah_pesanan'],
              'harga_total_item': getItemPesanan[i]['harga_total_item'],
            }
          ];
          postShoppingItems = [
            {
              'created_at_item': getItemPesanan[i]['created_at_item'],
              'id_produk': getItemPesanan[i]['id_produk'],
              'foto': getItemPesanan[i]['foto'],
              'nama': getItemPesanan[i]['nama'],
              'harga': getItemPesanan[i]['harga'],
              'jumlah_pesanan': jumlahPemesanan,
              'harga_total_item': getItemPesanan[i]['harga_total_item'],
            }
          ];
        });
      }
    }
  }

  updateTombolAdd(String idProduk, int jumlahPemesanan) async {
    searchItemPesanan(idProduk, jumlahPemesanan);
    Firestore.instance
        .collection('baskets')
        .document('BASKET' + userId)
        .updateData({
      'item_pesanan': FieldValue.arrayRemove(getShoppingItems),
    }).then((onValue) {
      setState(() {
        print("hpus berhasil");
        print(getShoppingItems);
      });
    });
    Firestore.instance
        .collection('baskets')
        .document('BASKET' + userId)
        .updateData({
      'item_pesanan': FieldValue.arrayUnion(postShoppingItems),
    }).whenComplete(() {
      print("update");
    });
  }

  assignDataToVar() async {
    await getData();
  }

  void initState() {
    super.initState();
    assignDataToVar();
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
                Text('Rp.500,000',
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
                color: Colors.red,
                textColor: Colors.white,
                child: Center(
                  child: Text('Beli',
                      textAlign: TextAlign.center,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.white)),
                ),
                onPressed: () {},
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0))),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Map<dynamic, dynamic> document) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    TextEditingController jumlahController =
        new TextEditingController.fromValue(
      TextEditingValue(
        text: document['jumlah_pesanan'].toString(),
        selection: new TextSelection.collapsed(
          offset: document['jumlah_pesanan'].toString().length,
        ),
      ),
    );
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // checbox buat ceklis keseluruhan
              Container(
                height: 80,
                width: 50,
                alignment: Alignment.center,
                child: Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.red,
                  value: false,
                  onChanged: (bool val) {},
                ),
              ),

              // buat foto
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            child: Container(
                              height: 80,
                              width: 80,
                              alignment: Alignment.center,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/background.png',
                                image: document['foto'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // buat nama produk dan harga
                                      Container(
                                        child: Text(
                                          document['nama'] != null
                                              ? document['nama'].toString()
                                              : "-",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          document['harga_total_item'] != null
                                              ? "Rp." +
                                                  format
                                                      .format(document[
                                                          'harga_total_item'])
                                                      .toString()
                                              : "Rp.-",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // buat delete pake function remove
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: Icon(
                    Icons.delete,
                    size: 25,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  // buat kurang pesanan
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: Icon(
                    Icons.remove,
                    size: 20,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey[400],
                        offset: new Offset(0.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
              // jumlah pesanan
              Container(
                width: width * 1 / 6,
                height: 40,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: jumlahController,
                  enabled: false,
                ),
              ),
              //  buat tambah pesanan
              GestureDetector(
                onTap: () async {
                  int add = int.tryParse(jumlahController.text) + 1;
                  print(document['id_produk']);
                  updateTombolAdd(document['id_produk'], add);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.red,
                        offset: new Offset(0.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        Divider(
          height: 10.0,
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('baskets')
            .document('BASKET' + userId)
            .snapshots(),
        builder: (context, snapshot) {
          var document = snapshot.data;
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
          } else if (snapshot.data.data == null) {
            return Center(
              child: Text("Belanja Terlebih Dahulu"),
            );
          } else {
            getItemPesanan = document['item_pesanan'];
            document['item_pesanan'].sort((b, a) => Timestamp(
                    a['created_at_item'].seconds,
                    a['created_at_item'].nanoseconds)
                .toDate()
                .compareTo(Timestamp(b['created_at_item'].seconds,
                        b['created_at_item'].nanoseconds)
                    .toDate()));
            return new ListView.builder(
              itemCount: document['item_pesanan'].length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, document['item_pesanan'][index]),
            );
          }
        },
      ),
      bottomNavigationBar: _showButton(),
    );
  }
}
