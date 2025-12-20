import 'package:arcane_jaspr/arcane_jaspr.dart';

/// Divider with centered text for authentication forms.
///
/// Typically used to separate OAuth buttons from email/password form
/// with text like "or continue with email".
class AuthDivider extends StatelessComponent {
  /// Text to display in the center of the divider
  final String text;

  const AuthDivider({
    super.key,
    this.text = 'or continue with',
  });

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(raw: {
        'display': 'flex',
        'align-items': 'center',
        'gap': '16px',
        'margin': '24px 0',
      }),
      [
        // Left line
        div(
          styles: Styles(raw: {
            'flex': '1',
            'height': '1px',
            'background': '#27272a',
          }),
          [],
        ),
        // Text
        span(
          styles: Styles(raw: {
            'font-size': '13px',
            'color': '#71717a',
            'text-transform': 'lowercase',
            'white-space': 'nowrap',
          }),
          [Component.text(text)],
        ),
        // Right line
        div(
          styles: Styles(raw: {
            'flex': '1',
            'height': '1px',
            'background': '#27272a',
          }),
          [],
        ),
      ],
    );
  }
}
