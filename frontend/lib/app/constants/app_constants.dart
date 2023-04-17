library app_constants;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
part 'api_path.dart';
part 'assets_path.dart';

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
    fontSize: size.height * 0.060, fontWeight: FontWeight.bold);

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.030,
    );

// TextStyle kLoginTitleStyle(Size size) =>
//     TextStyle(fontSize: size.height * 0.060, fontWeight: FontWeight.bold);

// TextStyle kLoginSubtitleStyle(Size size) => TextStyle(
//       fontSize: size.height * 0.030,
//     );

TextStyle kLoginButtonStyle() =>
    GoogleFonts.ubuntu(fontSize: 20, color: Colors.white);

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: Colors.grey, height: 1.5);

TextStyle kHaveAnAccountStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.black);

TextStyle kLoginOrSignUpTextStyle(
  Size size,
) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF00296B),
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);

const kBorderRadius = 20.0;
const kSpacing = 20.0;

const kFontColorPallets = [
  // Color.fromRGBO(223, 172, 172, 1),
  // Color.fromRGBO(132, 111, 111, 1),
  // Color.fromRGBO(87, 65, 65, 1),

  Color(0xFF001840),
  Color(0x99000000),
  Color(0xFF00296B),
  Color.fromRGBO(170, 170, 170, 1),
];

const kNotifColor = Color.fromRGBO(74, 177, 120, 1);

const LargeScreenWidth = 600;
