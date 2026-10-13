# Quickstart & Verification Guide: Catalog & Product Management (002-catalog-management)

**Date**: 2026-10-13
**Feature**: [spec.md](./spec.md)

## Summary

This guide describes how to verify the offline Excel import, Drift SQLite products catalog, Arabic normalization search, and product maintenance flows locally.

## Prerequisites

- Flutter 3.47.5 / Dart 3.13.4 installed and in PATH.
- Git branch: `002-catalog-management`.

## Commands

### 1. Format and Static Analysis

```powershell
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze lib test integration_test
```

### 2. Code Generation (Drift Migration v2)

```powershell
dart run build_runner build --delete-conflicting-outputs
```

### 3. Automated Test Suite

```powershell
# Run all unit, widget, and database tests
flutter test

# Run catalog specific tests
flutter test test/features/products/
```

### 4. Acceptance Scenarios Verification

- **Excel Import Verification**: Run `test/features/products/data/excel_importer_test.dart` to verify that 1,000 simulated rows are parsed and validated in under 3 seconds in a background isolate.
- **Arabic Search Normalization**: Run `test/features/products/data/arabic_search_normalization_test.dart` to verify that `كوع ١/٢`, `كوع 1/2`, and `كوع نصف بوصة` match predictably.
- **Drift Migration Verification**: Run `test/core/database/migrations/migration_v2_test.dart` to verify that an existing v1 database upgrades smoothly without losing settings or failing pragmas.
