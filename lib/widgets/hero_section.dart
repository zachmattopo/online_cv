import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:online_cv/models/social_link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/cubit/resume_cubit.dart';

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
              ? BlocBuilder<ResumeCubit, ResumeState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(child: HeroContent()),
                        const SizedBox(width: 60),
                        ProfileImage(size: 300, imageUrl: state.profileImageUrl),
                      ],
                    );
                  },
                )
              : BlocBuilder<ResumeCubit, ResumeState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        ProfileImage(size: 200, imageUrl: state.profileImageUrl),
                        const SizedBox(height: 40),
                        HeroContent(),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class HeroContent extends StatelessWidget {
  const HeroContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResumeCubit, ResumeState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.heroTitle,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 100.ms)
                .slideX(begin: -0.2, duration: 600.ms, delay: 100.ms)
                .slideY(begin: 0.1, duration: 600.ms, delay: 100.ms),
            const SizedBox(height: 16),
            Text(
              state.heroSubtitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideX(begin: -0.2, duration: 500.ms, delay: 200.ms)
                .slideY(begin: 0.1, duration: 500.ms, delay: 200.ms),
            const SizedBox(height: 24),
            Text(
              state.heroDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
              semanticsLabel: state.heroSemanticsLabel,
            ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: state.socialLinks
                  .map(
                    (SocialLink socialLink) => SocialButton(
                      label: socialLink.label,
                      url: socialLink.url,
                      icon: socialLink.icon,
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

class ProfileImage extends StatelessWidget {
  final double size;
  final String imageUrl;

  const ProfileImage({
    super.key,
    required this.size,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
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
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
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
        ).animate().fadeIn(duration: 500.ms, delay: 300.ms).scale(
            begin: const Offset(0.9, 0.9),
            end: Offset(1, 1),
            duration: 500.ms,
            delay: 300.ms,
            curve: Curves.easeOutCubic),
      ),
    );
  }
}

class SocialButton extends StatefulWidget {
  final String label;
  final String url;
  final IconData icon;

  const SocialButton({
    super.key,
    required this.label,
    required this.url,
    required this.icon,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _isHovered = false;

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 200.ms,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: _isHovered
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isHovered ? Theme.of(context).colorScheme.primary : Colors.transparent,
          width: _isHovered ? 2 : 0,
        ),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(
                        alpha: 0.15,
                      ),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: ElevatedButton.icon(
        onPressed: () => _launchUrl(widget.url),
        onHover: (hovered) {
          setState(() {
            _isHovered = hovered;
          });
        },
        onFocusChange: (focused) {
          setState(() {
            _isHovered = focused;
          });
        },
        icon: Icon(
          widget.icon,
          color: _isHovered ? Theme.of(context).colorScheme.primary : null,
        ),
        label: Text(
          widget.label,
          style: TextStyle(
            color: _isHovered ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: _isHovered ? 4 : 0,
        ),
      ),
    );
  }
}
