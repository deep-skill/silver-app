import 'package:formz/formz.dart';

// Define input validation errors
enum ServiceCarTypeError { empty }

// Extend FormzInput and provide the input type and error type.
class ServiceCarType extends FormzInput<String, ServiceCarTypeError> {
  // Call super.pure to represent an unmodified form input.
  const ServiceCarType.pure() : super.pure('Seleccione el tipo de vehículo');

  // Call super.dirty to represent a modified form input.
  const ServiceCarType.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ServiceCarTypeError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  ServiceCarTypeError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty || value == 'Seleccione el tipo de vehículo') return ServiceCarTypeError.empty;

    return null;
  }
}
