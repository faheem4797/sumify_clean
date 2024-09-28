import 'dart:io' as io;
import 'package:file/file.dart';

import 'package:file/memory.dart' as memory;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/local_file_saving_exception.dart';
import 'package:sumify_clean/core/utils/save_document_service.dart';
import 'package:sumify_clean/features/article/data/datasources/article_local_datasource.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class MockPdfDocument extends Mock implements PdfDocument {}

class MockSaveDocumentService extends Mock implements SaveDocumentService {}

class MockFile extends Mock implements File {}

class MockMemoryFileSystem extends Mock implements memory.MemoryFileSystem {}

void main() {
  late ArticleLocalDatasourceImpl articleLocalDatasourceImpl;
  late MockPdfDocument mockPdfDocument;
  late MockSaveDocumentService mockSaveDocumentService;
  late MockMemoryFileSystem mockMemoryFileSystem;
  late MockFile mockFile;

  setUp(() {
    mockPdfDocument = MockPdfDocument();
    mockSaveDocumentService = MockSaveDocumentService();
    mockMemoryFileSystem = MockMemoryFileSystem();
    mockFile = MockFile();

    articleLocalDatasourceImpl = ArticleLocalDatasourceImpl(
        saveDocumentService: mockSaveDocumentService);
  });

  group('saveDocument', () {
    const String tFileName = 'test.pdf';
    final List<int> tPdfBytes = [1, 2, 3, 4];
    const String tDirPath = '/test/documents';

    const String tExceptionMessage = 'Error saving PDF';

    test('should save PDF document successfully on Android', () async {
      // Arrange
      when(() => mockPdfDocument.save()).thenAnswer((_) async => tPdfBytes);
      when(() => mockSaveDocumentService.isAndroid).thenReturn(true);
      when(() => mockSaveDocumentService.getExternalDocumentsDirectory)
          .thenAnswer((_) async => tDirPath);
      when(() => mockSaveDocumentService.getFileSystem)
          .thenReturn(mockMemoryFileSystem);
      when(() => mockMemoryFileSystem.file(any())).thenReturn(mockFile);
      when(() => mockFile.create(
              recursive: any(named: 'recursive'),
              exclusive: any(named: 'exclusive')))
          .thenAnswer((_) async => mockFile);
      when(() => mockFile.writeAsBytes(any()))
          .thenAnswer((_) async => mockFile);

      // Act
      final result = await articleLocalDatasourceImpl.saveDocument(
          name: tFileName, pdf: mockPdfDocument);

      // Assert
      expect(result, Constants.saveDocumentSuccessMessage);
      verify(() => mockPdfDocument.save()).called(1);
      verify(() => mockSaveDocumentService.isAndroid).called(1);
      verify(() => mockSaveDocumentService.getExternalDocumentsDirectory)
          .called(1);
      verifyNever(() => mockSaveDocumentService.getAppsDocumentsDirectory);

      verify(() => mockSaveDocumentService.getFileSystem).called(1);
      verify(() => mockMemoryFileSystem.file('$tDirPath/$tFileName')).called(1);

      verify(() => mockFile.create(recursive: true)).called(1);
      verify(() => mockFile.writeAsBytes(tPdfBytes)).called(1);
    });

    test('should save PDF document successfully on iOS', () async {
      // Arrange
      final directory = io.Directory.systemTemp;

      when(() => mockPdfDocument.save()).thenAnswer((_) async => tPdfBytes);
      when(() => mockSaveDocumentService.isAndroid).thenReturn(false);
      when(() => mockSaveDocumentService.getAppsDocumentsDirectory)
          .thenAnswer((_) async => directory);
      when(() => mockSaveDocumentService.getFileSystem)
          .thenReturn(mockMemoryFileSystem);
      when(() => mockMemoryFileSystem.file(any())).thenReturn(mockFile);

      when(() => mockFile.writeAsBytes(any()))
          .thenAnswer((_) async => mockFile);

      // Act
      final result = await articleLocalDatasourceImpl.saveDocument(
          name: tFileName, pdf: mockPdfDocument);

      // Assert
      expect(result, Constants.saveDocumentSuccessMessage);

      verify(() => mockPdfDocument.save()).called(1);
      verify(() => mockSaveDocumentService.isAndroid).called(1);
      verifyNever(() => mockSaveDocumentService.getExternalDocumentsDirectory);
      verify(() => mockSaveDocumentService.getAppsDocumentsDirectory).called(1);

      verify(() => mockSaveDocumentService.getFileSystem).called(1);
      verify(() => mockMemoryFileSystem.file('${directory.path}/$tFileName'))
          .called(1);
      verifyNever(() => mockFile.create());
      verify(() => mockFile.writeAsBytes(tPdfBytes)).called(1);
    });

    test(
        'should throw a LocalFileSavingException with a message when a LocalFileSavingException occurs',
        () async {
      // Arrange
      when(() => mockPdfDocument.save()).thenAnswer((_) async => tPdfBytes);
      when(() => mockSaveDocumentService.isAndroid).thenReturn(false);
      when(() => mockSaveDocumentService.getAppsDocumentsDirectory)
          .thenThrow(const LocalFileSavingException(tExceptionMessage));

      // Act
      final call = articleLocalDatasourceImpl.saveDocument;

      // Assert
      expect(
          () async => await call(name: tFileName, pdf: mockPdfDocument),
          throwsA(isA<LocalFileSavingException>().having(
              (localFileSavingException) => localFileSavingException.message,
              'message',
              tExceptionMessage)));
    });

    test(
        'should throw a LocalFileSavingException with a message when a MissingPlatformDirectoryException occurs',
        () async {
      // Arrange
      when(() => mockPdfDocument.save()).thenAnswer((_) async => tPdfBytes);
      when(() => mockSaveDocumentService.isAndroid).thenReturn(false);
      when(() => mockSaveDocumentService.getAppsDocumentsDirectory)
          .thenThrow(MissingPlatformDirectoryException(tExceptionMessage));

      // Act
      final call = articleLocalDatasourceImpl.saveDocument;

      // Assert
      expect(
          () async => await call(name: tFileName, pdf: mockPdfDocument),
          throwsA(isA<LocalFileSavingException>().having(
              (localFileSavingException) => localFileSavingException.message,
              'message',
              tExceptionMessage)));
    });
    test(
        'should throw a LocalFileSavingException with a message when a FileSystemException occurs',
        () async {
      // Arrange
      when(() => mockPdfDocument.save())
          .thenThrow(const FileSystemException(tExceptionMessage));

      // Act
      final call = articleLocalDatasourceImpl.saveDocument;

      // Assert
      expect(
          () async => await call(name: tFileName, pdf: mockPdfDocument),
          throwsA(isA<LocalFileSavingException>().having(
              (localFileSavingException) => localFileSavingException.message,
              'message',
              tExceptionMessage)));
    });
    test(
        'should throw a LocalFileSavingException when a generic exception occurs',
        () async {
      // Arrange
      when(() => mockPdfDocument.save())
          .thenThrow(Exception(tExceptionMessage));

      // Act
      final call = articleLocalDatasourceImpl.saveDocument;

      // Assert
      expect(
          () async => await call(name: tFileName, pdf: mockPdfDocument),
          throwsA(isA<LocalFileSavingException>().having(
              (localFileSavingException) => localFileSavingException.message,
              'message',
              const LocalFileSavingException().message)));
    });
  });
}
