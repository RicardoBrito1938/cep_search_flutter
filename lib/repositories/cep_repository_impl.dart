import 'dart:math';

import 'package:cep_app/models/address_model.dart';
import 'package:dio/dio.dart';

import './cep_repository.dart';



class CepRepositoryImpl implements CepRepository {
  @override
  Future<AddressModel> fetchCep(String cep) async {
    try {
      final result = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      return AddressModel.fromMap(result.data);
    } on DioException catch (e) {
      log("Error findind CEP: ${e.message}" as num);
      throw Exception("Error searching CEP");
    }
  }
}