import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:omc/common_widget/animated_dialog.dart';
import 'package:omc/util/colors.dart';

import '../model/customer.dart';
import '../model/deal.dart';
import '../model/ordine.dart';
import '../model/prodotto_deal.dart';
import '../model/prodotto_ordine.dart';
import '../model/sanamento_debito.dart';
class CommonFunction {

  Widget returnText(String text , double size){
    return
      Text(
        text,
        style: TextStyle(fontSize: size),
      );

  }

  ThemeData darkTheme(){
    return ThemeData.dark().copyWith(
      textTheme: ThemeData.dark().textTheme.copyWith(
        bodyText2: const TextStyle(
          fontFamily: 'appFont', // Utilizza lo stesso font per la modalità scura
          color: AppColors.headline, // Personalizza il colore del testo nella modalità scura
        ),
      ),
    );
  }

  void showToast(String text){
    Fluttertoast.showToast(msg: text,textColor: AppColors.background, backgroundColor: AppColors.highlight);
  }

  PreferredSizeWidget customAppBar(String titolo){
    return AppBar(
      title: Text(titolo, style: const TextStyle(color: AppColors.background, fontFamily: 'medium'),),
      backgroundColor: AppColors.highlight,
      leading: Image.asset('images/logo.png', width: 100, height: 100),

    );
  }

  double calcolaTotaleDovuto(List<ProdottoOrdine> prodottiOrdine){
    double totale = 0;
    prodottiOrdine.forEach((pOrdine) {
      totale += pOrdine.prodottoDeal.prezzoDettaglio * pOrdine.quantitativoPrevisto;
    });
    return totale;
  }

  double calcolaTotaleSpeso(List<Deal> deals){
    double importo = 0;
    deals.forEach((deal) {
      deal.prodottiDeals.forEach((pDeal) {
        importo += pDeal.quantitativoProdottoDealIniziale * pDeal.prezzoIngrosso;
      });
    });
    return importo;
  }

  double calcolaTotaleRientrato(List<Deal> deals){
    double importo = 0;

    deals.forEach((deal) {
      deal.prodottiDeals.forEach((pDeal) {
        importo += pDeal.importoRientrato;
      });
    });

    return importo;
  }

  String fromTimeStampToDateHour(int timeStamp){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  double getTotaleDebito(Customer customer){
    List<Ordine>? ordini = customer.ordini;
    double totaleDebito = 0;

    for(Ordine ordine in ordini!){
      totaleDebito += ordine.debito!.importoDebito;
      List<SanamentoDebito>? sanamenti = ordine.debito?.sanamenti;
      for(SanamentoDebito sanamentoDebito in sanamenti!){
        totaleDebito -= sanamentoDebito.importoSanamento;
      }
    }
    return totaleDebito;
  }

  void showAnimatedDialog(BuildContext mainContext , String title , List<Widget> widgets){
    showDialog(
        context: mainContext,
        builder: (BuildContext context){
          return AnimatedDialog(
              title: title,
              widgets: widgets
          );
        }
    );
  }



}