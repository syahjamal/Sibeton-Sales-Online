import 'package:flutter/material.dart';

class KeranjangVerifikasiPembayaran extends StatefulWidget {
  KeranjangVerifikasiPembayaran({this.orderID});
  final orderID;
  @override
  _KeranjangVerifikasiPembayaranState createState() =>
      _KeranjangVerifikasiPembayaranState();
}

class _KeranjangVerifikasiPembayaranState
    extends State<KeranjangVerifikasiPembayaran> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lakukan Pembayaran"),
      ),
      body: Center(child: Text("hi")),
    );
  }
}
