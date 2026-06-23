part of '../../app_manager_page.dart';

extension _ActionButtonBuild on _AppManagerPageState {
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    required int delay,
  }) {
    final colors = AppColors.of(context);
    return FadeIn(
      duration: Duration(milliseconds: delay),
      child: Tooltip(
        message: tooltip,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: colors.foreground.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: colors.foregroundMuted),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: colors.foregroundMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
