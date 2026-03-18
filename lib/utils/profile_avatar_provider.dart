import 'dart:math';

class ProfileAvatarProvider {
  static final String imageUrl = _buildRandomAvatarUrl();

  static String _buildRandomAvatarUrl() {
    final imageId = Random().nextInt(70) + 1;
    return 'https://i.pravatar.cc/300?img=$imageId';
  }
}
