import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

import 'package:formvalidation/src/models/product_model.dart';

class ProductService {
  final String _path = 'https://flutter-several.firebaseio.com';

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_path/products.json';

    final response = await http.post(url, body: productModelToJson(product));

    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final url = '$_path/products/${product.id}.json';

    final response = await http.put(url, body: productModelToJson(product));

    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductModel>> loadProducts() async {
    final url = '$_path/products.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductModel> products = new List();

    if (decodedData == null) return [];

    decodedData.forEach((id, product) {
      final prodTemp = ProductModel.fromJson(product);
      prodTemp.id = id;

      products.add(prodTemp);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_path/products/$id.json';
    final resp = await http.delete(url);

    // print(resp.body);
    return 1;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/ddjmfoix2/image/upload?upload_preset=uqyi3gii');

    final mimeType = mime(image.path).split('/'); // image/jpg

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('something went wrong');
      return null;
    }

    final responseData = json.decode(resp.body);

    return responseData['secure_url'];
  }
}
