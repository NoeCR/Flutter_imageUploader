import 'dart:io';

import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/services/product_service.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  final _producController = new BehaviorSubject<List<ProductModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productService = new ProductService();

  Stream<List<ProductModel>> get productStream => _producController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void loadProducts() async {
    final products = await _productService.loadProducts();
    _producController.sink.add(products);
  }

  void addProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productService.createProduct(product);
    _loadingController.sink.add(false);
  }

  Future<String> uploadImage(File image) async {
    _loadingController.sink.add(true);
    final photoUrl = await _productService.uploadImage(image);
    _loadingController.sink.add(false);

    return photoUrl;
  }

  void updateProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productService.updateProduct(product);
    _loadingController.sink.add(false);
  }

  void deleteProduct(String id) async {
    await _productService.deleteProduct(id);
  }

  dispose() {
    _producController.close();
    _loadingController.close();
  }
}
