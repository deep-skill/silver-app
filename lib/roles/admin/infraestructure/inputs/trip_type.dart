import 'package:formz/formz.dart';

// Define input validation errors
enum TripTypeError { empty }

// Extend FormzInput and provide the input type and error type.
class TripType extends FormzInput<String, TripTypeError> {
  // Call super.pure to represent an unmodified form input.
  const TripType.pure() : super.pure('Seleccione el tipo de viaje');

  // Call super.dirty to represent a modified form input.
  const TripType.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == TripTypeError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  TripTypeError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty || value == 'Seleccione el tipo de viaje') return TripTypeError.empty;

    return null;
  }
}
