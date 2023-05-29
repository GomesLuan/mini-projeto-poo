import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/current_page.dart';
import '../utils/page_status.dart';

class DataService {
  final ValueNotifier<Map<String, dynamic>> pageStateNotifier = ValueNotifier({
    'status': PageStatus.loading,
    'currentPage': CurrentPage.product,
    'dataObjects': []
  });
  final List cartItems = [];

  void loadPage(index) {
    final functions = [loadProduct, loadClient, loadOrder];
    pageStateNotifier.value = {'status': PageStatus.loading, 'dataObjects': []};
    functions[index]();
  }

  Future<void> loadProduct() async {
    var productsUri = Uri(
      scheme: "http",
      host: "fakestoreapi.com",
      path: "/products",
    );
    var jsonString = await http.read(productsUri);
    var productsJson = jsonDecode(jsonString);
    pageStateNotifier.value = {
      'status': PageStatus.ready,
      'currentPage': CurrentPage.product,
      'dataObjects': productsJson
    };
  }

  void loadClient() {
    pageStateNotifier.value = {
      'status': PageStatus.ready,
      'currentPage': CurrentPage.client,
      'dataObjects': []
    };
  }

  void loadOrder() {
    pageStateNotifier.value = {
      'status': PageStatus.ready,
      'currentPage': CurrentPage.order,
      'dataObjects': []
    };
  }
}
