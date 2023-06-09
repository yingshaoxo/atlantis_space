mkdir -p /tmp/atlantis_flutter
flutter build apk --release --obfuscate --split-debug-info=/tmp/atlantis_space_flutter
flutter build appbundle --release --obfuscate --split-debug-info=/tmp/atlantis_space_flutter