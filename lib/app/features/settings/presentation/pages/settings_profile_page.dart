import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class SettingsProfilePage extends StatelessWidget {
  const SettingsProfilePage({super.key});

  static const List<String> avatarPresets = [
    'https://api.dicebear.com/7.x/avataaars/png?seed=Chef1',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Chef2',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Chef3',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Chef4',
  ];

  @override
  Widget build(BuildContext context) {
    final customUrlNotifier = ValueNotifier<String>('');
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is! Authenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.user;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: colorScheme.primary.withOpacity(0.15),
                        backgroundImage: user.photoUrl.isNotEmpty
                            ? NetworkImage(user.photoUrl)
                            : null,
                        child: user.photoUrl.isEmpty
                            ? Icon(Icons.person, size: 64, color: colorScheme.primary)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: colorScheme.primary,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit_rounded,
                              size: 16,
                              color: colorScheme.onPrimary,
                            ),
                            onPressed: () =>
                                _showAvatarSheet(context, customUrlNotifier),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Name
                Text(
                  '${user.firstName} ${user.lastName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),

                // Stats card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        label: 'Chef Status',
                        value: 'Amateur',
                        colorScheme: colorScheme,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                      _StatItem(
                        label: 'Verified',
                        icon: Icons.verified_user_rounded,
                        iconColor: Colors.green,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Info row
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Username',
                        value: user.username,
                        colorScheme: colorScheme,
                      ),
                      Divider(
                        height: 24,
                        color: colorScheme.outline.withOpacity(0.1),
                      ),
                      _InfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: user.email,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAvatarSheet(BuildContext context, ValueNotifier<String> urlNotifier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        final colorScheme = Theme.of(sheetContext).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose Profile Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 84,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: avatarPresets.length,
                  itemBuilder: (_, idx) {
                    return GestureDetector(
                      onTap: () {
                        context.read<AuthCubit>().updateUserPhoto(avatarPresets[idx]);
                        Navigator.pop(sheetContext);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(avatarPresets[idx]),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Or paste a custom URL',
                style: TextStyle(
                    fontSize: 13, color: colorScheme.onSurface.withOpacity(0.5)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'https://example.com/photo.jpg',
                        filled: true,
                        fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => urlNotifier.value = val,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (urlNotifier.value.isNotEmpty) {
                        context.read<AuthCubit>().updateUserPhoto(urlNotifier.value);
                      }
                      Navigator.pop(sheetContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String? value;
  final IconData? icon;
  final Color? iconColor;
  final ColorScheme colorScheme;

  const _StatItem({
    required this.label,
    this.value,
    this.icon,
    this.iconColor,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5), fontSize: 12)),
        const SizedBox(height: 6),
        if (value != null)
          Text(value!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (icon != null)
          Icon(icon, color: iconColor ?? colorScheme.primary, size: 24),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurface.withOpacity(0.45))),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
