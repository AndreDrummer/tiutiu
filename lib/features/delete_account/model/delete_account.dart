enum DeleteAccountEnum {
  descrivedMotive,
  displayName,
  userDeleted,
  userEmail,
  motive,
}

class DeleteAccount {
  DeleteAccount({
    required this.descrivedMotive,
    required this.displayName,
    required this.userDeleted,
    required this.userEmail,
    required this.motive,
  });

  factory DeleteAccount.fromMap(Map<String, dynamic> map) {
    return DeleteAccount(
      descrivedMotive: map[DeleteAccountEnum.descrivedMotive.name],
      displayName: map[DeleteAccountEnum.displayName.name],
      userDeleted: map[DeleteAccountEnum.userDeleted.name],
      userEmail: map[DeleteAccountEnum.userEmail.name],
      motive: map[DeleteAccountEnum.motive.name],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DeleteAccountEnum.descrivedMotive.name: descrivedMotive,
      DeleteAccountEnum.displayName.name: displayName,
      DeleteAccountEnum.userDeleted.name: userDeleted,
      DeleteAccountEnum.userEmail.name: userEmail,
      DeleteAccountEnum.motive.name: motive,
    };
  }

  final String descrivedMotive;
  final String displayName;
  final bool userDeleted;
  final String userEmail;
  final String motive;
}
