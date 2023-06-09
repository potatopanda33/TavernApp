import 'package:url_launcher/url_launcher.dart';

import '../screens/product_detail.dart';
import '../providers/pages.dart';
import 'package:flutter/material.dart';
import '../preset_web.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final bool? showHomeScreen;

  _launchLink(link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  AppDrawer(this.showHomeScreen);

  @override
  Widget build(BuildContext context) {
    final webPages = Provider.of<WebPages>(
      context,
      listen: false,
    );
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text(WebApp.title!),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(WebApp.title!),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: webPages.items.length,
            itemBuilder: (ctx, index) => ListTile(
              leading: Icon(Icons.web),
              title: Text(
                webPages.items[index]!.title!,
              ),
              onTap: () {
                if (webPages.items[index]!.price == 2) {
                  if (webPages.items[index]!.description!.startsWith('http')) {
                    _launchLink(webPages.items[index]!.description);
                  }
                } else {
                  Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: webPages.items[index]!.id,
                  );
                }
              },
            ),
          ),
        ),
        /*for (WebPage p in Provider.of<WebPages>(
          context,
          listen: false,
        ).items)
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(p.title),
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: p.id,
              );
            },
          ),*/
        //Divider(),
        Divider(),
        if (!Provider.of<Auth>(context, listen: false).isAuth)
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
      ]),
    );
  }
}
