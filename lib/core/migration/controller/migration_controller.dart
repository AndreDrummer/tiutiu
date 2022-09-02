import 'package:get/get.dart';
import 'package:tiutiu/core/migration/service/migration_service.dart';

class MigrationController extends GetxController {
  MigrationController(this.migrationService);

  final MigrationService migrationService;

  void migrate() {
    migrationService.migrate();
  }
}
