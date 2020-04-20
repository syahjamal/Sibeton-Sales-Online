import 'package:flutter/material.dart';

class KeranjangPembayaran extends StatefulWidget {
  KeranjangPembayaran({this.hargaTotal});
  final hargaTotal;
  @override
  _KeranjangPembayaranState createState() => _KeranjangPembayaranState();
}

class _KeranjangPembayaranState extends State<KeranjangPembayaran> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
    );
  }
}
