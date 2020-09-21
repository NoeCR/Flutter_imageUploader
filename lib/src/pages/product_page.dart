import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // Reemplazamos el servicio por el provider que contiene el BLoC de los productos
  // final productService = new ProductService();
  ProductModel product = new ProductModel();
  ProductBloc productBloc;
  // Bandera para bloquear el envío múltiple de peticiones
  bool _loading = false;
  // Almacenara la imágen
  PickedFile photo;

  @override
  Widget build(BuildContext context) {
    // Inicializamos el BLoC para manejar el CRUD de los products
    productBloc = Provider.productsBloc(context);
    // Obtenemos los argumentos de la llamada a este componente que tienen que
    // ser una instancia de ProductModel
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    // Si no es null, reinicializamos la instancia de ProductModel, con los datos recibidos
    if (prodData != null) product = prodData;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectPhoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takeAPicture,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  _showPicture(),
                  _createName(),
                  _createPrice(),
                  _createAvaible(),
                  _createButton(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Product'),
      onSaved: (newValue) => product.title = newValue,
      validator: (value) {
        if (value.length < 3)
          return 'product name is too short';
        else
          return null;
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.price.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Price'),
      onSaved: (newValue) => product.price = double.parse(newValue),
      validator: (value) {
        if (utils.isNumber(value))
          return null;
        else
          return 'only numbers';
      },
    );
  }

  Widget _createButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: (_loading) ? null : _submit,
      icon: Icon(Icons.save),
      label: Text('Save'),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    setState(() {
      _loading = true;
    });
    // Subir imagen si existe y almacenar la url
    if (photo != null) {
      // product.photoUrl = await productService.uploadImage(File(photo.path));
      product.photoUrl = await productBloc.uploadImage(File(photo.path));
    }

    // Solo despues de validar el formulario, podemos salvar los cambios actuales
    // En los campos del formulario
    formKey.currentState.save();
    //  Old
    // if (product.id == null)
    //   productService.createProduct(product);
    // else
    //   productService.updateProduct(product);

    if (product.id == null)
      productBloc.addProduct(product);
    else
      productBloc.updateProduct(product);

    setState(() {
      _loading = false;
    });
    showSnackBar('Product successfully registered');

    Navigator.pop(context);
  }

  Widget _createAvaible() {
    return SwitchListTile(
      value: product.avaible,
      activeColor: Colors.deepPurple,
      title: Text('Avaible', style: TextStyle()),
      onChanged: (value) => setState(() => product.avaible = value),
    );
  }

  void showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _showPicture() {
    if (product.photoUrl != null) {
      return FadeInImage(
        image: NetworkImage(product.photoUrl),
        placeholder: AssetImage('assets/img/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (photo != null) {
        return Image.file(
          File(photo.path),
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/img/no-image.png');
    }
  }

  _selectPhoto() {
    _processImage(ImageSource.gallery);
  }

  _takeAPicture() {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource type) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: type,
    );

    // Para manejar el error al cancelar la seleccion de una foto
    try {
      photo = PickedFile(pickedFile.path);
    } catch (e) {
      print('$e');
    }

    // Si el usuario cancelo o no selecciona una foto
    if (photo != null) {
      // limpieza
      product.photoUrl = null;
    }

    setState(() {});
  }
}
