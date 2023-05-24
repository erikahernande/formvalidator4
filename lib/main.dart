import 'package:flutter/material.dart';
import 'package:formvalidation41/src/preferencias_usuario/preferencias_usuario.dart';

import 'package:formvalidation41/src/bloc/provider.dart';

import 'package:formvalidation41/src/pages/home_page.dart';
import 'package:formvalidation41/src/pages/login_page.dart';
import 'package:formvalidation41/src/pages/producto_page.dart';
import 'package:formvalidation41/src/pages/registro_page.dart';
 
void main() async{
 WidgetsFlutterBinding.ensureInitialized();
  final prefs =  PreferenciasUsuario();
  await prefs.initPrefs();

 runApp(MyApp());
 }
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    
  final prefs =  PreferenciasUsuario();
  print(prefs.token);

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login' : ( BuildContext context ) => LoginPage(),
          'registro' : ( BuildContext context ) => RegistroPage(),
          'home'  : ( BuildContext context ) => HomePage(),
          'producto' : ( BuildContext context ) => ProductoPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      ),
    );
      
  }
}