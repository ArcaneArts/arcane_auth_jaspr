import 'package:arcane_jaspr/arcane_jaspr.dart';

import '../button/github_button.dart';
import '../button/google_button.dart';
import '../button/apple_button.dart';
import '../provider/auth_provider.dart';
import '../service/auth_state.dart';
import '../util/password_policy.dart';

/// Signup card component
///
/// Provides a complete registration UI with email/password form and social sign-in buttons.
///
/// ```dart
/// ArcaneSignupCard(
///   methods: [AuthMethod.email, AuthMethod.github, AuthMethod.google],
///   loginRoute: '/login',
///   header: Logo(),
/// )
/// ```
class ArcaneSignupCard extends StatefulComponent {
  /// Authentication methods to display
  final List<AuthMethod> methods;

  /// Header component (logo, title, etc.)
  final Component? header;

  /// Route for login link
  final String? loginRoute;

  /// Password validation policy
  final PasswordPolicy passwordPolicy;

  /// Terms of service URL
  final String? termsUrl;

  /// Privacy policy URL
  final String? privacyUrl;

  /// Callback when registration succeeds
  final void Function()? onSuccess;

  /// Max width of the card
  final String maxWidth;

  const ArcaneSignupCard({
    this.methods = const <AuthMethod>[
      AuthMethod.email,
      AuthMethod.github,
      AuthMethod.google,
    ],
    this.header,
    this.loginRoute,
    this.passwordPolicy = const PasswordPolicy(),
    this.termsUrl,
    this.privacyUrl,
    this.onSuccess,
    this.maxWidth = '400px',
    super.key,
  });

  @override
  State<ArcaneSignupCard> createState() => _ArcaneSignupCardState();
}

class _ArcaneSignupCardState extends State<ArcaneSignupCard> {
  String _displayName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _acceptedTerms = false;
  bool _loading = false;
  String? _error;

  bool get _hasEmailMethod => component.methods.contains(AuthMethod.email);
  bool get _hasGithubMethod => component.methods.contains(AuthMethod.github);
  bool get _hasGoogleMethod => component.methods.contains(AuthMethod.google);
  bool get _hasAppleMethod => component.methods.contains(AuthMethod.apple);
  bool get _hasSocialMethods =>
      _hasGithubMethod || _hasGoogleMethod || _hasAppleMethod;
  bool get _hasTerms => component.termsUrl != null || component.privacyUrl != null;

  Future<void> _handleSubmit() async {
    print('[SignupCard] handleSubmit called');
    print('[SignupCard] displayName="$_displayName", email="$_email"');
    // Validation
    if (_displayName.isEmpty) {
      print('[SignupCard] Validation failed: displayName is empty');
      setState(() => _error = 'Please enter your name.');
      return;
    }
    if (_email.isEmpty) {
      setState(() => _error = 'Please enter your email.');
      return;
    }
    if (_password.isEmpty) {
      setState(() => _error = 'Please enter a password.');
      return;
    }

    // Password policy validation
    final String? passwordError = component.passwordPolicy.validate(_password);
    if (passwordError != null) {
      setState(() => _error = passwordError);
      return;
    }

    if (_password != _confirmPassword) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }

