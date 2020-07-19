import 'package:flutter/material.dart';
import 'package:admin_books_app/helpers/product.dart';
import '../models/products.dart';

class ProductProvider with ChangeNotifier{
  ProductServices _productServices = ProductServices();
  List<Product> products = [];
  List<Product> productsByCategory = [];
  List<Product> productsById = [];
  List<Product> productsByRating = [];
  List<Product> productsSearched = [];


  ProductProvider.initialize(){
    loadProducts();
  }

  loadProducts()async{
    products = await _productServices.getProducts();
    notifyListeners();
  }

  Future<bool> deleteProduct({String productId, String imageUrl}) async {
    try {
      _productServices.deleteProduct(productId: productId, imageUrl: imageUrl);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateProduct({String productId, String name, String image, String category, String author, String nxb, String description, String rating, String old_price, int price}) async {
    try {
      _productServices.updateProduct( productId : productId, name : name, image : image, category : category, author :author,nxb : nxb, description : description, rating : rating, old_price : old_price , price : price);
    return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future loadProductsByCategory({String categoryName})async{
    productsByCategory = await _productServices.getProductsOfCategory(category: categoryName);
    notifyListeners();
  }

  Future loadProductsById({String id})async{
    productsById = await _productServices.getProductsById(id: id);
    notifyListeners();
  }


  Future loadProductsByRating({String rating})async{
    productsByRating = await _productServices.getProductsOfRating(rating: rating);
    notifyListeners();
  }


  Future search({String productName})async{
    productsSearched = await _productServices.searchProducts(productName: productName);
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");
    notifyListeners();
  }



}