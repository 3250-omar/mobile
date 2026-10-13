# Contract: Application Initialization

## Purpose

Define observable startup behavior without prescribing concrete classes.

## Inputs

- Compile-time environment value.
- OS-provided private application-support location.
- Local diagnostics, database, and settings adapters.

## Contract

1. Initialization is idempotent per attempt and single-flight; concurrent callers observe the same attempt.
2. It proceeds through configuration, diagnostics, path, database, migration, settings, and composition stages.
3. It performs no network call, runtime authentication, remote font load, or remote configuration.
4. The interactive shell is exposed only after all required stages succeed.
5. Retry disposes partial resources and starts a new attempt without deleting or overwriting existing database files.
6. A force close at any stage cannot leave a committed half-write; transactions provide safety.

## Observable results

- `ready(settings)`: Arabic shell may be used.
- `failed(failure)`: shell remains blocked; Arabic explanation, retry when applicable, and a diagnostic reference/action are available.
- A progress gate appears during initialization; there is no blank, frozen, or indefinitely silent state.

## Acceptance evidence

- Cold/warm offline launch tests.
- Concurrent-start single-flight test.
- Failure injection at each stage followed by retry.
- Force-close/relaunch around committed and uncommitted settings writes.

