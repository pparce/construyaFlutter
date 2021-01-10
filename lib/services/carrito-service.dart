import 'package:construyaalcosto/models/cart.dart';
import 'package:construyaalcosto/models/category.dart';
import 'package:construyaalcosto/models/product.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:hive/hive.dart';

class CarroService extends ChangeNotifier {
  static CarroService _instance;
  Cart cart;

  CarroService._internal() {
    _instance = this;
    initCart();
  }

  factory CarroService() => _instance ?? CarroService._internal();

  void initCart() async {
    cart = Cart(items: []);
    Box box = await Hive.openBox('app');
    String carro = box.get('carrito', defaultValue: cartToJson(cart));
    cart = cartFromJson(carro);
    if (cart.items.isEmpty) {
      cart = Cart(items: []);
    }

    notifyListeners();
  }

  List<Item> getItemsCart() {
    return cart.items;
  }

  Cart getCart() {
    return cart;
  }

  double getCartTotal() {
    return cart.total;
  }

  bool isCartEmpty() {
    return cart.items.length == 0;
  }

  void clearCart() {
    cart = Cart(items: []);
    calcularCartTotal();
  }

  void removeItem(Item item) {
    cart.items = cart.items.where((element) => element != item).toList();
    calcularCartTotal();
  }

  void addToCart(Product product, int qty) {
    if (itemExists(product)) {
      int posicionItem =
          cart.items.map((e) => e.product.id).toList().indexOf(product.id);
      Item item = cart.items[posicionItem];
      cart.items[posicionItem] = buildItem(product, qty + item.qty);
    } else {
      cart.items.add(buildItem(product, qty));
    }
    calcularCartTotal();
  }

  bool itemExists(Product product) {
    return cart.items.map((e) => e.product.id).toList().indexOf(product.id) !=
        -1;
  }

  Item buildItem(Product product, int qty) {
    return Item(
        product: product,
        qty: qty,
        price: product.productPricing.realPrice,
        subTotal: product.productPricing.realPrice * qty);
  }

  void calcularCartTotal() {
    double auxTotal = 0;
    for (var item in cart.items) {
      auxTotal += item.subTotal;
    }
    cart.total = auxTotal;
    saveCart();
  }

  void saveCart() async {
    Box box = await Hive.openBox('app');
    box.put('carrito', cartToJson(cart));
    notifyListeners();
  }
}