    if (_hasTerms && !_acceptedTerms) {
      setState(() => _error = 'Please accept the terms and conditions.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.registerWithEmail(_email, _password, _displayName);
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
          <Component>[Component.text('Create an account')],
        ),

        p(
          styles: Styles(raw: <String, String>{
            'margin': '0 0 ${ArcaneSpacing.lg} 0',
            'font-size': ArcaneTypography.fontSm,
            'color': 'var(--arcane-muted-foreground, #a1a1aa)',
            'text-align': 'center',
          }),
          <Component>[Component.text('Get started with your free account')],
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
                  label: 'Sign up with GitHub',
                  fullWidth: true,
                  disabled: _loading,
                ),
              if (_hasGoogleMethod)
                GoogleSignInButton(
                  label: 'Sign up with Google',
                  fullWidth: true,
                  disabled: _loading,
                ),
              if (_hasAppleMethod)
                AppleSignInButton(
                  label: 'Sign up with Apple',
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
                _handleSubmit();
              },
            },
            <Component>[
              // Display name field
              _buildField(
                labelText: 'Name',
                type: 'text',
                placeholder: 'Your name',
                autocomplete: 'name',
                onChanged: (String value) => setState(() => _displayName = value),
              ),

              // Email field
              _buildField(
                labelText: 'Email',
                type: 'email',
                placeholder: 'you@example.com',
                autocomplete: 'email',
                onChanged: (String value) => setState(() => _email = value),
              ),

              // Password field
              _buildField(
                labelText: 'Password',
                type: 'password',
                placeholder: 'Create a password',
                autocomplete: 'new-password',
                hint: component.passwordPolicy.description,
                onChanged: (String value) => setState(() => _password = value),
              ),

              // Confirm password field
              _buildField(
                labelText: 'Confirm Password',
                type: 'password',
                placeholder: 'Confirm your password',
                autocomplete: 'new-password',
                onChanged: (String value) =>
                    setState(() => _confirmPassword = value),
              ),

              // Terms checkbox
              if (_hasTerms)
                div(
                  styles: Styles(raw: <String, String>{
                    'display': 'flex',
                    'align-items': 'flex-start',
                    'gap': ArcaneSpacing.sm,
                    'margin-bottom': ArcaneSpacing.lg,
                  }),
                  <Component>[
                    input(
                      attributes: <String, String>{
                        'type': 'checkbox',
                        'id': 'terms',
                        if (_acceptedTerms) 'checked': 'true',
                      },
                      styles: Styles(raw: <String, String>{
                        'margin-top': '2px',
                        'accent-color': 'var(--arcane-accent, #10b981)',
                      }),
                      events: {
                        'change': (event) {
                          final dynamic target = event.target;
                          if (target != null) {
                            setState(() => _acceptedTerms = (target as dynamic).checked ?? false);
                          }
                        },
                      },
                    ),
                    label(
                      attributes: <String, String>{'for': 'terms'},
                      styles: Styles(raw: <String, String>{
                        'font-size': ArcaneTypography.fontSm,
                        'color': 'var(--arcane-muted-foreground, #a1a1aa)',
                        'cursor': 'pointer',
                      }),
                      <Component>[
                        Component.text('I agree to the '),
                        if (component.termsUrl != null)
                          a(
                            href: component.termsUrl!,
                            attributes: <String, String>{'target': '_blank'},
                            styles: Styles(raw: <String, String>{
                              'color': 'var(--arcane-accent, #10b981)',
                              'text-decoration': 'none',
                            }),
                            <Component>[Component.text('Terms of Service')],
                          ),
                        if (component.termsUrl != null &&
                            component.privacyUrl != null)
                          Component.text(' and '),
                        if (component.privacyUrl != null)
                          a(
                            href: component.privacyUrl!,
                            attributes: <String, String>{'target': '_blank'},
                            styles: Styles(raw: <String, String>{
                              'color': 'var(--arcane-accent, #10b981)',
                              'text-decoration': 'none',
                            }),
                            <Component>[Component.text('Privacy Policy')],
                          ),
                      ],
                    ),
                  ],
                ),

              // Submit button
              ArcaneButton.primary(
                label: _loading ? 'Creating account...' : 'Create account',
                fullWidth: true,
                disabled: _loading,
                loading: _loading,
                onPressed: _handleSubmit,
              ),
            ],
          ),

        // Login link
        if (component.loginRoute != null)
          div(
            styles: Styles(raw: <String, String>{
              'margin-top': ArcaneSpacing.lg,
              'text-align': 'center',
              'font-size': ArcaneTypography.fontSm,
              'color': 'var(--arcane-muted-foreground, #a1a1aa)',
            }),
            <Component>[
              Component.text('Already have an account? '),
              a(
                href: component.loginRoute!,
                styles: Styles(raw: <String, String>{
                  'color': 'var(--arcane-accent, #10b981)',
                  'text-decoration': 'none',
                  'font-weight': ArcaneTypography.weightMedium,
                }),
                <Component>[Component.text('Sign in')],
              ),
            ],
          ),
      ],
    );
  }

  Component _buildField({
    required String labelText,
    required String type,
    required String placeholder,
    required String autocomplete,
    required void Function(String) onChanged,
    String? hint,
  }) {
    return div(
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
          <Component>[Component.text(labelText)],
        ),
        input(
          attributes: <String, String>{
            'type': type,
            'placeholder': placeholder,
            'autocomplete': autocomplete,
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
                final String value = (target as dynamic).value ?? '';
                print('[SignupCard] Input changed for $labelText: "$value"');
                onChanged(value);
              }
            },
          },
        ),
        if (hint != null)
          p(
            styles: Styles(raw: <String, String>{
              'margin': '${ArcaneSpacing.xs} 0 0 0',
              'font-size': ArcaneTypography.fontXs,
              'color': 'var(--arcane-muted-foreground, #71717a)',
            }),
            <Component>[Component.text(hint)],
          ),
      ],
    );
  }
}
