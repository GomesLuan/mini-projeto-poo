import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Catalog extends HookWidget {
  final dataObjects;
  final cartItems;

  const Catalog({this.dataObjects = const [], this.cartItems = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataObjects.length,
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
                  dataObjects[index]["image"].toString(),
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
                            dataObjects[index]["rating"]["rate"].toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Icon(Icons.category),
                          Text(
                            dataObjects[index]["category"].toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ))
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: Text(
                  dataObjects[index]["title"].toString(),
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
                  dataObjects[index]["description"].toString(),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: Text("R\$ " + dataObjects[index]["price"].toString(),
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
                          final exists = cartItems.indexWhere((element) =>
                              element["title"] == dataObjects[index]["title"]);
                          if (exists != -1) {
                            cartItems[exists]["quantity"]++;
                          } else {
                            cartItems.add({
                              "image": dataObjects[index]["image"],
                              "title": dataObjects[index]["title"],
                              "price": dataObjects[index]["price"],
                              "rating": dataObjects[index]["rating"],
                              "category": dataObjects[index]["category"],
                              "description": dataObjects[index]["description"],
                              "quantity": 1,
                            });
                          }
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
                      ))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
