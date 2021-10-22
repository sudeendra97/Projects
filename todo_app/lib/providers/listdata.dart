import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/providers/tododata.dart';
import 'package:http/http.dart' as http;

class TodoListData with ChangeNotifier {
  List<TodoData> _list = [];

  List<TodoData> get list {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    //... is a spread operator
    return [..._list];
  }

  Future<void> addData(TodoData data) async {
    final url = Uri.parse(
        'https://todo-app-3b4dc-default-rtdb.firebaseio.com/Tasks.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'Task': data.data,
          'Time': data.time,
        }),
      );
      final newProduct = TodoData(
        data: data.data,
        time: data.time,
      );
      _list.add(newProduct);

      notifyListeners();
      fetchAndSetProduct();
    } catch (error) {
      print(error);
      throw error;
    }
    // _list.add(data);
    print(data.data);
    print(data.time);
    notifyListeners();
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    // final filterString =
    //     filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://todo-app-3b4dc-default-rtdb.firebaseio.com/Tasks.json');
    try {
      final response = await http.get(url);

      if (json.decode(response.body) == null) {
        return;
      } else {
        // final url = Uri.parse(
        //     'https://shop-app-bf823-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
        // final favoriteResponse = await http.get(url);
        // final favoriteData = json.decode(favoriteResponse.body);

        final extratedData = json.decode(response.body) as Map<String, dynamic>;

        final List<TodoData> loadedProducts = [];
        extratedData.forEach((prodId, prodData) {
          loadedProducts.add(
            TodoData(
              id: prodId,
              data: prodData['Task'],
              time: prodData['Time'],
            ),
          );
        });
        _list = loadedProducts;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    //status codes
    //200 and 201 everything good
    //300 you have been redirected
    //400 status codes tells that error has been occured .
    // 500 status codes do the same b ut litle different refer  the list attached to the course

    final url = Uri.parse(
        'https://todo-app-3b4dc-default-rtdb.firebaseio.com/Tasks/$id.json');
    final response = await http.delete(url);
    if (response.statusCode <= 200) {
      final existingProductIndex =
          _list.indexWhere((element) => element.id == id);
      TodoData? existingProduct = _list[existingProductIndex];
      _list.removeAt(existingProductIndex);
      notifyListeners();
      existingProduct = null;
    }

    //delete doesnot send any error messages to user if any exceptions occur

    if (response.statusCode >= 400) {
      // _list.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw Error();
    }

    // _items.removeWhere((element) => element.id == id);
    // notifyListeners();
  }
}
