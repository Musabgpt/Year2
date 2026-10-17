# Year 2 Adventure Academy — Godot game

This folder contains the initial Godot 4 project foundation on branch `feat/godot-adventure-foundation`.

## Open locally
1. Install Godot 4.3 or a compatible Godot 4.x release.
2. Import `game/project.godot` in Godot.
3. Run the main scene.

## Current foundation
- A horizontally explorable academy scene drawn with Godot primitives.
- Keyboard and on-screen movement/jump controls.
- A local Year 2 question loop with maths, English and science examples.
- Score tracking and a sound toggle UI.

## Not yet implemented / not claimed as complete
- MusabAI provider integration and automatic provider failover.
- Spoken questions / Android Text-to-Speech.
- Real audio assets and sound effects (the tone function is currently a placeholder).
- Persistent progress, validated question generation, full curriculum coverage.
- Android export configuration, APK build and device testing.

The first slice is deliberately offline-first. Provider integration should be added behind a dedicated adapter after the existing MusabAI interfaces and provider licences/quotas have been reviewed.
