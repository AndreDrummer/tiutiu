import 'package:cloud_firestore/cloud_firestore.dart';

enum SponsoredEnum {
  imagePath,
  title,
  link,
}

class Sponsored {
  Sponsored({
    this.imagePath,
    this.title,
    this.link,
  });

  factory Sponsored.fromSnapshot(DocumentSnapshot snapshot) {
    return Sponsored(
      imagePath: snapshot.get(SponsoredEnum.imagePath.name),
      title: snapshot.get(SponsoredEnum.title.name),
      link: snapshot.get(SponsoredEnum.link.name),
    );
  }

  factory Sponsored.fromMap(Map<String, dynamic> map) {
    return Sponsored(
      imagePath: map[SponsoredEnum.imagePath.name],
      title: map[SponsoredEnum.title.name],
      link: map[SponsoredEnum.link.name],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SponsoredEnum.imagePath.name: imagePath,
      SponsoredEnum.title.name: title,
      SponsoredEnum.link.name: link,
    };
  }

  String? imagePath;
  String? title;
  String? link;

  @override
  String toString() => 'imagePath: $imagePath, title: $title, link: $link';
}
