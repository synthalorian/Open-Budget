# Open Budget v1.0.0

First public release. Offline-first personal finance tracker — no accounts, no ads, no cloud you didn't ask for.

## Highlights

- **Zero-based budgeting** with envelope-style category tracking
- **Transactions** — fast manual entry for income and expenses
- **Recurring transactions** — subscriptions and bills auto-logged
- **Savings goals** with progress and target-date math
- **Insights** — charts and category breakdowns over time
- **Financial education** — built-in tips and mini-courses
- **Encrypted backups** — AES-256 archives, local-only, shared via OS share sheet
- **Biometric lock** (optional) — fingerprint / face unlock on supported devices
- **Synthwave theme system** — multiple neon palettes
- **Dark-first UI** — designed for late-night money reviews
- **15/15 unit tests passing**, `flutter analyze` clean (0 errors, 0 warnings)

## Install (Android)

1. Download `OpenBudget-v1.0.0.apk` from the assets below.
2. On your Android device, enable **Install unknown apps** for your browser or file manager.
3. Open the APK and install.

**Signing note:** this APK is debug-signed. It is safe but Android will show an "app from unknown source" warning. A properly release-signed build will follow when the app lands on Google Play.

## Support the project

If Open Budget saves you money, kick a few bucks back:
**https://buymeacoffee.com/synthalorian**

## Known limitations

- Android only for this release. iOS build is wired but unreleased.
- Debug-signed (see above).
- No bank integration (manual entry + CSV import). Coming in v1.1.

## Roadmap

- **v1.1** — Play Store release (real signing key), tip jar IAP, bank import via CSV/OFX
- **v1.2** — Cloud sync via Syncthing or user-controlled server
- **v2.0** — Multi-user household budgets, investment tracking

## Stack

Flutter 3.4+ · Riverpod · Hive · Go Router · FL Chart

---

Built by synth and synthclaw. 🎹🦞

This is the wave.
