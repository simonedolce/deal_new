class ElencoDealModel {
  final int idDeal;
  final double importoTotaleRientrato;
  final double disponibilitaTotaleMercato;
  final double disponibilitaTotalePersonale;
  final double disponibilitaTotalePersonaleIniziale;
  final double importoTotaleRientratoPrevisto;

  ElencoDealModel(
    this.idDeal,
    this.importoTotaleRientrato ,
    this.disponibilitaTotaleMercato,
    this.disponibilitaTotalePersonale,
    this.disponibilitaTotalePersonaleIniziale,
    this.importoTotaleRientratoPrevisto
  );

  factory ElencoDealModel.fromJson(Map<String, dynamic> json) {

    return ElencoDealModel(
      json['idDeal'],
      json['importoTotaleRientrato'],
      json['disponibilitaTotaleMercato'],
      json['disponibilitaTotalePersonale'],
      json['disponibilitaTotalePersonaleIniziale'],
      json['importoTotaleRientratoPrevisto']
    );
  }

  Map<String, dynamic> toJson() => {
    'idDeal': idDeal,
    'importoTotaleRientrato': importoTotaleRientrato,
    'disponibilitaTotaleMercato':disponibilitaTotaleMercato,
    'disponibilitaTotalePersonale':disponibilitaTotalePersonale,
    'disponibilitaTotalePersonaleIniziale' : disponibilitaTotalePersonaleIniziale,
    'importoTotaleRientratoPrevisto' : importoTotaleRientratoPrevisto
  };

}