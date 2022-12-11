import 'package:device_info_plus/device_info_plus.dart';

enum FeedbackEnum {
  contactMessage,
  contactSubject,
  screenshots,
  deviceInfo,
  createdAt,
  ownerId,
  uid,
}

class Feedback {
  Feedback({
    this.screenshots = const [],
    this.contactSubject = '-',
    this.contactMessage = '',
    this.deviceInfo,
    this.createdAt,
    this.ownerId,
    this.uid,
  });

  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      deviceInfo: _handleDeviceInfo(map[FeedbackEnum.deviceInfo.name]),
      contactSubject: map[FeedbackEnum.contactSubject.name],
      contactMessage: map[FeedbackEnum.contactMessage.name],
      screenshots: map[FeedbackEnum.screenshots.name],
      createdAt: map[FeedbackEnum.createdAt.name],
      ownerId: map[FeedbackEnum.ownerId.name],
      uid: map[FeedbackEnum.uid.name],
    );
  }

  BaseDeviceInfo? deviceInfo;
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
      FeedbackEnum.deviceInfo.name: deviceInfo?.data,
      FeedbackEnum.screenshots.name: screenshots,
      FeedbackEnum.createdAt.name: createdAt,
      FeedbackEnum.ownerId.name: ownerId,
      FeedbackEnum.uid.name: uid,
    };
  }

  static BaseDeviceInfo? _handleDeviceInfo(dynamic data) {
    if (data == null) return data;
    return data is BaseDeviceInfo ? data : BaseDeviceInfo(data);
  }
}
