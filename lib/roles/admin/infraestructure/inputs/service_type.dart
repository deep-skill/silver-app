import 'package:formz/formz.dart';

// Define input validation errors
enum ServiceTypeError { empty }

// Extend FormzInput and provide the input type and error type.
class ServiceType extends FormzInput<String, ServiceTypeError> {
  // Call super.pure to represent an unmodified form input.
  const ServiceType.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const ServiceType.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ServiceTypeError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  ServiceTypeError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return ServiceTypeError.empty;

    return null;
  }
}
