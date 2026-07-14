import 'package:flutter/material.dart';
import 'package:unit_testing/app/core/constants/app_constants.dart';

class SettingsAboutAppPage extends StatelessWidget {
  const SettingsAboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // App icon + name hero
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.restaurant_menu_rounded,
                  color: colorScheme.onPrimary,
                  size: 52,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Version ${AppConstants.appVersion}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          _InfoSection(
            title: 'What is ${AppConstants.appName}?',
            content:
                '${AppConstants.appName} is a premium recipe companion designed for home cooks and culinary enthusiasts. '
                'Explore hundreds of recipes, save your favourites, and manage your chef profile — all in one place.',
          ),
          const SizedBox(height: 20),

          _InfoSection(
            title: 'Features',
            bullets: const [
              '🍽️  Browse & search hundreds of recipes',
              '🔖  Bookmark your favourites',
              '🌗  Light, Dark & System theme support',
              '🧑‍🍳  Personalised chef profile & bio',
            ],
          ),
          const SizedBox(height: 20),

          _InfoSection(
            title: 'Technology',
            content:
                'Built with Flutter using Clean Architecture, Cubit state management, '
                'and SharedPreferences for local persistence.',
          ),
          const SizedBox(height: 20),

          _InfoSection(
            title: 'Legal',
            content:
                '© 2025 ${AppConstants.appName}. All rights reserved.\n'
                'Recipe data is powered by DummyJSON for demonstration purposes.',
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String? content;
  final List<String>? bullets;

  const _InfoSection({
    required this.title,
    this.content,
    this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          if (content != null)
            Text(
              content!,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface.withOpacity(0.65),
                height: 1.6,
              ),
            ),
          if (bullets != null)
            ...bullets!.map(
              (b) => Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  b,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withOpacity(0.65),
                    height: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
