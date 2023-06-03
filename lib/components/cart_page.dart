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

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[100],
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
            tileColor: Colors.green[50],
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
                overflow: TextOverflow.ellipsis,
              ),
            ),
            subtitle: Text(
              " R\$ ${items[index]["price"].toString()}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (items[index]["quantity"] > 1) {
                      items[index]["quantity"]--;
                      state.value--;
                    } else {
                      items.removeAt(index);
                      state.value--;
                    }
                  },
                ),
                Text(
                  items[index]["quantity"].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    items[index]["quantity"]++;
                    state.value++;
                  },
                ),
              ],
            ));
      },
    );
  }
}
