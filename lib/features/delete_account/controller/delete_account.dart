import 'package:get/get.dart';
import 'package:tiutiu/features/delete_account/service/delete_account_service.dart';

class DeleteAccountController extends GetxController {
  DeleteAccountController({
    required DeleteAccountService deleteAccountService,
  }) : _deleteAccountService = deleteAccountService;
  final DeleteAccountService _deleteAccountService;

  Future<void> deleteAccountForever(String userId) async {
    await _deleteAccountService.deleteAccountForever(userId);
  }
}
