import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:miniprojeto/main.dart';

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  const NewNavBar({itemSelectedCallback})
    : _itemSelectedCallback = itemSelectedCallback ?? (int);

  @override
  Widget build(BuildContext context) {
    var currentIndex = useState(0);

    final cartItemsQty = dataService.cartStateNotifier.value.length;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        currentIndex.value = index;
        _itemSelectedCallback(index);
      },
      currentIndex: currentIndex.value,
      items: [
        const BottomNavigationBarItem(
          label: "Produtos",
          icon: Icon(Icons.shopping_bag_outlined),
        ),
        const BottomNavigationBarItem(
          label: "Clientes", 
          icon: Icon(Icons.person_add_alt_1_outlined)
        ),
        BottomNavigationBarItem(
          label: "Pedido",
          icon: badges.Badge(
            badgeContent: Text(
              cartItemsQty.toString(),
              style: TextStyle(color: Colors.white),
            ),
            child: Icon(Icons.receipt_long_outlined),
          )
        ),
      ]
    );
  }
}
