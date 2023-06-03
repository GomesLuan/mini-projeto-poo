import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'services/data_service.dart';
import 'utils/page_status.dart';
import 'utils/current_page.dart';
import 'components/cart_page.dart';
import 'components/catalog_page.dart';
import 'components/form_customer_page.dart';
import 'layout/navbar.dart';

final dataService = DataService();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    dataService.loadProduct();

    return MaterialApp(
      title: 'PDV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("PDV")),
        body: ValueListenableBuilder(
          valueListenable: dataService.pageStateNotifier,
          builder: (_, value, __) {
            switch (value['status']) {
              case PageStatus.loading:
                return Center(child: CircularProgressIndicator());
              case PageStatus.ready:
                switch (value['currentPage']) {
                  case CurrentPage.product:
                    return Catalog(
                      dataObjects: value['dataObjects'], 
                      cartItems: dataService.cartStateNotifier.value
                    );
                  case CurrentPage.client:
                    return const FormClient();
                  case CurrentPage.order:
                    return Cart(items: dataService.cartStateNotifier.value);
                  default:
                    return const Center(child: Text("Algo deu errado"));
                }
              case PageStatus.error:
                return const Center(
                  child: Text("Não foi possível acessar os dados."));
                default:
                  return const Text("Ops Algo deu errado!");
            }
          }
        ),
        bottomNavigationBar: NewNavBar(
          itemSelectedCallback: dataService.loadPage, 
        )
      )
    );
  }
}
