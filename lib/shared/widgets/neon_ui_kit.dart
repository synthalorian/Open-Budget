import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// CRT scanline overlay that gives the entire screen a retro monitor feel.
class CRTOverlay extends StatelessWidget {
  final Widget child;
  final bool showScanlines;
  final bool showVignette;

  const CRTOverlay({
    super.key,
    required this.child,
    this.showScanlines = true,
    this.showVignette = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showScanlines)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ScanlinePainter(),
              ),
            ),
          ),
        if (showVignette)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.15),
                    ],
                    stops: const [0.65, 1.0],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.04)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Synthwave grid background pattern – subtle retro grid lines.
class SynthwaveGrid extends StatelessWidget {
  final double spacing;

  const SynthwaveGrid({super.key, this.spacing = 40});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _GridPainter(
            color: AppColors.primary.withValues(alpha: 0.06),
            spacing: spacing,
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  final double spacing;

  _GridPainter({required this.color, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Enhanced NeonCard with multi-layered glow for the synthwave84 aesthetic.
class NeonCard extends StatefulWidget {
  final Widget child;
  final Color? glowColor;
  final bool hasGlow;
  final double blur;
  final double opacity;
  final EdgeInsets padding;
  final Color? borderColor;

  const NeonCard({
    super.key,
    required this.child,
    this.glowColor,
    this.hasGlow = true,
    this.blur = 12.0,
    this.opacity = 0.6,
    this.padding = const EdgeInsets.all(20),
    this.borderColor,
  });

  @override
  State<NeonCard> createState() => _NeonCardState();
}

class _NeonCardState extends State<NeonCard> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveGlowColor = widget.glowColor ?? AppColors.primary;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final glowIntensity = widget.hasGlow ? _glowAnimation.value : 1.0;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: widget.opacity),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.borderColor ?? effectiveGlowColor.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: widget.hasGlow
                ? [
                    // Outer glow
                    BoxShadow(
                      color: effectiveGlowColor.withValues(alpha: 0.08 * glowIntensity),
                      blurRadius: widget.blur,
                      spreadRadius: 1 * glowIntensity,
                    ),
                    // Stronger inner glow layer
                    BoxShadow(
                      color: effectiveGlowColor.withValues(alpha: 0.04 * glowIntensity),
                      blurRadius: widget.blur * 0.5,
                      spreadRadius: 2 * glowIntensity,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: widget.padding,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// NeonPulseOrb with enhanced synthwave84 glow effects.
class NeonPulseOrb extends StatefulWidget {
  final double percentUsed;
  final Color baseColor;

  const NeonPulseOrb({
    super.key,
    required this.percentUsed,
    required this.baseColor,
  });

  @override
  State<NeonPulseOrb> createState() => _NeonPulseOrbState();
}

class _NeonPulseOrbState extends State<NeonPulseOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final duration = widget.percentUsed > 0.9 ? 800 : 1500;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orbColor = widget.percentUsed > 1.0
        ? AppColors.expense
        : widget.percentUsed > 0.8
            ? AppColors.warning
            : widget.baseColor;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  orbColor.withValues(alpha: 0.7),
                  orbColor.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
                stops: const [0.15, 0.6, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: orbColor.withValues(alpha: 0.35),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(widget.percentUsed * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: orbColor,
                      fontFamily: 'Orbitron',
                      shadows: [
                        Shadow(
                          color: orbColor.withValues(alpha: 0.6),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'USED',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: orbColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Section header with synthwave accent bar.
class SynthwaveSectionHeader extends StatelessWidget {
  final String title;
  final Color? accentColor;

  const SynthwaveSectionHeader({
    super.key,
    required this.title,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.labelNeon.copyWith(color: color)),
      ],
    );
  }
}

/// Synthwave neon progress bar with glow.
class SynthwaveProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final bool isOver;

  const SynthwaveProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.isOver = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.5),
                  color,
                ],
              ),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 16,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Synthwave action button with glow effect.
class SynthwaveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;

  const SynthwaveButton({
    super.key,
    required this.label,
    this.onPressed,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.15),
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTextStyles.labelNeon.copyWith(
                color: color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Neon-styled text input field.
class SynthwaveTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;

  const SynthwaveTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTextStyles.bodyMain,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText ?? label,
        hintStyle: TextStyle(color: AppColors.textMuted),
        labelText: label,
        labelStyle: AppTextStyles.labelNeon.copyWith(
          fontSize: 8,
          color: AppColors.textMuted,
        ),
        prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.surfaceLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.accent.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
