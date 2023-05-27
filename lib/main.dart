import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

ValueNotifier<List> products = ValueNotifier([]);
ValueNotifier<bool> isLoading = ValueNotifier(false);
ValueNotifier<List> cartItems = ValueNotifier([]);
ValueNotifier<int> totalItems = ValueNotifier(0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const DefaultTabController(
        length: 2,
        child: MyHomePage(title: 'PDV'),
      ),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDV"),
        bottom: TabBar(tabs: [
          Tab(
            icon: Icon(Icons.list),
            text: "Catalogo",
          ),
          Tab(
            icon: ValueListenableBuilder<int>(
              valueListenable: totalItems,
              builder: (context, value, child) => Badge.count(
                count: value,
                child: Icon(Icons.shopping_cart),
              ),
            ),
            text: "Carrinho",
          ),
        ]),
      ),
      body: const TabBarView(
        children: [
          Catalog(),
          Cart(),
        ],
      ),
    );
  }
}

class Catalog extends HookWidget {
  const Catalog({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> getProducts() async {
      isLoading.value = true;
      var productsUrl =
          Uri(scheme: "http", host: "fakestoreapi.com", path: "/products");
      var jsonString = http.read(productsUrl);
      var json = await jsonString;
      isLoading.value = false;
      products.value = jsonDecode(json);
    }

    useEffect(() {
      getProducts();
    }, []);

    return ValueListenableBuilder<List>(
      valueListenable: products,
      builder: (context, value, child) {
        return isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Image.network(
                            value[index]["image"].toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star),
                                    Text(
                                      value[index]["rating"]["rate"].toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )),
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.category),
                                    Text(
                                      value[index]["category"].toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            value[index]["title"].toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            value[index]["description"].toString(),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(10),
                          child: Text("R\$" + value[index]["price"].toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: FilledButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(20)),
                                  ),
                                  onPressed: () {
                                    cartItems.value.add(value[index]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Adicionado ao carrinho'),
                                        action: SnackBarAction(
                                          label: 'Fechar',
                                          onPressed: () {},
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Adicionar ao carrinho'),
                                ))
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}

class Cart extends HookWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List>(
      valueListenable: cartItems,
      builder: (context, value, child) {
        return isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  totalItems.value = cartItems.value.length;
                  return ListTile(
                    leading: SizedBox(
                        width: 100,
                        child: Image.network(
                          value[index]["image"],
                          fit: BoxFit.cover,
                        )),
                    title: Text(
                      value[index]["title"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      " R\$ ${value[index]["price"].toString()}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        cartItems.value.removeAt(index);
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}