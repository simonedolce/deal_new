import 'package:deal/app/appstarter.dart';
import 'package:deal/model/product-type.dart';
import 'package:deal/objectbox/objectbox-helper.dart';
import 'package:deal/services/product-type-service.dart';
import 'package:deal/services/user-service.dart';
import 'package:flutter/material.dart';



late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();

  // Controlli da effetturare all'avvio dell'applicazione
  bool isInitiated = await UserService().isInitiated();

  if(!isInitiated){
    ProductType maryType = ProductType(descrizione: 'Marijuana');
    ProductType hashType = ProductType(descrizione: 'Hashish');

    ProductTypeService().put(maryType);
    ProductTypeService().put(hashType);
  }


  runApp(AppStarter(isInitiated: isInitiated));
}






