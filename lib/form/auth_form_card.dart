import 'package:arcane_jaspr/arcane_jaspr.dart';

/// Container card for authentication form content.
///
/// Provides consistent styling with title, optional subtitle,
/// and content area for form fields.
class AuthFormCard extends StatelessComponent {
  /// Title displayed at the top
  final String title;

  /// Optional subtitle below the title
  final String? subtitle;

  /// Form content
  final Component child;

  /// Optional footer content (links, etc)
  final Component? footer;

  const AuthFormCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.footer,
  });

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(raw: {
        'width': '100%',
      }),
      [
        // Header
        div(
          styles: Styles(raw: {
            'margin-bottom': '32px',
            'text-align': 'center',
          }),
          [
            h1(
              styles: Styles(raw: {
                'font-size': '28px',
                'font-weight': '700',
                'color': '#fafafa',
                'margin': '0 0 8px 0',
                'letter-spacing': '-0.02em',
              }),
              [Component.text(title)],
            ),
            if (subtitle != null)
              p(
                styles: Styles(raw: {
                  'font-size': '15px',
                  'color': '#71717a',
                  'margin': '0',
                  'line-height': '1.5',
                }),
                [Component.text(subtitle!)],
              ),
          ],
        ),
        // Form content
        child,
        // Footer
        if (footer != null)
          div(
            styles: Styles(raw: {
              'margin-top': '24px',
              'text-align': 'center',
            }),
            [footer!],
          ),
      ],
    );
  }
}
