import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sustainable_city_management/app/constants/app_constants.dart';
import 'package:sustainable_city_management/app/dashboard/models/profile_model.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    required this.data,
    Key? key,
  }) : super(key: key);

  final ProfileCardData data;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ProfilImage(image: data.photo),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleText(data.name),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _SubtitleText(data.role),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

/* -----------------------------> COMPONENTS <------------------------------ */
class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.percent,
    required this.center,
    Key? key,
  }) : super(key: key);

  final double percent;
  final Widget center;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 55,
      lineWidth: 2.0,
      percent: percent,
      center: center,
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: Colors.blueGrey,
      progressColor: Theme.of(Get.context!).primaryColor,
    );
  }
}

class _ProfilImage extends StatelessWidget {
  const _ProfilImage({required this.image, Key? key}) : super(key: key);

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: image,
      radius: 30,
      backgroundColor: Colors.white,
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText(this.data, {Key? key}) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data.capitalize!,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: kFontColorPallets[0],
        letterSpacing: 0.8,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText(this.data, {Key? key}) : super(key: key);

  final String data;
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: kFontColorPallets[1]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
