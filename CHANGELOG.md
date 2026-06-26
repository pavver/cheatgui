# Changelog

All notable changes to Cheatgui are documented in this file.

## Unreleased - 2026-06-27

### Added

- Added a key-based i18n system with a complete English catalog and automatic
  English fallback for missing translations (`c2a4025`).
- Added locale catalog files for every language officially supported by Noita
  (`c2a4025`).
- Added complete Russian and Ukrainian translations. Ukrainian language mods
  are recognized through both `uk` and `ua` locale aliases (`6337c3b`).
- Added a complete German translation.
- Added a complete Spanish translation.
- Added UTF-8 helpers for text input, case normalization, and safe character
  deletion (`c3b74f7`).

### Removed

- Removed the legacy web console, its bundled frontend, Pollnet bindings, and
  the external `pollnet.dll` requirement.

### Changed

- Localized spell, perk, material, and item names are now displayed by default
  (`760d4a7`).
- Item translation keys are now resolved through Noita's built-in localization
  function instead of being shown as raw keys (`760d4a7`).
- Moved all user-facing menu labels, panel names, buttons, status messages,
  material categories, console messages, and information widgets from
  hardcoded strings into locale catalogs (`c2a4025`).
- Fungal-shift predictions and selected materials now use their localized
  names (`c2a4025`).
- Always-cast spell selections now display localized spell names in the wand
  builder (`c2a4025`).
- Menu filters now search localized names, original English game translations,
  and technical IDs at the same time.

### Fixed

- Replaced unreliable locale detection through `GameTextGet("x")` with the
  translated `$current_language` game key (`ee757a2`).
- Added mappings for Noita's localized language names, including Russian and
  Ukrainian (`ee757a2`).
- Fixed menu filters rejecting non-ASCII input such as Cyrillic characters
  (`c3b74f7`).
- Fixed Backspace corrupting UTF-8 text by deleting only one byte of a
  multi-byte character (`c3b74f7`).
- Made filtering case-insensitive for Cyrillic and supported accented Latin
  characters (`c3b74f7`).
- Made filter matching literal so characters meaningful to Lua patterns no
  longer break or alter searches (`c3b74f7`).
- Switched filter typing to SDL's UTF-8 text-input events so active keyboard
  layouts and input methods can provide non-Latin text under compatibility
  layers such as Proton.
- Prevented the Shift modifier used to activate filtering from forcing all
  entered text to uppercase.
