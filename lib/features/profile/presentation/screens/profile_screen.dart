import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final profile = ref.watch(profileProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(t.profileTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    )),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () => _pickAvatar(context, ref),
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        gradient: AppColors.emeraldGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.emerald.withValues(alpha: 0.45),
                            blurRadius: 40,
                            spreadRadius: -4,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ClipOval(
                          child: profile.avatarPath != null &&
                                  File(profile.avatarPath!).existsSync()
                              ? Image.file(
                                  File(profile.avatarPath!),
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: AppColors.surfaceDark,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 56,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.emerald,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                profile.displayName ?? user?.email ?? '',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            if (user != null)
              Center(
                child: Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 24),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings_rounded),
                    title: Text(t.settings),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/settings'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionLabel(text: t.privacy),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Consumer(builder: (context, ref, _) {
                final hide = ref.watch(
                    settingsProvider.select((s) => s.hideBalances));
                return SwitchListTile(
                  value: hide,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).setHideBalances(v),
                  title: Text(t.hideBalances),
                  secondary: const Icon(Icons.visibility_off_outlined),
                );
              }),
            ),
            const SizedBox(height: 16),
            _SectionLabel(text: t.security),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_reset_rounded),
                    title: Text(t.changePassword),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/change-password'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_forever_rounded,
                        color: AppColors.negative),
                    title: Text(t.deleteAccount,
                        style: const TextStyle(color: AppColors.negative)),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.negative),
                    onTap: () => context.push('/delete-account'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionLabel(text: t.about),
            GlassCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: Text(t.about),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/about'),
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.logout_rounded,
                    color: AppColors.negative),
                title: Text(t.signOut,
                    style: const TextStyle(color: AppColors.negative)),
                onTap: () => ref.read(authProvider.notifier).signOut(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAvatar(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource?>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: Text(t.fromCamera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(t.fromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: Text(t.removeAvatar),
              onTap: () {
                ref.read(profileProvider.notifier).setAvatar(null);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (picked == null) return;
    await ref.read(profileProvider.notifier).setAvatar(picked.path);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
