import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/bloc/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Cargamos el Bloc que queremos manejar en este componente
    final productBloc = Provider.productsBloc(context);
    productBloc.loadProducts();
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: _createList(context, productBloc),
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

  Widget _createList(BuildContext context, ProductBloc productsBloc) {
    return StreamBuilder(
      stream: productsBloc.productStream,
      builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) =>
          (snapshot.hasData)
              ? _buildList(context, snapshot.data, productsBloc)
              : Center(child: CircularProgressIndicator()),
    );

    // Old version with Futures
    // return FutureBuilder(
    //   future: productService.loadProducts(),
    //   builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) =>
    //       (snapshot.hasData)
    //           ? _buildList(context, snapshot.data)
    //           : Center(child: CircularProgressIndicator()),
    // );
  }

  Widget _buildList(BuildContext context, List<ProductModel> products,
      ProductBloc productsBloc) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) =>
          _createItem(context, products[index], productsBloc),
    );
  }

  Widget _createItem(
      BuildContext context, ProductModel product, ProductBloc productsBloc) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red[100],
      ),
      onDismissed: (direction) => productsBloc.deleteProduct(product.id),
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
