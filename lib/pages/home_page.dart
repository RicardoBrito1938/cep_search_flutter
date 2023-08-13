import 'package:cep_app/models/address_model.dart';
import 'package:cep_app/repositories/cep_repository.dart';
import 'package:cep_app/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  AddressModel? addressModel;
  bool loading = false;

  final formkey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search CEP'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: cepEC,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required field";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      final valid = formkey.currentState?.validate() ?? false;
                      if (valid) {
                        try {
                          setState(() {
                            loading = true;
                          });
                          cepRepository.fetchCep(cepEC.text).then((value) {
                            setState(() {
                              loading = false;
                              addressModel = value;
                            });
                          });
                        } catch (e) {
                          setState(() {
                            loading = false;
                            addressModel = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error searching CEP'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Search')),
                Visibility(visible: loading, child: const CircularProgressIndicator()),
                Visibility(
                    visible: addressModel != null,
                    child: Text(
                        '${addressModel?.cep} - ${addressModel?.logradouro} - ${addressModel?.complemento}')),
              ],
            )),
      ),
    );
  }
}
