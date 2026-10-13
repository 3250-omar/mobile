# Developer Quickstart: Quotations Management (003)

## Running the Verification Suite
```sh
# Format check
dart format --output=none --set-exit-if-changed lib test integration_test

# Static Analysis
flutter analyze lib test

# Build Runner
dart run build_runner build --delete-conflicting-outputs

# Automated Tests
flutter test
```

## Key Invariants to Remember
1. **Never use `double` for currency**: Always use `int` minor units (piastres / قروش).
2. **Snapshot immutability**: Once a quotation is accepted/finalized, its items must not depend on live catalog rows.
3. **Arabic numbers**: Normalize Eastern Arabic digits (`١٢٣`) to Western Arabic digits (`123`) before parsing in all text inputs.
