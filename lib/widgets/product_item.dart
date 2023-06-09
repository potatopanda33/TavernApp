import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/page.dart';
import '../screens/product_detail.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  _launchLink(link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<WebPage>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            if (product.price == 2 && product.description!.startsWith('http')) {
              _launchLink(product.description);
            } else {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            }
          },
          child: Image.network(
            product.imageUrl!,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<WebPage>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite! ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
              },
              color: Colors.white70,
            ),
          ),
          title: Text(
            product.title!,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(null),
            onPressed: () {},
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
