import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/pages.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

// Uncomment to build for WEB
import 'dart:html' as html;
import 'dart:ui' as ui;
// end of block for WEB

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  static const mainItemIndex = 0;
  static int _addedViews = 0;

  final bool limited;
  final bool? showApplicationBar;
  final bool? showHomeScreen;

  ProductDetailScreen(
      this.limited, this.showApplicationBar, this.showHomeScreen);

  bool _isUnlimited(loadedProduct) {
    if (limited) {
      return false;
    }

    return WebPages.defaultPages.contains(loadedProduct);
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String?;
    final loadedProduct = !showHomeScreen!
        ? Provider.of<WebPages>(
            context,
            listen: false,
          ).items[mainItemIndex]!
        : showApplicationBar!
            ? Provider.of<WebPages>(
                context,
                listen: false,
              ).findById(productId)!
            : Provider.of<WebPages>(
                context,
                listen: false,
              ).items[mainItemIndex]!;

    // Uncomment to build for WEB

    if (loadedProduct.description != null) {
      if (kIsWeb) {
        try {
          ++_addedViews;
          if (loadedProduct.description!
              .startsWith('https://www.youtube.com/')) {
            // YouTube is always On

            ui.platformViewRegistry.registerViewFactory(
                'web-page-html$_addedViews',
                (int id) => html.IFrameElement()
                  ..width = MediaQuery.of(context).size.width.toString()
                  ..height = MediaQuery.of(context).size.height.toString()
                  ..src = loadedProduct.description!
                          .startsWith('https://www.youtube.com/watch?v=')
                      ? loadedProduct.description!.replaceAll(
                          'https://www.youtube.com/watch?v=',
                          'https://www.youtube.com/embed/')
                      : loadedProduct.description
                  ..style.border = 'none');
          } else if (_isUnlimited(loadedProduct)) {
            // Preview

            ui.platformViewRegistry.registerViewFactory(
                'web-page-html$_addedViews',
                (int id) => html.IFrameElement()
                  ..width = MediaQuery.of(context).size.width.toString()
                  ..height = MediaQuery.of(context).size.height.toString()
                  ..src = loadedProduct.description!.startsWith('http')
                      ? loadedProduct.description
                      : Uri.dataFromString(loadedProduct.description!,
                              mimeType: 'text/html')
                          .toString()
                  ..style.border = 'none');
          } else {
            // Run
            String? src = loadedProduct.description!.startsWith('http')
                ? loadedProduct.description
                : Uri.dataFromString(
                        loadedProduct.description!.replaceAll('\n', '<br>'),
                        mimeType: 'text/html',
                        encoding: Encoding.getByName('utf-8'))
                    .toString();
            // ignore: undefined_prefixed_name
            ui.platformViewRegistry.registerViewFactory(
                'web-page-html$_addedViews',
                (int id) => html.IFrameElement()
                  ..width = MediaQuery.of(context).size.width.toString()
                  ..height = MediaQuery.of(context).size.height.toString()
                  ..src = Uri.dataFromString(
                          // <center><p>Some functionality may be limited in the <b>editor mode</b>.</p></center>
                          '<iframe src="$src"  scrolling="yes" style="position:fixed; top:0; left:0; bottom:0; right:0; width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;"></iframe>',
                          mimeType: 'text/html')
                      .toString()
                  ..style.border = 'none');

            /*Future.delayed(const Duration(milliseconds: 1000), () {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Some functionality may be limited in the editor mode',
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ));
            });*/
          }
        } catch (e) {
          print(e);
        }
      }
    }

    // end of block for WEB

    var urlString = loadedProduct.description;

    if (!kIsWeb) {
      if (loadedProduct.description!.startsWith('https://www.youtube.com/')) {
        // YouTube is always On
        urlString = loadedProduct.description!
                .startsWith('https://www.youtube.com/watch?v=')
            ? loadedProduct.description!.replaceAll(
                'https://www.youtube.com/watch?v=',
                'https://www.youtube.com/embed/')
            : loadedProduct.description;
      } else if (_isUnlimited(loadedProduct)) {
        // Preview
        urlString = loadedProduct.description!.startsWith('http')
            ? loadedProduct.description
            : Uri.dataFromString(loadedProduct.description!,
                    mimeType: 'text/html')
                .toString();
      } else {
        // Run
        String? src = loadedProduct.description!.startsWith('http')
            ? loadedProduct.description
            : Uri.dataFromString(
                    loadedProduct.description!.replaceAll('\n', '<br>'),
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8'))
                .toString();
        urlString = Uri.dataFromString(
            // <center><p>Some functionality may be limited in the <b>editor mode</b>.</p></center>
            """<html><head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body>
        <iframe src="$src"  scrolling="yes" style="position:fixed; top:0; left:0; bottom:0; right:0; width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;"></iframe>
      </body></html>""", mimeType: 'text/html').toString();
      }
    }

    return Scaffold(
      appBar: showApplicationBar!
          ? AppBar(
              title: Text(loadedProduct.title!),
            )
          : null,
      drawer: !showHomeScreen! ? AppDrawer(showHomeScreen) : null,
      body: loadedProduct.description != null
          ? SizedBox(
              height: double.infinity,
              child: kIsWeb
                  ? HtmlElementView(
                      viewType: 'web-page-html$_addedViews',
                    )
                  : WebView(
                      initialUrl: urlString,
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: Image.network(
                      loadedProduct.imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  Text(
                    '\$${loadedProduct.price}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      loadedProduct.description!,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
