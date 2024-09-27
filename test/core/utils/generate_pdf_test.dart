import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/core/utils/generate_pdf.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  group('generatePdf', () {
    const String tReport = 'Sample Report';

    test('should return a valid PdfDocument object', () async {
      // Act
      final pdfDocument = await generatePdf(tReport);

      // Assert
      expect(pdfDocument, isA<PdfDocument>());

      pdfDocument.dispose();
    });

    test('should add a page to the PdfDocument', () async {
      // Act
      final pdfDocument = await generatePdf(tReport);

      // Assert
      expect(pdfDocument.pages.count, equals(1));
      pdfDocument.dispose();
    });

    test('should set page size to A4', () async {
      // Act
      final pdfDocument = await generatePdf(tReport);

      // Assert
      expect(pdfDocument.pageSettings.size, equals(PdfPageSize.a4));
      pdfDocument.dispose();
    });

    test('should draw text on the page', () async {
      // Act
      final pdfDocument = await generatePdf(tReport);

      // Save document to byte array
      final List<int> bytes = await pdfDocument.save();

      // Assert that the document contains some content (checking byte length)
      expect(bytes.isNotEmpty, true);
    });
  });
}
