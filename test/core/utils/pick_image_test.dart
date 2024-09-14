import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/utils/pick_image.dart';

class MockImagePicker extends Mock implements ImagePicker {}

class MockXFile extends Mock implements XFile {}

void main() {
  late MockImagePicker mockImagePicker;
  late MockXFile mockXFile;

  setUp(() {
    mockImagePicker = MockImagePicker();
    mockXFile = MockXFile();
  });

  group('pickImage', () {
    const fileName = 'fileName';
    const filePath = 'filePath';
    test(
      '''should return a PickedImage when user picks an image successfully
      with the correct file path and file name
      ''',
      () async {
        //arrange
        when(() => mockImagePicker.pickImage(source: ImageSource.gallery))
            .thenAnswer((_) async => mockXFile);

        when(() => mockXFile.name).thenReturn(fileName);
        when(() => mockXFile.path).thenReturn(filePath);

        //act
        final result = await pickImage(imagePicker: mockImagePicker);

        //assert
        verify(() => mockImagePicker.pickImage(source: ImageSource.gallery));
        expect(result, isNotNull);
        expect(result, isA<PickedImage>());
        expect(result?.name, fileName);
        expect(result?.file.path, filePath);
      },
    );

    test(
      'should return null when no image is picked',
      () async {
        //arrange
        when(() => mockImagePicker.pickImage(source: ImageSource.gallery))
            .thenAnswer((_) async => null);

        //act
        final result = await pickImage(imagePicker: mockImagePicker);

        //assert
        verify(() => mockImagePicker.pickImage(source: ImageSource.gallery));
        verifyNever(() => mockXFile.path);
        verifyNever(() => mockXFile.name);
        expect(result, isNull);
      },
    );

    test(
      'should return null when an exception occurs from imagePicker',
      () async {
        //arrange
        when(() => mockImagePicker.pickImage(source: ImageSource.gallery))
            .thenThrow((_) async => Exception());

        //act
        final result = await pickImage(imagePicker: mockImagePicker);

        //assert
        verify(() => mockImagePicker.pickImage(source: ImageSource.gallery));
        verifyNever(() => mockXFile.path);
        verifyNever(() => mockXFile.name);
        expect(result, isNull);
      },
    );
    test(
      'should return null when an exception occurs from accessing File',
      () async {
        //arrange
        when(() => mockImagePicker.pickImage(source: ImageSource.gallery))
            .thenAnswer((_) async => mockXFile);

        when(() => mockXFile.path).thenReturn(filePath);
        when(() => mockXFile.name).thenThrow(Exception());

        //act
        final result = await pickImage(imagePicker: mockImagePicker);

        //assert
        verify(() => mockImagePicker.pickImage(source: ImageSource.gallery));
        verify(() => mockXFile.path);
        verifyNever(() => mockXFile.path);
        expect(result?.file.path, isNull);
        expect(result?.name, isNull);
        expect(result, isNull);
      },
    );
  });
}
