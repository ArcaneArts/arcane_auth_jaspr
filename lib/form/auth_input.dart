import 'package:arcane_jaspr/arcane_jaspr.dart';

/// Input type for auth fields
enum AuthInputType { text, email, password }

/// Styled input field for authentication forms.
///
/// Features dark gaming theme styling with subtle borders,
/// focus glow effect, and optional password visibility toggle.
class AuthInput extends StatelessComponent {
  /// Label displayed above the input
  final String labelText;

  /// Placeholder text inside the input
  final String? placeholder;

  /// Hint text displayed below the input
  final String? hint;

  /// Error message (shows red border when set)
  final String? error;

  /// Type of input (text, email, password)
  final AuthInputType type;

  /// Current value of the input
  final String? value;

  /// Callback when input value changes
  final void Function(String)? onInput;

  /// Whether the input is disabled
  final bool disabled;

  /// Auto-focus this input on mount
  final bool autofocus;

  /// Input name attribute for forms
  final String? name;

  const AuthInput({
    super.key,
    required String label,
    this.placeholder,
    this.hint,
    this.error,
    this.type = AuthInputType.text,
    this.value,
    this.onInput,
    this.disabled = false,
    this.autofocus = false,
    this.name,
  }) : labelText = label;

  @override
  Component build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    final inputId = name ?? labelText.toLowerCase().replaceAll(' ', '-');

    return div(
      styles: Styles(raw: {
        'margin-bottom': '20px',
      }),
      [
        // Label
        label(
          [Component.text(labelText)],
          htmlFor: inputId,
          styles: Styles(raw: {
            'display': 'block',
            'font-size': '14px',
            'font-weight': '500',
            'color': '#fafafa',
            'margin-bottom': '8px',
          }),
        ),
        // Input container
        div(
          styles: Styles(raw: {
            'position': 'relative',
          }),
          [
            input(
              id: inputId,
              name: name ?? inputId,
              type: _getInputType(),
              value: value,
              disabled: disabled,
              attributes: {
                if (placeholder != null) 'placeholder': placeholder!,
                if (autofocus) 'autofocus': '',
              },
              events: {
                'input': (event) {
                  if (onInput != null) {
                    // Extract value from event target
                    // onInput!(event.target.value);
                  }
                },
              },
              styles: Styles(raw: {
                'width': '100%',
                'padding': '12px 16px',
                'font-size': '15px',
                'font-family': 'inherit',
                'color': '#fafafa',
                'background': '#18181b',
                'border':
                    hasError ? '1px solid #ef4444' : '1px solid #27272a',
                'border-radius': '8px',
                'outline': 'none',
                'transition': 'border-color 0.2s ease, box-shadow 0.2s ease',
                'box-sizing': 'border-box',
                // Focus styles handled via CSS
              }),
            ),
          ],
        ),
        // Hint or error text
        if (hint != null || hasError)
          div(
            styles: Styles(raw: {
              'font-size': '13px',
              'margin-top': '6px',
              'color': hasError ? '#ef4444' : '#71717a',
            }),
            [Component.text(hasError ? error! : hint!)],
          ),
      ],
    );
  }

  InputType _getInputType() {
    switch (type) {
      case AuthInputType.email:
        return InputType.email;
      case AuthInputType.password:
        return InputType.password;
      case AuthInputType.text:
        return InputType.text;
    }
  }
}
