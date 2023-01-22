import 'package:tiutiu/features/adption_form.dart/model/adoption_form.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';

class AdoptionFormRepository {
  Future<void> saveForm({required AdoptionForm adoptionForm}) async {
    await LocalStorage.setValueUnderStringKey(key: AdoptionFormStorage.form.name, value: adoptionForm.toMap());
  }

  Future<AdoptionForm?> getForm() async {
    final form = await LocalStorage.getValueUnderStringKey(AdoptionFormStorage.form.name);

    if (form != null) {
      return AdoptionForm.fromMap(form);
    }

    return null;
  }
}
