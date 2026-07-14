import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unit_testing/app/core/constants/app_constants.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import 'settings_theme_page.dart';
import 'settings_about_you_page.dart';
import 'settings_about_app_page.dart';
import 'settings_profile_page.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, authState) {
          if (authState is Unauthenticated) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (authState is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authState.message),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        builder: (context, authState) {
          if (authState is! Authenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authState.user;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ─────────────────────────────────
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsProfilePage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: colorScheme.primary.withOpacity(0.15),
                          backgroundImage: user.photoUrl.isNotEmpty
                              ? NetworkImage(user.photoUrl)
                              : null,
                          child: user.photoUrl.isEmpty
                              ? Icon(Icons.person, size: 32, color: colorScheme.primary)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user.firstName} ${user.lastName}',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.email,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.55),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: colorScheme.onSurface.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(
                  thickness: 0.5,
                  height: 0,
                  color: colorScheme.outline.withOpacity(0.15),
                ),

                const SizedBox(height: 8),

                // ── Menu Items ─────────────────────────────
                Expanded(
                  child: BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, settingsState) {
                      final themeLabel = settingsState is SettingsLoaded
                          ? _themeModeLabel(settingsState.themeMode)
                          : 'System';

                      return ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          _SettingsMenuItem(
                            icon: Icons.palette_outlined,
                            label: 'App Theme',
                            subtitle: themeLabel,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SettingsThemePage()),
                              );
                            },
                          ),
                          _SettingsMenuItem(
                            icon: Icons.edit_note_outlined,
                            label: 'About You',
                            subtitle: 'Your culinary bio',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SettingsAboutYouPage()),
                              );
                            },
                          ),
                          _SettingsMenuItem(
                            icon: Icons.info_outline_rounded,
                            label: 'About App',
                            subtitle: '${AppConstants.appName} v${AppConstants.appVersion}',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SettingsAboutAppPage()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),

                Divider(
                  thickness: 0.5,
                  height: 0,
                  color: colorScheme.outline.withOpacity(0.15),
                ),

                // ── Log Out ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton.icon(
                    onPressed: () => context.read<AuthCubit>().logoutUser(),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Log Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}

// ── Private menu tile widget ────────────────────────────────────────────────

class _SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 22),
          ),
          title: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
