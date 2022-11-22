enum DeleteAccountEnum {
  descrivedMotive,
  userEmail,
  motive,
}

class DeleteAccount {
  DeleteAccount({
    required this.descrivedMotive,
    required this.userEmail,
    required this.motive,
  });

  factory DeleteAccount.fromMap(Map<String, dynamic> map) {
    return DeleteAccount(
      descrivedMotive: map[DeleteAccountEnum.descrivedMotive.name],
      userEmail: map[DeleteAccountEnum.userEmail.name],
      motive: map[DeleteAccountEnum.motive.name],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DeleteAccountEnum.descrivedMotive.name: descrivedMotive,
      DeleteAccountEnum.userEmail.name: userEmail,
      DeleteAccountEnum.motive.name: motive,
    };
  }

  final String descrivedMotive;
  final String userEmail;
  final String motive;
}
