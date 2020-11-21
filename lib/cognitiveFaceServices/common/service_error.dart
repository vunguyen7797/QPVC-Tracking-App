import 'client_error.dart';

class ServiceError {
  final ClientError error;

  ServiceError(this.error);
}
