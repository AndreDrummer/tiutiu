import 'package:tiutiu/features/adption_form.dart/model/adoption_form.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdoptionFormServices {
  Future<void> submitForm({
    required AdoptionForm adoptionForm,
    required String userId,
  }) async {
    await pathToAdoptionForm(userId: userId, formId: adoptionForm.uid!).set(adoptionForm.toMap());
  }

  DocumentReference pathToAdoptionForm({
    required String userId,
    required String formId,
  }) {
    return EndpointResolver.getDocumentEndpoint(EndpointNames.pathToAdoptionForm.name, [userId, formId]);
  }
}
