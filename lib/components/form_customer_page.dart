import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class FormClient extends HookWidget {
  const FormClient({super.key});

  @override
  Widget build(BuildContext context) {
    final isVip = useState<bool?>(false);
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('VIP'),
                  value: isVip.value,
                  onChanged: (value) {
                    isVip.value = value;
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if(value == null || value.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                    return "Utilize apenas letras e espaços";
                  }
                  else {
                    return null;
                  }
                } 
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'CPF',
                ),
                validator: (value) {
                  if(value == null || value.isEmpty || !CPFValidator.isValid(value)) {
                    return "CPF inválido";
                  }
                  else {
                    return null;
                  }
                } 
              ),
              TextFormField(
                decoration: InputDecoration( 
                  border: UnderlineInputBorder(),
                  labelText: 'Telefone'
                ),
                validator: (value){
                  if(value == null || value.isEmpty || !RegExp(r'[1-9]{2} (?:[2-8]|9[1-9])[0-9]{3}\-[0-9]{4}$').hasMatch(value)){
                    return "Digite no formato: XX XXXXX-XXXX";
                  }
                  else{
                    return null;
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: FilledButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(30, 5, 30, 5)
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processando dados')),
                          );
                        }
                      },
                      child: const Text('Salvar'),
                    ),
                  )
                ]
              )
            ]
          )
        )
      )
    );
  }
}