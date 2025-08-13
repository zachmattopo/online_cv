import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: isDesktop ? 120 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isDesktop
              ? Row(
                  children: [
                    Expanded(child: _buildContent(context, theme)),
                    const SizedBox(width: 60),
                    _buildProfileImage(context, 300),
                  ],
                )
              : Column(
                  children: [
                    _buildProfileImage(context, 200),
                    const SizedBox(height: 40),
                    _buildContent(context, theme),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, I\'m Hafiz Nordin',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Senior Software Engineer',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'A self-taught developer with a degree in Mechanical Engineering from 🇺🇸. Born and raised in 🇲🇾, now based in 🇬🇧.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
          semanticsLabel:
              'A self-taught developer with a degree in Mechanical Engineering from the United States of America. Born and raised in Malaysia, now based in the United Kingdom.',
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildSocialButton(
              'LinkedIn',
              'https://www.linkedin.com/in/hafiznordin/',
              PhosphorIcons.linkedinLogo(PhosphorIconsStyle.fill),
              context,
            ),
            _buildSocialButton(
              'GitHub',
              'https://github.com/zachmattopo',
              PhosphorIcons.githubLogo(),
              context,
            ),
            _buildSocialButton(
              'Stack Overflow',
              'https://stackoverflow.com/users/9166207/hafiz',
              PhosphorIcons.stackOverflowLogo(),
              context,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://avatars.githubusercontent.com/u/39941205?v=4',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Icon(
                Icons.person,
                size: size * 0.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, String url, IconData icon, BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _launchUrl(url),
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
