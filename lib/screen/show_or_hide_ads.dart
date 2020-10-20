import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/providers/ads_provider.dart';

class ShowOrHideAds extends StatelessWidget {
  ShowOrHideAds({
    this.streamData,
    this.callBack,
    this.anchorOffset,
    this.anchorType,
    this.name,
  });

  final Stream<BannerAd> streamData;
  final Function() callBack;
  final double anchorOffset;
  final anchorType;
  final String name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<AdsProvider>(context).canShowAds,
      builder: (context, snapshotStarted) {
        if (snapshotStarted.data == null) {
          return SizedBox();
        }
        return Container(
          color: Colors.black87,
          height: 50,
          child: StreamBuilder<BannerAd>(
            stream: streamData,
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshotStarted.data) {
                callBack();
                print("DATA $name");
                snapshot.data
                  ..load().then(
                    (value) async {
                      if (value) {
                        snapshot.data.show(
                          anchorOffset: anchorOffset,
                          anchorType: anchorType,
                        );
                      }
                    },
                  );
              }
              return SizedBox();
            },
          ),
        );
      },
    );
  }
}
