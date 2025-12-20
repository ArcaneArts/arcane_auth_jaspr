/// Arcane Auth Jaspr - Firebase authentication for Jaspr web applications
///
/// A complete authentication solution with OAuth providers (GitHub, Google, Apple)
/// and email/password support.
///
/// ## Quick Start
///
/// 1. Wrap your app with [ArcaneAuthProvider]:
/// ```dart
/// ArcaneAuthProvider(
///   serverApiUrl: 'https://api.example.com',
///   redirectOnLogin: '/dashboard',
///   redirectOnLogout: '/login',
///   child: const AppRouter(),
/// )
/// ```
///
/// 2. Use [ArcaneLoginCard] for the login screen:
/// ```dart
/// ArcaneLoginCard(
///   methods: [AuthMethod.email, AuthMethod.github, AuthMethod.google],
///   signupRoute: '/signup',
///   forgotPasswordRoute: '/forgot-password',
/// )
/// ```
///
/// 3. Protect routes with [AuthGuard]:
/// ```dart
/// AuthGuard(
///   redirectTo: '/login',
///   child: DashboardScreen(),
/// )
/// ```
///
/// 4. Access auth state from any component:
/// ```dart
/// if (context.isAuthenticated) {
///   print('User: ${context.currentUser?.email}');
/// }
///
/// // Sign in
/// await context.signInWithGitHub();
///
/// // Sign out
/// await context.signOut();
/// ```
library arcane_auth_jaspr;

// Re-export arcane_jaspr for convenience
export 'package:arcane_jaspr/arcane_jaspr.dart';

// ============================================================================
// Service
// ============================================================================
export 'service/auth_state.dart';
export 'service/auth_service.dart';

// ============================================================================
// Provider
// ============================================================================
export 'provider/auth_provider.dart';
export 'provider/auth_guard.dart';

// ============================================================================
// Components
// ============================================================================
export 'component/login_card.dart';
export 'component/signup_card.dart';
export 'component/forgot_password_card.dart';

// ============================================================================
// Buttons
// ============================================================================
export 'button/social_button.dart';
export 'button/github_button.dart';
export 'button/google_button.dart';
export 'button/apple_button.dart';

// ============================================================================
// Utilities
// ============================================================================
export 'util/password_policy.dart';

// ============================================================================
// Layout
// ============================================================================
export 'layout/auth_split_layout.dart';

// ============================================================================
// Form Components
// ============================================================================
export 'form/auth_input.dart';
export 'form/auth_button.dart';
export 'form/auth_divider.dart';
export 'form/auth_social_row.dart';
export 'form/auth_form_card.dart';

// ============================================================================
// View Components
// ============================================================================
export 'view/auth_branding_panel.dart';
