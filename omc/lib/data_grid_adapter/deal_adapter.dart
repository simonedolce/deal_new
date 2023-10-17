import 'package:omc/model/deal.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DealAdapter extends DataGridSource {
  /// Creates the employee data source class with required details.
  DealAdapter({required List<Deal> dealData}) {
    _dealData = dealData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'dataDeal', value: e.dataDeal),
      DataGridCell<String>(columnName: 'disponibilitaMercato', value: e.disponibilitaTotaleMercato.toString()),
      DataGridCell<String>(
          columnName: 'giorniPassati', value: e.giorniPassati.toString()),
      DataGridCell<int>(columnName: 'prodotti', value: e.prodottiDeals.length),
    ])).toList();
  }

  List<DataGridRow> _dealData = [];

  @override
  List<DataGridRow> get rows => _dealData;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
              alignment: (dataGridCell.columnName == 'dataDeal' ||
                  dataGridCell.columnName == 'dataDeal')
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ));
        }).toList());
  }
}