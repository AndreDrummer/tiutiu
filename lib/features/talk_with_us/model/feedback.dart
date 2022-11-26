enum FeedbackEnum {
  contactMessage,
  contactSubject,
  screenshots,
  createdAt,
  ownerId,
  uid,
}

class Feedback {
  Feedback({
    this.screenshots = const [],
    this.contactSubject = '-',
    this.contactMessage = '',
    this.createdAt,
    this.ownerId,
    this.uid,
  });

  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      contactSubject: map[FeedbackEnum.contactSubject.name],
      contactMessage: map[FeedbackEnum.contactMessage.name],
      screenshots: map[FeedbackEnum.screenshots.name],
      createdAt: map[FeedbackEnum.createdAt.name],
      ownerId: map[FeedbackEnum.ownerId.name],
      uid: map[FeedbackEnum.uid.name],
    );
  }

  String contactMessage;
  String contactSubject;
  String? createdAt;
  List screenshots;
  String? ownerId;
  String? uid;

  Map<String, dynamic> toMap() {
    return {
      FeedbackEnum.contactMessage.name: contactMessage,
      FeedbackEnum.contactSubject.name: contactSubject,
      FeedbackEnum.screenshots.name: screenshots,
      FeedbackEnum.createdAt.name: createdAt,
      FeedbackEnum.ownerId.name: ownerId,
      FeedbackEnum.uid.name: uid,
    };
  }
}
