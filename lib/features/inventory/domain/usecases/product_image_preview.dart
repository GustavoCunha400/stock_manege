import 'package:estokar_gestaodeestoque/app/app_breakpoints.dart';
import 'package:flutter/material.dart';

class ProductImagePreview extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderRadius;

  const ProductImagePreview({
    super.key,
    required this.imageUrl,
    this.size = 52,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSize = context.isMobile ? size * 0.68 : size;
    final effectiveRadius = context.isMobile ? borderRadius * 0.75 : borderRadius;
    final cleanImageUrl = imageUrl.trim();

    if (cleanImageUrl.isEmpty) {
      return _ProductImagePlaceholder(size: effectiveSize);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showExpandedImage(context, cleanImageUrl),
          child: Image.network(
            cleanImageUrl,
            width: effectiveSize,
            height: effectiveSize,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _ProductImagePlaceholder(size: effectiveSize);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showExpandedImage(
    BuildContext context,
    String cleanImageUrl,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: colorScheme.surface,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: Image.network(
                        cleanImageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const SizedBox(
                            width: 120,
                            height: 120,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _ProductImagePlaceholder(size: 160);
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductImagePlaceholder extends StatelessWidget {
  final double size;

  const _ProductImagePlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

