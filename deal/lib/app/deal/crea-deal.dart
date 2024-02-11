import 'package:deal/main.dart';
import 'package:deal/services/product-service.dart';
import 'package:deal/util/deal-button-styles.dart';
import 'package:deal/util/deal-styles.dart';
import 'package:deal/util/routes.dart';
import 'package:deal/util/text-styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/deal-product.dart';
import '../../model/deal.dart';
import '../../model/product.dart';
import '../../services/deal-service.dart';
import '../../util/colors.dart';

class CreaDeal extends StatefulWidget {
  const CreaDeal({super.key});

  @override
  State<CreaDeal> createState() => _CreaDealState();
}

class _CreaDealState extends State<CreaDeal> {

  late final Stream<List<Product>> _streamProduct;
  late List<bool> isSelected = [];
  late Deal nuovoDeal;
  DealService dealService = DealService();
  ProductService productService = ProductService();

  int count = 0;

  @override
  void initState() {
    super.initState();
    _streamProduct = productService.getAllStream();
    DateTime dataCorrente = DateTime.now();
    nuovoDeal = Deal(dataDeal: dataCorrente);
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(elevation: 8,backgroundColor: CommonColors.background,title: const Text("Crea Deal", style: TextStyle(fontFamily: 'mosteraRegular'))),
      body: Padding(
        padding: const EdgeInsets.only(
            right: 20,
            left: 20,
            top: 10,
        ),
        child: SafeArea(
            child: StreamBuilder<List<Product>>(
              stream: _streamProduct,
              builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                if(!snapshot.hasData){
                  return  Center(
                      child: Wrap(
                        runSpacing: 10,
                        children: [
                          Text("Non ci sono prodotti disponibili", style: DealTextStyles(
                            fontSize: 20,
                            fontName: 'regular'
                          ).textStyleDark
                          ),
                          ElevatedButton(
                              onPressed: (){
                                Navigator.popAndPushNamed(context, RoutesDef.creaProdotto);
                              },
                              style: DealButtonStyles.elevatedButton,
                              child: Text("Crea Prodotto")
                          )
                        ],
                      )
                  );
                } else {

                  final products = snapshot.data!;

                  return ListView.separated(
                    itemCount: products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      Product prodotto = products[index];
                      isSelected.add(false);

                      DealProduct dealProduct = DealProduct();
                      dealProduct.product.target = prodotto;

                      return Card(
                        color: isSelected[index] ? CommonColors.secondary : CommonColors.primary,
                        shape: DealStyles.roundRectangleRadiusBorder,
                        child: ListTile(
                            title: Text(prodotto.nomeProdotto),
                            subtitle: Text(prodotto.productType.target!.descrizione),
                            onTap: (){
                              updateSelectedList(index,dealProduct);
                              setState(() {});
                            },
                        )
                      );

                    }, separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  );
                }
              },
            ),
        )
      ),

      persistentFooterButtons: [
        Text('Selez. ${nuovoDeal.prodottiDeals.length.toString()}', style: const TextStyle(fontFamily: 'regular', fontSize: 20),),
        ElevatedButton(
            onPressed: (){
              Navigator.popAndPushNamed(context, RoutesDef.creaProdotto);
            },
            style: DealButtonStyles.elevatedButton,
            child: Text("Crea Prodotto")
        ),
        ElevatedButton(
            onPressed: (){
              nuovoDeal.prodottiDeals.isNotEmpty ?
              Navigator.popAndPushNamed(
                  context,
                  RoutesDef.creaProdottoDeal,
                  arguments: {'deal': nuovoDeal}
              ) : null;
            },
            style: DealButtonStyles.elevatedButton,
            child: const Text("Continua")
        ),
      ]
    );

  }

  updateSelectedList(int index, DealProduct dealProduct){
    if(isSelected[index] == true){
      isSelected[index] = false;
      nuovoDeal.prodottiDeals.remove(
          nuovoDeal.prodottiDeals.firstWhere((element) => element.product.target?.id == dealProduct.product.target?.id)
      );
    } else {
      isSelected[index] = true;
      nuovoDeal.prodottiDeals.add(dealProduct);
    }
  }

}
