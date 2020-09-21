import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/product_bloc.dart';
export 'package:formvalidation/src/bloc/product_bloc.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
export 'package:formvalidation/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  static Provider _instancia;
  final loginBloc = LoginBloc();
  // Los blocs cargador en el provider deberían ser privados
  // Para crear una nueva instancia el new es opcional ----------------------
  final _productBloc = ProductBloc();

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  // Provider({ Key key, Widget child })
  //   : super(key: key, child: child );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductBloc productsBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productBloc;
  }
}
