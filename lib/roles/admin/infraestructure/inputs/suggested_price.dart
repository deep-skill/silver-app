import 'package:formz/formz.dart';

// Define input validation errors
enum SuggestedPriceError { empty, value, format }

// Extend FormzInput and provide the input type and error type.
class SuggestedPrice extends FormzInput<String, SuggestedPriceError> {
  // Call super.pure to represent an unmodified form input.
  const SuggestedPrice.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const SuggestedPrice.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SuggestedPriceError.empty) return 'El campo es requerido';
    if (displayError == SuggestedPriceError.format) return 'El campo debe ser un nro.';
    if (displayError == SuggestedPriceError.value) return 'El campo no puede ser menor a 0';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SuggestedPriceError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return SuggestedPriceError.empty;
    if (double.tryParse(value) == null ) return SuggestedPriceError.format;
    if (double.tryParse(value)! <= 0 ) return SuggestedPriceError.value;

    return null;
  }
}
