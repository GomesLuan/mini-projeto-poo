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

  final ValueNotifier<List> cartStateNotifier = ValueNotifier([]);

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
    try {
      final response = await http.get(productsUri);
      if (response.statusCode == 200) {
        final List<dynamic> products = jsonDecode(response.body);
        pageStateNotifier.value = {
          'status': PageStatus.ready,
          'currentPage': CurrentPage.product,
          'dataObjects': products
        };
      } else {
        pageStateNotifier.value = {
          'status': PageStatus.error,
          'currentPage': CurrentPage.product,
          'dataObjects': []
        };
      }
    } catch (error) {
      pageStateNotifier.value = {
        'status': PageStatus.error,
        'currentPage': CurrentPage.product,
        'dataObjects': []
      };
    }
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
