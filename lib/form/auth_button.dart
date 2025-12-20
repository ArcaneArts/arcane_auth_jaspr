import 'package:arcane_jaspr/arcane_jaspr.dart';

/// Button variant for auth forms
enum AuthButtonVariant { primary, secondary, ghost }

/// Styled button for authentication forms.
///
/// Supports primary (green gradient), secondary (outlined),
/// and ghost (text only) variants with loading state.
class AuthButton extends StatelessComponent {
  /// Button label text
  final String label;

  /// Callback when button is clicked
  final void Function()? onPressed;

  /// Button style variant
  final AuthButtonVariant variant;

  /// Show loading spinner
  final bool loading;

  /// Make button full width
  final bool fullWidth;

  /// Whether the button is disabled
  final bool disabled;

  /// Button type (submit, button, reset)
  final String type;

  const AuthButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AuthButtonVariant.primary,
    this.loading = false,
    this.fullWidth = true,
    this.disabled = false,
    this.type = 'button',
  });

  @override
  Component build(BuildContext context) {
    final isDisabled = disabled || loading;

    return button(
      type: type == 'submit' ? ButtonType.submit : ButtonType.button,
      disabled: isDisabled,
      events: {
        'click': (event) {
          if (!isDisabled && onPressed != null) {
            onPressed!();
          }
        },
      },
      styles: Styles(raw: _getStyles()),
      [
        if (loading) _buildSpinner(),
        span(
          styles: Styles(raw: {
            'opacity': loading ? '0' : '1',
          }),
          [Component.text(label)],
        ),
      ],
    );
  }

  Map<String, String> _getStyles() {
    final baseStyles = {
      'display': 'inline-flex',
      'align-items': 'center',
      'justify-content': 'center',
      'gap': '8px',
      'padding': '12px 24px',
      'font-size': '15px',
      'font-weight': '600',
      'font-family': 'inherit',
      'border-radius': '8px',
      'cursor': disabled || loading ? 'not-allowed' : 'pointer',
      'transition': 'all 0.2s ease',
      'position': 'relative',
      'width': fullWidth ? '100%' : 'auto',
      'opacity': disabled ? '0.5' : '1',
    };

    switch (variant) {
      case AuthButtonVariant.primary:
        return {
          ...baseStyles,
          'background': 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
          'color': '#ffffff',
          'border': 'none',
          'box-shadow': '0 0 20px rgba(16, 185, 129, 0.3)',
        };

      case AuthButtonVariant.secondary:
        return {
          ...baseStyles,
          'background': 'transparent',
          'color': '#fafafa',
          'border': '1px solid #27272a',
        };

      case AuthButtonVariant.ghost:
        return {
          ...baseStyles,
          'background': 'transparent',
          'color': '#a1a1aa',
          'border': 'none',
          'padding': '8px 16px',
        };
    }
  }

  Component _buildSpinner() {
    return div(
      styles: Styles(raw: {
        'position': 'absolute',
        'display': 'flex',
        'align-items': 'center',
        'justify-content': 'center',
      }),
      [
        div(
          styles: Styles(raw: {
            'width': '18px',
            'height': '18px',
            'border': '2px solid transparent',
            'border-top-color': variant == AuthButtonVariant.primary
                ? '#ffffff'
                : '#10b981',
            'border-radius': '50%',
            'animation': 'spin 0.8s linear infinite',
          }),
          [],
        ),
      ],
    );
  }
}
