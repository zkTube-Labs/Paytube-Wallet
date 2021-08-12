import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_coinid/utils/permission.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
// import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';

import '../public.dart';

class PDFScreen extends StatefulWidget {
  PDFScreen({Key? key, this.pathPDF}) : super(key: key);
  final String? pathPDF;

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final pdfController = PdfController(
    document: PdfDocument.openAsset('assets/data/agreementinfo.pdf'),
  );

  Widget pdfView() =>
      PdfView(controller: pdfController, scrollDirection: Axis.vertical);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenScrollView: true,
      child: Container(
        alignment: Alignment.center,
        child: pdfView(),
      ),
    );
  }
}
