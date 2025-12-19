import 'package:arcane_jaspr/arcane_jaspr.dart';

import '../provider/auth_provider.dart';

/// Forgot password card component
///
/// Provides a password reset UI with email input.
///
/// ```dart
/// ArcaneForgotPasswordCard(
///   loginRoute: '/login',
///   header: Logo(),
/// )
/// ```
class ArcaneForgotPasswordCard extends StatefulComponent {
  /// Header component (logo, title, etc.)
  final Component? header;

  /// Route for login link
  final String? loginRoute;

  /// Callback when email is sent successfully
  final void Function()? onSuccess;

  /// Max width of the card
  final String maxWidth;

  const ArcaneForgotPasswordCard({
    this.header,
    this.loginRoute,
    this.onSuccess,
    this.maxWidth = '400px',
    super.key,
  });

  @override
  State<ArcaneForgotPasswordCard> createState() =>
      _ArcaneForgotPasswordCardState();
}

class _ArcaneForgotPasswordCardState extends State<ArcaneForgotPasswordCard> {
  String _email = '';
  bool _loading = false;
  bool _sent = false;
  String? _error;

  Future<void> _handleSubmit() async {
    if (_email.isEmpty) {
      setState(() => _error = 'Please enter your email.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.sendPasswordResetEmail(_email);
      setState(() {
        _sent = true;
        _loading = false;
      });
      component.onSuccess?.call();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(raw: <String, String>{
        'width': '100%',
        'max-width': component.maxWidth,
        'padding': ArcaneSpacing.xl,
        'background': 'var(--arcane-card, #18181b)',
        'border': '1px solid var(--arcane-border, #27272a)',
        'border-radius': 'var(--arcane-radius-lg, 12px)',
        'box-shadow': 'var(--arcane-shadow-lg)',
      }),
      <Component>[
        // Header
        if (component.header != null) ...<Component>[
          component.header!,
          div(styles: Styles(raw: <String, String>{'height': ArcaneSpacing.lg}), <Component>[]),
        ],

        // Title
        h2(
          styles: Styles(raw: <String, String>{
            'margin': '0 0 ${ArcaneSpacing.xs} 0',
            'font-size': ArcaneTypography.fontXl,
            'font-weight': ArcaneTypography.weightSemibold,
            'color': 'var(--arcane-on-surface, #fafafa)',
            'text-align': 'center',
          }),
          <Component>[Component.text(_sent ? 'Check your email' : 'Reset password')],
        ),

        p(
          styles: Styles(raw: <String, String>{
            'margin': '0 0 ${ArcaneSpacing.lg} 0',
            'font-size': ArcaneTypography.fontSm,
            'color': 'var(--arcane-muted-foreground, #a1a1aa)',
            'text-align': 'center',
          }),
          <Component>[
            Component.text(_sent
                ? "We've sent a password reset link to $_email"
                : 'Enter your email and we\'ll send you a reset link'),
          ],
        ),

        // Success message
        if (_sent)
          div(
            styles: Styles(raw: <String, String>{
              'padding': ArcaneSpacing.md,
              'margin-bottom': ArcaneSpacing.md,
              'background': 'rgba(16, 185, 129, 0.1)',
              'border': '1px solid rgba(16, 185, 129, 0.3)',
              'border-radius': 'var(--arcane-radius-md, 8px)',
              'color': '#10b981',
              'font-size': ArcaneTypography.fontSm,
              'text-align': 'center',
            }),
            <Component>[
              Component.text('Check your inbox for the password reset link.'),
            ],
          ),

        // Error message
        if (_error != null)
          div(
            styles: Styles(raw: <String, String>{
              'padding': ArcaneSpacing.md,
              'margin-bottom': ArcaneSpacing.md,
              'background': 'rgba(239, 68, 68, 0.1)',
              'border': '1px solid rgba(239, 68, 68, 0.3)',
              'border-radius': 'var(--arcane-radius-md, 8px)',
              'color': '#ef4444',
              'font-size': ArcaneTypography.fontSm,
            }),
            <Component>[Component.text(_error!)],
          ),

        // Form (hidden if sent)
        if (!_sent)
          form(
            events: {
              'submit': (event) {
                event.preventDefault();
                _handleSubmit();
              },
            },
            <Component>[
              // Email field
              div(
                styles: Styles(raw: <String, String>{'margin-bottom': ArcaneSpacing.lg}),
                <Component>[
                  label(
                    styles: Styles(raw: <String, String>{
                      'display': 'block',
                      'margin-bottom': ArcaneSpacing.xs,
                      'font-size': ArcaneTypography.fontSm,
                      'font-weight': ArcaneTypography.weightMedium,
                      'color': 'var(--arcane-on-surface, #fafafa)',
                    }),
                    <Component>[Component.text('Email')],
                  ),
                  input(
                    attributes: <String, String>{
                      'type': 'email',
                      'placeholder': 'you@example.com',
                      'autocomplete': 'email',
                      'required': 'true',
                    },
                    styles: Styles(raw: <String, String>{
                      'width': '100%',
                      'padding': '${ArcaneSpacing.sm} ${ArcaneSpacing.md}',
                      'font-size': ArcaneTypography.fontSm,
                      'background': 'var(--arcane-input, #27272a)',
                      'border': '1px solid var(--arcane-border, #3f3f46)',
                      'border-radius': 'var(--arcane-radius-md, 8px)',
                      'color': 'var(--arcane-on-surface, #fafafa)',
                      'outline': 'none',
                      'transition': 'border-color 150ms ease',
                      'box-sizing': 'border-box',
                    }),
                    events: {
                      'input': (event) {
                        final dynamic target = event.target;
                        if (target != null) {
                          setState(() => _email = (target as dynamic).value ?? '');
                        }
                      },
                    },
                  ),
                ],
              ),

              // Submit button
              ArcaneButton.primary(
                label: _loading ? 'Sending...' : 'Send reset link',
                fullWidth: true,
                disabled: _loading,
                loading: _loading,
                onPressed: _handleSubmit,
              ),
            ],
          ),

        // Try again button (shown after sent)
        if (_sent)
          ArcaneButton.outline(
            label: 'Try another email',
            fullWidth: true,
            onPressed: () => setState(() => _sent = false),
          ),

        // Back to login link
        if (component.loginRoute != null)
          div(
            styles: Styles(raw: <String, String>{
              'margin-top': ArcaneSpacing.lg,
              'text-align': 'center',
            }),
            <Component>[
              a(
                href: component.loginRoute!,
                styles: Styles(raw: <String, String>{
                  'font-size': ArcaneTypography.fontSm,
                  'color': 'var(--arcane-accent, #10b981)',
                  'text-decoration': 'none',
                }),
                <Component>[Component.text('Back to sign in')],
              ),
            ],
          ),
      ],
    );
  }
}
