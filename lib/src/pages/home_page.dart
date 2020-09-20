import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/services/product_service.dart';
// import 'package:formvalidation/src/bloc/provider.dart';

class HomePage extends StatelessWidget {
  final productService = new ProductService();
  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: _createList(context),
      floatingActionButton: _createButton(context),
    );
  }

  FloatingActionButton _createButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'product'),
    );
  }

  Widget _createList(BuildContext context) {
    return FutureBuilder(
      future: productService.loadProducts(),
      builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) =>
          (snapshot.hasData)
              ? _buildList(context, snapshot.data)
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildList(BuildContext context, List<ProductModel> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => _createItem(context, products[index]),
    );
  }

  Widget _createItem(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red[100],
      ),
      onDismissed: (direction) {
        productService.deleteProduct(product.id);
      },
      child: Card(
        child: Column(
          children: [
            (product.photoUrl == null)
                ? Image(image: AssetImage('assets/img/no-image.png'))
                : FadeInImage(
                    placeholder: AssetImage('assets/img/jar-loading.gif'),
                    image: NetworkImage(product.photoUrl),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${product.title} - ${product.price}'),
              subtitle: Text(product.id),
              onTap: () =>
                  Navigator.pushNamed(context, 'product', arguments: product),
            )
          ],
        ),
      ),
    );
  }
}
