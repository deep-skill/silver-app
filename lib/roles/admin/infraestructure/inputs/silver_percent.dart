import 'package:formz/formz.dart';

// Define input validation errors
enum SilverPercentError { minValue, maxValue, format }

// Extend FormzInput and provide the input type and error type.
class SilverPercent extends FormzInput<String, SilverPercentError> {
  // Call super.pure to represent an unmodified form input.
  const SilverPercent.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const SilverPercent.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SilverPercentError.format) return 'El campo debe ser un nro.';

    if (displayError == SilverPercentError.minValue) return 'El campo no puede ser menor a 0';
    if (displayError == SilverPercentError.maxValue) return 'El campo no puede ser mayor a 100';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SilverPercentError? validator(String value) {
    if (int.tryParse(value) == null && value != '') return SilverPercentError.format;
    if (int.tryParse(value) != null) {
      if (int.tryParse(value)! < 0) {
        return SilverPercentError.minValue;
      }
      if (int.tryParse(value)! > 100) {
        return SilverPercentError.maxValue;
      }
    }
    return null;
  }
}
