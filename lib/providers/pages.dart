import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/http_exception.dart';
import '../providers/page.dart';
import 'package:http/http.dart' as http;

import 'auth.dart';

class WebPages with ChangeNotifier {
  static List<WebPage?> defaultPages = [
    /*WebPage(
      id: 'p2',
      title: 'Vocal Survey',
      description: 'https://www.youtube.com/embed/pNts69vZTx4',
      price: 0,
      imageUrl:
          'https://img.youtube.com/vi/pNts69vZTx4/0.jpg',
    ),*/
    /*WebPage(
      id: 'p3',
      title: 'Page',
      description: 'https://glowbom.github.io/mobile-orders/',
      price: 1,
      imageUrl:
          'https://glowbom.netlify.app/v1.1.3/img/presets/web/web-page-small.png',
    ),

    WebPage(
      id: 'p1',
      title: 'Video',
      description: 'https://www.youtube.com/watch?v=gDNHy0em7Do',
      price: 1,
      imageUrl: 'https://glowbom.netlify.app/v1.1.3/img/presets/web/web-video-small.png',
    ),*/

    /*WebPage(
      id: 'p4',
      title: 'Chair',
      description: """<center>
  <br>
  <p style='width: 320px; max-width: 100%; text-align: left;'>
    <b>Chair</b>
  </p>

  <p style='width: 320px; max-width: 100%; text-align: left;'>
    <img src="https://glowbom.netlify.app/v1.1.3/img/presets/store/chair-small.jpg"
     alt="Chair" style='width: 320px; max-width: 100%; text-align: left;'>
  </p>

  <p style='width: 320px; max-width: 100%; text-align: left;'>
    One of the basic pieces of furniture,
    a <b>chair</b> is a type of seat.
    <br>
    <br>
    Source: 
    <a href='https://en.wikipedia.org/wiki/Chair'>Wikipedia</a>
  </p>
</center>""",
      price: 1,
      imageUrl:
          'https://glowbom.netlify.app/v1.1.3/img/presets/store/chair-small.jpg',
    ),

    WebPage(
      id: 'p5',
      title: 'Table',
      description: """<center>
  <br>
  <p style='width: 320px; max-width: 100%; text-align: left;'>
    <b>Table</b>
  </p>

  <p style='width: 320px; max-width: 100%; text-align: left;'>
    <img src="https://glowbom.netlify.app/v1.1.3/img/presets/store/table-small.jpg"
     alt="Table" style='width: 320px; max-width: 100%; text-align: left;'>
  </p>

  <p style='width: 320px; max-width: 100%; text-align: left;'>
    A <b>table</b> is an item of furniture with a flat top and 
    one or more legs, used as a surface for working at, eating 
    from or on which to place things.
    <br>
    <br>
    Source: 
    <a href='https://en.wikipedia.org/wiki/Chair'>Wikipedia</a>
  </p>
</center>""",
      price: 1,
      imageUrl:
          'https://glowbom.netlify.app/v1.1.3/img/presets/store/table-small.jpg',
    ),*/

    /*WebPage(
      id: 'p4',
      title: 'Tutorial',
      description: '''<html>
<head>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
</head>
<body>
  <div class="container">
    <div class="container" style="margin-top: 40px;">
      <ul class="collapsible z-depth-0 guides" style="border: none;">
        <li>
          <div class="collapsible-header grey lighten-4">
            <h4>Step 1</h4>
          </div>
          <div class="collapsible-body white">
            <p><b>Bold text</b>. Feel free to put your text here.</p>
            <a href="https://glowbom.com" target="_blank" class="btn" style="width: 160px; margin: 3px;" role="link">
              Your Button Name
            </a>
        </li>
        <li>
          <div class="collapsible-header grey lighten-4">
            <h4>Step 2</h4>
          </div>
          <div class="collapsible-body white">
            Add your text here
            <br>
        </li>
        <li>
          <div class="collapsible-header grey lighten-4">
            <h4>Feedback</h4>
          </div>
          <div class="collapsible-body white">
            <p>If you have any questions or feedback, please let us know <b>email@mydomain.com</b>.</p>
        </li>
      </ul>
    </div>
  </div> <!-- CLOSE CONTAINER -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
  <script>
    // setup materialize components
    document.addEventListener('DOMContentLoaded', function () {
      var collapsibleItems = document.querySelectorAll('.collapsible');
      M.Collapsible.init(collapsibleItems);
      var instance = M.Collapsible.getInstance(collapsibleItems[0]);
      instance.open(0);
    });
  </script>
</body>
</html>''',
      price: 1,
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/09/02/12/45/movie-918655_960_720.jpg',
    ),*/

    /*WebPage(
      id: 'p5',
      title: 'PayPal',
      description: 'https://www.paypal.com/paypalme/glowbom/50',
      price: 2,
      imageUrl:
          'https://www.paypalobjects.com/webstatic/i/logo/rebrand/ppcom.png',
    ),*/

    //https://img.youtube.com/vi/gDNHy0em7Do/0.jpg

    //Audio
    /*Product(
      id: 'p4',
      title: 'Glowbom',
      description: 'https://glowbom.com/chat/',
      price: 0,
      imageUrl:
          'https://glowbom.com/images/demovideo2x.png',
    ),*/
    /*Product(
      id: 'p4',
      title: 'Glowbom',
      description: 'https://glowbom.github.io/Glowbom/',
      price: 0,
      imageUrl:
          'https://raw.githubusercontent.com/Glowbom/Glowbom/master/icons/white/glowbom_logo.png',
    ),*/
    /*WebPage(
      id: 'p6',
      title: 'Music',
      description: """
      <center>
      <br>
      <p style='width: 320px; max-width: 100%; text-align: left;'>
        <b>Music</b>
      </p>
      <audio controls>
        <source src="https://raw.githubusercontent.com/Glowbom/Glowbom/master/audio/example.mp3" />
      </audio>
      <p style='width: 320px; max-width: 100%; text-align: left;'>
        <b>Music</b> is an art form, and a cultural activity, whose medium is sound. General definitions of music include common elements such as pitch (which governs melody and harmony), rhythm (and its associated concepts tempo, meter, and articulation), dynamics (loudness and softness), and the sonic qualities of timbre and texture (which are sometimes termed the "color" of a musical sound).
        <br>
        <br>
        Source: <a href='https://en.wikipedia.org/wiki/Music'>Wikipedia</a>
      </p>
      </center>
      """,
      price: 1,
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/08/25/00/56/guitar-905998_960_720.jpg',
    ),*/
    // movie
    /* WebPage(
      id: 'p7',
      title: 'Movie',
      description: """
      <center>
      <br>
      <p style='width: 320px; max-width: 100%; text-align: left;'>
        <b>Glowbom</b>
      </p>
      <video width="320" height="240" controls>
        <source src="https://raw.githubusercontent.com/Glowbom/Glowbom/master/video/demo.mp4" type="video/mp4">
        Your browser does not support the video tag.
      </video>
      <p style='width: 320px; max-width: 100%; text-align: left;'>
        <b>Glowbom</b> is the first no-code platform that lets you create software via chat, using just your voice.
      </p>
      </center>
      """,
      price: 1,
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/09/02/12/45/movie-918655_960_720.jpg',
    ),*/

    /*
    // use audio controlls to play audio
    <audio controls>
      <source src="https://raw.githubusercontent.com/Glowbom/Glowbom/master/audio/example.mp3" />
    </audio>
    */
  ];
  List<WebPage?>? _items = defaultPages;

