import 'package:cep_app/models/address_model.dart';

abstract interface class CepRepository {
  Future<AddressModel> fetchCep(String cep);
}