import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Bloco padrão: cinza sutil + borda nítida (substitui o Card com sombra).
class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: AppTheme.panel(color: color, borderColor: borderColor),
      child: child,
    );
    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: content,
    );
  }
}

/// KPI: número grande em destaque + rótulo em caixa alta.
class StatTile extends StatelessWidget {
  final String value;
  final String label;

  /// Usa a cor de destaque no número (reservar para 1 KPI por tela).
  final bool emphasize;

  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: emphasize ? AppTheme.accent : AppTheme.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(label.toUpperCase(), style: AppTheme.label),
        ],
      ),
    );
  }
}

/// Rótulo de seção em caixa alta (eyebrow industrial).
class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const SectionTitle(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.text,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            letterSpacing: 1.5,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Marcador quadrado e nítido para o rótulo A/B/C do treino.
class LabelPill extends StatelessWidget {
  final String text;

  const LabelPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        border: Border.all(color: AppTheme.borderStrong),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.text,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
    );
  }
}
