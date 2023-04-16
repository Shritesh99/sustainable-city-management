import 'package:flutter/material.dart';

class ProfileCardData {
  final ImageProvider photo;
  final String name;
  final String email;
  final String role;

  const ProfileCardData({
    required this.photo,
    required this.name,
    required this.email,
    required this.role,
  });
}
