import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';

class KeranjangPengiriman extends StatefulWidget {
  KeranjangPengiriman({this.hargaTotal});
  final hargaTotal;
  @override
  _KeranjangPengirimanState createState() => _KeranjangPengirimanState();
}

class _KeranjangPengirimanState extends State<KeranjangPengiriman> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengiriman'),
      ),
    );
  }
}
