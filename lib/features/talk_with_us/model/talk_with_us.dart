enum TalkWithUsEnum {
  contactMessage,
  contactSubject,
  screenshots,
}

class TalkWithUs {
  TalkWithUs({
    this.screenshots = const [],
    this.contactSubject = '-',
    this.contactMessage = '',
  });

  factory TalkWithUs.fromMap(Map<String, dynamic> map) {
    return TalkWithUs(
      contactSubject: map[TalkWithUsEnum.contactSubject.name],
      contactMessage: map[TalkWithUsEnum.contactMessage.name],
      screenshots: map[TalkWithUsEnum.screenshots.name],
    );
  }

  String contactMessage;
  String contactSubject;
  List screenshots;

  Map<String, dynamic> toMap() {
    return {
      TalkWithUsEnum.contactMessage.name: contactMessage,
      TalkWithUsEnum.contactSubject.name: contactSubject,
      TalkWithUsEnum.screenshots.name: screenshots,
    };
  }
}
