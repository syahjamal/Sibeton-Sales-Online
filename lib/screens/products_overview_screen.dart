import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/cart.dart';
import 'package:flutter_ecommerce/providers/products.dart';
import 'package:flutter_ecommerce/screens/cart_screen.dart';
import 'package:flutter_ecommerce/widgets/app_drawer.dart';
import 'package:flutter_ecommerce/widgets/badge.dart';
import 'package:flutter_ecommerce/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';

PreferenceUtil appData = new PreferenceUtil();

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Sibeton Online Sales '),
        actions: <Widget>[
          /*PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (FilterOptions.Favourites == selectedValue) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return [
                /*PopupMenuItem(
                  child: Text("Only Favourites"),
                  value: FilterOptions.Favourites,
                ),*/
                PopupMenuItem(
                  child: Text("Select All"),
                  value: FilterOptions.All,
                ),
              ];
            },
          ),*/
          Consumer<Cart>(
            builder: (BuildContext context, Cart cart, Widget widget) {
              return Badge(
                child: widget,
                value: cart.itemCount.toString(),
              );
            },
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavourites),
    );
  }
}
