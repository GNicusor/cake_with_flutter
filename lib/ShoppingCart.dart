import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';
import 'package:flutter/cupertino.dart';

class ShoppingCart extends ChangeNotifier{

  List<CartItem> _cartItems = [];
  get cartItems => _cartItems;

  void addItemToCart(String itemName, int pret){
      _cartItems.add(CartItem(itemName, pret));
      notifyListeners();
  }

  void removeItemFromCart(String name) {
    bool itemRemoved = false;
    _cartItems.removeWhere((carts) {
      if (!itemRemoved && carts.name == name) {
        itemRemoved = true;
        return true;
      }
      return false;
    });
    if (itemRemoved) {
      notifyListeners();
    }
  }

}

class CartItem {
  final String name;
  final int quantity;

  CartItem(this.name,this.quantity);
}


