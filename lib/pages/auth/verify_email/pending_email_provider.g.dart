// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_email_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stores the email address of a user who just signed up
/// but doesn't have an active session yet
// pending_email_provider.dart

@ProviderFor(PendingVerificationEmail)
final pendingVerificationEmailProvider = PendingVerificationEmailProvider._();

/// Stores the email address of a user who just signed up
/// but doesn't have an active session yet
// pending_email_provider.dart
final class PendingVerificationEmailProvider
    extends $NotifierProvider<PendingVerificationEmail, String?> {
  /// Stores the email address of a user who just signed up
  /// but doesn't have an active session yet
  // pending_email_provider.dart
  PendingVerificationEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingVerificationEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingVerificationEmailHash();

  @$internal
  @override
  PendingVerificationEmail create() => PendingVerificationEmail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingVerificationEmailHash() =>
    r'cde214edc40fbff5492fb8ba19537b84c79d6ddb';

/// Stores the email address of a user who just signed up
/// but doesn't have an active session yet
// pending_email_provider.dart

abstract class _$PendingVerificationEmail extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
