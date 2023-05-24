import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation41/src/bloc/provider.dart';
import 'package:formvalidation41/src/models/producto_model.dart';
//import 'package:formvalidation41/src/providers/productos_provider.dart';

import 'package:formvalidation41/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //final productoProvider = new ProductosProvider();

  ProductosBloc productosBloc;
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  XFile foto;

  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productosBloc(context);
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
              onPressed: () {
                _seleccionarFoto();
              },
              icon: Icon(Icons.photo_size_select_actual)),
          IconButton(
              onPressed: () {
                _tomarFoto();
              },
              icon: Icon(Icons.camera_alt))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20.0)
      // ),
      // color: Colors.deepPurple,
      // textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    File file = File(foto.path);
    if (file != null) {
      producto.fotoUrl = await productosBloc.subirFoto(file);
    }

    if (producto.id == null) {
      productosBloc.agregarProducto(producto);
    } else {
      productosBloc.editarProducto(producto);
    }

    //setState(() {_guardando = true; });

    // if ( producto.id == null ) {
    //   productosBloc.agregarProducto(producto);
    // } else {
    //  productosBloc.editarProducto(producto);
    //}

    //setState(() {_guardando = false; });
    mostrarSnackbar();

    Navigator.pop(context);

    //mostrarSnackbar();
  }

  void mostrarSnackbar() {
    //scaffoldKey.currentState.showBottomSheet((context) => snackbar);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter somethong here to display on snackbar")));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Registro guardado"),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        File file = File(foto.path);
        return Image.file(
          file,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final ImagePicker _picker = ImagePicker();
    foto = await _picker.pickImage(source: origen);

    if (foto != null) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }
}
