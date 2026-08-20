# Penablox Scripts

Roblox exploit scripts for Penablox HVH (PlaceId `122764594952227`). Target executor: **Volt**.

## Structure

- `Penablox.lua` — Original script (Fatality UI lib, ~3400 lines)
- `PenabloxV2.lua` — Rewrite on Skeet Framework UI (~2500 lines, active development)
- `volt_docs_combined.md` — Volt executor API reference

## What this is

Both `.lua` files are standalone scripts injected via Roblox executor. There is no build system, no tests, no linter, no package manager. Changes are verified by injecting into the live game.

## Key conventions

- All global state lives in `getgenv()` (aliased as `G` in V2)
- Volt-specific APIs: `hookmetamethod`, `newcclosure`, `setstackhidden`, `restorefunction`, `getnamecallmethod`
- Game uses a cipher system (`encryptstring`/`decryptstring`) for remote args — all remote payloads must be encrypted
- Force Hit hooks `MainEvent.FireServer` via `__namecall` metamethod hook (not `hookfunction` — Volt rejects the old pattern)
- Resolver V3 is data-only (yaw tracking); it does NOT modify character joints
- Remote spy available via `roblox-mcp_remote-spy` for debugging FireServer payloads

## Debugging workflow

1. Use MCP tools (`roblox-mcp`) to inspect live game state and scripts
2. Use `remote-spy` to capture actual `MainEvent` FireServer args when testing Force Hit changes
3. Use `script-grep`/`semantic-search-scripts` to find relevant decompiled game scripts
4. Use `get-data-by-code` to read runtime values from the game
