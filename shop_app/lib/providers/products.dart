import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:shop_app/models/httpexception.dart';
import 'package:shop_app/providers/productsblueprint.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product>? _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var _showFavoritesOnly = false;

  var authToken;

  var userId;

  Products([this.authToken, this.userId, this._items]);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    //... is a spread operator
    return [...?_items];
  }

  List<Product> get favoriteItems {
    return _items!.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items!.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-app-bf823-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
          // 'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items!.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    // .then((response) {
  }
  //

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items!.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-app-bf823-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavorite': newProduct.isFavorite,
          },
        ),
      );
      _items![prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('.....');
    }
  }

  Future<void> deleteProduct(String id) async {
    //status codes
    //200 and 201 everything good
    //300 you have been redirected
    //400 status codes tells that error has been occured .
    // 500 status codes do the same b ut litle different refer  the list attached to the course

    final url = Uri.parse(
        'https://shop-app-bf823-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex =
        _items!.indexWhere((element) => element.id == id);
    Product? existingProduct = _items![existingProductIndex];
    _items!.removeAt(existingProductIndex);
    notifyListeners();
    //delete doesnot send any error messages to user if any exceptions occur

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items!.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete Product');
    }

    existingProduct = null;

    // _items.removeWhere((element) => element.id == id);
    // notifyListeners();
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://shop-app-bf823-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);

      if (json.decode(response.body) == null) {
        return;
      } else {
        final url = Uri.parse(
            'https://shop-app-bf823-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
        final favoriteResponse = await http.get(url);

        final favoriteData = json.decode(favoriteResponse.body);

        final extratedData = json.decode(response.body) as Map<String, dynamic>;

        final List<Product> loadedProducts = [];
        extratedData.forEach((prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              isFavorite:
                  //here ?? question mark checks whether the value is null
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
            ),
          );
        });
        _items = loadedProducts;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
