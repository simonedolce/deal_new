import 'package:omc/model/prodotto_deal.dart';
import 'package:intl/intl.dart';
class Deal {


  final int id;

  final double importoTotaleRientratoPrevisto;

  final double importoTotaleRientrato;

  final double disponibilitaTotaleMercato;

  final double disponibilitaTotalePersonale;

  final double disponibilitaTotalePersonaleIniziale;

  final double disponibilitaTotaleMercatoIniziale;

  final int dataDeal;

  final int giorniPassati;

  final List<ProdottoDeal> prodottiDeals;

  double importoTotaleReale;

  Deal(
      this.id,
      this.importoTotaleRientratoPrevisto,
      this.importoTotaleRientrato,
      this.disponibilitaTotaleMercato,
      this.disponibilitaTotalePersonale,
      this.disponibilitaTotalePersonaleIniziale,
      this.disponibilitaTotaleMercatoIniziale,
      this.dataDeal,
      this.giorniPassati,
      this.prodottiDeals,
      this.importoTotaleReale
      );

  factory Deal.fromJson(Map<String, dynamic> json) {

    var prodottiDealData = json['prodottiDeals'] as List<dynamic>;
    var prodottiDealList = prodottiDealData
        .map((prodottoDealJson) => ProdottoDeal.fromJson(prodottoDealJson)).toList();

    return Deal(
      json['id'],
      json['importoTotaleRientratoPrevisto'],
      json['importoTotaleRientrato'],
      json['disponibilitaTotaleMercato'],
      json['disponibilitaTotalePersonale'],
      json['disponibilitaTotalePersonaleIniziale'],
      json['disponibilitaTotaleMercatoIniziale'],
      json['dataDeal'],
      json['giorniPassati'],
      prodottiDealList,
      json['importoTotaleReale']
    );
  }

  Map<String, dynamic> toJson() => {
    'id':id,
    'importoTotaleRientratoPrevisto':importoTotaleRientratoPrevisto,
    'importoTotaleRientrato':importoTotaleRientrato,
    'disponibilitaTotaleMercato':disponibilitaTotaleMercato,
    'disponibilitaTotalePersonale':disponibilitaTotalePersonale,
    'disponibilitaTotalePersonale':disponibilitaTotalePersonale,
    'disponibilitaTotalePersonaleIniziale':disponibilitaTotalePersonaleIniziale,
    'disponibilitaTotaleMercatoIniziale':disponibilitaTotaleMercatoIniziale,
    'dataDeal':dataDeal,
    'giorniPassati':giorniPassati,
    'prodottiDeals': prodottiDeals.map((prodottoDeal) => prodottoDeal.toJson()).toList(),
    'importoTotaleReale' : importoTotaleReale
  };

  String formatDate(){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dataDeal);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }


}