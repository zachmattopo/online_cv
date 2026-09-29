import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Whether the browser asks for reduced motion. The Flutter web engine does
/// not surface `prefers-reduced-motion`, so read the media query directly.
bool browserPrefersReducedMotion() {
  try {
    final query = globalContext.callMethod<JSObject>(
      'matchMedia'.toJS,
      '(prefers-reduced-motion: reduce)'.toJS,
    );
    return query.getProperty<JSBoolean>('matches'.toJS).toDart;
  } catch (_) {
    return false;
  }
}
