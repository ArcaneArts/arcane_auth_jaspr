import 'package:arcane_jaspr/arcane_jaspr.dart';

import '../button/github_button.dart';
import '../button/google_button.dart';
import '../button/apple_button.dart';
import '../provider/auth_provider.dart';
import '../service/auth_state.dart';
import '../util/password_policy.dart';

/// Login card component
///
/// Provides a complete login UI with email/password form and social sign-in buttons.
///
/// ```dart
/// ArcaneLoginCard(
///   methods: [AuthMethod.email, AuthMethod.github, AuthMethod.google],
///   signupRoute: '/signup',
///   forgotPasswordRoute: '/forgot-password',
///   header: Logo(),
/// )
/// ```
class ArcaneLoginCard extends StatefulComponent {
  /// Authentication methods to display
  final List<AuthMethod> methods;

  /// Header component (logo, title, etc.)
  final Component? header;

  /// Route for signup link
  final String? signupRoute;

  /// Route for forgot password link
  final String? forgotPasswordRoute;

  /// Password validation policy
  final PasswordPolicy? passwordPolicy;

  /// Callback when login succeeds
  final void Function()? onSuccess;

  /// Max width of the card
  final String maxWidth;

  const ArcaneLoginCard({
    this.methods = const <AuthMethod>[
      AuthMethod.email,
      AuthMethod.github,
      AuthMethod.google,
    ],
    this.header,
    this.signupRoute,
    this.forgotPasswordRoute,
    this.passwordPolicy,
    this.onSuccess,
    this.maxWidth = '400px',
    super.key,
  });

  @override
  State<ArcaneLoginCard> createState() => _ArcaneLoginCardState();
}

class _ArcaneLoginCardState extends State<ArcaneLoginCard> {
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  bool get _hasEmailMethod => component.methods.contains(AuthMethod.email);
  bool get _hasGithubMethod => component.methods.contains(AuthMethod.github);
  bool get _hasGoogleMethod => component.methods.contains(AuthMethod.google);
  bool get _hasAppleMethod => component.methods.contains(AuthMethod.apple);
  bool get _hasSocialMethods =>
      _hasGithubMethod || _hasGoogleMethod || _hasAppleMethod;

  Future<void> _handleEmailSubmit() async {
    if (_email.isEmpty || _password.isEmpty) {
      setState(() => _error = 'Please enter your email and password.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.signInWithEmail(_email, _password);
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
          <Component>[Component.text('Welcome back')],
        ),

        p(
          styles: Styles(raw: <String, String>{
            'margin': '0 0 ${ArcaneSpacing.lg} 0',
            'font-size': ArcaneTypography.fontSm,
            'color': 'var(--arcane-muted-foreground, #a1a1aa)',
            'text-align': 'center',
          }),
          <Component>[Component.text('Sign in to your account')],
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

        // Social sign-in buttons
        if (_hasSocialMethods) ...<Component>[
          div(
            styles: Styles(raw: <String, String>{
              'display': 'flex',
              'flex-direction': 'column',
              'gap': ArcaneSpacing.sm,
            }),
            <Component>[
              if (_hasGithubMethod)
                GithubSignInButton(
                  fullWidth: true,
                  disabled: _loading,
                ),
              if (_hasGoogleMethod)
                GoogleSignInButton(
                  fullWidth: true,
                  disabled: _loading,
                ),
              if (_hasAppleMethod)
                AppleSignInButton(
                  fullWidth: true,
                  disabled: _loading,
                ),
            ],
          ),
        ],

        // Divider
        if (_hasSocialMethods && _hasEmailMethod)
          div(
            styles: Styles(raw: <String, String>{
              'display': 'flex',
              'align-items': 'center',
              'gap': ArcaneSpacing.md,
              'margin': '${ArcaneSpacing.lg} 0',
            }),
            <Component>[
              div(
                styles: Styles(raw: <String, String>{
                  'flex': '1',
                  'height': '1px',
                  'background': 'var(--arcane-border, #27272a)',
                }),
                <Component>[],
              ),
              span(
                styles: Styles(raw: <String, String>{
                  'font-size': ArcaneTypography.fontXs,
                  'color': 'var(--arcane-muted-foreground, #71717a)',
                  'text-transform': 'uppercase',
                  'letter-spacing': '0.05em',
                }),
                <Component>[Component.text('or continue with email')],
              ),
              div(
                styles: Styles(raw: <String, String>{
                  'flex': '1',
                  'height': '1px',
                  'background': 'var(--arcane-border, #27272a)',
                }),
                <Component>[],
              ),
            ],
          ),

        // Email/password form
        if (_hasEmailMethod)
          form(
            events: {
              'submit': (event) {
                event.preventDefault();
                _handleEmailSubmit();
              },
            },
            <Component>[
              // Email field
              div(
                styles: Styles(raw: <String, String>{'margin-bottom': ArcaneSpacing.md}),
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

              // Password field
              div(
                styles: Styles(raw: <String, String>{'margin-bottom': ArcaneSpacing.md}),
                <Component>[
                  div(
                    styles: Styles(raw: <String, String>{
                      'display': 'flex',
                      'justify-content': 'space-between',
                      'align-items': 'center',
                      'margin-bottom': ArcaneSpacing.xs,
                    }),
                    <Component>[
                      label(
                        styles: Styles(raw: <String, String>{
                          'font-size': ArcaneTypography.fontSm,
                          'font-weight': ArcaneTypography.weightMedium,
                          'color': 'var(--arcane-on-surface, #fafafa)',
                        }),
                        <Component>[Component.text('Password')],
                      ),
                      if (component.forgotPasswordRoute != null)
                        a(
                          href: component.forgotPasswordRoute!,
                          styles: Styles(raw: <String, String>{
                            'font-size': ArcaneTypography.fontXs,
                            'color': 'var(--arcane-accent, #10b981)',
                            'text-decoration': 'none',
                          }),
                          <Component>[Component.text('Forgot password?')],
                        ),
                    ],
                  ),
                  input(
                    attributes: <String, String>{
                      'type': 'password',
                      'placeholder': 'Enter your password',
                      'autocomplete': 'current-password',
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
                          setState(() => _password = (target as dynamic).value ?? '');
                        }
                      },
                    },
                  ),
                ],
              ),

              // Submit button
              ArcaneButton.primary(
                label: _loading ? 'Signing in...' : 'Sign in',
                fullWidth: true,
                disabled: _loading,
                loading: _loading,
                onPressed: _handleEmailSubmit,
              ),
            ],
          ),

        // Signup link
        if (component.signupRoute != null)
          div(
            styles: Styles(raw: <String, String>{
              'margin-top': ArcaneSpacing.lg,
              'text-align': 'center',
              'font-size': ArcaneTypography.fontSm,
              'color': 'var(--arcane-muted-foreground, #a1a1aa)',
            }),
            <Component>[
              Component.text("Don't have an account? "),
              a(
                href: component.signupRoute!,
                styles: Styles(raw: <String, String>{
                  'color': 'var(--arcane-accent, #10b981)',
                  'text-decoration': 'none',
                  'font-weight': ArcaneTypography.weightMedium,
                }),
                <Component>[Component.text('Sign up')],
              ),
            ],
          ),
      ],
    );
  }
}
