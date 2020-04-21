import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/utils/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ecommerce/models/list_bank.dart';
import 'package:flutter_ecommerce/screens/keranjang_bayar.dart';

class KeranjangPembayaran extends StatefulWidget {
  KeranjangPembayaran({this.hargaTotal});
  final hargaTotal;
  @override
  _KeranjangPembayaranState createState() => _KeranjangPembayaranState();
}

class _KeranjangPembayaranState extends State<KeranjangPembayaran> {
  final format = new NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Text(
                        "Ringkasan Pembayaran",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(
                                "Total Tagihan",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(
                                "Rp." +
                                    format.format(widget.hargaTotal).toString(),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(
                                "Biaya Layanan",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(
                                "Rp.-",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // metode pemabyaran
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 5.0, left: 12.0, right: 12.0),
                child: Text(
                  "Metode Pembayaran",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 2.0, bottom: 10.0, left: 12.0, right: 12.0),
                child: Text(
                  "Transfer Bank (Verifikasi Manual)",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              // List Bank
              Column(
                children: List.generate(listBank.length, (i) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => KeranjangBayar(
                                hargaTotal: widget.hargaTotal,
                                namaBank: listBank[i]['nama'],
                                logoBank: listBank[i]['logo'],
                                noRek: listBank[i]['norek'],
                              ),
                            ),
                          );
                        },
                        leading: Image.asset(
                          listBank[i]['logo'],
                          width: 40,
                          height: 40,
                        ),
                        title: Text(listBank[i]['nama']),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15.0,
                          color: Colors.grey[500],
                        ),
                      ),
                      Divider(
                        height: 0.0,
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
