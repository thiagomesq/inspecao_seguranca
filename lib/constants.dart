import 'package:flutter/material.dart';

const Map<int, Color> color = {
  50: Color.fromRGBO(146, 209, 79, .1),
  100: Color.fromRGBO(146, 209, 79, .2),
  200: Color.fromRGBO(146, 209, 79, .3),
  300: Color.fromRGBO(146, 209, 79, .4),
  400: Color.fromRGBO(146, 209, 79, .5),
  500: Color.fromRGBO(146, 209, 79, .6),
  600: Color.fromRGBO(146, 209, 79, .7),
  700: Color.fromRGBO(146, 209, 79, .8),
  800: Color.fromRGBO(146, 209, 79, .9),
  900: Color.fromRGBO(146, 209, 79, 1),
};
const emflorMaterialGreen = MaterialColor(0xff026f2b, color);
const emflorSilver = Color(0xffc0c0c0);
const emflorGreen = Color(0xff75b631);
const eiConsultoriaRed = Color(0xff8b0000);
const pdfRed = Color(0xffff120f);
const excelGreen = Color(0xff217346);
const ncLeve = Colors.black;
const ncMedia = Colors.black;
const ncGrave = Colors.red;

const titleTag = 'com.tmsistemas.title';
const logoTag = 'com.tmsistemas.logo';

const headerNaoConformidadeTable = <DataColumn>[
  DataColumn(
    label: Text(
      'Elementos de verificação',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Descrição',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Grau da NC',
      style: tableHeaderTextStyle,
    ),
  ),
];

const tableHeaderTextStyle = TextStyle(
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold,
  color: emflorGreen,
);

const paginationSelectableRowCount = <int>[
  5,
  10,
  25,
  50,
];

const iconBtnPdf = Icon(
  Icons.picture_as_pdf_rounded,
  color: Colors.white,
);

const textBtnExcel = Text(
  'X',
  textAlign: TextAlign.center,
  style: TextStyle(
    color: Colors.white54,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 20,
  ),
);

const headerVeiculoTable = <DataColumn>[
  DataColumn(
    label: Text(
      'Empresa',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Placa',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Ano',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Tipo',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Identificação',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Finalidade',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'LT/ART',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Ações',
      style: tableHeaderTextStyle,
    ),
  ),
];

const headerMotoristaOperadorTable = <DataColumn>[
  DataColumn(
    label: Text(
      'Nome',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Função',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'CNH',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Categoria',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Validade',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Ações',
      style: tableHeaderTextStyle,
    ),
  ),
];

const headerFuncaoTable = <DataColumn>[
  DataColumn(
    label: Text(
      'Nome',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Ações',
      style: tableHeaderTextStyle,
    ),
  ),
];
