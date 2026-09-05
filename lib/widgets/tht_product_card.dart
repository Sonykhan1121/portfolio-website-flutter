part of '../portfolio_app.dart';

/// A locally bundled official product photo; no third-party image request is
/// needed to render the company page. The slot stays stable while it loads.
class _ThtProductCard extends StatelessWidget {
  const _ThtProductCard({
    super.key,
    required this.width,
    required this.category,
    required this.name,
    required this.description,
    required this.image,
    required this.productUrl,
    required this.icon,
  });

  final double width;
  final String category;
  final String name;
  final String description;
  final String image;
  final String productUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: _line),
      boxShadow: _cardShadow,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: ColoredBox(
            color: Colors.white,
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ProgressiveAssetImage(
                  image,
                  fit: BoxFit.contain,
                  semanticLabel: '$name — $category, official product photo',
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 1, color: _line),
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 18, color: _mint),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  color: _text,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => _launch(productUrl),
                style: TextButton.styleFrom(
                  foregroundColor: _sky,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.centerLeft,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'View product',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(width: 7),
                    Icon(Icons.open_in_new_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
