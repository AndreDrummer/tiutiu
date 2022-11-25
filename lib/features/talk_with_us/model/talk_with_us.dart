enum TalkWithUsEnum {
  contactMessage,
  contactSubject,
  screenshots,
}

class TalkWithUs {
  TalkWithUs({
    this.contactSubject,
    this.contactMessage,
    this.screenshots,
  });

  factory TalkWithUs.fromMap(Map<String, dynamic> map) {
    return TalkWithUs(
      contactSubject: map[TalkWithUsEnum.contactSubject.name],
      contactMessage: map[TalkWithUsEnum.contactMessage.name],
      screenshots: map[TalkWithUsEnum.screenshots.name],
    );
  }

  String? contactSubject;
  String? contactMessage;
  List? screenshots;

  Map<String, dynamic> toMap() {
    return {
      TalkWithUsEnum.contactMessage.name: contactMessage,
      TalkWithUsEnum.contactSubject.name: contactSubject,
      TalkWithUsEnum.screenshots.name: screenshots,
    };
  }
}
