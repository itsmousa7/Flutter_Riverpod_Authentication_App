// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Signin)
final signinProvider = SigninProvider._();

final class SigninProvider extends $AsyncNotifierProvider<Signin, void> {
  SigninProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signinProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signinHash();

  @$internal
  @override
  Signin create() => Signin();
}

String _$signinHash() => r'2d20ab98ecaf964e341433e4c9c2870e4dd57e56';

abstract class _$Signin extends $AsyncNotifier<void> {
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
