import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<PdfDocument> generatePdf(String report) async {
  final PdfDocument document = PdfDocument();
  PdfPage page = document.pages.add();
  document.pageSettings.size = PdfPageSize.a4;
  PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 18);
  PdfTextElement(text: report, font: font).draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 0, page.getClientSize().width, page.getClientSize().height));
  return document;
}
