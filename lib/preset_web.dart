import 'dart:convert';
import 'dart:math';

import './providers/page.dart';

import './screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/pages.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_page_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail.dart';
import './screens/products_overview_screen.dart';
import './screens/splash_screen.dart';
import './screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class WebApp extends StatefulWidget {
  static String? title = 'Web';
  final dynamic content;
  final bool onlyEditor;
  final bool limited;
  WebApp(this.content, this.onlyEditor, this.limited);

  @override
  _WebAppState createState() => _WebAppState(content);
}

class _WebAppState extends State<WebApp> {
  dynamic _content;
  bool? _showApplicationBar = true;
  bool? _showHomeScreen = true;
  _WebAppState(this._content);

  Future<dynamic> loadContentFromAssets() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/web.glowbom");
    return json.decode(data);
  }

  var _expired = false;

  @override
  void initState() {
    super.initState();
    if (_content == null) {
      loadContentFromAssets().then(
        (value) => setState(() {
          _content = value;
          List<WebPage> pages = List<WebPage>.empty(growable: true);

          List<dynamic> loadedPages = value['products'];

          for (int index = 0; index < loadedPages.length; index++) {
            WebPage page = WebPage(
              description: (loadedPages[index]['description'] as String)
                  .replaceAll('[HASHTAG]', '#'),
              id: loadedPages[index]['id'],
              title: loadedPages[index]['title'],
              price: double.tryParse(loadedPages[index]['price'].toString()),
              imageUrl: loadedPages[index]['imageUrl'],
              isFavorite: loadedPages[index]['isFavorite'],
            );
            pages.add(page);
          }
          value['products'] = pages;
        }),
      );
    }
  }

  int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);

  MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  @override
  Widget build(BuildContext context) {
    WebApp.title = _content != null ? _content['title'] : 'Web';

    if (_content != null) {
      if (_content.containsKey('show_percentage_result')) {
        _showApplicationBar = _content['show_percentage_result'];
      } else {
        _showApplicationBar = true;
      }

      if (_content.containsKey('show_number_result')) {
        _showHomeScreen = _content['show_number_result'];
      } else {
        _showHomeScreen = true;
      }
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, WebPages?>(
          create: (ctx) => null,
          update: (ctx, auth, previousProducts) => WebPages(
            auth.token,
            auth.userId,
            _content != null ? _content['products'] : WebPages.defaultPages,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders?>(
          create: (ctx) => null,
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: WebApp.title!,
          theme: ThemeData(
            primarySwatch: _content != null
                ? (_content['main_color'] == 'Blue'
                    ? Colors.blue
                    : _content['main_color'] == 'Green'
                        ? Colors.green
                        : _content['main_color'] == 'Red'
                            ? Colors.red
                            : _content['main_color'] == 'Grey'
                                ? Colors.grey
                                : _content['main_color'] == 'White'
                                    ? generateMaterialColor(Colors.white)
                                    : _content['main_color'] == 'Black'
                                        ? generateMaterialColor(Colors.black)
                                        : Colors.purple)
                : Colors.blue, // default color
            //accentColor: Colors.deepOrange,
            textTheme: GoogleFonts.latoTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: _expired
              ? Scaffold(
                  body: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('The preview is no longer available.'),
                    ),
                  ),
                )
              : widget.onlyEditor
                  ? UserProductsScreen(widget.onlyEditor)
                  : auth.isAuth
                      ? !_showApplicationBar!
                          ? ProductDetailScreen(widget.limited,
                              _showApplicationBar, _showHomeScreen)
                          : _showHomeScreen!
                              ? ProductsOverviewScreen(_showHomeScreen)
                              : ProductDetailScreen(widget.limited,
                                  _showApplicationBar, _showHomeScreen)
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (ctx, authResultSnapshot) =>
                              authResultSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : AuthScreen(),
                        ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(
                widget.limited, _showApplicationBar, _showHomeScreen),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) =>
                UserProductsScreen(widget.onlyEditor),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            CheckoutScreen.routeName: (ctx) => CheckoutScreen(
                () {},
                _content != null ? _content['show_number_result'] : false,
                _content != null ? _content['show_percentage_result'] : false,
                _content != null ? _content['voice'] : false,
                _content != null
                    ? _content['conclusion']
                    : 'Thank you! Please enter your shipping information:',
                _content != null ? _content['start_over'] : '',
                ''),
          },
        ),
      ),
    );
  }
}