  static List<WebPage?> get copyDefaultPages {
    return [...defaultPages];
  }

  List<WebPage?> get items {
    return [..._items!];
  }

  List<WebPage?> get favoriteItems {
    return _items!.where((element) => element!.isFavorite!).toList();
  }

  WebPage? findById(String? id) {
    return _items!.firstWhere((prod) => prod!.id == id);
  }

  final String? authToken;
  final String? userId;

  WebPages(this.authToken, this.userId, this._items);

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    // In order to filter by userId on the server side
    // 1. url =  Auth.URL + '/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    // 2. set index on Firebase Rules
    // "products": {
    //   ".indexOn": ["creatorId"]
    // }

    if (authToken == null) {
      return;
    }

    String filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';

    var url = Auth.URL + '/products.json?auth=$authToken$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }

      url = Auth.URL + '/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData =
          json.decode(favoriteResponse.body) as Map<String, dynamic>?;

      final List<WebPage?> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          WebPage(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(WebPage? value) async {
    if (authToken != null) {
      final url = Auth.URL + '/products.json?auth=$authToken';
      try {
        final response = await http.post(
          Uri.parse(url),
          body: json.encode({
            'title': value!.title,
            'description': value.description,
            'price': value.price,
            'imageUrl': value.imageUrl,
            'creatorId': userId,
          }),
        );
        final newProduct = WebPage(
          id: json.decode(response.body)['name'],
          title: value.title,
          description: value.description,
          price: value.price,
          imageUrl: value.imageUrl,
        );
        _items!.add(newProduct);
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      final newProduct = WebPage(
        id: DateTime.now().toIso8601String(),
        title: value!.title,
        description: value.description,
        price: value.price,
        imageUrl: value.imageUrl,
      );
      _items!.add(newProduct);
      notifyListeners();
    }
  }

  Future<void> updateProduct(String? id, WebPage? value) async {
    final prodIndex = _items!.indexWhere((element) => element!.id == id);
    if (prodIndex >= 0) {
      if (authToken != null) {
        final url = Auth.URL + '/products/$id.json?auth=$authToken';
        await http.patch(
          Uri.parse(url),
          body: json.encode({
            'title': value!.title,
            'description': value.description,
            'price': value.price,
            'imageUrl': value.imageUrl,
          }),
        );
      }
      _items![prodIndex] = value;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String? id) async {
    final url = Auth.URL + '/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items!.indexWhere((element) => element!.id == id);
    var existingProduct = _items![existingProductIndex];
    _items!.removeAt(existingProductIndex);
    notifyListeners();
    if (authToken != null) {
      try {
        final response = await http.delete(Uri.parse(url));
        if (response.statusCode >= 400) {
          throw HttpException('Could not delete product.');
        }
        existingProduct = null;
      } catch (error) {
        _items!.insert(existingProductIndex, existingProduct);
        notifyListeners();
      }
    }
  }
}
