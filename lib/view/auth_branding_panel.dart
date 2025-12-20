import 'package:arcane_jaspr/arcane_jaspr.dart';

/// Branding panel content for split-screen auth layouts.
///
/// Displays logo, tagline, feature list, and optional testimonial
/// with a dark gaming-themed design.
class AuthBrandingPanel extends StatelessComponent {
  /// URL to the logo image
  final String? logoUrl;

  /// Main tagline text
  final String tagline;

  /// Optional description text below tagline
  final String? description;

  /// List of feature highlights with checkmarks
  final List<String>? features;

  /// Optional testimonial quote
  final String? testimonialQuote;

  /// Optional testimonial author
  final String? testimonialAuthor;

  /// Optional testimonial author title/company
  final String? testimonialTitle;

  const AuthBrandingPanel({
    super.key,
    this.logoUrl,
    required this.tagline,
    this.description,
    this.features,
    this.testimonialQuote,
    this.testimonialAuthor,
    this.testimonialTitle,
  });

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(raw: {
        'display': 'flex',
        'flex-direction': 'column',
        'justify-content': 'center',
        'height': '100%',
      }),
      [
        // Logo
        if (logoUrl != null)
          div(
            styles: Styles(raw: {
              'margin-bottom': '40px',
            }),
            [
              img(
                src: logoUrl!,
                alt: 'Logo',
                styles: Styles(raw: {
                  'width': '48px',
                  'height': '48px',
                  'border-radius': '12px',
                  'object-fit': 'contain',
                }),
              ),
            ],
          ),

        // Tagline
        h2(
          styles: Styles(raw: {
            'font-size': '36px',
            'font-weight': '700',
            'color': '#fafafa',
            'margin': '0 0 16px 0',
            'line-height': '1.2',
            'letter-spacing': '-0.02em',
          }),
          [Component.text(tagline)],
        ),

        // Description
        if (description != null)
          p(
            styles: Styles(raw: {
              'font-size': '16px',
              'color': '#a1a1aa',
              'margin': '0 0 32px 0',
              'line-height': '1.6',
            }),
            [Component.text(description!)],
          ),

        // Features list
        if (features != null && features!.isNotEmpty)
          div(
            styles: Styles(raw: {
              'display': 'flex',
              'flex-direction': 'column',
              'gap': '16px',
              'margin-bottom': '40px',
            }),
            [
              for (final feature in features!)
                _buildFeatureItem(feature),
            ],
          ),

        // Testimonial
        if (testimonialQuote != null)
          _buildTestimonial(),
      ],
    );
  }

  Component _buildFeatureItem(String text) {
    return div(
      styles: Styles(raw: {
        'display': 'flex',
        'align-items': 'flex-start',
        'gap': '12px',
      }),
      [
        // Checkmark icon
        div(
          styles: Styles(raw: {
            'width': '20px',
            'height': '20px',
            'border-radius': '50%',
            'background': 'rgba(16, 185, 129, 0.15)',
            'display': 'flex',
            'align-items': 'center',
            'justify-content': 'center',
            'flex-shrink': '0',
            'margin-top': '2px',
          }),
          [
            RawText('''
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"></polyline>
              </svg>
            '''),
          ],
        ),
        // Feature text
        span(
          styles: Styles(raw: {
            'font-size': '15px',
            'color': '#d4d4d8',
            'line-height': '1.5',
          }),
          [Component.text(text)],
        ),
      ],
    );
  }

  Component _buildTestimonial() {
    return div(
      styles: Styles(raw: {
        'padding': '24px',
        'background': 'rgba(24, 24, 27, 0.5)',
        'border': '1px solid #27272a',
        'border-radius': '12px',
        'margin-top': 'auto',
      }),
      [
        // Quote
        p(
          styles: Styles(raw: {
            'font-size': '15px',
            'color': '#d4d4d8',
            'margin': '0 0 16px 0',
            'line-height': '1.6',
            'font-style': 'italic',
          }),
          [Component.text('"$testimonialQuote"')],
        ),
        // Author
        if (testimonialAuthor != null)
          div(
            styles: Styles(raw: {
              'display': 'flex',
              'align-items': 'center',
              'gap': '12px',
            }),
            [
              // Avatar placeholder
              div(
                styles: Styles(raw: {
                  'width': '36px',
                  'height': '36px',
                  'border-radius': '50%',
                  'background': 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                  'display': 'flex',
                  'align-items': 'center',
                  'justify-content': 'center',
                  'font-size': '14px',
                  'font-weight': '600',
                  'color': '#ffffff',
                }),
                [Component.text(testimonialAuthor![0].toUpperCase())],
              ),
              div([
                div(
                  styles: Styles(raw: {
                    'font-size': '14px',
                    'font-weight': '600',
                    'color': '#fafafa',
                  }),
                  [Component.text(testimonialAuthor!)],
                ),
                if (testimonialTitle != null)
                  div(
                    styles: Styles(raw: {
                      'font-size': '13px',
                      'color': '#71717a',
                    }),
                    [Component.text(testimonialTitle!)],
                  ),
              ]),
            ],
          ),
      ],
    );
  }
}
