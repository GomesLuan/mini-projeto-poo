import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum PageStatus{loading,ready,error}
enum Page{product,client,order}
class DataService {
  final ValueNotifier<Map<String,dynamic>> pageStateNotifier = ValueNotifier({
    'status': PageStatus.ready,
    'currentPage': Page.product,
    'dataObjects': []
  });
  final List cartItems = [];

  void carregarPagina(index) { 
    final funcoes = [carregarProduto, carregarCliente, carregarPedido];
    pageStateNotifier.value = {
      'status': PageStatus.loading,
      'dataObjects': []
    };
    funcoes[index]();
  }

  Future<void> carregarProduto() async {
    var productsUri = Uri(
      scheme: "http",
      host: "fakestoreapi.com",
      path: "/products",
    );
    var jsonString = await http.read(productsUri);
    var productsJson = jsonDecode(jsonString);
    pageStateNotifier.value = {
      'status': PageStatus.ready,
      'currentPage': Page.product,
      'dataObjects': productsJson
    };
  }

  void carregarCliente() {
    pageStateNotifier.value = {
      'status': PageStatus.ready,
      'currentPage': Page.client,
      'dataObjects': []
    };
  }

  void carregarPedido() {
    pageStateNotifier.value = {
      'status': PageStatus.ready,
      'currentPage': Page.order,
      'dataObjects': []
    };
  }
}

final dataService = DataService();

void main() {
  runApp(const MyApp());
}

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text("PDV")
        ),
        body: ValueListenableBuilder(
          valueListenable: dataService.pageStateNotifier,
          builder: (_, value, __) {
            switch (value['status']) {
              case PageStatus.loading:
                return Center(child: CircularProgressIndicator());
              case PageStatus.ready:
                switch (value['currentPage']) {
                  case Page.product:
                    return Catalog();
                  case Page.order:
                    return Cart(items: dataService.cartItems);
                }
              case PageStatus.error:
                return Center(child: Text("Não foi possível acessar os dados."));
            }
            return Text("...");
          }
        ),
        bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.carregarPagina),
      )
    );
  }
}

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  NewNavBar({itemSelectedCallback}):
    _itemSelectedCallback = itemSelectedCallback ?? (int){}
    
  @override
  Widget build(BuildContext context) {
    var state = useState(0);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index){
        state.value = index;
        _itemSelectedCallback(index);                
      }, 
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Produtos",
          icon: Icon(Icons.shopping_bag_outlined),
        ),
        BottomNavigationBarItem(
          label: "Clientes", 
          icon: Icon(Icons.person_add_alt_1_outlined)
        ),
        BottomNavigationBarItem(
          label: "Pedidos", 
          icon: Icon(Icons.sell_outlined)
        ),
      ]
    );
  }
}

class Catalog extends HookWidget {
  const Catalog({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      dataService.carregarProduto();
    }, []);

    return ValueListenableBuilder(
      valueListenable: dataService.pageStateNotifier,
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value['dataObjects'].length,
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
                      value['dataObjects'][index]["image"].toString(),
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
                              value['dataObjects'][index]["rating"]["rate"].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        )
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(Icons.category),
                            Text(
                              value['dataObjects'][index]["category"].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      value['dataObjects'][index]["title"].toString(),
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
                      value['dataObjects'][index]["description"].toString(),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "R\$" + value['dataObjects'][index]["price"].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500
                      )
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: FilledButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.all(20)
                            ),
                          ),
                          onPressed: () {
                            dataService.cartItems.add(value['dataObjects'][index]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Adicionado ao carrinho'),
                                action: SnackBarAction(
                                  label: 'Fechar',
                                  onPressed: () {},
                                ),
                              ),
                            );
                          },
                          child: const Text('Adicionar ao carrinho'),
                        )
                      )
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

class FormClient extends HookWidget {
  const FormClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('placeholder');
  }
}

class Cart extends HookWidget {
  final List items;

  const Cart({this.items = const []});

  @override
  Widget build(BuildContext context) {
    var state = useState(items.length);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: SizedBox(
            width: 100,
            child: Image.network(
              items[index]["image"],
              fit: BoxFit.cover,
            )
          ),
          title: Text(
            items[index]["title"],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            " R\$ ${items[index]["price"].toString()}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              items.removeAt(index);
              state.value--;
            }
          )
        );
      },
    );
  }
}