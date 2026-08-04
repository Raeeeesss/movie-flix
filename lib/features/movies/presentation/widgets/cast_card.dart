import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/cast_member.dart';

class CastCard extends StatelessWidget {
  final CastMember castMember;

  const CastCard({
    super.key,
    required this.castMember,
  });

  @override
  Widget build(BuildContext context) {
    final profileUrl = castMember.profileUrl;

    return Container(
      width: 78,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rounded Rectangle Squircle Cast Photo (Reference design exact style)
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: AppColors.divider, width: 0.8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: profileUrl != null && profileUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: profileUrl,
                      width: 78,
                      height: 78,
                      fit: BoxFit.cover,
                      memCacheWidth: 200,
                      placeholder: (context, url) => Container(color: AppColors.cardBg),
                      errorWidget: (context, url, error) => _buildInitials(),
                    )
                  : _buildInitials(),
            ),
          ),
          const SizedBox(height: 6),

          // Actor Name
          Text(
            castMember.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),

          // Character Name
          if (castMember.character.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              castMember.character,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInitials() {
    final initials = castMember.name.isNotEmpty ? castMember.name.substring(0, 1).toUpperCase() : '?';
    return Container(
      color: AppColors.cardBg,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: AppColors.primaryAccent,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
