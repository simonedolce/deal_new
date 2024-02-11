import 'package:deal/main.dart';
import 'package:deal/model/product-type.dart';
import 'package:deal/model/product.dart';
import 'package:deal/services/product-service.dart';
import 'package:deal/services/product-type-service.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-button-styles.dart';
import 'package:deal/util/deal-input-decorator.dart';
import 'package:deal/util/routes.dart';
import 'package:flutter/material.dart';

class CreaProdotto extends StatefulWidget {
  const CreaProdotto({super.key});

  @override
  State<CreaProdotto> createState() => _CreaProdottoState();
}

class _CreaProdottoState extends State<CreaProdotto> {
  late final Stream<List<ProductType>> _streamProductType;
  late List<ProductType> _productTypes = [];
  late ProductType typeSelected ;
  late TextEditingController _controllerNome;

  ProductTypeService productTypeService = ProductTypeService();
  ProductService productService = ProductService();

  @override
  void initState() {
    super.initState();
    _streamProductType = productTypeService.getAllStream();
    _controllerNome = TextEditingController();

    _streamProductType.first.then((types) {
      setState(() {
        _productTypes = types;
      });

      typeSelected = _productTypes.first;

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: CommonColors.background, title: const Text("Crea Prodotto", style: TextStyle(fontFamily: 'mosteraRegular'))),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Wrap(
          spacing: 10,
          runSpacing: 20,
          children: [
            TextFormField(decoration: DealInputDecorator(label: 'Nome Prodotto').dealInputDecorator,controller: _controllerNome),

            Wrap(
              spacing: 5.0,
              children: _productTypes.map((type) {
                bool isSelected = typeSelected.id == type.id;
                return ChoiceChip(
                  label: Text(
                    type.descrizione,
                    style: TextStyle(
                        fontFamily: 'medium',
                        color: isSelected ? CommonColors.paragraph : Colors.black

                    ) ,
                  ),
                  selected: isSelected,
                  selectedColor: CommonColors.primary,
                  onSelected: (bool selected) {
                    setState(() {
                      typeSelected = selected ? type : typeSelected;
                    });
                  },
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: (){
                if(_controllerNome.text.isNotEmpty){
                  Product nuovoProdotto = Product(nomeProdotto:_controllerNome.text);
                  nuovoProdotto.productType.target = typeSelected;
                  productService.put(nuovoProdotto);
                  Navigator.popAndPushNamed(context, RoutesDef.creaDeal);
                }

            }, style: DealButtonStyles.elevatedButton, child: const Text("Conferma"))

          ],
        ),
      ),
    );
  }
}
