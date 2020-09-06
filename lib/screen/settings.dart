import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:tiutiu/Widgets/input_text.dart';
import 'package:tiutiu/providers/user_provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isNameEditing = false;
  bool isWhatsAppEditing = false;
  bool isTelefoneEditing = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _whatsAppController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();

  TextEditingController _actualPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _repeatNewPassword = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var telefoneMask = new MaskTextInputFormatter(
    mask: '(##) ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  var celularMask = new MaskTextInputFormatter(
    mask: '(##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String validarCelular(String value) {
    value = celularMask.getUnmaskedText();

    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length < 11) {
      return 'Número deve ter 11 dígitos';      
    } else if (!regExp.hasMatch(value)) {
      return "O número do celular so deve conter números";
    }   
    return null;
  }

  String validarTelefone(String value) {
    value = telefoneMask.getUnmaskedText();

    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length < 10) {
      return 'Número deve ter 10 dígitos';            
    } else if (!regExp.hasMatch(value)) {
     return "O número do telefone so deve conter números";
    }
    return null;
  }

  @override
  void didChangeDependencies() {
    UserProvider userProvider = Provider.of(context);
    if (userProvider.displayName != null)
      _nameController.text = userProvider.displayName;
    if (userProvider.whatsapp != null)
      _whatsAppController.text = userProvider.whatsapp;
    if (userProvider.telefone != null)
      _telefoneController.text = userProvider.telefone;
    super.didChangeDependencies();
  }

  void changeFieldEditingState(bool newState, String field) {
    switch (field) {
      case 'isNameEditing':
        setState(() {
          isNameEditing = newState;
        });
        break;
      case 'isWhatsAppEditing':
        setState(() {
          isWhatsAppEditing = newState;
        });
        break;
      case 'isTelefoneEditing':
        setState(() {
          isTelefoneEditing = newState;
        });
        break;
    }
  }  

  bool handleAlterPassword() {
    bool passwordFormIsTouched = _actualPassword.text.length > 0 ||
        _newPassword.text.length > 0 ||
        _repeatNewPassword.text.length > 0;

    if (passwordFormIsTouched) {
      // TODO: Verificar se a senha atual está correta;
      _formKey.currentState.validate();
      if (true) {
        if (_newPassword.text.length < 6) {
          return false;
        }
        if (_repeatNewPassword.text.isEmpty) {
          return false;
        }
        if (_repeatNewPassword.text != _newPassword.text) {
          return false;
        }
      }
    }

    return true;
  }

  void save() {
    if(handleAlterPassword()) {
      print('Pronto para salvar');
    } else {
      print('Preencha os campos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      backgroundColor: Colors.blueGrey[50],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomDivider(text: 'Dados do perfil'),
              Container(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      // backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Icon(Icons.person_outline),
                      ),
                    ),
                    SizedBox(height: 7),
                    Text('Alter/Adicionar')
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: ListView(
                  children: [
                    ListTile(
                      title: Text('Nome'),
                      subtitle: isNameEditing
                          ? TextField(
                              controller: _nameController,
                            )
                          : Text(_nameController.text),
                      trailing: IconButton(
                        icon: isNameEditing
                            ? Icon(Icons.save)
                            : Icon(Icons.mode_edit),
                        onPressed: () {
                          if (isNameEditing) {
                            changeFieldEditingState(false, 'isNameEditing');
                          } else {
                            changeFieldEditingState(true, 'isNameEditing');
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('WhatsApp'),
                      subtitle: isWhatsAppEditing
                          ? TextFormField(
                            inputFormatters: [celularMask],
                            validator: (String value) => validarCelular(value),
                              keyboardType: TextInputType.number,
                              controller: _whatsAppController,
                            )
                          : Text(_whatsAppController.text),
                      trailing: IconButton(
                        icon: isWhatsAppEditing
                            ? Icon(Icons.save)
                            : Icon(Icons.mode_edit),
                        onPressed: () {
                          if (isWhatsAppEditing) {
                            changeFieldEditingState(false, 'isWhatsAppEditing');
                          } else {
                            changeFieldEditingState(true, 'isWhatsAppEditing');
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Telefone Fixo'),
                      subtitle: isTelefoneEditing
                          ? TextFormField(
                            inputFormatters: [telefoneMask],
                              validator: (String value) => validarTelefone(value),
                              keyboardType: TextInputType.number,
                              controller: _telefoneController,
                            )
                          : Text(_telefoneController.text),
                      trailing: IconButton(
                        icon: isTelefoneEditing
                            ? Icon(Icons.save)
                            : Icon(Icons.mode_edit),
                        onPressed: () {
                          if (isTelefoneEditing) {
                            changeFieldEditingState(false, 'isTelefoneEditing');
                          } else {
                            changeFieldEditingState(true, 'isTelefoneEditing');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              CustomDivider(text: 'Alterar senha'),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),                    
                    InputText(
                      hintText: 'Senha Atual',
                      controller: _actualPassword,
                    ),
                    SizedBox(height: 15),
                    InputText(
                      hintText: 'Nova Senha',
                      controller: _newPassword,
                    ),
                    SizedBox(height: 15),
                    InputText(
                      hintText: 'Repita a nova senha',
                      controller: _repeatNewPassword,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: ButtonWide(
        action: save,
        isToExpand: true,
        rounded: false,
        text: 'Salvar',
      ),
    );
  }
}
