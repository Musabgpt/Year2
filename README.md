# Year 2 Adventure Academy

Educational adventure for Year 2 pupils in England.

## Current implementation tracks

- The repository's existing root project remains the Rust-first Android app described by its original workflow.
- A separate Godot 4 prototype is being developed in `game/` on branch `feat/godot-adventure-foundation` to evaluate a richer 2D game experience before choosing the long-term engine.
- The Godot prototype currently contains a small explorable academy, on-screen movement/jump controls, local sample questions, score feedback, and generated beep effects.

## Godot prototype status

Open `game/project.godot` with Godot 4.3 or compatible Godot 4.x.

This is an early foundation, not a finished or APK-verified release. Spoken question narration, MusabAI/provider integration, provider failover, saved learning progress, complete curriculum coverage, Android export setup, and real-device QA remain to be implemented and verified. The `.github/workflows/godot-check.yml` workflow validates the project headlessly; passing that check alone does not prove an Android APK works on a phone.
