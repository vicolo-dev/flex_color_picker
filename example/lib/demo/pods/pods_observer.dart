import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../store/hive_store.dart';
import '../utils/keys.dart';

/// Provider "Pods" observer used to store the state of selected Riverpod
/// providers with Hive and debugPrint changes to them in none release mode.
class PodsObserver extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase<dynamic> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    // If it is a StateProvider we will save the value if...
    if (provider is StateProvider) {
      // If its new value is different from previous value AND
      // it is one that we have a named key for, we store it in Hive
      if (newValue != previousValue &&
          Keys.defaults.containsKey(provider.name)) {
        // Log the new value, but not in Release, just a debugPrint.
        if (!kReleaseMode) {
          debugPrint('HIVE PUT: ${provider.name ?? provider.runtimeType}\n'
              '  new value: $newValue\n'
              '  old value: $previousValue');
        }
        // Store the new value in our Hive box.
        hiveStore.put(provider.name, newValue);
      }
    }
  }
}
