import 'package:flutter/material.dart';
import '../theme.dart';

/// Custom shimmer effect without external dependency
class _ShimmerEffect extends StatefulWidget {
  final Widget child;
  const _ShimmerEffect({required this.child});

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFF1A2E23),
                Color(0xFF2A4E3A),
                Color(0xFF1A2E23),
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}

/// Shimmer placeholder for a card
class ShimmerCard extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const ShimmerCard({
    super.key,
    this.height = 80,
    this.width,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return _ShimmerEffect(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer placeholder for dashboard loading
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShimmerEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Container(height: 80, decoration: BoxDecoration(color: TradEtTheme.cardBg, borderRadius: BorderRadius.circular(14)))),
              const SizedBox(width: 12),
              Expanded(child: Container(height: 80, decoration: BoxDecoration(color: TradEtTheme.cardBg, borderRadius: BorderRadius.circular(14)))),
            ],
          ),
          const SizedBox(height: 24),
          Container(height: 20, width: 150, decoration: BoxDecoration(color: TradEtTheme.cardBg, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: Row(
              children: List.generate(3, (i) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 2 ? 12 : 0),
                  decoration: BoxDecoration(
                    color: TradEtTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer placeholder for a list
class ListShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ListShimmer({super.key, this.itemCount = 5, this.itemHeight = 70});

  @override
  Widget build(BuildContext context) {
    return _ShimmerEffect(
      child: Column(
        children: List.generate(itemCount, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            height: itemHeight,
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        )),
      ),
    );
  }
}
