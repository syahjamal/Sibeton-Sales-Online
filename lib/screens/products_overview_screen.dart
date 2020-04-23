import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/cart.dart';
import 'package:flutter_ecommerce/providers/products.dart';
import 'package:flutter_ecommerce/widgets/badge.dart';
import 'package:flutter_ecommerce/screens/detail_product.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

PreferenceUtil appData = new PreferenceUtil();

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final format = new NumberFormat("#,###");
  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;
  String email = '';
  String userId = '';

  @override
  void initState() {
    // WON'T WORK
//    Provider.of<Products>(context).fetchAndSetProducts();

    // WILL WORK
//    Provider.of<Products>(context,listen: false).fetchAndSetProducts();

    // WILL WORK
//    Future.delayed(Duration.zero).then((_){
//      Provider.of<Products>(context).fetchAndSetProducts();
//    });

    super.initState();
    appData.getVariable("email").then((result) {
      setState(() {
        email = result;
        print(email);
      });
    });
    appData.getVariable("user_id").then((result) {
      setState(() {
        userId = result;
        print(userId);
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  _buildListItem(BuildContext context, DocumentSnapshot document) {
    return InkWell(
      onTap: () {
        // Lanjut ke halman detail produk
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailProduk(
              productId: document.documentID,
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 170,
              width: MediaQuery.of(context).size.width,
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage("assets/images/loading_ring.gif"),
                image: NetworkImage(
                  document['foto'][0],
                ),
              ),
            ),
            // nama products
            Padding(
              padding: const EdgeInsets.only(left: 5.0, bottom: 2.0, top: 2.0),
              child: Text(
                document['nama'].toString(),
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // harga barang
            Padding(
              padding: const EdgeInsets.only(left: 5.0, bottom: 2.0),
              child: Text(
                "Rp." + format.format(document['harga']).toString() + " \\m3",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/Sibeton_logo.png',
          scale: 17,
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Consumer<Cart>(
                  builder: (BuildContext context, Cart cart, Widget widget) {
                    return Badge(
                      child: widget,
                      value: cart.itemCount.toString(),
                    );
                  },
                  child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/keranjang');
                      }),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 0),
                child: Consumer<Cart>(
                  builder: (BuildContext context, Cart cart, Widget widget) {
                    return Badge(
                      child: widget,
                      value: cart.itemCount.toString(),
                    );
                  },
                  child: IconButton(
                      icon: Icon(Icons.history),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/history');
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('products').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
            } else {
              return GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              );
            } 
          }),
    );
  }
}
