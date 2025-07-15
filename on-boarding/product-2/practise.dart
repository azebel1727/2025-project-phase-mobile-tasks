import 'dart:io';

void main() {
  product p1 = product();
  Map listofactions = {
    1: "add",
    2: "view all",
    3: "view a single product",
    4: "delete",
    5: "update"
  };
  print(listofactions);
  bool perform = true;
  while (perform) {
    print("enter the number to perform a task");
    String? choice = stdin.readLineSync();
    if (choice == "1") {
      p1.addproduct();
    } else if (choice == "2") {
      p1.viewproduct();
    } else if (choice == "3") {
      p1.viewsingleproduct();
    } else if (choice == "2") {
      p1.deleteproduct();
    } else if (choice == "2") {
      p1.updateproduct();
    }
    print("do you want to proceed?");
    String? ans = stdin.readLineSync();
    if (ans != "y") {
      perform = false;
    }
  }
}

class product {
  String? name;
  String? description;
  double? price;
  List<Map<String, dynamic>> customers = [];

  void addproduct() {
    bool check = true;
    while (check) {
      print("enter the product name, description and price");
      name = stdin.readLineSync();
      description = stdin.readLineSync();
      String? price1 = stdin.readLineSync();
      //int price1 = int.parse(this.price);
      price = double.tryParse(price1 ?? '');
      customers.add({'name': name, 'description': description, "price": price});
      print("do you want to add other products?");
      String? c;
      c = stdin.readLineSync();
      if (c != "y") {
        check = false;
      } 
    }
  }

  void viewproduct() {
    print(customers);
  }

  void viewsingleproduct() {
    print("enter the name of the product to see the price and description");
    String? product_name = stdin.readLineSync();
    var products = customers.firstWhere(
      (foundproduct) =>
          foundproduct['name'].toString().toLowerCase() ==
          product_name?.toLowerCase(),
      orElse: () => {},
    );

    if (products.isEmpty) {
      print("no product found");
    } else {
      print(
          "name: ${products['name']}, Description: ${products['description']}, Price: ${products['price']}");
    }
  }

  void deleteproduct() {
    print("enter the name of the product which you want to delete");
    String? product_name = stdin.readLineSync();
    var products = customers.firstWhere(
      (foundproduct) =>
          foundproduct['name'].toString().toLowerCase() ==
          product_name?.toLowerCase(),
      orElse: () => {},
    );

    if (products.isEmpty) {
      print("no product found");
    } else {
      customers.remove(products);
    }
  }

  void updateproduct() {
    print("enter the name of the product to update the details");
    String? product_name = stdin.readLineSync();
    var products = customers.firstWhere(
      (foundproduct) =>
          foundproduct['name'].toString().toLowerCase() ==
          product_name?.toLowerCase(),
      orElse: () => {},
    );

    if (products.isEmpty) {
      print("no product found");
    } else {
      print("enter the name, description and price of the updated one");
      String? updatedname = stdin.readLineSync();
      String? updateddescription = stdin.readLineSync();
      String? updatedprice = stdin.readLineSync();
      products['name'] = updatedname;
      products['description'] = updateddescription;
      products['price'] = double.tryParse(updatedprice ?? '');
    }
  }
}
