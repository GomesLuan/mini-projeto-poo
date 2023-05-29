import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Cart extends HookWidget {
  final List items;

  const Cart({this.items = const []});

  @override
  Widget build(BuildContext context) {
    var state = useState(items.length);

    if (items.isEmpty) {
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

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
            leading: SizedBox(
                width: 100,
                child: Image.network(
                  items[index]["image"],
                  fit: BoxFit.cover,
                )),
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
                }));
      },
    );
  }
}
