# Year 2 Adventure Academy — Godot game

This folder contains the Godot 4 prototype on branch `feat/godot-adventure-foundation`.

## Open locally
1. Install Godot 4.3 or a compatible Godot 4.x release.
2. Import `game/project.godot` in Godot.
3. Run the main scene.

## Current foundation
- Horizontally explorable academy scene drawn with Godot primitives.
- Keyboard and on-screen movement/jump controls.
- Local Year 2 question bank for maths, English and science.
- Score tracking and generated sound effects.
- Reusable MusabAI adapter for OpenAI-compatible chat-completions APIs, ordered provider fallback and basic response validation.

## Configure MusabAI
The game works offline without AI. The adapter reads `user://musab_ai.cfg`; see `musab_ai.example.cfg` for the format. Configure an endpoint, model ID and optional API key for each provider section (`provider_0`, `provider_1`, etc.). Providers are attempted in section order; failed or invalid responses advance to the next one.

- This does not guarantee a provider is free or available. Check current terms, quotas and endpoint format.
- Do not commit real API keys. Keys packaged in an APK can be extracted; a private backend/proxy is safer for production.
- Only OpenAI-compatible chat-completions responses are supported currently.

## Not yet complete
- The adapter is reusable but not yet wired into the visible game UI.
- Native Android Text-to-Speech / spoken questions.
- Full curriculum-aligned content and independent educational review.
- Persistent progress and parent/teacher settings.
- Android export templates, APK build, and real-device QA.
