import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/core/utils/split_string_by_digit.dart';

void main() {
  group('splitStringByDigit', () {
    test('should split string by digits and trim spaces', () {
      // Arrange
      const input = '1. First item 2. Second item  3. Third item';

      // Act
      final result = splitStringByDigit(input);

      // Assert
      expect(result, ['First item', 'Second item', 'Third item']);
    });

    test('should return an empty list when input has no digits', () {
      // Arrange
      const input = 'No digits here';

      // Act
      final result = splitStringByDigit(input);

      // Assert
      expect(result, ['No digits here']);
    });

    test('should handle multiple spaces and empty strings', () {
      // Arrange
      const input = '1.   First item   2.  Second item   3.  ';

      // Act
      final result = splitStringByDigit(input);

      // Assert
      expect(result, ['First item', 'Second item']);
    });

    test('should return an empty list when input is empty', () {
      // Arrange
      const input = '';

      // Act
      final result = splitStringByDigit(input);

      // Assert
      expect(result, isEmpty);
    });

    test('should handle string with only digits', () {
      // Arrange
      const input = '123.456.789.';

      // Act
      final result = splitStringByDigit(input);

      // Assert
      expect(result, isEmpty);
    });
  });
}
