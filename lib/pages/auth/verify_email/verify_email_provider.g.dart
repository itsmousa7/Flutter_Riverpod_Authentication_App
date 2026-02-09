// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VerifyEmail)
final verifyEmailProvider = VerifyEmailProvider._();

final class VerifyEmailProvider
    extends $AsyncNotifierProvider<VerifyEmail, void> {
  VerifyEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verifyEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verifyEmailHash();

  @$internal
  @override
  VerifyEmail create() => VerifyEmail();
}

String _$verifyEmailHash() => r'dc895fc5981d14d7449847ef214d28d3d4189e41';

abstract class _$VerifyEmail extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
