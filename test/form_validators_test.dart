import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/forms/form_validators.dart';

void main() {
  group('FormValidators', () {
    test('requiredTrimmed', () {
      expect(
        FormValidators.requiredTrimmed('', FormValidators.titleRequired),
        FormValidators.titleRequired,
      );
      expect(
        FormValidators.requiredTrimmed('  Hi  ', FormValidators.titleRequired),
        isNull,
      );
    });

    test('maxLength', () {
      expect(
        FormValidators.maxLength('abcd', 3, fieldLabel: 'Title'),
        'Title must be 3 characters or fewer.',
      );
      expect(FormValidators.maxLength('ab', 3), isNull);
    });

    test('optionalPositiveInt', () {
      expect(FormValidators.optionalPositiveInt(''), isNull);
      expect(FormValidators.optionalPositiveInt('5'), isNull);
      expect(
        FormValidators.optionalPositiveInt('0'),
        FormValidators.capacityInvalid,
      );
    });

    test('combine stops at first error', () {
      final validator = FormValidators.combine([
        (value) => FormValidators.requiredTrimmed(
              value,
              FormValidators.titleRequired,
            ),
        (value) => FormValidators.maxLength(value, 2, fieldLabel: 'Title'),
      ]);

      expect(validator(''), FormValidators.titleRequired);
      expect(validator('hello'), 'Title must be 2 characters or fewer.');
      expect(validator('ok'), isNull);
    });
  });
}
