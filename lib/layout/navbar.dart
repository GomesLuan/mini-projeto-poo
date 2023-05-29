import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  const NewNavBar({itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? (int);

  @override
  Widget build(BuildContext context) {
    var state = useState(0);
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
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
              label: "Clientes", icon: Icon(Icons.person_add_alt_1_outlined)),
          BottomNavigationBarItem(
              label: "Pedidos", icon: Icon(Icons.sell_outlined)),
        ]);
  }
}
