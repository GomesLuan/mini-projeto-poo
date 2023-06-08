import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Cart extends HookWidget {
  final cartItems;
  final customers;

  Cart({this.cartItems = const [], this.customers = const []});

  @override
  Widget build(BuildContext context) {
    var cartState = useState(cartItems.length);
    double totalPrice = 0.0;

    totalPrice = cartItems.fold(
        totalPrice,
        (previousValue, element) =>
            previousValue + (element["price"] * element["quantity"]));

    if (cartItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Seu carrinho está vazio",
              style: TextStyle(fontSize: 16),
            ),
            Text("Adicione produtos para continuar")
          ],
        ),
      );
    }

    if (customers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Não há clientes cadastrados",
              style: TextStyle(fontSize: 16),
            ),
            Text("Cadastre clientes para continuar")
          ],
        ),
      );
    }

    var customerSelected = useState(customers.first['name']);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          alignment: Alignment.topLeft,
          child: const Text("Selecione o cliente:",
              style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: DropdownButtonFormField(
            value: customerSelected.value,
            onChanged: (value) {
              customerSelected.value = value!;
            },
            items: customers
                .map<DropdownMenuItem<String>>((cust) =>
                    DropdownMenuItem<String>(
                        value: cust['name'], child: Text(cust['name'])))
                .toList(),
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[100],
            ),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                  tileColor: Colors.green[50],
                  leading: SizedBox(
                      width: 100,
                      child: Image.network(
                        cartItems[index]["image"],
                        fit: BoxFit.cover,
                      )),
                  title: Text(
                    cartItems[index]["title"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  subtitle: Text(
                    " R\$ ${cartItems[index]["price"].toString()}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (cartItems[index]["quantity"] > 1) {
                            cartItems[index]["quantity"]--;
                            cartState.value--;
                          } else {
                            cartItems.removeAt(index);
                            cartState.value--;
                          }
                        },
                      ),
                      Text(
                        cartItems[index]["quantity"].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cartItems[index]["quantity"]++;
                          cartState.value++;
                        },
                      ),
                    ],
                  ));
            },
          ),
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total: R\$ ${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: FilledButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                ),
                child: Text("Finalizar compra"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Pedido enviado!"),
                          content: Text(
                              "Obrigado por comprar conosco, ${customerSelected.value}!"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"))
                          ],
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
