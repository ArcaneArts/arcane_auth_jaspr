import 'package:arcane_jaspr/arcane_jaspr.dart';

/// Split-screen layout for authentication pages.
///
/// Renders a two-column layout with branding content on the left
/// and form content on the right. On mobile, only the form panel
/// is shown with an optional header.
class AuthSplitLayout extends StatelessComponent {
  /// Content for the left branding panel
  final Component brandingContent;

  /// Content for the right form panel
  final Component formContent;

  /// Optional header shown on mobile (when branding panel is hidden)
  final Component? mobileHeader;

  /// Swap the left and right panels
  final bool reverseSides;

  const AuthSplitLayout({
    super.key,
    required this.brandingContent,
    required this.formContent,
    this.mobileHeader,
    this.reverseSides = false,
  });

  @override
  Component build(BuildContext context) {
    final leftPanel = _buildBrandingPanel();
    final rightPanel = _buildFormPanel();

    return div(
      styles: Styles(raw: {
        'display': 'flex',
        'min-height': '100vh',
        'background': '#09090b',
      }),
      [
        // Branding panel (hidden on mobile)
        if (!reverseSides) leftPanel else rightPanel,
        // Form panel
        if (!reverseSides) rightPanel else leftPanel,
      ],
    );
  }

  Component _buildBrandingPanel() {
    return div(
      styles: Styles(raw: {
        'flex': '1',
        'display': 'flex',
        'flex-direction': 'column',
        'justify-content': 'center',
        'padding': '48px',
        'position': 'relative',
        'overflow': 'hidden',
        'background': '#0a0a0c',
        // Hide on mobile
        '@media (max-width: 1024px)': 'display: none',
      }),
      [
        // Background gradient glow
        div(
          styles: Styles(raw: {
            'position': 'absolute',
            'inset': '0',
            'pointer-events': 'none',
          }),
          [
            // Top-left green glow
            div(
              styles: Styles(raw: {
                'position': 'absolute',
                'top': '-20%',
                'left': '-10%',
                'width': '60%',
                'height': '60%',
                'background':
                    'radial-gradient(circle, rgba(16, 185, 129, 0.12) 0%, transparent 70%)',
              }),
              [],
            ),
            // Bottom-right cyan glow
            div(
              styles: Styles(raw: {
                'position': 'absolute',
                'bottom': '-20%',
                'right': '-10%',
                'width': '50%',
                'height': '50%',
                'background':
                    'radial-gradient(circle, rgba(6, 182, 212, 0.08) 0%, transparent 70%)',
              }),
              [],
            ),
            // Subtle grid pattern
            div(
              styles: Styles(raw: {
                'position': 'absolute',
                'inset': '0',
                'background-image':
                    'linear-gradient(rgba(255, 255, 255, 0.02) 1px, transparent 1px), linear-gradient(90deg, rgba(255, 255, 255, 0.02) 1px, transparent 1px)',
                'background-size': '40px 40px',
              }),
              [],
            ),
          ],
        ),
        // Content
        div(
          styles: Styles(raw: {
            'position': 'relative',
            'z-index': '1',
            'max-width': '480px',
            'margin': '0 auto',
          }),
          [brandingContent],
        ),
      ],
    );
  }

  Component _buildFormPanel() {
    return div(
      styles: Styles(raw: {
        'flex': '1',
        'display': 'flex',
        'flex-direction': 'column',
        'justify-content': 'center',
        'align-items': 'center',
        'padding': '48px 24px',
        'background': '#09090b',
        'min-height': '100vh',
      }),
      [
        // Mobile header (only shown on mobile when branding panel is hidden)
        if (mobileHeader != null)
          div(
            styles: Styles(raw: {
              'display': 'none',
              'margin-bottom': '32px',
              '@media (max-width: 1024px)': 'display: block',
            }),
            [mobileHeader!],
          ),
        // Form content
        div(
          styles: Styles(raw: {
            'width': '100%',
            'max-width': '420px',
          }),
          [formContent],
        ),
      ],
    );
  }
}
