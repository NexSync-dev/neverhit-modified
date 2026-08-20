# Volt Documentation (combined)

Scraped from https://docs.voltbz.net/docs

---

# Introduction

Source: https://docs.voltbz.net/docs

The official documentation for **Volt**

The environment docs are heavily based on the [sUNC](https://sunc.su) (senS' Unified Naming Convention) standard.

Here you can find information about Volt's scripting environment and other general usage information.

This documentation is subject to refactoring and may not remain exactly the
same

---

## [Explore the Docs](#explore-the-docs)

[### Closures

Inspect, modify and create Luau closures with precise control.](/docs/closures)[### Debug

Access debug library functions for runtime inspection.](/docs/debug)[### Decompiler

Learn how Volt turns Luau bytecode into readable source.](/docs/decompiler)[### Drawing

Create and manage drawing objects for visual overlays.](/docs/drawing)[### Encoding

Encode and decode data in various formats.](/docs/encoding)[### Environment

Access and manipulate the Luau environment.](/docs/environment)[### Filesystem

Read, write, and manage files on the local system.](/docs/filesystem)[### Instances

Interact with game instances in special ways.](/docs/instances)[### Metatable

Work with metatables and metamethods.](/docs/metatable)[### Miscellaneous

Various utility functions.](/docs/miscellaneous)[### oth

Secure thread-based function hooking for C functions.](/docs/oth)[### Reflection

Access hidden properties and thread identity.](/docs/reflection)[### Scripts

Interact with running scripts and modules.](/docs/scripts)[### Signals

Fire and manage game signals.](/docs/signals)[### VoltSignal

Custom signal implementation for events.](/docs/voltsignal)[### LuaStateProxy

Proxy object for Lua states.](/docs/luastateproxy)[### WebSocket

Create WebSocket connections for real-time communication.](/docs/websocket)[### RakNet

Inspect, modify, block, and send low-level game packets.](/docs/raknet)


---

# Account Manager

Source: https://docs.voltbz.net/docs/account-manager

The **Account Manager** is a built-in panel for storing multiple accounts and
launching the game with any of them, without signing in by hand every time. Each
account is added once by capturing its login session, which Volt stores **locally
and encrypted**. From there you can launch one or many accounts at once, point
them at a specific place or private server, automatically restart crashed
instances, watch each instance's live CPU, memory and connection status, and
organize everything into groups.

Launching, browser login and live process stats are **Windows-only**. Your
accounts never leave your machine. See [Storage and
security](/docs/account-manager).

## [Opening the Account Manager](#opening-the-account-manager)

* **Activity bar**: click the **Account Manager** item (people icon) on the side rail.
* **Command palette**: search for **"Account Manager: Open"**.
* Keep it docked in the main window, or use **Dock / Overlay** to pop it out into
  its own window or a compact always-on-top monitor.

## [Adding accounts](#adding-accounts)

There are three ways to add accounts. However you add them, Volt fetches each
account's identity (username and display name), confirms the session is valid,
then encrypts and stores it. Accounts are de-duplicated automatically, so
re-adding an existing one simply updates it. After importing, a summary reports
how many accounts were **imported**, **updated**, and **failed** (with a reason
for each failure).

### [Log in from a browser (recommended)](#log-in-from-a-browser-recommended)

Click **Login from Browser**. Volt opens Microsoft Edge or Google Chrome in a
throwaway profile on the platform's login page. Sign in as you normally would.
Volt detects the session automatically, imports the account, and closes the
browser for you. Use **Cancel** to stop at any time. (Requires Edge or Chrome
installed.)

### [Paste sessions](#paste-sessions)

Click **Paste Cookies**, paste one session token per line, and click **Import**.
Handy for bulk-adding accounts you already have.

### [Load from a file](#load-from-a-file)

Click **Load from File** and pick one or more `.txt` / `.csv` / `.log` files.
Their contents are merged into the paste box for review, then imported the same
way.

## [Launching](#launching)

1. In **Launch Settings**, enter a **Place ID** and wait for the green validation
   pill (it shows the resolved game name, creator and live player count), or
   choose a [private server](/docs/account-manager).
2. Tick the account(s) you want in the table.
3. Click **Launch Selected**.

Volt launches each selected account in turn, waiting the **Launch delay**
(default 5s, range 0 to 120s) between each so clients don't all start at once. The
**Connection** column moves from *Connecting* to *Connected* as each client
attaches, and live CPU and memory fill in.

Running more than one client at a time needs Volt's global **Multi-Instance**
setting enabled. If it's off, the panel prompts you with a shortcut to turn it
on.

To relaunch a single account immediately (skipping the delay), use the
circular-arrow button on its row. To close running clients, select the accounts
and click **Stop**.

## [Auto-relaunch](#auto-relaunch)

Enable **Auto-relaunch closed instances** to have Volt restart an account after
its client exits unexpectedly. A background monitor watches the tracked
processes and, after the **Relaunch delay** (default 5s, range 5 to 300s),
relaunches the account; the row shows a live "Relaunching in Ns…" countdown.

When you turn this on, Volt suggests enabling **Silent Errors** so crash
dialogs don't block the relaunch.

## [Groups](#groups)

Groups let you run different sets of accounts with different settings. Each group
carries its **own** full launch configuration (place ID, delays, auto-relaunch,
private-server mode), so one group can target one place while another targets a
different one.

* **Add group**, **rename**, or **remove** from the **Launch Settings** group dropdown.
* **Assign accounts** with the per-row group dropdown, or select several and use
  **Set group** in the Accounts header.

The accounts table is split into sections per group (plus an *Ungrouped*
section) with counts.

## [Private servers](#private-servers)

Open the **mode selector** in Launch Settings:

* **None**: launch straight into the place ID.
* **Round-robin**: spread launched accounts across a pool of private servers.
* **Assigned**: each account uses the private server assigned to it (per-row dropdown).

Add servers under **Advanced Private Servers**: give each a name, place ID, and a
private link or code. Volt resolves the link to the place at launch time and
caches the result.

## [Health checks](#health-checks)

Click **Check Health** (or **Check** on a selection) to test whether each stored
session is still valid. Every account shows an **alive**, **dead**, or
**unknown** badge, along with when it was last checked.

## [Monitoring](#monitoring)

* **Header summary**: totals for accounts, connected, connecting, relaunching,
  total memory, total CPU, and alive/dead counts.
* **Per row**: session health, **Connection** state (Idle / Connecting /
  Connected / Relaunching), committed **Memory**, **CPU**, assigned private
  server, and last-launch time.
* **Performance overlay**: click **Overlay** for a small always-on-top window
  that refreshes every few seconds with connected/total, process count, memory,
  CPU and a per-account list. A corner dropdown (Top / Bottom × Left / Right)
  tiles it to your screen; opening it hibernates Volt's other windows to save
  resources.
* **Recent Activity**: a live, timestamped log of launches, connections,
  closes, relaunches, imports and errors.

Launch settings, groups and private servers **autosave** a couple of seconds
after you change them (and before every launch); per-account edits save
immediately.

## [Account data](#account-data)

Each account stores:

| Field | Description |
| --- | --- |
| Username / Display name | Pulled from the platform when the account is added |
| Alias | Your own nickname for the account (shown first when set) |
| Group | Which group the account belongs to |
| Notes | Free-text notes |
| Session status | `alive` / `dead` / `unknown`, from the last health check |
| Auto-relaunch | Whether this account is included in auto-relaunch |
| Assigned private server | Used in *Assigned* mode |
| Last checked / Last launched | Timestamps |
| Live usage | PID, committed memory, CPU and connection state while running |

The login session itself is stored **encrypted** and is never shown in the interface.

## [Storage and security](#storage-and-security)

* **Local only.** Accounts, sessions, settings, groups and private servers live
  in a single `account-manager.json` file in Volt's app-data folder. Nothing
  about your accounts is sent to Volt's servers. The only network calls go
  directly to the platform (to fetch identity, auth tickets and resolve places)
  and to your local browser during browser login.
* **Encrypted at rest.** On Windows, sessions are encrypted with the operating
  system's data-protection API (DPAPI) and tied to your Windows user, so the file
  can't be read on another machine or account. The decrypted session never
  reaches the interface.
* **Windows-only actions.** Launching, browser login, stopping/tracking clients
  and live CPU all require Windows; on other platforms those actions are unavailable.
* **Multi-Instance.** Running multiple clients depends on Volt's Multi-Instance
  setting being enabled.

## [Quick start](#quick-start)

1. Open the Account Manager and click **Login from Browser**, then sign in. The
   account imports automatically.
2. Enter a **Place ID** in Launch Settings and wait for the green pill.
3. Tick the account and click **Launch Selected**.
4. To run several at once, enable **Multi-Instance** when prompted, set a
   **Launch delay**, turn on **Auto-relaunch**, then select all and launch.


---

# Decompiler

Source: https://docs.voltbz.net/docs/decompiler

Volt's decompiler turns Luau bytecode back into readable Luau source. The most important thing to know as a user is that decompilation runs asynchronously: calls that need source can yield while the decompiler works in the background, then resume when the result is ready.

That behavior matters most for saves, where one operation may need source for many scripts before the final file can be written.

## [How It Works](#how-it-works)

The decompiler work is scheduled as jobs. The Luau-facing operation yields while those jobs run, so long decompiles do not block the calling script thread.

The decompiler scheduler will configure itself automatically based on the number of available CPU cores. When these threads are not used, they are in a dormant state and don't utilize any CPU time.

[`decompile`](/docs/scripts/decompile) schedules one script and yields until the source is ready. [`saveinstance`](/docs/miscellaneous/saveinstance) and [`saveplace`](/docs/miscellaneous/saveplace) can schedule many scripts during a save, wait for the results, then finish writing the final place or model file.

## [The Pipeline](#the-pipeline)

This section explains how Volt's decompiler pipeline works, how each option changes the output, and what those choices mean for performance.

Volt prioritizes semantic correctness over raw speed. It is still fast, but it may take longer than some alternatives. In return, it can decompile scripts with 100k+ lines while preserving behavior close to the original source.

The diagram gives a simplified view of how Volt turns script bytecode into readable Luau source.

First, the bytecode is lifted into Volt's internal IR, or [intermediate representation](https://en.wikipedia.org/wiki/Intermediate_representation). This IR uses [SSA form](https://en.wikipedia.org/wiki/Static_single-assignment_form), where each temporary value is assigned once, and a [CFG](https://en.wikipedia.org/wiki/Control-flow_graph), which maps the blocks of code and the jumps between them.

From there, the SSA pass pipeline simplifies the IR and removes unnecessary noise. Once the IR is clean enough, the CFG is lowered into a linear [AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree). The AST is a tree-shaped representation of the code that is much closer to real source.

Finally, more AST passes clean up the structure, remove artifacts, and improve readability before the result is formatted and printed as Luau source code.

### [Options and Tradeoffs](#options-and-tradeoffs)

Volt exposes SSA and AST pass controls through the `DecompilerOptions` type. These pass groups run at different stages of the pipeline, so you may want to toggle them for different reasons depending on whether you care more about speed, correctness, or readability.

#### [SSA Passes](#ssa-passes)

As of this writing, the only configurable SSA pass is the `DecompilerOptions.ConditionalStructurer` pass. This pass rewrites certain `if` and `else` control-flow patterns into equivalent `and` / `or` expressions.

The output behaves the same, but it is often easier to read. The pass is relatively fast, even on large scripts, but it is not required for semantic correctness. Turning it off can noticeably reduce decompilation time on some scripts.

#### [AST Passes](#ast-passes)

Most AST passes are worth leaving enabled. Passes like `SmartVariableRenamer`, `FunctionDeclarations`, and `GuardClauses` are very cheap and usually make the output much easier to read.

The main AST setting worth tuning is `DoBlockInsertionThreshold`. This controls when Volt wraps a region in a `do ... end` block to keep the number of live locals under Luau's limit.

You usually only need this when you want the decompiled script to compile again. If your goal is readability or analysis, setting the threshold to `0` disables this pass, which can make the output cleaner and slightly reduce decompilation time.

#### [Formatting](#formatting)

Formatting is mostly a matter of preference. The formatter has a negligible performance cost, taking about 30ms on a script with 100k lines of code.

Volt exposes formatter settings through [`DecompilerFormatter`](/docs/scripts/decompile#decompilerformatter). See that API reference page for the full list of formatting options.

## [Related Reference](#related-reference)

* [`decompile`](/docs/scripts/decompile), [`DecompilerOptions`](/docs/scripts/decompile#decompileroptions), [`DecompilerFormatter`](/docs/scripts/decompile#decompilerformatter)
* [`saveinstance`](/docs/miscellaneous/saveinstance)
* [`saveplace`](/docs/miscellaneous/saveplace)


---

# Closures

Source: https://docs.voltbz.net/docs/closures

The **Closures** library allows for viewing info about a closures origin and allowing the manipulation of said closure.

## [Overview](#overview)

This library provides tools to:

* **Inspect** closures to determine their type and origin
* **Modify** closures by hooking or replacing them
* **Create** new closures with specific properties

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`checkcaller`](/docs/closures/checkcaller) | Check if the current call is from Volt |
| [`clonefunction`](/docs/closures/clonefunction) | Create a copy of a function |
| [`getfunctionhash`](/docs/closures/getfunctionhash) | Get the hash of a function's bytecode |
| [`hookfunction`](/docs/closures/hookfunction) | Replace a function with another |
| [`hookmetamethod`](/docs/closures/hookmetamethod) | Hook a metatable metamethod |
| [`iscclosure`](/docs/closures/iscclosure) | Check if a function is a C closure |
| [`isexecutorclosure`](/docs/closures/isexecutorclosure) | Check if a function is from Volt |
| [`isfunctionhooked`](/docs/closures/isfunctionhooked) | Check if a function has been hooked |
| [`islclosure`](/docs/closures/islclosure) | Check if a function is a Luau closure |
| [`isnewcclosure`](/docs/closures/isnewcclosure) | Check if a function is a newcclosure |
| [`newcclosure`](/docs/closures/newcclosure) | Wrap a Luau function as a C closure |
| [`newlclosure`](/docs/closures/newlclosure) | Wrap a C closure as a Luau closure |
| [`restorefunction`](/docs/closures/restorefunction) | Restore a hooked function to its original |
| [`setstackhidden`](/docs/closures/setstackhidden) | Hide a function from stack traces |

## [Closure Types](#closure-types)

There are two main types of closures:

### [C Closures](#c-closures)

Functions implemented in C/C++. These are typically:

* Built-in Luau functions like `print`, `type`
* Game API methods
* Majority of custom functions

### [Luau Closures](#luau-closures)

Functions written in Luau. These are typically:

* User-defined functions
* Game Script functions


---

# Debug

Source: https://docs.voltbz.net/docs/debug

The **Debug** library provides functions for runtime inspection of Luau functions, including access to constants, upvalues, protos, and stack values.

The functions added by Volt to the `debug` table are also registered as same-named globals, such as `getconstant`, `getinfo`, and `setstack`. `debug.validlevel` additionally has the `debug.isvalidlevel` alias; both `validlevel` and `isvalidlevel` are globals.

## [Overview](#overview)

These functions allow you to:

* **Inspect** function internals (constants, upvalues, protos)
* **Modify** function behavior at runtime
* **Access** the call stack

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`debug.getcallstack`](/docs/debug/getcallstack) | Get the current call stack |
| [`debug.getconstant`](/docs/debug/getconstant) | Get a constant from a function |
| [`debug.getconstants`](/docs/debug/getconstants) | Get all constants from a function |
| [`debug.getinfo`](/docs/debug/getinfo) | Get information about a function |
| [`debug.getproto`](/docs/debug/getproto) | Get a proto (nested function) from a function |
| [`debug.getprotos`](/docs/debug/getprotos) | Get all protos from a function |
| [`debug.getstack`](/docs/debug/getstack) | Get a value from the stack |
| [`debug.getupvalue`](/docs/debug/getupvalue) | Get an upvalue from a function |
| [`debug.getupvalues`](/docs/debug/getupvalues) | Get all upvalues from a function |
| [`debug.setconstant`](/docs/debug/setconstant) | Set a constant in a function |
| [`debug.setinfo`](/docs/debug/setinfo) | Change function debug metadata |
| [`debug.setstack`](/docs/debug/setstack) | Set a value on the stack |
| [`debug.setupvalue`](/docs/debug/setupvalue) | Set an upvalue in a function |
| [`debug.validlevel`](/docs/debug/validlevel) | Check if a stack level is valid |
| [`ProtoProxy`](/docs/debug/protoproxy) | Inspect a nested prototype |

## [Terminology](#terminology)

### [Constants](#constants)

Values embedded directly in the function's bytecode. These include:

* String literals
* Numbers
* Booleans
* `nil`

### [Upvalues](#upvalues)

Variables captured from the enclosing scope. When a function references a variable from outside its own scope, that variable becomes an upvalue.

### [Protos](#protos)

Nested function definitions within a function. These are the "prototypes" of inner functions.

### [Stack](#stack)

The call stack containing local variables and temporary values for the current execution context.


---

# Reflection

Source: https://docs.voltbz.net/docs/reflection

The **Reflection** library provides functions for accessing hidden properties, managing thread identity, and modifying property scriptability.

## [Overview](#overview)

These functions allow you to:

* Read and write hidden properties
* Get and set thread identity level
* Control whether properties are scriptable

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`gethiddenproperty`](/docs/reflection/gethiddenproperty) | Get a hidden property value |
| [`gethiddenproperties`](/docs/reflection/gethiddenproperties) | Get all hidden properties |
| [`getproperties`](/docs/reflection/getproperties) | Get all properties of an instance |
| [`getthreadidentity`](/docs/reflection/getthreadidentity) | Get the current thread identity |
| [`isnetworkowner`](/docs/reflection/isnetworkowner) | Check network ownership of a part |
| [`isscriptable`](/docs/reflection/isscriptable) | Check if a property is scriptable |
| [`sethiddenproperty`](/docs/reflection/sethiddenproperty) | Set a hidden property value |
| [`setscriptable`](/docs/reflection/setscriptable) | Set a property's scriptability |
| [`setsimulationradius`](/docs/reflection/setsimulationradius) | Registered compatibility no-op |
| [`setthreadidentity`](/docs/reflection/setthreadidentity) | Set the current thread identity |


---

# Metatable

Source: https://docs.voltbz.net/docs/metatable

The **Metatable** library provides functions for working with metatables and metamethods on game objects.

## [Overview](#overview)

These functions allow you to:

* Access raw metatables on locked objects
* Modify metatable read-only status
* Get the namecall method in hooks

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`getnamecallmethod`](/docs/metatable/getnamecallmethod) | Get the method name in a namecall hook |
| [`getrawmetatable`](/docs/metatable/getrawmetatable) | Get the raw metatable of an object |
| [`isreadonly`](/docs/metatable/isreadonly) | Check if a table is read-only |
| [`iswritable`](/docs/metatable/iswritable) | Check if a table is writable |
| [`makereadonly`](/docs/metatable/makereadonly) | Make a table read-only |
| [`makewritable`](/docs/metatable/makewritable) | Make a table writable |
| [`setnamecallmethod`](/docs/metatable/setnamecallmethod) | Set the method name in a namecall hook |
| [`setrawmetatable`](/docs/metatable/setrawmetatable) | Set the raw metatable of an object |
| [`setreadonly`](/docs/metatable/setreadonly) | Set a table's read-only status |

## [Understanding Metatables](#understanding-metatables)

Metatables in Luau control the behavior of tables and userdata. They define how objects respond to operations like indexing, calling, and arithmetic.

### [Common Metamethods](#common-metamethods)

| Metamethod | Triggered By |
| --- | --- |
| `__index` | Reading a missing key (`obj.key`) |
| `__newindex` | Writing to a key (`obj.key = value`) |
| `__namecall` | Method calls (`obj:method()`) |
| `__call` | Calling as function (`obj()`) |
| `__tostring` | String conversion (`tostring(obj)`) |


---

# Environment

Source: https://docs.voltbz.net/docs/environment

The **Environment** library provides functions for accessing and manipulating the Luau environment, including garbage collection inspection and global environments.

## [Overview](#overview)

These functions allow you to:

* Access different global environments
* Inspect the garbage collector
* Filter and find objects in memory

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`filtergc`](/docs/environment/filtergc) | Filter garbage collected objects |
| [`getallthreads`](/docs/environment/getallthreads) | Get GC-visible Luau threads |
| [`getgc`](/docs/environment/getgc) | Get all objects tracked by garbage collector |
| [`getgenv`](/docs/environment/getgenv) | Get Volt's global environment |
| [`getreg`](/docs/environment/getreg) | Get the Luau registry |
| [`getrenv`](/docs/environment/getrenv) | Get the game's global environment |
| [`gettenv`](/docs/environment/gettenv) | Get a thread's environment |

## [Environment Types](#environment-types)

### [Volt Environment (genv)](#volt-environment-genv)

The global environment where your scripts run. Variables defined here persist across script executions.

### [Game Environment (renv)](#game-environment-renv)

The game's Luau environment containing globals such as `game` and `workspace`.

### [Registry](#registry)

The Luau registry is a special table used internally by the Luau implementation to store references.


---

# Bit

Source: https://docs.voltbz.net/docs/bit

The settings-gated **bit** library performs 32-bit unsigned integer operations. It is disabled by default; enable **Bit Library** in Volt's client settings before using it.

## [Functions](#functions)

```
bit.badd(...: number) -> number
bit.bsub(...: number) -> number
bit.bmul(...: number) -> number
bit.bdiv(...: number) -> number

bit.band(...: number) -> number
bit.bor(...: number) -> number
bit.bxor(...: number) -> number
bit.bnot(value: number) -> number
bit.bswap(value: number) -> number

bit.ror(value: number, count: number) -> number
bit.rol(value: number, count: number) -> number
bit.lshift(value: number, count: number) -> number
bit.rshift(value: number, count: number) -> number
bit.arshift(value: number, count: number) -> number

bit.tohex(value: number) -> string
bit.tobit(value: number) -> number
```

Arithmetic and bitwise results are trimmed to 32 bits. The variadic functions currently skip arguments that cannot be converted to unsigned integers.

## [Example](#example)

```
print(bit.band(0xF0, 0xCC)) -- 192 (0xC0)
print(bit.bor(0xF0, 0x0F))  -- 255
print(bit.bxor(0xAA, 0xFF)) -- 85
print(bit.lshift(1, 8))     -- 256
print(bit.tohex(255))       -- "ff"
```


---

# Scripts

Source: https://docs.voltbz.net/docs/scripts

The **Scripts** library provides functions for interacting with running scripts, loading modules, and compiling code.

## [Overview](#overview)

These functions allow you to:

* Get references to running scripts
* Access script environments
* Load and compile Luau code
* Extract script information

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`decompile`](/docs/scripts/decompile) | Decompile a script into Luau source |
| [`getcallingscript`](/docs/scripts/getcallingscript) | Get the script that called the current function |
| [`getfunctionbytecode`](/docs/scripts/getfunctionbytecode) | Get bytecode for a Luau closure |
| [`getloadedmodules`](/docs/scripts/getloadedmodules) | Get all loaded ModuleScripts |
| [`getmodules`](/docs/scripts/getmodules) | Get cached ModuleScripts |
| [`getrunningscripts`](/docs/scripts/getrunningscripts) | Get all running scripts |
| [`getscriptbytecode`](/docs/scripts/getscriptbytecode) | Get processed script bytecode |
| [`getscriptclosure`](/docs/scripts/getscriptclosure) | Get a script's main function |
| [`getscriptfromthread`](/docs/scripts/getscriptfromthread) | Get the script associated with a thread |
| [`getscriptthread`](/docs/scripts/getscriptthread) | Get a thread associated with a script |
| [`getscripthash`](/docs/scripts/getscripthash) | Hash processed script bytecode |
| [`getscripts`](/docs/scripts/getscripts) | Get cached client-visible scripts |
| [`getsenv`](/docs/scripts/getsenv) | Get a script's environment |
| [`isexecutorthread`](/docs/scripts/isexecutorthread) | Check whether a thread belongs to Volt |
| [`loadstring`](/docs/scripts/loadstring) | Compile and load Luau code |


---

# LuaStateProxy

Source: https://docs.voltbz.net/docs/luastateproxy

The **LuaStateProxy** library provides a proxy object for accessing and controlling Lua states.

## [Overview](#overview)

LuaStateProxy allows you to:

* Access state properties and identifiers
* Execute code on specific states
* Communicate between different Lua states
* Manage actors associated with states

## [Constructor](#constructor)

| Function | Description |
| --- | --- |
| [`LuaStateProxy.new`](/docs/luastateproxy/new) | Create a new LuaStateProxy for the current state |

## [Properties](#properties)

| Property | Type | Description |
| --- | --- | --- |
| [`Id`](/docs/luastateproxy/id) | `number` | Unique identifier for this Lua state |
| [`IsActorState`](/docs/luastateproxy/isactorstate) | `boolean` | Whether this state was created for Actors |
| [`Event`](/docs/luastateproxy/event) | `VoltSignal` | Generic event for communication between states |

## [Methods](#methods)

| Method | Description |
| --- | --- |
| [`LuaStateProxy:GetActors`](/docs/luastateproxy/getactors) | Get all Actor instances for this state |
| [`LuaStateProxy:Execute`](/docs/luastateproxy/execute) | Execute code on this Lua state |


---

# oth

Source: https://docs.voltbz.net/docs/oth

The **oth** library provides functions for hooking C closures with Luau callbacks.

## [Overview](#overview)

The `oth` library allows you to:

* Hook C closures
* Remove hooks when no longer needed
* Access the original function even after multiple hooks
* Detect if code is running in a hook thread

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`oth.hook`](/docs/oth/hook) | Hook a C closure |
| [`oth.unhook`](/docs/oth/unhook) | Remove a hook created with `oth.hook` |
| [`oth.get_root_callback`](/docs/oth/get_root_callback) | Get the original function |
| [`oth.is_hook_thread`](/docs/oth/is_hook_thread) | Check if running in a hook thread |
| [`get_original_thread`](/docs/oth/get_original_thread) | Get the original thread |

## [Related Libraries](#related-libraries)

* [`closures`](/docs/closures) - Standard function hooking with `hookfunction`


---

# Instances

Source: https://docs.voltbz.net/docs/instances

The **Instances** library provides functions for interacting with game instances in special ways that aren't normally possible.

## [Overview](#overview)

These functions allow you to:

* Clone instance references
* Fire interaction events
* Access hidden UI containers
* Inspect instances in the instance cache

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`cloneref`](/docs/instances/cloneref) | Clone an instance reference |
| [`compareinstances`](/docs/instances/compareinstances) | Compare two instance references |
| [`fireclickdetector`](/docs/instances/fireclickdetector) | Trigger a ClickDetector |
| [`fireproximityprompt`](/docs/instances/fireproximityprompt) | Trigger a ProximityPrompt |
| [`firetouchinterest`](/docs/instances/firetouchinterest) | Trigger a Touched event |
| [`getcallbackmember` / `getcallbackvalue`](/docs/instances/getcallbackvalue) | Get a callback property value |
| [`gethui`](/docs/instances/gethui) | Get the hidden UI container |
| [`getinstancecache`](/docs/instances/getinstancecache) | Get all cached instance references |
| [`getinstances`](/docs/instances/getinstances) | Get cached instances |
| [`getnilinstances`](/docs/instances/getnilinstances) | Get all nil-parented instances |
| [`getrendersteppedlist`](/docs/instances/getrendersteppedlist) | Get RenderStepped connections |


---

# Cache

Source: https://docs.voltbz.net/docs/cache

The **Cache** library provides functions for manipulating the instance reference cache.

## [Overview](#overview)

These functions allow you to:

* Replace cached instance references
* Invalidate cached references
* Check if an instance is cached

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`cache.replace`](/docs/cache/replace) | Replace a cached instance reference |
| [`cache.invalidate`](/docs/cache/invalidate) | Remove an instance from the cache |
| [`cache.iscached`](/docs/cache/iscached) | Check if an instance is cached |

## [Related Functions](#related-functions)

| Function | Description |
| --- | --- |
| [`cloneref`](/docs/instances/cloneref) | Clone an instance reference |
| [`compareinstances`](/docs/instances/compareinstances) | Compare two instance references |


---

# Signals

Source: https://docs.voltbz.net/docs/signals

The **Signals** library provides functions for firing and managing game signals.

## [Overview](#overview)

These functions allow you to:

* Fire signals programmatically
* Get and manage signal connections
* Replicate signals to the server

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`cansignalreplicate`](/docs/signals/cansignalreplicate) | Check if a signal can replicate |
| [`firesignal`](/docs/signals/firesignal) | Fire a signal with arguments |
| [`getconnections`](/docs/signals/getconnections) | Get all connections to a signal |
| [`getsignalarguments`](/docs/signals/getsignalarguments) | Get argument types for a signal |
| [`getsignalargumentsinfo`](/docs/signals/getsignalargumentsinfo) | Get detailed argument info |
| [`getsignalwhitelist`](/docs/signals/getsignalwhitelist) | Get network whitelist signals |
| [`replicatesignal`](/docs/signals/replicatesignal) | Fire a signal with replication |


---

# VoltSignal

Source: https://docs.voltbz.net/docs/voltsignal

The **VoltSignal** library provides a custom signal implementation for creating and managing events.

`Signal` is an alias of the `VoltSignal` constructor table.

## [Overview](#overview)

VoltSignal allows you to:

* Create custom signals/events
* Connect handlers to signals
* Wait for signals to fire
* Fire signals with arguments

## [Classes](#classes)

### [VoltSignal](#voltsignal)

| Method | Description |
| --- | --- |
| [`VoltSignal.new`](/docs/voltsignal/new) | Create a new VoltSignal |
| [`VoltSignal:Connect`](/docs/voltsignal/connect) | Connect a handler function |
| [`VoltSignal:Once`](/docs/voltsignal/once) | Connect a handler for one fire |
| [`VoltSignal:Wait`](/docs/voltsignal/wait) | Yield until the signal fires |
| [`VoltSignal:Fire`](/docs/voltsignal/fire) | Fire the signal with arguments |

### [VoltConnection](#voltconnection)

| Method | Description |
| --- | --- |
| [`VoltConnection:Disconnect`](/docs/voltsignal/disconnect) | Disconnect the connection |
| [`VoltConnection.Connected`](/docs/voltsignal/connected) | Check whether a connection is active |


---

# Actors

Source: https://docs.voltbz.net/docs/actors

The **Actors** library provides functions for working with Actors and their Lua states.

## [Overview](#overview)

These functions allow you to:

* Get active Actors
* Run code on an Actor
* Create communication channels between actors
* Access related Lua states
* Listen for newly available Actor states

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`create_comm_channel`](/docs/actors/create_comm_channel) | Create a communication channel |
| [`get_comm_channel`](/docs/actors/get_comm_channel) | Get an existing communication channel |
| [`get_current_actor`](/docs/actors/get_current_actor) | Get the Actor for the current state |
| [`getactors`](/docs/actors/getactors) | Get active Actors |
| [`getactorstates`](/docs/actors/getactorstates) | Get all active LuaStateProxy objects |
| [`getluastate`](/docs/actors/getluastate) | Get LuaStateProxy for actor or script |
| [`getgamestate`](/docs/actors/getgamestate) | Get the default game Lua state |
| [`isparallel`](/docs/actors/isparallel) | Check if running in parallel |
| [`on_actor_state_created`](/docs/actors/on_actor_state_created) | Event fired when actor state is created |
| [`run_on_actor`](/docs/actors/run_on_actor) | Execute code on an actor |

## [What are Actors?](#what-are-actors)

Actors can run Luau code independently and support parallel execution.

## [Communication Channels](#communication-channels)

Communication channels allow actors to send messages to each other. Use `create_comm_channel` to create a channel and `get_comm_channel` to retrieve it from another actor.


---

# Filesystem

Source: https://docs.voltbz.net/docs/filesystem

The **Filesystem** library provides functions for reading, writing, and managing files in Volt's workspace.

You cannot access files outside the workspace folder for security reasons,
unless an explicit symlink is created within the workspace folder.

## [Overview](#overview)

These functions allow you to:

* Read and write files
* Create and delete files and folders
* Check if files and folders exist
* List directory contents

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`appendfile`](/docs/filesystem/appendfile) | Append data to a file |
| [`delfile`](/docs/filesystem/delfile) | Delete a file |
| [`delfolder`](/docs/filesystem/delfolder) | Delete a folder |
| [`dofile`](/docs/filesystem/dofile) | Load and execute a Luau file |
| [`getcustomasset`](/docs/filesystem/getcustomasset) | Get a content URL for a local file |
| [`isfile`](/docs/filesystem/isfile) | Check if a path is a file |
| [`isfolder`](/docs/filesystem/isfolder) | Check if a path is a folder |
| [`listfiles`](/docs/filesystem/listfiles) | List files in a folder |
| [`loadfile`](/docs/filesystem/loadfile) | Load a Luau file as a function |
| [`makefolder`](/docs/filesystem/makefolder) | Create a folder |
| [`readfile`](/docs/filesystem/readfile) | Read contents of a file |
| [`writefile`](/docs/filesystem/writefile) | Write data to a file |

## [Workspace Folder](#workspace-folder)

All file operations are relative to Volt's workspace folder. Paths that lexically escape that folder are rejected.

```
-- These are relative to the workspace folder
writefile("myfile.txt", "Hello")        -- workspace/myfile.txt
writefile("subfolder/file.txt", "Hi")   -- workspace/subfolder/file.txt
```


---

# Input

Source: https://docs.voltbz.net/docs/input

The **Input** library provides functions for simulating keyboard and mouse input.

## [Overview](#overview)

These functions allow you to:

* Simulate keyboard key presses
* Simulate mouse button clicks
* Move the mouse cursor

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`iswindowactive`](/docs/input/iswindowactive) | Check if game window is focused |
| [`keypress`](/docs/input/keypress) | Simulate key press |
| [`keyrelease`](/docs/input/keyrelease) | Simulate key release |
| [`keyclick`](/docs/input/keyclick) | Simulate key click (press+release) |
| [`mouse1press`](/docs/input/mouse1press) | Simulate left mouse press |
| [`mouse1release`](/docs/input/mouse1release) | Simulate left mouse release |
| [`mouse1click`](/docs/input/mouse1click) | Simulate left mouse click |
| [`mouse2press`](/docs/input/mouse2press) | Simulate right mouse press |
| [`mouse2release`](/docs/input/mouse2release) | Simulate right mouse release |
| [`mouse2click`](/docs/input/mouse2click) | Simulate right mouse click |
| [`mousescroll`](/docs/input/mousescroll) | Simulate mouse scroll |
| [`mousemoverel`](/docs/input/mousemoverel) | Move mouse relative to position |
| [`mousemoveabs`](/docs/input/mousemoveabs) | Move mouse to absolute position |


---

# Console

Source: https://docs.voltbz.net/docs/console

The **Console** library provides functions for creating and managing a custom console window.

## [Overview](#overview)

These functions allow you to:

* Create and manage a custom console window
* Print messages with different log levels
* Get user input from the console

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`rconsoleshow`](/docs/console/rconsoleshow) | Create and show the console window |
| [`rconsolehide`](/docs/console/rconsolehide) | Hide and destroy the console window |
| [`rconsoletoggle`](/docs/console/rconsoletoggle) | Toggle console visibility |
| [`rconsolehidden`](/docs/console/rconsolehidden) | Check if console is hidden |
| [`rconsoletop`](/docs/console/rconsoletop) | Bring console to front |
| [`rconsoleprint`](/docs/console/rconsoleprint) | Print text to console |
| [`rconsoleinfo`](/docs/console/rconsoleinfo) | Print info message to console |
| [`rconsolewarn`](/docs/console/rconsolewarn) | Print warning to console |
| [`rconsoleerr`](/docs/console/rconsoleerr) | Print error to console |
| [`rconsoleclear`](/docs/console/rconsoleclear) | Clear console output |
| [`rconsolename`](/docs/console/rconsolename) | Set console window title |
| [`rconsoleinput`](/docs/console/rconsoleinput) | Get input from user |


---

# Crypt

Source: https://docs.voltbz.net/docs/crypt

The **Crypt** library provides cryptographic functions for encryption, hashing, and random number generation.

## [Overview](#overview)

These functions allow you to:

* Encrypt and decrypt data
* Generate cryptographic hashes
* Create secure random values
* Perform HMAC authentication

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`crypt.encrypt`](/docs/crypt/encrypt) | Encrypt data with a key |
| [`crypt.decrypt`](/docs/crypt/decrypt) | Decrypt data with a key |
| [`crypt.hash`](/docs/crypt/hash) | Generate a hash of data |
| [`crypt.hmac`](/docs/crypt/hmac) | Generate HMAC authentication code |
| [`crypt.random`](/docs/crypt/random) | Generate random bytes |
| [`crypt.generatekey`](/docs/crypt/generatekey) | Generate a random encryption key |
| [`crypt.generatebytes`](/docs/crypt/generatebytes) | Generate random bytes |

## [Note](#note)

Base64 encoding functions (`crypt.base64encode`, `crypt.base64decode`) and LZ4 compression functions (`crypt.lz4compress`, `crypt.lz4decompress`) are documented in the [Encoding](/docs/encoding) section.


---

# Encoding

Source: https://docs.voltbz.net/docs/encoding

The **Encoding** library provides functions for encoding and decoding data in various formats.

## [Overview](#overview)

These functions allow you to:

* Convert data to and from Base64
* Compress and decompress data using LZ4

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`base64decode`](/docs/encoding/base64decode) | Decode a Base64 string |
| [`base64encode`](/docs/encoding/base64encode) | Encode data to Base64 |
| [`lz4compress`](/docs/encoding/lz4compress) | Compress data using LZ4 |
| [`lz4decompress`](/docs/encoding/lz4decompress) | Decompress LZ4 data |


---

# Miscellaneous

Source: https://docs.voltbz.net/docs/miscellaneous

The **Miscellaneous** library contains various utility functions that don't fit into other categories.

## [Available Functions](#available-functions)

| Function | Description |
| --- | --- |
| [`clearqueueonteleport`](/docs/miscellaneous/clearqueueonteleport) | Clear the teleport script queue |
| [`getfflag`](/docs/miscellaneous/getfflag) | Get a Fast Flag value |
| [`getfpscap`](/docs/miscellaneous/getfpscap) | Get current FPS cap |
| [`gethwid`](/docs/miscellaneous/gethwid) | Get Volt's external identifier |
| [`get_process_identifier`](/docs/miscellaneous/get_process_identifier) | Get the game process ID |
| [`identifyexecutor`](/docs/miscellaneous/identifyexecutor) | Get Volt's name and version |
| [`messagebox`](/docs/miscellaneous/messagebox) | Display a message box |
| [`queueonteleport`](/docs/miscellaneous/queueonteleport) | Queue script for after teleport |
| [`request`](/docs/miscellaneous/request) | Make HTTP requests |
| [`saveinstance`](/docs/miscellaneous/saveinstance) | Save instance to file |
| [`saveplace`](/docs/miscellaneous/saveplace) | Save the current place |
| [`setclipboard`](/docs/miscellaneous/setclipboard) | Copy text to clipboard |
| [`setrbxclipboard`](/docs/miscellaneous/setrbxclipboard) | Copy to the Studio clipboard |
| [`setfflag`](/docs/miscellaneous/setfflag) | Set a Fast Flag value |
| [`setfpscap`](/docs/miscellaneous/setfpscap) | Set FPS cap |


---

# Drawing

Source: https://docs.voltbz.net/docs/drawing

The **Drawing** library creates persistent visual overlays rendered above the game viewport.

## [Constructor](#constructor)

```
Drawing.new(type: "Line" | "Circle" | "Square" | "Triangle" | "Text" | "Image" | "Quad") -> DrawingObject
```

```
local line = Drawing.new("Line")
line.From = Vector2.new(0, 0)
line.To = Vector2.new(100, 100)
line.Color = Color3.fromRGB(255, 0, 0)
line.Thickness = 2
line.Visible = true
```

## [Functions](#functions)

| Function | Description |
| --- | --- |
| [`cleardrawcache`](/docs/drawing/cleardrawcache) | Remove all drawing objects |
| [`getrenderproperty`](/docs/drawing/getrenderproperty) | Read an object property |
| [`isrenderobj`](/docs/drawing/isrenderobj) | Test whether a value is a drawing object |
| [`setrenderproperty`](/docs/drawing/setrenderproperty) | Assign an object property |
| [`DrawFont.Register`](/docs/drawing/drawfont) | Register a font from memory |
| [`DrawingImmediate`](/docs/drawing/immediate) | Draw from a per-frame paint callback |

## [DrawingObject](#drawingobject)

Every drawing object exposes `Remove()` and `Destroy()`. Both stop the object from rendering. The read-only `__OBJECT_EXISTS` property reports whether it still exists.

### [Common Properties](#common-properties)

| Property | Type |
| --- | --- |
| `Visible` | `boolean` |
| `ZIndex` | `number` |
| `Transparency` | `number` |
| `Color` | `Color3` |
| `__OBJECT_EXISTS` | `boolean` (read-only) |

### [Line](#line)

| Property | Type |
| --- | --- |
| `From` | `Vector2` |
| `To` | `Vector2` |
| `Thickness` | `number` |

### [Circle](#circle)

| Property | Type |
| --- | --- |
| `Position` | `Vector2` |
| `Radius` | `number` |
| `NumSides` | `number` |
| `Thickness` | `number` |
| `Filled` | `boolean` |

### [Square](#square)

| Property | Type |
| --- | --- |
| `Position` | `Vector2` |
| `Size` | `Vector2` |
| `Thickness` | `number` |
| `Filled` | `boolean` |

### [Triangle](#triangle)

| Property | Type |
| --- | --- |
| `PointA` | `Vector2` |
| `PointB` | `Vector2` |
| `PointC` | `Vector2` |
| `Thickness` | `number` |
| `Filled` | `boolean` |

### [Quad](#quad)

| Property | Type |
| --- | --- |
| `PointA` | `Vector2` |
| `PointB` | `Vector2` |
| `PointC` | `Vector2` |
| `PointD` | `Vector2` |
| `Thickness` | `number` |
| `Filled` | `boolean` |

### [Text](#text)

| Property | Type | Notes |
| --- | --- | --- |
| `Text` | `string` | Displayed text |
| `TextBounds` | `Vector2` | Read-only calculated bounds |
| `Font` | `Drawing.Fonts | DrawFont` | Legacy font ID or registered font |
| `Size` | `number` | Font size |
| `Position` | `Vector2` | Draw position |
| `Center`, `Centered` | `boolean` | Equivalent names |
| `Outline`, `Outlined` | `boolean` | Equivalent names |
| `OutlineColor` | `Color3` | Outline color |
| `OutlineOpacity` | `number` | Outline opacity |

### [Image](#image)

| Property | Type | Notes |
| --- | --- | --- |
| `Data` | `string` | Encoded image data |
| `Size` | `Vector2` | Draw size |
| `Position` | `Vector2` | Draw position |
| `Rounding` | `number` | Corner rounding |
| `Loaded` | `boolean` | Read-only load state |

## [Legacy Fonts](#legacy-fonts)

```
Drawing.Fonts.UI        -- 0
Drawing.Fonts.System    -- 1
Drawing.Fonts.Plex      -- 2
Drawing.Fonts.Monospace -- 3
```

## [Cleanup](#cleanup)

```
local circle = Drawing.new("Circle")
circle.Visible = true

-- Later
circle:Remove()
print(circle.__OBJECT_EXISTS) -- false
```


---

# WebSocket

Source: https://docs.voltbz.net/docs/websocket

The **WebSocket** library provides functions for creating WebSocket connections for real-time bidirectional communication.

The lowercase `websocket` global is an alias of the same read-only table.

The `wss://your-server.example/socket` URLs in these examples are
placeholders. Replace them with a WebSocket endpoint you control.

## [Overview](#overview)

WebSockets allow you to:

* Establish persistent connections to servers
* Send and receive messages in real-time

## [Constructor](#constructor)

| Function | Description |
| --- | --- |
| [`WebSocket.connect`](/docs/websocket/connect) | Create a new WebSocket connection |

## [Properties](#properties)

| Property | Type | Description |
| --- | --- | --- |
| [`OnMessage`](/docs/websocket/onmessage) | `VoltSignal` | Fired when a message is received |
| [`OnClose`](/docs/websocket/onclose) | `VoltSignal` | Fired when the connection closes |
| `IsClosed` | `boolean` | Whether `Close` has been called |

## [Methods](#methods)

| Method | Description |
| --- | --- |
| [`WebSocket:Send`](/docs/websocket/send) | Send a text or binary message |
| [`WebSocket:Close`](/docs/websocket/close) | Close the connection |


---

# RakNet

Source: https://docs.voltbz.net/docs/raknet

The **RakNet** library provides low-level access to outgoing game packets.

The library is disabled by default. Enable **RakNet Library** under **Settings → Client** before using any of these functions.

Interacting with RakNet is unsafe and can lead to account terminations,
broken game behavior, disconnects, or other unintended side effects. Do not
use this library unless you understand the risks and know exactly what you
are doing.

## [Overview](#overview)

RakNet allows you to:

* Inspect outgoing packets before they are sent
* Modify or block packets in a send hook
* Send custom packet payloads manually
* Work with packet data as a buffer, string, or byte array

## [Functions](#functions)

| Function | Description |
| --- | --- |
| `raknet.add_send_hook` | Register a callback that runs before a packet is sent |
| `raknet.remove_send_hook` | Remove a callback registered with `raknet.add_send_hook` |
| `raknet.send` | Send a packet with a payload, priority, reliability, and ordering channel |
| `raknet.is_enabled` | Return whether the RakNet setting is enabled |

## [Packet API](#packet-api)

### [Methods](#methods)

| Method | Description |
| --- | --- |
| `RakNetPacket:SetData` | Replace the packet payload |
| `RakNetPacket:Block` | Prevent the packet from being sent |

### [Properties](#properties)

| Property | Type | Description |
| --- | --- | --- |
| `RakNetPacket.AsBuffer` | `buffer` | Packet data as a buffer |
| `RakNetPacket.AsString` | `string` | Packet data as a string |
| `RakNetPacket.AsArray` | `{number}` | Packet data as an array of bytes |
| `RakNetPacket.PacketId` | `number` | Packet identifier |
| `RakNetPacket.Priority` | `number` | Packet priority |
| `RakNetPacket.Reliability` | `number` | Packet reliability |
| `RakNetPacket.OrderingChannel` | `number` | Packet ordering channel |
| `RakNetPacket.Size` | `number` | Packet payload size in bytes |

## [Hook Syntax](#hook-syntax)

```
raknet.add_send_hook(hook: (packet: RakNetPacket) -> ()) -> ()
raknet.remove_send_hook(hook: (packet: RakNetPacket) -> ()) -> ()
raknet.is_enabled() -> boolean
```

## [Send Syntax](#send-syntax)

```
raknet.send(
    data: buffer | string | {number},
    priority?: number,
    reliability?: number,
    ordering_channel?: number
) -> ()
```

## [Packet Method Syntax](#packet-method-syntax)

```
RakNetPacket:SetData(data: buffer | string | {number}) -> ()
RakNetPacket:Block() -> ()
```

## [Parameters](#parameters)

### [`raknet.add_send_hook`](#raknetadd_send_hook)

| Parameter | Type | Description |
| --- | --- | --- |
| `hook` | `(packet: RakNetPacket) -> ()` | Callback fired before a packet is sent |

### [`raknet.remove_send_hook`](#raknetremove_send_hook)

| Parameter | Type | Description |
| --- | --- | --- |
| `hook` | `(packet: RakNetPacket) -> ()` | Previously registered send hook |

### [`raknet.send`](#raknetsend)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `buffer`, `string`, or `{number}` (byte array) | Packet payload to send |
| `priority` | `number?` | RakNet send priority from 0 through 3; defaults to 2 |
| `reliability` | `number?` | RakNet reliability mode from 0 through 7; defaults to 3 |
| `ordering_channel` | `number?` | Ordering channel from 0 through 31 |

### [`RakNetPacket:SetData`](#raknetpacketsetdata)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `buffer`, `string`, or `{number}` (byte array) | New packet payload |

## [Returns](#returns)

`raknet.is_enabled()` returns the current RakNet-library setting and can be called while the library is disabled. The other functions and packet methods do not return a value.

## [Description](#description)

`raknet.add_send_hook` lets you intercept outgoing packets before they are sent. Inside a hook, you can inspect packet metadata, read its payload in multiple formats, replace the payload with `RakNetPacket:SetData`, or stop transmission entirely with `RakNetPacket:Block`.

`raknet.send` sends a non-empty custom packet payload using the provided priority, reliability, and ordering channel. Payload data may be supplied as a `buffer`, a `string`, or a table of byte values. Some packet identifiers are not accepted.

Because this library operates at the packet level, mistakes can be difficult to debug and may have immediate consequences. Keep hooks minimal, validate payloads carefully, and avoid modifying traffic unless absolutely necessary.

## [Example: Logging Outgoing Packets](#example-logging-outgoing-packets)

```
local function packetLogger(packet)
    print("Outgoing packet:")
    print("  Size:", packet.Size)
    print("  Priority:", packet.Priority)
    print("  Reliability:", packet.Reliability)
    print("  Ordering channel:", packet.OrderingChannel)
end

raknet.add_send_hook(packetLogger)

-- Remove the exact same callback when finished
raknet.remove_send_hook(packetLogger)
```

## [Example: Blocking a Packet](#example-blocking-a-packet)

```
local function blockLargePackets(packet)
    if packet.Size > 512 then
        warn("Blocked packet larger than 512 bytes")
        packet:Block()
    end
end

raknet.add_send_hook(blockLargePackets)
```

## [Example: Reading and Reapplying Packet Data](#example-reading-and-reapplying-packet-data)

```
local function rewritePacket(packet)
    -- This round trip leaves the bytes unchanged. Only modify a payload when
    -- you know the exact schema for that packet identifier.
    local bytes = packet.AsBuffer
    packet:SetData(bytes)
end

raknet.add_send_hook(rewritePacket)
```

Payloads passed to `raknet.send` must match the packet format expected by the game.

## [Notes](#notes)

* Hooks run before the packet is sent
* Use a `RakNetPacket` only inside its hook callback
* `RakNetPacket:Block()` prevents the current packet from being transmitted
* `RakNetPacket:SetData()` replaces the packet payload
* Packet data can be read and written as a `buffer`, `string`, or byte array
* Invalid payloads or incorrect metadata can disconnect clients or break protocol behavior


---

# Guides

Source: https://docs.voltbz.net/docs/guides

Practical, walk-through guides for Volt. Start here if you are new, then dig into
the [function reference](/docs) once you are up and running.

[### Getting Started

Download, install, and run Volt for the first time.](/docs/guides/getting-started)

More guides are on the way.


---

# Release Notes

Source: https://docs.voltbz.net/docs/releases

[### Volt 1.3

Featuring a custom decompiler, built-in saveinstance, native game explorer, script viewer, account manager, and much more.](/docs/releases/1.3)


---

# decompile

Source: https://docs.voltbz.net/docs/scripts/decompile

Decompiles Luau bytecode into source text.

## [Syntax](#syntax)

```
decompile(source: LuaSourceContainer | string, options: DecompilerOptions?) -> string
DecompilerOptions.new() -> DecompilerOptions
DecompilerFormatter.new() -> DecompilerFormatter
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `source` | `LuaSourceContainer | string` | A client-visible script or raw Luau bytecode |
| `options` | `DecompilerOptions?` | Optional decompiler settings |

## [Description](#description)

Pass a script to decompile it directly, or pass a Luau bytecode string. Server-running `Script` instances are not supported.

The function yields until decompilation finishes and raises an error if the input cannot be decompiled.

## [DecompilerOptions](#decompileroptions)

`DecompilerOptions.new()` initializes its fields from Volt's current decompiler settings.

| Property | Type | Description |
| --- | --- | --- |
| `SmartVariableRenamer` | `boolean` | Improve generated local-variable names |
| `FunctionDeclarations` | `boolean` | Recover declaration-style functions when possible |
| `GuardClauses` | `boolean` | Recover guard-clause control flow |
| `ConstantFolding` | `boolean` | Fold eligible constant expressions |
| `ConditionalStructurer` | `boolean` | Reconstruct conditional control flow |
| `DoBlockInsertionThreshold` | `number` | Threshold used when inserting `do` blocks |
| `Formatter` | `DecompilerFormatter` | Formatter configuration |

## [DecompilerFormatter](#decompilerformatter)

`DecompilerFormatter.new()` also uses the current Volt settings as its defaults.

| Property | Type | Description |
| --- | --- | --- |
| `IndentWidth` | `number` | Spaces used for each indentation level |
| `ColumnLimit` | `number` | Preferred output column limit |
| `ParenthesizeConditions` | `boolean` | Add parentheses around conditions |
| `AppendSemicolons` | `boolean` | Append semicolons to statements |
| `FunctionMetadataEnabled` | `boolean` | Emit function metadata |
| `FunctionMetadataLayout` | `number` | Metadata layout constant |
| `FunctionMetadataIncludeName` | `boolean` | Include function names in metadata |
| `FunctionMetadataIncludeLine` | `boolean` | Include source lines in metadata |
| `FunctionMetadataIncludeUpvalues` | `boolean` | Include upvalue information |
| `FunctionMetadataUpvalueFormat` | `number` | Upvalue-format constant |

### [Metadata Constants](#metadata-constants)

```
DecompilerFormatter.FunctionMetadata.Layout.Block
DecompilerFormatter.FunctionMetadata.Layout.Inline

DecompilerFormatter.FunctionMetadata.UpvalueFormat.Name
DecompilerFormatter.FunctionMetadata.UpvalueFormat.Kind
DecompilerFormatter.FunctionMetadata.UpvalueFormat.KindAndIndex
```

## [Example](#example)

```
local module = getloadedmodules()[1]
assert(module, "No loaded ModuleScript was available")

local options = DecompilerOptions.new()
options.SmartVariableRenamer = true
options.GuardClauses = true
options.Formatter.IndentWidth = 4
options.Formatter.ColumnLimit = 100
options.Formatter.FunctionMetadataEnabled = true
options.Formatter.FunctionMetadataLayout =
    DecompilerFormatter.FunctionMetadata.Layout.Block

local success, sourceOrError = pcall(decompile, module, options)
if success then
    print(sourceOrError)
else
    warn("Decompilation failed:", sourceOrError)
end
```

## [Raw Bytecode](#raw-bytecode)

```
local module = assert(getloadedmodules()[1])
local bytecode = getscriptbytecode(module)
local source = decompile(bytecode)
print(source)
```

## [Related Functions](#related-functions)

* [`getscriptbytecode`](/docs/scripts/getscriptbytecode) - Retrieve script bytecode
* [`getscripthash`](/docs/scripts/getscripthash) - Hash script bytecode

## [Related Guides](#related-guides)

* [Decompiler](/docs/decompiler) - Pipeline overview


---

# saveinstance

Source: https://docs.voltbz.net/docs/miscellaneous/saveinstance

Serializes one or more instances to the game's binary model or place format.

## [Syntax](#syntax)

```
saveinstance(root: Instance | {Instance}, options: SaveInstanceOptions?) -> ()
SaveInstanceOptions.new() -> SaveInstanceOptions
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `root` | `Instance | {Instance}` | An instance hierarchy, the DataModel, or an array of instances |
| `options` | `SaveInstanceOptions?` | Optional serialization settings |

`options` must be a `SaveInstanceOptions` value created with `SaveInstanceOptions.new()`. Plain tables are not accepted.

## [Behavior](#behavior)

* Instances and arrays are saved as binary model files. Passing `game` saves a binary place file.
* If `FilePath` has no extension, Volt appends `.rbxm` for a model or `.rbxl` for a place. An existing extension is not validated or replaced.
* If `FilePath` is empty and clipboard output is disabled, Volt generates a filename.

## [SaveInstanceOptions](#saveinstanceoptions)

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `FilePath` | `string` | `""` | Workspace-relative output path |
| `IgnoreArchivable` | `boolean` | `false` | Serialize instances regardless of `Archivable` |
| `SavePlayerCharacters` | `boolean` | `false` | Include player characters in place output |
| `SavePlayers` | `boolean` | `false` | Include `Player` instances and their non-creatable descendants |
| `DisableCompression` | `boolean` | `false` | Disable binary compression |
| `DecompileScripts` | `boolean` | `true` | Store decompiled source for scripts when possible |
| `SaveNonCreatable` | `boolean` | `false` | Represent non-creatable instances as folders |
| `SaveNilInstances` | `boolean` | `false` | Include cached nil-parented instances in place output |
| `CopyToClipboard` | `boolean` | `false` | Copy binary output to the Studio clipboard |
| `IgnoreList` | `{Instance}` | `{}` | Instances to exclude from the save |
| `DecompilerOptions` | `DecompilerOptions` | New default options | Options used when `DecompileScripts` is enabled |

Assign a complete table to `IgnoreList`. Reading the property returns a read-only copy, so create or modify a separate table and assign it back when changing the list.

## [Example](#example)

```
local model = Instance.new("Model")
model.Name = "ExampleModel"

local part = Instance.new("Part")
part.Name = "ExamplePart"
part.Parent = model

local options = SaveInstanceOptions.new()
options.FilePath = "exports/example-model.rbxm"
options.IgnoreArchivable = false
options.DecompileScripts = true

saveinstance(model, options)
print(isfile("exports/example-model.rbxm")) -- true

model:Destroy()
```

## [Saving Multiple Roots](#saving-multiple-roots)

```
local options = SaveInstanceOptions.new()
options.FilePath = "exports/selection.rbxm"

saveinstance({workspace.Terrain, workspace.CurrentCamera}, options)
```

## [Related Functions](#related-functions)

* [`saveplace`](/docs/miscellaneous/saveplace) - Serialize the current place
* [`decompile`](/docs/scripts/decompile) - Configure script decompilation


---

# saveplace

Source: https://docs.voltbz.net/docs/miscellaneous/saveplace

Serializes the current DataModel to the game's binary place format.

## [Syntax](#syntax)

```
saveplace(options: SaveInstanceOptions?) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `options` | `SaveInstanceOptions?` | Optional settings created with `SaveInstanceOptions.new()` |

## [Description](#description)

`saveplace` saves the current place as a binary `.rbxl` file. If `FilePath` is empty, Volt generates a filename. If a supplied path has no extension, `.rbxl` is appended; an existing extension is left unchanged.

See [`saveinstance`](/docs/miscellaneous/saveinstance#saveinstanceoptions) for every option.

## [Example](#example)

```
local options = SaveInstanceOptions.new()
options.FilePath = "exports/current-place.rbxl"
options.SaveNilInstances = false
options.SavePlayerCharacters = false
options.SavePlayers = false

saveplace(options)
print(isfile("exports/current-place.rbxl")) -- true
```

Options may be omitted:

```
saveplace()
```

## [Related Functions](#related-functions)

* [`saveinstance`](/docs/miscellaneous/saveinstance) - Serialize an instance or selection


---

# checkcaller

Source: https://docs.voltbz.net/docs/closures/checkcaller

Returns whether the current function was called by Volt.

## [Syntax](#syntax)

```
checkcaller() -> boolean
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | `true` if called from a Volt thread, `false` otherwise |

## [Description](#description)

`checkcaller` returns a boolean indicating whether the current function was invoked from Volt's own thread. This is useful for differentiating between your own calls and those made by the game.

When you hook a game function, both your code and the game will trigger it. Use `checkcaller` to determine whether to run custom logic or pass through to the original.

## [Example](#example)

```
local old
old = hookfunction(game.HttpGet, function(self, url, ...)
    if checkcaller() then
        -- Call is from our script, allow it
        return old(self, url, ...)
    end

    -- Call is from the game, we can block or modify it
    print("Game tried to fetch:", url)
    return old(self, url, ...)
end)

-- This will pass checkcaller() because we're calling it
local result = game:HttpGet("https://example.com")
```


---

# clonefunction

Source: https://docs.voltbz.net/docs/closures/clonefunction

Creates a copy of the given function.

## [Syntax](#syntax)

```
clonefunction(func: function) -> function
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | The function to clone |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function` | A copy of the original function |

## [Description](#description)

`clonefunction` creates an independent copy of a function. The cloned function behaves identically to the original but is a separate entity. This is particularly useful when you need to keep a reference to the original behavior before hooking.

## [Example](#example)

```
-- Clone a function before hooking it
local originalPrint = clonefunction(print)

-- Now hook the original
hookfunction(print, function(...)
    originalPrint("[HOOKED]", ...)
end)

-- The clone still works as the original
originalPrint("This bypasses the hook")

-- The hooked version adds prefix
print("This goes through the hook") -- Output: [HOOKED] This goes through the hook
```

## [Notes](#notes)

* The cloned function shares the same upvalues as the original
* C closures are supported
* Cloning is useful for preserving original behavior during hooks


---

# getfunctionhash

Source: https://docs.voltbz.net/docs/closures/getfunctionhash

Returns a hash of the function's bytecode.

## [Syntax](#syntax)

```
getfunctionhash(func: function) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | The function to hash |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | A 96-character hexadecimal SHA-384 digest |

## [Description](#description)

`getfunctionhash` computes a SHA-384 digest over a Luau closure's instructions and constants. It throws for C closures, which have no Luau bytecode to hash.

## [Example](#example)

```
local function isSha384Hex(hash)
    return #hash == 96 and hash:match("^[0-9a-fA-F]+$") ~= nil
end

local function first()
    return "constant"
end

local function second()
    return "different constant"
end

local firstHash = getfunctionhash(first)
local secondHash = getfunctionhash(second)

print(isSha384Hex(firstHash)) -- true
print(firstHash == secondHash) -- false
```

## [Notes](#notes)

* Only works with Luau closures; C closures throw an error
* Slight changes in function bytecode will alter the returned hash


---

# hookfunction

Source: https://docs.voltbz.net/docs/closures/hookfunction

Replaces a function with a custom implementation.

## [Syntax](#syntax)

```
hookfunction(target: function, hook: function) -> function
```

## [Aliases](#aliases)

* `replaceclosure`
* `hookfunc`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `target` | `function` | The function to hook |
| `hook` | `function` | The replacement function |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function` | A reference to the original function |

## [Description](#description)

`hookfunction` replaces the target function with your hook function. All calls to the original function will now go through your hook instead. The function returns a reference to the original, allowing you to call it from within your hook.

## [Example](#example)

```
-- Hook the print function
local originalPrint = hookfunction(print, function(...)
    originalPrint("[PREFIX]", ...)
end)

print("Hello") -- Output: [PREFIX] Hello

-- You can still use the original
originalPrint("Direct call") -- Output: Direct call
```

## [Advanced Example](#advanced-example)

```
-- Hook a game method
local oldNamecall
oldNamecall = hookfunction(
    getrawmetatable(game).__namecall,
    newcclosure(function(self, ...)
        local method = getnamecallmethod()

        if method == "Kick" then
            return -- Block kick
        end

        return oldNamecall(self, ...)
    end)
)
```

## [Notes](#notes)

* Use `checkcaller` to differentiate between your calls and game calls
* Automatically wrapps Luau hooks in `newcclosure` when hooking C closures
* The returned original can be called to bypass the hook
* Restore the hook with `restorefunction`


---

# hookmetamethod

Source: https://docs.voltbz.net/docs/closures/hookmetamethod

Hooks a metamethod on an object's metatable.

## [Syntax](#syntax)

```
hookmetamethod(object: any, metamethod: string, hook: function) -> function
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `object` | `any` | An object with the target metatable |
| `metamethod` | `string` | The metamethod name (e.g., "\*\*index", "\*\*namecall") |
| `hook` | `function` | The replacement function |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function` | A reference to the original metamethod |

## [Description](#description)

`hookmetamethod` replaces a metamethod in an object's metatable with your custom function. This is commonly used to intercept method calls, property accesses, and other metamethod operations on instances.

## [Example](#example)

```
-- Hook __namecall to intercept method calls
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()

    if method == "GetService" then
        print("GetService called with:", ...)
    end

    return oldNamecall(self, ...)
end))

-- This triggers the hook
local players = game:GetService("Players")
```

## [Common Metamethods](#common-metamethods)

| Metamethod | Triggered By |
| --- | --- |
| `__index` | Property reads (`obj.Property`) |
| `__newindex` | Property writes (`obj.Property = value`) |
| `__namecall` | Method calls (`obj:Method()`) |
| `__tostring` | `tostring(obj)` |
| `__eq` | Equality comparison (`obj1 == obj2`) |

## [Notes](#notes)

* Automatically uses `newcclosure` when hooking metamethods on game objects
* Use `getnamecallmethod` inside `__namecall` hooks to get the method name
* Multiple objects may share the same metatable
* Use `checkcaller` to filter Volt calls from game calls


---

# iscclosure

Source: https://docs.voltbz.net/docs/closures/iscclosure

Checks if a function is a C closure.

## [Syntax](#syntax)

```
iscclosure(func: function) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | The function to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | `true` if the function is a C closure, `false` otherwise |

## [Description](#description)

`iscclosure` returns whether the given function is implemented in C/C++ rather than Luau. C closures include built-in Luau functions, game API methods, and functions wrapped with `newcclosure`.

## [Example](#example)

```
-- Built-in functions are C closures
print(iscclosure(print)) -- true
print(iscclosure(type)) -- true
print(iscclosure(game.GetService)) -- true

-- User-defined functions are Luau closures
local function myFunc()
    return "hello"
end
print(iscclosure(myFunc)) -- false

-- Wrapped functions become C closures
local wrapped = newcclosure(myFunc)
print(iscclosure(wrapped)) -- true
```

## [Related Functions](#related-functions)

* [`islclosure`](/docs/closures/islclosure) - Check if a function is a Luau closure
* [`newcclosure`](/docs/closures/newcclosure) - Wrap a Luau function as a C closure


---

# isexecutorclosure

Source: https://docs.voltbz.net/docs/closures/isexecutorclosure

Checks if a function originates from Volt.

## [Syntax](#syntax)

```
isexecutorclosure(func: function) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | The function to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | `true` if the function is from Volt, `false` otherwise |

## [Description](#description)

`isexecutorclosure` determines whether a function was created by or is part of Volt's environment. This includes both Volt-provided functions (like `loadstring`, `hookfunction`) and functions defined in your scripts.

## [Example](#example)

```
-- Volt functions return true
print(isexecutorclosure(loadstring)) -- true
print(isexecutorclosure(hookfunction)) -- true

-- Your script functions return true
local function myFunc()
    return "hello"
end
print(isexecutorclosure(myFunc)) -- true

-- Game functions return false
print(isexecutorclosure(print)) -- false
print(isexecutorclosure(game.GetService)) -- false
```

## [Related Functions](#related-functions)

* [`checkcaller`](/docs/closures/checkcaller) - Check if the current call is from Volt's thread
* [`iscclosure`](/docs/closures/iscclosure) - Check if a function is a C closure
* [`islclosure`](/docs/closures/islclosure) - Check if a function is a Luau closure

## [Aliases](#aliases)

* `checkclosure`
* `isourclosure`


---

# isfunctionhooked

Source: https://docs.voltbz.net/docs/closures/isfunctionhooked

Checks if a function has been hooked.

## [Syntax](#syntax)

```
isfunctionhooked(func: function) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | The function to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if the function is hooked |

## [Description](#description)

`isfunctionhooked` checks whether a function has been replaced using `hookfunction` or similar hooking methods.

## [Example](#example)

```
local function myFunc()
    return "original"
end

print(isfunctionhooked(myFunc)) -- false

hookfunction(myFunc, function()
    return "hooked"
end)

print(isfunctionhooked(myFunc)) -- true
```

## [Use Cases](#use-cases)

* Checking if a function has already been hooked
* Avoiding double-hooking
* Debugging hook states

## [Related Functions](#related-functions)

* [`hookfunction`](/docs/closures/hookfunction) - Hook a function
* [`restorefunction`](/docs/closures/restorefunction) - Restore original


---

# islclosure

Source: https://docs.voltbz.net/docs/closures/islclosure

Checks if a function is a Luau closure.

## [Syntax](#syntax)

```
islclosure(func: function) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | The function to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | `true` if the function is a Luau closure, `false` otherwise |

## [Description](#description)

`islclosure` returns whether the given function is written in Luau rather than C/C++. Luau closures include user-defined functions and script functions.

## [Example](#example)

```
-- User-defined functions are Luau closures
local function myFunc()
    return "hello"
end
print(islclosure(myFunc)) -- true

-- Built-in functions are NOT Luau closures
print(islclosure(print)) -- false
print(islclosure(type)) -- false

-- Wrapped functions are NOT Luau closures
local wrapped = newcclosure(myFunc)
print(islclosure(wrapped)) -- false
```

## [Relationship with iscclosure](#relationship-with-iscclosure)

`islclosure` is the logical opposite of `iscclosure`:

```
local function test() end

print(islclosure(test)) -- true
print(iscclosure(test)) -- false

print(islclosure(test) == not iscclosure(test)) -- true
```

## [Related Functions](#related-functions)

* [`iscclosure`](/docs/closures/iscclosure) - Check if a function is a C closure
* [`newcclosure`](/docs/closures/newcclosure) - Convert a Luau closure to a C closure


---

# isnewcclosure

Source: https://docs.voltbz.net/docs/closures/isnewcclosure

Checks if a function is a newcclosure wrapper.

## [Syntax](#syntax)

```
isnewcclosure(func: function) -> boolean
```

## [Aliases](#aliases)

* `iscustomcclosure`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | The function to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if function was created by newcclosure |

## [Description](#description)

`isnewcclosure` checks whether a function was wrapped using `newcclosure`.

## [Example](#example)

```
local function luaFunc()
    return "lua"
end

local wrapped = newcclosure(luaFunc)

print(isnewcclosure(luaFunc)) -- false
print(isnewcclosure(wrapped)) -- true
print(isnewcclosure(print))   -- false (native C closure)
```

## [Notes](#notes)

* Useful for distinguishing between native C closures and wrapped functions
* Returns false for native C closures like `print`

## [Related Functions](#related-functions)

* [`newcclosure`](/docs/closures/newcclosure) - Wrap as C closure
* [`iscclosure`](/docs/closures/iscclosure) - Check if C closure
* [`islclosure`](/docs/closures/islclosure) - Check if Luau closure


---

# newcclosure

Source: https://docs.voltbz.net/docs/closures/newcclosure

Wraps a Luau function to appear as a C closure.

## [Syntax](#syntax)

```
newcclosure(func: function, debugname?: string) -> function
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | The Luau function to wrap |
| `debugname` | `string?` | Optional debug name for the wrapper |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function` | A C closure wrapper that calls the original function |

## [Description](#description)

`newcclosure` wraps a Luau function so that it appears to be a C closure when inspected. The wrapped function behaves identically but `iscclosure` will return `true` for it.

## [Example](#example)

```
local function myHook(...)
    print("Hooked!")
    return ...
end

-- Check before wrapping
print(iscclosure(myHook)) -- false

-- Wrap it
local wrapped = newcclosure(myHook)

-- Now it appears as a C closure
print(iscclosure(wrapped)) -- true

-- But still works the same
wrapped("test") -- Output: Hooked!
```

## [With a Debug Name](#with-a-debug-name)

```
local wrapped = newcclosure(function()
    print("Handling request")
end, "RequestHandler")

wrapped()
```

## [Notes](#notes)

* The wrapper is yieldable
* It has no upvalues and reports errors with C-closure semantics
* `debugname` changes the name shown by debug tooling

## [Related Functions](#related-functions)

* [`newlclosure`](/docs/closures/newlclosure) - Wrap as Luau closure
* [`iscclosure`](/docs/closures/iscclosure) - Check if C closure
* [`isnewcclosure`](/docs/closures/isnewcclosure) - Check if newcclosure


---

# newlclosure

Source: https://docs.voltbz.net/docs/closures/newlclosure

Wraps a C closure to appear as a Luau closure.

## [Syntax](#syntax)

```
newlclosure(func: function, debugname?: string) -> function
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | The C closure to wrap |
| `debugname` | `string?` | Optional debug name for the wrapper |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function` | A Luau closure wrapper that calls the original function |

## [Description](#description)

`newlclosure` wraps a C closure so that it appears to be a Luau closure when inspected. The wrapped function behaves identically but `islclosure` will return `true` for it.

## [Example](#example)

```
-- print is a C closure
print(iscclosure(print)) -- true
print(islclosure(print)) -- false

-- Wrap it as a Luau closure
local wrappedPrint = newlclosure(print)

-- Now it appears as a Luau closure
print(iscclosure(wrappedPrint)) -- false
print(islclosure(wrappedPrint)) -- true

-- But still works the same
wrappedPrint("Hello!") -- Output: Hello!
```

## [Related Functions](#related-functions)

* [`newcclosure`](/docs/closures/newcclosure) - Wrap as C closure
* [`islclosure`](/docs/closures/islclosure) - Check if Luau closure
* [`iscclosure`](/docs/closures/iscclosure) - Check if C closure


---

# restorefunction

Source: https://docs.voltbz.net/docs/closures/restorefunction

Restores a hooked function to its original implementation.

## [Syntax](#syntax)

```
restorefunction(func: function) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | The hooked function to restore |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`restorefunction` removes a hook from a function, restoring it to its original behavior. This is useful for cleanup or when you need to temporarily remove a hook.

## [Example](#example)

```
-- Hook print
local originalPrint = hookfunction(print, function(...)
    originalPrint("[HOOKED]", ...)
end)

print("Test 1") -- Output: [HOOKED] Test 1

-- Restore the original
restorefunction(print)

print("Test 2") -- Output: Test 2 (no prefix)
```

## [Notes](#notes)

* Only works on functions that were hooked by Volt
* Has no effect on functions that aren't currently hooked
* The original function reference from `hookfunction` remains valid

## [Aliases](#aliases)

* `restorefunc`


---

# setstackhidden

Source: https://docs.voltbz.net/docs/closures/setstackhidden

Sets whether a function is hidden from stack traces.

## [Syntax](#syntax)

```
setstackhidden(funcOrLevel: function | number, hidden: boolean) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `funcOrLevel` | `function` or `number` | Function to modify, or a non-negative stack level |
| `hidden` | `boolean` | Whether to hide from stack |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`setstackhidden` controls whether a function appears in stack traces and debug info. Hidden functions are invisible to stack inspection.

## [Example](#example)

```
local function secretFunc()
    print("This function is hidden!")
end

setstackhidden(secretFunc, true)

-- Now secretFunc won't appear in debug.traceback()
```

## [Use Cases](#use-cases)

* Hiding hook implementations
* Preventing detection via stack inspection
* Clean stack traces

## [Related Functions](#related-functions)

* [`debug.getinfo`](/docs/debug/getinfo) - Get function info
* [`debug.getcallstack`](/docs/debug/getcallstack) - Get call stack


---

# debug.getcallstack

Source: https://docs.voltbz.net/docs/debug/getcallstack

Gets visible call frames from the current thread or another thread.

## [Syntax](#syntax)

```
debug.getcallstack(thread?: thread) -> {{func: function, currentline: number?}}
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `thread` | `thread?` | Thread to inspect; defaults to the current thread |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Array of call stack entries |

## [Description](#description)

`debug.getcallstack` returns non-hidden frames. Each entry contains the function and, for Luau frames, the current source line. OTH hook frames are followed into their linked original thread.

## [Example](#example)

```
local function innerFunc()
    local stack = debug.getcallstack()
    for i, entry in ipairs(stack) do
        local info = debug.getinfo(entry.func)
        print(i, info.name or "anonymous", entry.currentline)
    end
end

local function outerFunc()
    innerFunc()
end

outerFunc()
```

## [Entry Fields](#entry-fields)

| Field | Description |
| --- | --- |
| `func` | Function running in this frame |
| `currentline` | Current source line for a Luau frame; absent for C frames |

## [Related Functions](#related-functions)

* [`debug.getinfo`](/docs/debug/getinfo) - Get info for specific level
* [`debug.validlevel`](/docs/debug/validlevel) - Check if level is valid


---

# debug.getconstant

Source: https://docs.voltbz.net/docs/debug/getconstant

Gets a constant from a function at the specified index.

## [Syntax](#syntax)

```
debug.getconstant(func: function | number | ProtoProxy, index: number) -> any
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function`, stack level, or `ProtoProxy` | The prototype to inspect |
| `index` | `number` | The constant index (1-based) |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `any` | The constant value at the specified index |

## [Description](#description)

`debug.getconstant` retrieves a constant value from a function's bytecode. Constants are literal values like strings, numbers, and booleans that are embedded in the compiled function.

## [Example](#example)

```
local function example()
    local x = "hello"
    local y = 42
    print(x, y)
end

-- Constant order is compiler-dependent, so discover the index first
for index, value in ipairs(debug.getconstants(example)) do
    print(index, debug.getconstant(example, index), value)
end
```

## [Using Stack Level](#using-stack-level)

You can also pass a stack level instead of a function:

```
local function inner()
    -- Get constant from the calling function (level 2)
    print(debug.getconstant(2, 1))
end

local function outer()
    local msg = "from outer"
    inner()
end

outer() -- Prints a constant from outer
```

## [Notes](#notes)

* Index is 1-based
* Not all indices may have constants (some may be nil)
* Only works with Luau closures

## [Related Functions](#related-functions)

* [`debug.getconstants`](/docs/debug/getconstants) - Get all constants
* [`debug.setconstant`](/docs/debug/setconstant) - Modify a constant


---

# debug.getconstants

Source: https://docs.voltbz.net/docs/debug/getconstants

Gets all constants from a function.

## [Syntax](#syntax)

```
debug.getconstants(func: function | number | ProtoProxy) -> table
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function`, stack level, or `ProtoProxy` | The prototype to inspect |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | An array of all constants in the function |

## [Description](#description)

`debug.getconstants` returns a table containing all constant values embedded in a function's bytecode. This is useful for inspecting what literal values a function uses.

## [Example](#example)

```
local function greet(name)
    local greeting = "Hello"
    local punctuation = "!"
    return greeting .. ", " .. name .. punctuation
end

local constants = debug.getconstants(greet)
for i, v in ipairs(constants) do
    print(i, type(v), v)
end
--[[
Output:
1  string  Hello
2  string  !
3  string  , 
]]
```

## [Inspecting Game Functions](#inspecting-game-functions)

```
-- Find what strings a function uses
local function findStrings(func)
    local strings = {}
    for i, const in ipairs(debug.getconstants(func)) do
        if type(const) == "string" then
            table.insert(strings, const)
        end
    end
    return strings
end
```

## [Notes](#notes)

* The table is indexed starting at 1
* Some indices may contain `nil` for unused constant slots
* Only works with Luau closures

## [Related Functions](#related-functions)

* [`debug.getconstant`](/docs/debug/getconstant) - Get a single constant
* [`debug.setconstant`](/docs/debug/setconstant) - Modify a constant


---

# debug.getinfo

Source: https://docs.voltbz.net/docs/debug/getinfo

Gets information about a function or stack level.

## [Syntax](#syntax)

```
debug.getinfo(func_or_level: function | number | ProtoProxy) -> table
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func_or_level` | `function`, `number`, or `ProtoProxy` | Function, stack level, or nested prototype |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Information about target |

## [Description](#description)

`debug.getinfo` returns a table with information about a function or the function at a given stack level.

## [Info Fields](#info-fields)

| Field | Description |
| --- | --- |
| `name` | Function name, or an empty string |
| `source` | Source identifier |
| `short_src` | Short source name |
| `what` | `Lua`, `C`, or `main` |
| `currentline` | Current line, or the runtime sentinel for a non-active function |
| `nups` | Number of upvalues |
| `numparams` | Number of parameters |
| `is_vararg` | `1` for a variadic function, otherwise `0` |
| `func` | Function or `ProtoProxy` passed in |

## [Example](#example)

```
local function myFunc()
    return "hello"
end

local info = debug.getinfo(myFunc)
print("Name:", info.name)
print("Source:", info.short_src)
print("Current line:", info.currentline)

-- Get info for current function
local currentInfo = debug.getinfo(1)
print("Current function:", currentInfo.name)
```

## [Related Functions](#related-functions)

* [`debug.getcallstack`](/docs/debug/getcallstack) - Get full call stack
* [`debug.validlevel`](/docs/debug/validlevel) - Check if level is valid


---

# debug.getproto

Source: https://docs.voltbz.net/docs/debug/getproto

Gets a proto (nested function) from a function.

## [Syntax](#syntax)

```
debug.getproto(func: function | number | ProtoProxy, index: number, activated?: boolean) -> ProtoProxy | {function}
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` or `number` | The function or stack level |
| `index` | `number` | The proto index (1-based) |
| `activated` | `boolean?` | If true, returns all activated instances |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `ProtoProxy` | The nested prototype when `activated` is false or omitted |
| `table` | Array of activated instances (if `activated` is true) |

## [Description](#description)

`debug.getproto` retrieves a nested prototype. By default Volt returns a non-executable `ProtoProxy` that can be inspected by other debug APIs. With `activated = true`, it returns the live closures currently using that prototype.

## [Example](#example)

```
local function outer()
    local function inner1()
        print("inner1")
    end
    
    local function inner2()
        print("inner2")
    end
    
    inner1()
    inner2()
end

-- Get and inspect the first nested prototype
local proto1 = debug.getproto(outer, 1)
print(debug.getconstants(proto1))

-- Get the second nested function
local proto2 = debug.getproto(outer, 2)
print(debug.getconstants(proto2))
```

## [Activated Instances](#activated-instances)

When `activated` is true, returns all instances of the proto that have been created:

```
local retainedClosures = {}

local function factory()
    local function create()
        return {}
    end
    table.insert(retainedClosures, create)
end

factory()

-- Get all activated instances of the inner function
local activated = debug.getproto(factory, 1, true)
print(#activated) -- 1 while the retained closure is alive
```

## [Related Functions](#related-functions)

* [`debug.getprotos`](/docs/debug/getprotos) - Get all protos from a function


---

# debug.getprotos

Source: https://docs.voltbz.net/docs/debug/getprotos

Gets all protos (nested functions) from a function.

## [Syntax](#syntax)

```
debug.getprotos(func: function | number | ProtoProxy) -> {ProtoProxy}
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function`, stack level, or `ProtoProxy` | The prototype to inspect |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | An array of `ProtoProxy` values for all nested prototypes |

## [Description](#description)

`debug.getprotos` returns `ProtoProxy` values for nested functions. These values can be used with compatible debug functions, but cannot be called directly.

## [Example](#example)

```
local function container()
    local function a() return 1 end
    local function b() return 2 end
    local function c() return 3 end
    return a() + b() + c()
end

local protos = debug.getprotos(container)
print(#protos) -- 3

for i, proto in ipairs(protos) do
    print(i, typeof(proto), #debug.getconstants(proto))
end
```

## [Use Cases](#use-cases)

* **Script analysis**: Find all functions defined within a script
* **Hooking**: Locate specific nested functions to hook
* **Debugging**: Inspect the structure of complex functions

## [Related Functions](#related-functions)

* [`debug.getproto`](/docs/debug/getproto) - Get a single proto by index


---

# debug.getstack

Source: https://docs.voltbz.net/docs/debug/getstack

Gets one value or all values from a Luau stack frame.

## [Syntax](#syntax)

```
debug.getstack(level: number, index?: number) -> any | {any}
debug.getstack(thread: thread, level: number, index?: number) -> any | {any}
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `level` | `number` | The stack level (1 = current function) |
| `index` | `number?` | The stack slot index. Omit it to return every value at the level |
| `thread` | `thread?` | Optional thread to inspect before `level` |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `any` or `{any}` | The selected value, or an array of every value when `index` is omitted |

## [Description](#description)

`debug.getstack` retrieves values from a Luau call frame. It throws if `level` refers to a C closure, including level `0`.

## [Example](#example)

```
local marker = "caller value"

local function inspectCaller()
    local callerStack = debug.getstack(2)

    for index, value in ipairs(callerStack) do
        print(index, value)
        assert(debug.getstack(2, index) == value)
    end
end

inspectCaller()
```

## [Stack Levels](#stack-levels)

| Level | Meaning |
| --- | --- |
| 1 | Current function |
| 2 | Calling function |
| 3 | Caller of the caller |
| ... | And so on |

## [Notes](#notes)

* Stack indices correspond to local variable slots
* The exact index depends on the function's compiled bytecode
* Values can include locals, parameters, functions, and temporary stack slots
* Stack layout is compiler-dependent; do not assume an index without inspecting the frame

## [Related Functions](#related-functions)

* [`debug.setstack`](/docs/debug/setstack) - Modify a stack value


---

# debug.getupvalue

Source: https://docs.voltbz.net/docs/debug/getupvalue

Gets an upvalue from a function by index.

## [Syntax](#syntax)

```
debug.getupvalue(func: function | number, index: number) -> any
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` or `number` | The function or stack level |
| `index` | `number` | The upvalue index (1-based) |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `any` | The upvalue at the specified index |

## [Description](#description)

`debug.getupvalue` retrieves an upvalue (captured variable from an outer scope) from a function. Upvalues are variables that a closure "closes over" from its enclosing environment.

## [Example](#example)

```
local counter = 0
local prefix = "Count: "

local function increment()
    counter = counter + 1
    return prefix .. counter
end

-- Upvalue order is compiler-dependent
for index in ipairs(debug.getupvalues(increment)) do
    print(index, debug.getupvalue(increment, index))
end

-- After calling the function
increment()
```

## [Use Cases](#use-cases)

* **Inspect closures**: See what variables a function has captured
* **Debugging**: Examine the state of captured variables
* **Modification**: Read before modifying with `setupvalue`

## [Related Functions](#related-functions)

* [`debug.getupvalues`](/docs/debug/getupvalues) - Get all upvalues
* [`debug.setupvalue`](/docs/debug/setupvalue) - Modify an upvalue


---

# debug.getupvalues

Source: https://docs.voltbz.net/docs/debug/getupvalues

Gets all upvalues from a function.

## [Syntax](#syntax)

```
debug.getupvalues(func: function | number) -> table
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` or `number` | The function or stack level |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | A table mapping indices to upvalue values |

## [Description](#description)

`debug.getupvalues` returns a table containing all upvalues (captured variables) of a function.

## [Example](#example)

```
local a = 1
local b = "hello"
local c = {key = "value"}

local function example()
    print(a, b, c.key)
end

local upvalues = debug.getupvalues(example)
for i, v in pairs(upvalues) do
    print(i, type(v), v)
end
--[[
Output:
1  number   1
2  string   hello
3  table    table: 0x...
]]
```

## [Practical Use](#practical-use)

```
-- Find all string upvalues in a function
local function getStringUpvalues(func)
    local strings = {}
    for i, upvalue in pairs(debug.getupvalues(func)) do
        if type(upvalue) == "string" then
            strings[i] = upvalue
        end
    end
    return strings
end
```

## [Related Functions](#related-functions)

* [`debug.getupvalue`](/docs/debug/getupvalue) - Get a single upvalue
* [`debug.setupvalue`](/docs/debug/setupvalue) - Modify an upvalue


---

# ProtoProxy

Source: https://docs.voltbz.net/docs/debug/protoproxy

Represents a nested Luau prototype without presenting it as an activated closure.

## [Creation](#creation)

`debug.getproto` and `debug.getprotos` return `ProtoProxy` values unless activated closures are explicitly requested.

## [Properties](#properties)

```
proxy.CodeHash: number
```

`CodeHash` is a signed 32-bit hash of the prototype's instructions. It is useful for comparing proxies during the same executor version, but it is not a cryptographic digest.

## [Supported Functions](#supported-functions)

A `ProtoProxy` can be passed to:

* `debug.getproto` and `debug.getprotos`
* `debug.getconstant` and `debug.getconstants`
* `debug.setconstant`
* `debug.getinfo` and `debug.setinfo`
* Luau's `debug.info`

Calling a `ProtoProxy` is accepted by its metatable but returns no values and does not execute the nested function.

```
local function outer()
    local function inner()
        return "value"
    end
    return inner
end

local proxy = debug.getproto(outer, 1)
print(typeof(proxy)) -- ProtoProxy
print(proxy.CodeHash)
print(proxy()) -- nil; the nested function is not executed
```


---

# debug.setconstant

Source: https://docs.voltbz.net/docs/debug/setconstant

Sets a constant in a function at the specified index.

## [Syntax](#syntax)

```
debug.setconstant(func: function | number | ProtoProxy, index: number, value: any) -> function
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function`, stack level, or `ProtoProxy` | The prototype to modify |
| `index` | `number` | The constant index (1-based) |
| `value` | `any` | The new value for the constant |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function` | The function whose constant was changed |

## [Description](#description)

`debug.setconstant` modifies a constant value in a function's bytecode. This allows you to change literal values that the function uses.

## [Example](#example)

```
local function greet()
    return "Hello, World!"
end

print(greet()) -- "Hello, World!"

-- Find and change the string constant
local constants = debug.getconstants(greet)
for i, v in pairs(constants) do
    if v == "Hello, World!" then
        debug.setconstant(greet, i, "Goodbye, World!")
        break
    end
end

print(greet()) -- "Goodbye, World!"
```

## [Caution](#caution)

Modifying constants can cause unexpected behavior if:

* The constant is used in multiple places
* You set an incompatible type
* The bytecode expects a specific value

## [Use Cases](#use-cases)

* **Patching**: Change hardcoded values in game scripts
* **Testing**: Modify behavior without changing source
* **Bypasses**: Alter check values

## [Related Functions](#related-functions)

* [`debug.getconstant`](/docs/debug/getconstant) - Get a constant
* [`debug.getconstants`](/docs/debug/getconstants) - Get all constants


---

# debug.setinfo

Source: https://docs.voltbz.net/docs/debug/setinfo

Changes selected debug metadata on a Luau function or proto.

## [Syntax](#syntax)

```
debug.setinfo(func_or_level: function | number | ProtoProxy, info: table) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func_or_level` | `function`, stack level, or `ProtoProxy` | Luau proto to modify |
| `info` | `table` | Metadata fields to assign |

## [Supported Fields](#supported-fields)

| Field | Type | Description |
| --- | --- | --- |
| `source` | `string` | Full source identifier |
| `short_src` | `string` | Replacement source identifier that preserves a leading `=` or `@` marker |
| `name` | `string` | Function debug name |
| `currentline` | `number` | Function definition line |

If both `source` and `short_src` are present, `source` takes precedence.

## [Example](#example)

```
local function example()
    return true
end

debug.setinfo(example, {
    source = "@custom/example.luau",
    name = "renamed_example",
    currentline = 25,
})

local info = debug.getinfo(example)
print(info.source) -- @custom/example.luau
print(info.name) -- renamed_example
print(info.currentline) -- 25
```

## [Notes](#notes)

* C closures are rejected

## [Related Functions](#related-functions)

* [`debug.getinfo`](/docs/debug/getinfo) - Read debug metadata
* [`debug.getproto`](/docs/debug/getproto) - Access nested protos


---

# debug.setstack

Source: https://docs.voltbz.net/docs/debug/setstack

Sets a value on the stack at a specific level and index.

## [Syntax](#syntax)

```
debug.setstack(level: number, index: number, value: any) -> ()
debug.setstack(thread: thread, level: number, index: number, value: any) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `level` | `number` | The stack level (1 = current function) |
| `index` | `number` | The stack slot index |
| `value` | `any` | The new value to set |
| `thread` | `thread?` | Optional thread to modify before `level` |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`debug.setstack` modifies a value on the call stack. This can change local variables in any active function on the stack.

## [Example](#example)

```
local function modifier()
    for index, stackValue in ipairs(debug.getstack(2)) do
        if stackValue == "original" then
            debug.setstack(2, index, "modified!")
            return
        end
    end
end

local function example()
    local value = "original"
    modifier()
    print(value) -- "modified!"
end

example()
```

## [Caution](#caution)

Modifying stack values can cause crashes or undefined behavior if:

* You set an incompatible type
* The index doesn't exist
* The value is used in unexpected ways

## [Related Functions](#related-functions)

* [`debug.getstack`](/docs/debug/getstack) - Get a stack value


---

# debug.setupvalue

Source: https://docs.voltbz.net/docs/debug/setupvalue

Sets an upvalue in a function by index.

## [Syntax](#syntax)

```
debug.setupvalue(func: function | number, index: number, value: any) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` or `number` | The function or stack level |
| `index` | `number` | The upvalue index (1-based) |
| `value` | `any` | The new value for the upvalue |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`debug.setupvalue` modifies an upvalue (captured variable) in a function. Changes affect the shared variable, so all functions that capture the same upvalue will see the change.

## [Example](#example)

```
local count = 0

local function getCount()
    return count
end

local function increment()
    count = count + 1
end

print(getCount()) -- 0

-- Directly modify the upvalue
debug.setupvalue(getCount, 1, 100)

print(getCount()) -- 100
increment()
print(getCount()) -- 101
```

## [Shared Upvalues](#shared-upvalues)

When multiple functions share an upvalue, modifying it affects all of them:

```
local shared = "original"

local function read()
    return shared
end

local function write(val)
    shared = val
end

-- Both functions share the same upvalue
debug.setupvalue(read, 1, "modified")

print(read())  -- "modified"
print(write)   -- The write function also sees the change
```

## [Related Functions](#related-functions)

* [`debug.getupvalue`](/docs/debug/getupvalue) - Get an upvalue
* [`debug.getupvalues`](/docs/debug/getupvalues) - Get all upvalues


---

# debug.validlevel

Source: https://docs.voltbz.net/docs/debug/validlevel

Checks if a stack level is valid.

## [Syntax](#syntax)

```
debug.validlevel(level: number, thread?: thread) -> boolean
```

## [Aliases](#aliases)

* `debug.isvalidlevel`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `level` | `number` | The stack level |
| `thread` | `thread?` | Thread to inspect; defaults to the current thread |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if the stack level is valid |

## [Description](#description)

`debug.validlevel` checks whether a given stack level exists and is valid for debugging operations.

## [Example](#example)

```
-- Check stack levels
for i = 0, 10 do
    if debug.validlevel(i) then
        print("Level " .. i .. " is valid")
    else
        print("Level " .. i .. " is invalid")
        break
    end
end
```

## [Related Functions](#related-functions)

* [`debug.getinfo`](/docs/debug/getinfo) - Get function info
* [`debug.getcallstack`](/docs/debug/getcallstack) - Get call stack


---

# gethiddenproperties

Source: https://docs.voltbz.net/docs/reflection/gethiddenproperties

Gets all hidden properties of an object.

## [Syntax](#syntax)

```
gethiddenproperties(object: Object) -> table
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `object` | `Object` | The object to inspect |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Dictionary of hidden property values |

## [Description](#description)

`gethiddenproperties` returns a table containing all hidden (non-scriptable) properties and their current values.

## [Example](#example)

```
local part = Instance.new("Part")
local hidden = gethiddenproperties(part)

for property, value in pairs(hidden) do
    print(property, "=", value)
end
```

Properties that are write-only or cannot be read do not produce useful entries in the returned dictionary.

## [Related Functions](#related-functions)

* [`gethiddenproperty`](/docs/reflection/gethiddenproperty) - Get single hidden property
* [`sethiddenproperty`](/docs/reflection/sethiddenproperty) - Set hidden property
* [`getproperties`](/docs/reflection/getproperties) - Get all properties


---

# gethiddenproperty

Source: https://docs.voltbz.net/docs/reflection/gethiddenproperty

Gets the value of a hidden property.

## [Syntax](#syntax)

```
gethiddenproperty(object: Object, property: string) -> any?, boolean?
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `object` | `Object` | The object, including an `Instance` |
| `property` | `string` | The hidden property name |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `any?` | The property value, or nil when the property is missing, write-only, or cannot be read |
| `boolean?` | Whether the property is hidden from scripts; omitted for a missing property |

## [Description](#description)

`gethiddenproperty` reads a property and reports whether it is normally hidden from scripts. Ordinary properties return false as the second value.

## [Example](#example)

```
local part = Instance.new("Part")

local value, wasHidden = gethiddenproperty(part, "Transparency")
print("Value:", value)
print("Was hidden:", wasHidden) -- false

local missingValue, missingHidden = gethiddenproperty(part, "NotAProperty")
print(missingValue, missingHidden) -- nil, nil
```

## [Related Functions](#related-functions)

* [`sethiddenproperty`](/docs/reflection/sethiddenproperty) - Set a hidden property
* [`isscriptable`](/docs/reflection/isscriptable) - Check if property is scriptable


---

# getproperties

Source: https://docs.voltbz.net/docs/reflection/getproperties

Gets the readable properties of an object.

## [Syntax](#syntax)

```
getproperties(object: Object) -> table
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `object` | `Object` | The object to inspect |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Dictionary of property values that Volt could read |

## [Description](#description)

`getproperties` returns the readable properties of an `Object`, including hidden properties. Properties that cannot be read are omitted.

## [Example](#example)

```
local part = Instance.new("Part")
local properties = getproperties(part)

for property, value in pairs(properties) do
    print(property, "=", tostring(value))
end
```

## [Related Functions](#related-functions)

* [`gethiddenproperties`](/docs/reflection/gethiddenproperties) - Get hidden only
* [`gethiddenproperty`](/docs/reflection/gethiddenproperty) - Get single hidden property


---

# getthreadidentity

Source: https://docs.voltbz.net/docs/reflection/getthreadidentity

Gets the current thread's identity level.

## [Syntax](#syntax)

```
getthreadidentity() -> number
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `number` | The current identity level |

## [Description](#description)

`getthreadidentity` returns the identity level of the current thread. Higher identity levels have access to more restricted APIs.

## [Example](#example)

```
local identity = getthreadidentity()
print("Current identity:", identity)
```

## [Related Functions](#related-functions)

* [`setthreadidentity`](/docs/reflection/setthreadidentity) - Set the identity level

## [Aliases](#aliases)

* `getidentity`
* `getthreadcontext`
* `get_thread_identity`


---

# isnetworkowner

Source: https://docs.voltbz.net/docs/reflection/isnetworkowner

Checks if the local player owns a part's physics simulation.

## [Syntax](#syntax)

```
isnetworkowner(part: BasePart) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `part` | `BasePart` | The part to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if local player is network owner |

## [Description](#description)

`isnetworkowner` checks whether the local client has network ownership of a part, meaning they control its physics simulation.

## [Example](#example)

```
local part = Instance.new("Part")
part.Anchored = false
part.Parent = workspace

if isnetworkowner(part) then
    print("You own this part's physics")
    -- Can manipulate physics reliably
    part.Velocity = Vector3.new(0, 50, 0)
else
    print("Server or another player owns this part")
end

part:Destroy()
```

## [Notes](#notes)

* Network ownership affects physics simulation authority
* Ownership is assigned by the game and can change while the part is in the world


---

# isscriptable

Source: https://docs.voltbz.net/docs/reflection/isscriptable

Checks if a property is scriptable.

## [Syntax](#syntax)

```
isscriptable(object: Object, property: string) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `object` | `Object` | The object, including an `Instance` |
| `property` | `string` | The property name |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | Whether the property is currently scriptable |

## [Description](#description)

`isscriptable` checks whether a property is scriptable. An invalid property name raises an error.

## [Example](#example)

```
local part = Instance.new("Part")

-- Check common properties
print(isscriptable(part, "Name"))     -- true (visible)
print(isscriptable(part, "Position")) -- true (visible)
print(isscriptable(part, "size_xml")) -- false (hidden)
```

## [Use Case](#use-case)

```
local function getAllProperties(instance)
    local properties = {}
    
    -- Check a list of known property names
    local propertyNames = {"Name", "Position", "Size", "Color", "size_xml"}
    
    for _, propName in ipairs(propertyNames) do
        local scriptable = isscriptable(instance, propName)
        properties[propName] = {
            scriptable = scriptable,
            value = scriptable and instance[propName] or gethiddenproperty(instance, propName)
        }
    end
    
    return properties
end
```

## [Related Functions](#related-functions)

* [`setscriptable`](/docs/reflection/setscriptable) - Change scriptability
* [`gethiddenproperty`](/docs/reflection/gethiddenproperty) - Get hidden property values


---

# sethiddenproperty

Source: https://docs.voltbz.net/docs/reflection/sethiddenproperty

Sets the value of a hidden property.

## [Syntax](#syntax)

```
sethiddenproperty(object: Object, property: string, value: any) -> boolean?
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `object` | `Object` | The object, including an `Instance` |
| `property` | `string` | The hidden property name |
| `value` | `any` | The value to set |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean?` | Whether the property was non-scriptable, or no value when the property is missing |

## [Description](#description)

`sethiddenproperty` changes the selected property and returns whether it is normally hidden from scripts.

## [Example](#example)

```
local part = Instance.new("Part")

local wasHidden = sethiddenproperty(part, "Transparency", 0.5)
print(part.Transparency) -- 0.5
print(wasHidden) -- false, because Transparency is normally scriptable
```

## [Caution](#caution)

Modifying hidden properties can cause unexpected behavior or break instances. Only modify properties you understand.

## [Related Functions](#related-functions)

* [`gethiddenproperty`](/docs/reflection/gethiddenproperty) - Get a hidden property
* [`setscriptable`](/docs/reflection/setscriptable) - Make properties scriptable


---

# setscriptable

Source: https://docs.voltbz.net/docs/reflection/setscriptable

Sets whether a property is scriptable.

## [Syntax](#syntax)

```
setscriptable(object: Object, property: string, scriptable: boolean) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `object` | `Object` | The object, including an `Instance` |
| `property` | `string` | The property name |
| `scriptable` | `boolean` | The new scriptability |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | The previous scriptability; false is returned for a property that cannot be resolved |

## [Description](#description)

`setscriptable` changes whether a property is accessible through normal scripting. This can make hidden properties accessible via regular property access.

Not every hidden property supports this operation. Changing scriptability can also be observable by game code, so restore the previous value as soon as it is no longer needed.

## [Example](#example)

```
local part = Instance.new("Part")

-- Make a hidden property scriptable
local wasScriptable = setscriptable(part, "size_xml", true)

-- Now we can access it normally
print(part.size_xml)

-- Restore original state
setscriptable(part, "size_xml", wasScriptable)
```

## [Making Hidden Properties Accessible](#making-hidden-properties-accessible)

```
local function exposeProperty(instance, propName)
    local wasScriptable = setscriptable(instance, propName, true)
    return function()
        setscriptable(instance, propName, wasScriptable)
    end
end

-- Use
local restore = exposeProperty(part, "size_xml")
print(part.size_xml) -- Now accessible
restore() -- Restore original state
```

## [Related Functions](#related-functions)

* [`isscriptable`](/docs/reflection/isscriptable) - Check scriptability
* [`gethiddenproperty`](/docs/reflection/gethiddenproperty) - Alternative for hidden properties


---

# setsimulationradius

Source: https://docs.voltbz.net/docs/reflection/setsimulationradius

Compatibility function that currently has no effect.

## [Syntax](#syntax)

```
setsimulationradius(...: any) -> ()
```

## [Description](#description)

`setsimulationradius` currently does nothing and returns no values.

Do not use it to infer network ownership or physics authority. Use [`isnetworkowner`](/docs/reflection/isnetworkowner) to inspect a specific part instead.


---

# setthreadidentity

Source: https://docs.voltbz.net/docs/reflection/setthreadidentity

Sets the current thread's identity level.

## [Syntax](#syntax)

```
setthreadidentity(identity: number) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `identity` | `number` | The identity level (1-8) |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`setthreadidentity` changes the identity level of the current thread, which affects what APIs and properties are accessible.

## [Example](#example)

```
-- Check current identity
print("Before:", getthreadidentity())

-- Elevate identity
setthreadidentity(8)

print("After:", getthreadidentity())

-- Perform restricted operations here
```

## [Safe Identity Change](#safe-identity-change)

```
local function withIdentity(level, callback)
    local original = getthreadidentity()
    setthreadidentity(level)
    
    local success, result = pcall(callback)
    
    setthreadidentity(original)
    
    if not success then
        error(result)
    end
    
    return result
end

-- Use elevated identity temporarily
local result = withIdentity(8, function()
    -- Restricted operations here
    return "done"
end)
```

## [Notes](#notes)

* Higher identity gives more permissions
* Some operations require specific identity levels
* Always restore original identity when done

## [Related Functions](#related-functions)

* [`getthreadidentity`](/docs/reflection/getthreadidentity) - Get current identity

## [Aliases](#aliases)

* `setidentity`
* `setthreadcontext`
* `set_thread_identity`


---

# getnamecallmethod

Source: https://docs.voltbz.net/docs/metatable/getnamecallmethod

Gets the method name being called in a `__namecall` hook.

## [Syntax](#syntax)

```
getnamecallmethod() -> string?
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string?` | The method name inside a `__namecall` hook, otherwise nil |

## [Description](#description)

`getnamecallmethod` returns the name of the method that invoked `__namecall`. When called outside a `__namecall` hook, it safely returns nil.

## [Example](#example)

```
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    if method == "Kick" then
        return -- Block kick
    end
    
    if method == "FireServer" then
        print("FireServer called on:", self)
    end
    
    return oldNamecall(self, ...)
end))
```

## [Common Methods to Hook](#common-methods-to-hook)

| Method | Object | Description |
| --- | --- | --- |
| `FireServer` | RemoteEvent | Client to server communication |
| `InvokeServer` | RemoteFunction | Client to server with return |
| `Kick` | Player | Kick the player |
| `Destroy` | Instance | Destroy an instance |
| `GetService` | ServiceProvider | Get a service |

## [Filtering Example](#filtering-example)

```
local blockedMethods = {"Kick", "Ban", "Disconnect"}

oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    if table.find(blockedMethods, method) then
        warn("Blocked:", method)
        return
    end
    
    return oldNamecall(self, ...)
end))
```

## [Notes](#notes)

* Only works inside `__namecall` hooks
* Returns nil outside a `__namecall` hook
* Case-sensitive


---

# getrawmetatable

Source: https://docs.voltbz.net/docs/metatable/getrawmetatable

Gets the raw metatable of an object, bypassing `__metatable`.

## [Syntax](#syntax)

```
getrawmetatable(object: any) -> table?
```

Also available as `debug.getmetatable`.

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `object` | `any` | The object to get the metatable from |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table?` | The raw metatable, or nil if none |

## [Description](#description)

`getrawmetatable` retrieves the actual metatable of an object, bypassing the `__metatable` field that would normally prevent access via `getmetatable`.

## [Example](#example)

```
-- Normal getmetatable is blocked on game objects
print(getmetatable(game)) -- "The metatable is locked"

-- getrawmetatable bypasses this
local mt = getrawmetatable(game)
print(mt) -- table: 0x...
print(mt.__index) -- function
print(mt.__namecall) -- function
```

## [Inspecting Metamethods](#inspecting-metamethods)

```
local mt = getrawmetatable(game)

for key, value in pairs(mt) do
    print(key, type(value))
end
--[[
__index      function
__newindex   function
__namecall   function
__tostring   function
...
]]
```

## [Before Hooking](#before-hooking)

```
-- Always get the metatable before modifying
local mt = getrawmetatable(game)
local oldIndex = mt.__index

-- You may need to unlock it first
setreadonly(mt, false)
mt.__index = newcclosure(function(self, key)
    print("Indexing:", key)
    return oldIndex(self, key)
end)
setreadonly(mt, true)
```

## [Related Functions](#related-functions)

* [`setrawmetatable`](/docs/metatable/setrawmetatable) - Set a raw metatable
* [`setreadonly`](/docs/metatable/setreadonly) - Unlock the metatable


---

# isreadonly

Source: https://docs.voltbz.net/docs/metatable/isreadonly

Checks if a table is read-only.

## [Syntax](#syntax)

```
isreadonly(table: table) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `table` | `table` | The table to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | `true` if the table is read-only |

## [Description](#description)

`isreadonly` returns whether a table has been marked as read-only, preventing modifications.

## [Example](#example)

```
local mt = getrawmetatable(game)

print(isreadonly(mt)) -- true (game metatables are locked)

-- Normal tables are not read-only by default
local myTable = {a = 1}
print(isreadonly(myTable)) -- false
```

## [Before Modifying](#before-modifying)

```
local mt = getrawmetatable(game)

if isreadonly(mt) then
    setreadonly(mt, false)
    -- Now safe to modify
    mt.__index = myCustomIndex
    setreadonly(mt, true)
end
```

## [Related Functions](#related-functions)

* [`setreadonly`](/docs/metatable/setreadonly) - Set read-only status
* [`getrawmetatable`](/docs/metatable/getrawmetatable) - Get the metatable


---

# iswritable

Source: https://docs.voltbz.net/docs/metatable/iswritable

Checks if a table is writable (not read-only).

## [Syntax](#syntax)

```
iswritable(table: table) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `table` | `table` | The table to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if the table can be modified |

## [Description](#description)

`iswritable` checks whether a table can be modified. This is the inverse of `isreadonly` - it returns `true` when `isreadonly` would return `false`, and vice versa.

## [Example](#example)

```
local myTable = {value = 123}

print(iswritable(myTable)) -- true

makereadonly(myTable)
print(iswritable(myTable)) -- false

makewritable(myTable)
print(iswritable(myTable)) -- true
```

## [Metatable Example](#metatable-example)

```
local mt = getrawmetatable(game)

if iswritable(mt) then
    print("Metatable is writable")
else
    print("Metatable is read-only")
    makewritable(mt)
end
```

## [Notes](#notes)

* Equivalent to `not isreadonly(table)`
* Useful for checking before modifications

## [Related Functions](#related-functions)

* [`isreadonly`](/docs/metatable/isreadonly) - Check if table is read-only
* [`makewritable`](/docs/metatable/makewritable) - Make table writable
* [`makereadonly`](/docs/metatable/makereadonly) - Make table read-only


---

# makereadonly

Source: https://docs.voltbz.net/docs/metatable/makereadonly

Makes a table read-only.

## [Syntax](#syntax)

```
makereadonly(table: table) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `table` | `table` | The table to make read-only |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`makereadonly` sets a table's read-only flag to true, preventing modifications.

## [Example](#example)

```
local myTable = {value = 123}

makereadonly(myTable)

-- This will error
myTable.value = 456 -- Cannot modify read-only table
```

## [Notes](#notes)

* Equivalent to `setreadonly(table, true)`
* Use `makewritable` to reverse

## [Related Functions](#related-functions)

* [`makewritable`](/docs/metatable/makewritable) - Make table writable
* [`setreadonly`](/docs/metatable/setreadonly) - Set read-only status
* [`isreadonly`](/docs/metatable/isreadonly) - Check read-only status


---

# makewritable

Source: https://docs.voltbz.net/docs/metatable/makewritable

Makes a table writable.

## [Syntax](#syntax)

```
makewritable(table: table) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `table` | `table` | The table to make writable |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`makewritable` removes the read-only flag from a table, allowing modifications.

## [Example](#example)

```
local mt = getrawmetatable(game)

-- Make writable for modifications
makewritable(mt)

-- Now we can modify it
local oldIndex = mt.__index
mt.__index = newcclosure(function(self, key)
    return oldIndex(self, key)
end)

-- Lock it again
makereadonly(mt)
```

## [Notes](#notes)

* Equivalent to `setreadonly(table, false)`
* Always re-lock metatables after modification

## [Related Functions](#related-functions)

* [`makereadonly`](/docs/metatable/makereadonly) - Make table read-only
* [`setreadonly`](/docs/metatable/setreadonly) - Set read-only status
* [`isreadonly`](/docs/metatable/isreadonly) - Check read-only status


---

# setnamecallmethod

Source: https://docs.voltbz.net/docs/metatable/setnamecallmethod

Sets the method name for the current `__namecall` invocation.

## [Syntax](#syntax)

```
setnamecallmethod(method: string) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `method` | `string` | The new method name |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`setnamecallmethod` changes the method name that will be used for the current `__namecall` invocation. This allows you to redirect method calls to different methods.

## [Example](#example)

```
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    -- Redirect Kick to a harmless method
    if method == "Kick" then
        setnamecallmethod("GetFullName")
        return oldNamecall(self, ...)
    end
    
    return oldNamecall(self, ...)
end))
```

## [Spoofing Example](#spoofing-example)

```
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    -- Change FireServer to something else for debugging
    if method == "FireServer" then
        print("FireServer intercepted, redirecting...")
        setnamecallmethod("Fire")
    end
    
    return oldNamecall(self, ...)
end))
```

## [Notes](#notes)

* Only works inside `__namecall` hooks
* The change only affects the current call

## [Related Functions](#related-functions)

* [`getnamecallmethod`](/docs/metatable/getnamecallmethod) - Get current method
* [`hookmetamethod`](/docs/closures/hookmetamethod) - Hook metamethods


---

# setrawmetatable

Source: https://docs.voltbz.net/docs/metatable/setrawmetatable

Sets the raw metatable of an object.

## [Syntax](#syntax)

```
setrawmetatable<T>(object: T, metatable: table?) -> T
```

Also available as `debug.setmetatable`.

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `object` | `any` | The object to modify |
| `metatable` | `table?` | The new metatable, or nil to remove it |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `T` | The original object |

## [Description](#description)

`setrawmetatable` sets the metatable of an object directly, bypassing normal restrictions.

## [Example](#example)

```
local myTable = {}

-- Create a custom metatable
local mt = {
    __index = function(self, key)
        return "Key not found: " .. key
    end
}

local result = setrawmetatable(myTable, mt)

print(myTable.anything) -- "Key not found: anything"
print(result == myTable) -- true
```

## [Replacing Metatables](#replacing-metatables)

```
local object = {}
local originalMt = getrawmetatable(object)

-- Set a new metatable
setrawmetatable(object, {
    __tostring = function()
        return "Custom string!"
    end
})

print(tostring(object)) -- "Custom string!"

-- Restore the original metatable (including nil)
setrawmetatable(object, originalMt)
```

## [Caution](#caution)

Modifying metatables of game objects can cause unexpected behavior or crashes. Always keep a reference to the original.

## [Related Functions](#related-functions)

* [`getrawmetatable`](/docs/metatable/getrawmetatable) - Get a raw metatable


---

# setreadonly

Source: https://docs.voltbz.net/docs/metatable/setreadonly

Sets a table's read-only status.

## [Syntax](#syntax)

```
setreadonly(table: table, readonly: boolean) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `table` | `table` | The table to modify |
| `readonly` | `boolean` | The new read-only status |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`setreadonly` controls whether a table can be modified. This is useful for modifying game metatables, which are locked by default.

## [Example](#example)

```
local mt = getrawmetatable(game)

-- Unlock the metatable
setreadonly(mt, false)

-- Now we can modify it
local oldIndex = mt.__index
mt.__index = newcclosure(function(self, key)
    print("Accessing:", key)
    return oldIndex(self, key)
end)

-- Re-lock for safety
setreadonly(mt, true)
```

## [Pattern for Safe Modification](#pattern-for-safe-modification)

```
local function safeModifyMetatable(object, modifier)
    local mt = getrawmetatable(object)
    local wasReadonly = isreadonly(mt)
    
    if wasReadonly then
        setreadonly(mt, false)
    end
    
    modifier(mt)
    
    if wasReadonly then
        setreadonly(mt, true)
    end
end

safeModifyMetatable(game, function(mt)
    -- Your modifications here
end)
```

## [Notes](#notes)

* Always re-lock metatables after modification
* Some anti-cheats check for unlocked metatables
* Works on any Luau table, not just metatables

## [Related Functions](#related-functions)

* [`isreadonly`](/docs/metatable/isreadonly) - Check read-only status
* [`getrawmetatable`](/docs/metatable/getrawmetatable) - Get the metatable


---

# filtergc

Source: https://docs.voltbz.net/docs/environment/filtergc

Filters objects in the garbage collector based on specified criteria.

## [Syntax](#syntax)

```
filtergc(type: "function" | "table", options: table, returnOne?: boolean) -> any? | {any}
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `type` | `string` | The type of object to find ("function" or "table") |
| `options` | `table` | Filter options |
| `returnOne` | `boolean?` | Return the first match instead of an array (default: false) |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `any?` or `table` | The first match when `returnOne` is true; otherwise an array of matches |

## [Description](#description)

`filtergc` efficiently searches through garbage-collected objects with specific filter criteria. This is more performant than manually iterating through `getgc()`.

## [Function Filter Options](#function-filter-options)

| Option | Type | Description |
| --- | --- | --- |
| `Name` | `string` | Match function name |
| `Constants` | `table` | Match constants in function |
| `Upvalues` | `table` | Match upvalue values |
| `Hash` | `string` | Match the value returned by `getfunctionhash` |
| `IgnoreExecutor` | `boolean` | Exclude Volt-created functions (default: true) |
| `Environment` | `table` | Match the function's global environment |
| `StartLine` | `number` | Match the function's starting source line |
| `Source` | `string` | Match the function's short source name |
| `UpvalueCount` | `number` | Match the exact upvalue count |
| `ConstantCount` | `number` | Match the exact constant count |

## [Table Filter Options](#table-filter-options)

| Option | Type | Description |
| --- | --- | --- |
| `Keys` | `table` | Match table keys |
| `Values` | `table` | Match table values |
| `KeyValuePairs` | `table` | Match key-value pairs |
| `Metatable` | `table` | Match metatable |

## [Example: Find Function by Name](#example-find-function-by-name)

```
local functions = filtergc("function", {
    Name = "targetFunction",
    IgnoreExecutor = false
})

for _, func in ipairs(functions) do
    print("Found:", func)
end
```

## [Example: Find Function by Constants](#example-find-function-by-constants)

```
local functions = filtergc("function", {
    Constants = {"SomeUniqueString", "AnotherString"},
    IgnoreExecutor = false
})
```

## [Example: Find Table by Keys](#example-find-table-by-keys)

```
local tables = filtergc("table", {
    Keys = {"Health", "MaxHealth", "Damage"}
})

for _, tbl in ipairs(tables) do
    print("Found table with game stats")
end
```

## [Example: Return the First Match](#example-return-the-first-match)

```
local function targetFunction()
    return "unique constant"
end

local match = filtergc("function", {
    Name = "targetFunction",
    IgnoreExecutor = false
}, true)

print(match == targetFunction) -- true
```

## [Notes](#notes)

* Function filters narrow the result: every supplied criterion must match
* `Constants`, `Upvalues`, and `Hash` do not apply to C closures

## [Related Functions](#related-functions)

* [`getgc`](/docs/environment/getgc) - Get all GC objects


---

# getallthreads

Source: https://docs.voltbz.net/docs/environment/getallthreads

Returns all Luau threads currently reachable by the calling state's garbage collector.

## [Syntax](#syntax)

```
getallthreads() -> {thread}
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `{thread}` | A weak array containing the threads found during the GC walk |

## [Example](#example)

```
local threads = getallthreads()
print("Threads found:", #threads)

for index, thread in ipairs(threads) do
    print(index, coroutine.status(thread), getscriptfromthread(thread))
end
```

## [Notes](#notes)

* The result is scoped to the caller's Luau state
* The result table has weak values, so a thread can disappear after collection if nothing else retains it

## [Related Functions](#related-functions)

* [`getgc`](/docs/environment/getgc) - Walk other garbage-collected values
* [`getscriptfromthread`](/docs/scripts/getscriptfromthread) - Get the script associated with a thread


---

# getgc

Source: https://docs.voltbz.net/docs/environment/getgc

Returns Luau functions tracked by the garbage collector, optionally including tables, userdata, and threads.

## [Syntax](#syntax)

```
getgc(includeTables?: boolean) -> table
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `includeTables` | `boolean?` | Whether to include tables (default: false) |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Array of functions, plus tables, userdata, and threads when requested |

## [Description](#description)

By default, `getgc` returns tracked functions. Pass `true` to also include tables, userdata, and threads.

## [Example](#example)

```
-- Get all functions in memory
for _, obj in ipairs(getgc()) do
    if type(obj) == "function" then
        print("Found function:", obj)
    end
end
```

## [Finding Specific Functions](#finding-specific-functions)

```
-- Find a function by its constants
local function findFunction(targetString)
    for _, obj in ipairs(getgc()) do
        if type(obj) == "function" and islclosure(obj) then
            local constants = debug.getconstants(obj)
            for _, const in ipairs(constants) do
                if const == targetString then
                    return obj
                end
            end
        end
    end
    return nil
end

local targetFunc = findFunction("SomeUniqueString")
print(targetFunc or "No matching function was found")
```

## [Including Tables](#including-tables)

```
-- Get all tables (slower, more results)
local allObjects = getgc(true)

for _, obj in ipairs(allObjects) do
    if type(obj) == "table" and rawget(obj, "SpecialKey") ~= nil then
        print("Found target table!")
    end
end
```

## [Notes](#notes)

* Without `includeTables`, only functions are returned
* With `includeTables`, tables, userdata, and threads are added to the result
* Including tables can be slow due to the large number of tables in memory
* Consider using `filtergc` for more targeted searches

## [Related Functions](#related-functions)

* [`filtergc`](/docs/environment/filtergc) - Filter objects with conditions


---

# getgenv

Source: https://docs.voltbz.net/docs/environment/getgenv

Returns Volt's global environment table.

## [Syntax](#syntax)

```
getgenv() -> table
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Volt's global environment |

## [Description](#description)

`getgenv` returns the global environment table used by Volt. Variables stored here persist across different script executions and can be accessed by all scripts running in Volt.

## [Example](#example)

```
-- Store a value in the Volt environment
getgenv().myGlobalValue = "Hello from script 1"

-- Later, in another script execution
print(getgenv().myGlobalValue) -- "Hello from script 1"
```

## [Shared State](#shared-state)

```
-- Script 1: Initialize shared state
getgenv().SharedData = {
    players = {},
    settings = {
        enabled = true
    }
}

-- Script 2: Access shared state
if getgenv().SharedData then
    print("Settings:", getgenv().SharedData.settings.enabled)
end
```

## [Checking if Script Already Ran](#checking-if-script-already-ran)

```
if getgenv().MyScriptLoaded then
    warn("Script already running!")
    return
end
getgenv().MyScriptLoaded = true

-- Rest of your script...
```

## [Related Functions](#related-functions)

* [`getrenv`](/docs/environment/getrenv) - Get game's environment
* [`getsenv`](/docs/scripts/getsenv) - Get a script's environment


---

# getreg

Source: https://docs.voltbz.net/docs/environment/getreg

Returns the Luau registry table.

## [Syntax](#syntax)

```
getreg() -> table
```

## [Aliases](#aliases)

* `getregistry`

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | The Luau registry |

## [Description](#description)

`getreg` returns the Luau registry, a special table used internally by Luau to store references. This can contain connections, threads, and other internal objects.

## [Example](#example)

```
local registry = getreg()

for i, v in pairs(registry) do
    print(i, type(v), v)
end
```

## [Finding Connections](#finding-connections)

```
-- Find all RBXScriptConnections in the registry
local connections = {}
for _, v in pairs(getreg()) do
    if type(v) == "table" then
        for _, item in pairs(v) do
            local t = typeof(item)
            if t == "RBXScriptConnection" then
                table.insert(connections, item)
            end
        end
    end
end
print("Found", #connections, "connections")
```

## [Notes](#notes)

* The registry contains internal Luau objects
* Modifying the registry can cause undefined behavior
* Use with caution and primarily for reading

## [Related Functions](#related-functions)

* [`getgenv`](/docs/environment/getgenv) - Get Volt's environment
* [`getrenv`](/docs/environment/getrenv) - Get game environment


---

# getrenv

Source: https://docs.voltbz.net/docs/environment/getrenv

Returns the game's global environment table.

## [Syntax](#syntax)

```
getrenv() -> table
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | The game's global environment |

## [Description](#description)

`getrenv` returns the global environment used by game scripts. This contains standard globals such as `game`, `workspace`, and `Instance`.

## [Example](#example)

```
local renv = getrenv()

-- Access game globals
print(renv.game)      -- Same as game
print(renv.workspace) -- Same as workspace
print(renv.Instance)  -- Same as Instance
```

## [Finding Game Globals](#finding-game-globals)

```
-- List all globals in the game environment
local renv = getrenv()
for name, value in pairs(renv) do
    print(name, type(value))
end
```

## [Difference from getgenv](#difference-from-getgenv)

| `getrenv()` | `getgenv()` |
| --- | --- |
| Game's environment | Volt's environment |
| Contains game globals | Contains Volt globals |
| Read-only access recommended | Can freely modify |

## [Checking for Global Modifications](#checking-for-global-modifications)

```
-- Check if game modified a global
local renv = getrenv()
if renv.print ~= print then
    warn("print function was modified!")
end
```

## [Related Functions](#related-functions)

* [`getgenv`](/docs/environment/getgenv) - Get Volt's environment
* [`getsenv`](/docs/scripts/getsenv) - Get a script's environment


---

# gettenv

Source: https://docs.voltbz.net/docs/environment/gettenv

Gets the environment of a thread.

## [Syntax](#syntax)

```
gettenv(thread: thread?) -> table?
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `thread` | `thread` | (Optional) Thread, defaults to current |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table?` | The thread's environment, or nil for a thread from another Luau state |

## [Description](#description)

`gettenv` returns the environment table for the specified thread. It defaults to the current thread. A thread whose main state differs from the caller's returns nil.

## [Example](#example)

```
-- Get current thread's environment
local env = gettenv()
print(env.print) -- The print function

-- Get another thread's environment
local thread = coroutine.create(function() end)
local threadEnv = gettenv(thread)
print(threadEnv ~= nil) -- true
```

## [Related Functions](#related-functions)

* [`getgenv`](/docs/environment/getgenv) - Get global environment
* [`getrenv`](/docs/environment/getrenv) - Get the game environment


---

# getcallingscript

Source: https://docs.voltbz.net/docs/scripts/getcallingscript

Returns the script that called the current function.

## [Syntax](#syntax)

```
getcallingscript() -> BaseScript | ModuleScript | nil
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `LocalScript` or `ModuleScript` or `nil` | The calling script |

## [Description](#description)

`getcallingscript` returns a reference to the script that invoked the current function. This is useful in hooks to identify which script triggered the call.

## [Example](#example)

```
local oldPrint = print
print = function(...)
    local caller = getcallingscript()
    if caller then
        oldPrint("[" .. caller.Name .. "]", ...)
    else
        oldPrint("[Unknown]", ...)
    end
end

-- When a game script calls print, it shows which script
```

## [In Metamethod Hooks](#in-metamethod-hooks)

```
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local caller = getcallingscript()
    local method = getnamecallmethod()

    if caller then
        print("Script:", caller:GetFullName())
        print("Method:", method)
    end

    return oldNamecall(self, ...)
end))
```

## [Notes](#notes)

* Returns nil if called from Volt (not from a game script)
* Useful for filtering hooks based on the calling script
* Works in hooked functions and metamethods


---

# getfunctionbytecode

Source: https://docs.voltbz.net/docs/scripts/getfunctionbytecode

Returns the bytecode for a Luau closure.

## [Syntax](#syntax)

```
getfunctionbytecode(func: function) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `func` | `function` | Luau closure to read |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | Binary Luau bytecode for the closure |

## [Example](#example)

```
local function add(a, b)
    return a + b
end

local bytecode = getfunctionbytecode(add)
print(type(bytecode), #bytecode > 0) -- string, true
```

## [Notes](#notes)

* C closures are rejected

## [Related Functions](#related-functions)

* [`getscriptbytecode`](/docs/scripts/getscriptbytecode) - Get the source payload stored for a script
* [`getfunctionhash`](/docs/closures/getfunctionhash) - Hash a Luau closure's instructions and constants


---

# getloadedmodules

Source: https://docs.voltbz.net/docs/scripts/getloadedmodules

Returns all currently loaded ModuleScripts.

## [Syntax](#syntax)

```
getloadedmodules() -> {ModuleScript}
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Array of loaded ModuleScripts |

## [Description](#description)

`getloadedmodules` returns the currently loaded ModuleScripts.

## [Example](#example)

```
local modules = getloadedmodules()
print("Loaded modules:", #modules)

for _, module in ipairs(modules) do
    print("-", module:GetFullName())
end
```

## [Finding Specific Modules](#finding-specific-modules)

```
local function findModule(name)
    for _, module in ipairs(getloadedmodules()) do
        if module.Name == name then
            return module
        end
    end
    return nil
end

local playerModule = findModule("PlayerModule")
if playerModule then
    print("Found PlayerModule:", playerModule:GetFullName())
end
```

## [Accessing Module Environments](#accessing-module-environments)

```
for _, module in ipairs(getloadedmodules()) do
    local env = getsenv(module)
    if env then
        print("Module:", module.Name)
        for key, value in pairs(env) do
            print("  ", key, type(value))
        end
    end
end
```

## [Related Functions](#related-functions)

* [`getrunningscripts`](/docs/scripts/getrunningscripts) - Get running scripts
* [`getsenv`](/docs/scripts/getsenv) - Get a script's environment


---

# getmodules

Source: https://docs.voltbz.net/docs/scripts/getmodules

Gets cached ModuleScripts.

## [Syntax](#syntax)

```
getmodules() -> {ModuleScript}
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `{ModuleScript}` | Array of cached ModuleScripts |

## [Description](#description)

`getmodules` returns cached ModuleScripts, including modules that have not been required.

## [Example](#example)

```
local modules = getmodules()
print("Total modules:", #modules)

-- Find a specific module
for _, module in ipairs(modules) do
    if module.Name == "Settings" then
        print("Found Settings module at:", module:GetFullName())
    end
end
```

## [Notes](#notes)

* Returns cached ModuleScripts, not only loaded ones
* Use `getloadedmodules` for only required modules

## [Related Functions](#related-functions)

* [`getloadedmodules`](/docs/scripts/getloadedmodules) - Get loaded modules only
* [`getscripts`](/docs/scripts/getscripts) - Get all scripts


---

# getrunningscripts

Source: https://docs.voltbz.net/docs/scripts/getrunningscripts

Returns scripts that are currently running.

## [Syntax](#syntax)

```
getrunningscripts() -> {LuaSourceContainer}
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `{LuaSourceContainer}` | Array of running scripts |

## [Description](#description)

Each script appears at most once in the returned array.

## [Example](#example)

```
local scripts = getrunningscripts()
print("Running scripts:", #scripts)

for _, script in ipairs(scripts) do
    print("-", script:GetFullName())
end
```

## [Monitoring Scripts](#monitoring-scripts)

```
local function listRunningScripts()
    local scripts = getrunningscripts()
    
    print("=== Running Scripts ===")
    for i, script in ipairs(scripts) do
        print(i, script.Name, script:GetFullName())
    end
    print("Total:", #scripts)
end

listRunningScripts()
```

## [Related Functions](#related-functions)

* [`getloadedmodules`](/docs/scripts/getloadedmodules) - Get loaded modules
* [`getscripts`](/docs/scripts/getscripts) - Get cached client-visible scripts
* [`getsenv`](/docs/scripts/getsenv) - Get a script's environment


---

# getscriptbytecode

Source: https://docs.voltbz.net/docs/scripts/getscriptbytecode

Gets processed Luau bytecode for a script.

## [Syntax](#syntax)

```
getscriptbytecode(script: CoreScript | LocalScript | ModuleScript | Script) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `script` | `CoreScript`, `LocalScript`, `ModuleScript`, or client `Script` | The script |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | Binary Luau bytecode |

## [Description](#description)

`getscriptbytecode` returns the bytecode associated with the script. It does not return source text.

## [Example](#example)

```
local module = getloadedmodules()[1]
if module then
    local bytecode = getscriptbytecode(module)
    print("Bytecode length:", #bytecode)
    writefile("module-bytecode.bin", bytecode)
end
```

## [Notes](#notes)

* If Volt cannot retrieve bytecode, the function raises an error
* Luau strings preserve embedded null bytes in the returned data
* Use `decompile(script)` when you need source text rather than interpreting this payload directly

## [Related Functions](#related-functions)

* [`getscripthash`](/docs/scripts/getscripthash) - Get a hash of the same bytecode
* [`getscriptclosure`](/docs/scripts/getscriptclosure) - Get the script's function

## [Aliases](#aliases)

* `dumpstring`


---

# getscriptclosure

Source: https://docs.voltbz.net/docs/scripts/getscriptclosure

Gets the main function of a script.

## [Syntax](#syntax)

```
getscriptclosure(script: LocalScript | ModuleScript | Script) -> function | string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `script` | `LocalScript`, `ModuleScript`, or client `Script` | The script |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function` | A newly compiled closure on success |
| `string` | A compilation error message |

## [Description](#description)

`getscriptclosure` compiles a new closure from a script's bytecode. It is not the closure currently running in the game, and for a ModuleScript it is not the value returned by `require()`.

## [Example](#example)

```
local scripts = getrunningscripts()
if #scripts > 0 then
    local closure = getscriptclosure(scripts[1])
    print("Got closure:", closure)
    local constants = debug.getconstants(closure)
    print("Constants:", #constants)
end
```

## [Accessing Module Functions](#accessing-module-functions)

```
local modules = getloadedmodules()
for _, module in ipairs(modules) do
    local closure = getscriptclosure(module)
    
    local protos = debug.getprotos(closure)
    print(module.Name, "has", #protos, "inner functions")
end
```

If the bytecode cannot be read, the function raises an error. A string result indicates that compilation failed.

## [Related Functions](#related-functions)

* [`getscriptbytecode`](/docs/scripts/getscriptbytecode) - Get bytecode
* [`getsenv`](/docs/scripts/getsenv) - Get script environment

## [Aliases](#aliases)

* `getscriptfunction`


---

# getscriptfromthread

Source: https://docs.voltbz.net/docs/scripts/getscriptfromthread

Gets the script associated with a thread.

## [Syntax](#syntax)

```
getscriptfromthread(thread: thread) -> BaseScript | ModuleScript | nil
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `thread` | `thread` | The thread to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `LuaSourceContainer?` | The script, or nil if none associated |

## [Description](#description)

`getscriptfromthread` returns the script (LocalScript, ModuleScript, or Script) that is running in the specified thread.

## [Example](#example)

```
local script = getscriptfromthread(coroutine.running())
if script then
    print("Current script:", script:GetFullName())
end

-- Check what script a connection is from
local connection
connection = game:GetService("RunService").Heartbeat:Connect(function()
    local thread = coroutine.running()
    local scriptSource = getscriptfromthread(thread)
    if scriptSource then
        print("Heartbeat from:", scriptSource.Name)
    end
    connection:Disconnect()
end)
```

## [Related Functions](#related-functions)

* [`getcallingscript`](/docs/scripts/getcallingscript) - Get calling script
* [`getrunningscripts`](/docs/scripts/getrunningscripts) - Get all running scripts


---

# getscripthash

Source: https://docs.voltbz.net/docs/scripts/getscripthash

Gets a hash of a script's bytecode.

## [Syntax](#syntax)

```
getscripthash(script: CoreScript | LocalScript | ModuleScript | Script) -> string?
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `script` | `CoreScript`, `LocalScript`, `ModuleScript`, or client `Script` | The script |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string?` | A lowercase SHA-384 hexadecimal hash, or nil if the script has no bytecode |

## [Description](#description)

`getscripthash` returns a lowercase SHA-384 hexadecimal hash. It returns nil when bytecode is unavailable.

## [Example](#example)

```
local module = getloadedmodules()[1]
if module then
    local hash = getscripthash(module)
    print("Script hash:", hash)
end
```

## [Comparing Scripts](#comparing-scripts)

```
local function sameCode(script1, script2)
    local first = getscripthash(script1)
    local second = getscripthash(script2)
    return first ~= nil and first == second
end
```

## [Tracking Changes](#tracking-changes)

```
local scriptHashes = {}

local function hasScriptChanged(script)
    local currentHash = getscripthash(script)
    if not currentHash then
        return false
    end
    local previousHash = scriptHashes[script]
    
    scriptHashes[script] = currentHash
    
    return previousHash ~= nil and previousHash ~= currentHash
end
```

## [Related Functions](#related-functions)

* [`getscriptbytecode`](/docs/scripts/getscriptbytecode) - Get the bytecode being hashed
* [`getfunctionhash`](/docs/closures/getfunctionhash) - Hash a function


---

# getscripts

Source: https://docs.voltbz.net/docs/scripts/getscripts

Returns cached client-visible scripts.

## [Syntax](#syntax)

```
getscripts() -> {BaseScript | ModuleScript}
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| Array of `BaseScript` and `ModuleScript` values | Cached LocalScripts, ModuleScripts, and client Scripts |

## [Description](#description)

`getscripts` returns cached LocalScripts, ModuleScripts, and client Scripts.

## [Example](#example)

```
local scripts = getscripts()
print("Total scripts:", #scripts)

-- Count by type
local counts = {LocalScript = 0, ModuleScript = 0, Script = 0}
for _, script in ipairs(scripts) do
    local class = script.ClassName
    counts[class] = (counts[class] or 0) + 1
end

for class, count in pairs(counts) do
    print(class, count)
end
```

## [Finding Specific Scripts](#finding-specific-scripts)

```
local function findScript(name)
    for _, script in ipairs(getscripts()) do
        if script.Name == name then
            return script
        end
    end
    return nil
end

local mainScript = findScript("MainLocalScript")
if mainScript then
    print("Found:", mainScript:GetFullName())
end
```

## [Related Functions](#related-functions)

* [`getrunningscripts`](/docs/scripts/getrunningscripts) - Get only running scripts
* [`getloadedmodules`](/docs/scripts/getloadedmodules) - Get only loaded modules


---

# getscriptthread

Source: https://docs.voltbz.net/docs/scripts/getscriptthread

Returns a thread associated with a client script or ModuleScript.

## [Syntax](#syntax)

```
getscriptthread(script: LocalScript | ModuleScript | Script) -> thread?
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `script` | `LocalScript`, `ModuleScript`, or client `Script` | Script whose thread should be found |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `thread?` | The associated thread, or nil when none is available |

## [Example](#example)

```
local runningScript = getrunningscripts()[1]
local thread = runningScript and getscriptthread(runningScript)

if thread then
    print(coroutine.status(thread))
    print(getscriptfromthread(thread) == runningScript) -- true
else
    warn("No running script thread was available")
end
```

## [Related Functions](#related-functions)

* [`getscriptfromthread`](/docs/scripts/getscriptfromthread) - Perform the reverse lookup
* [`getrunningscripts`](/docs/scripts/getrunningscripts) - List running scripts


---

# getsenv

Source: https://docs.voltbz.net/docs/scripts/getsenv

Gets a script's environment table.

## [Syntax](#syntax)

```
getsenv(script: LocalScript | ModuleScript | Script) -> table?
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `script` | `LocalScript`, `ModuleScript`, or client `Script` | The script |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table?` | The script's global environment, or nil if it is unavailable |

## [Description](#description)

`getsenv` returns the script's global environment. It does not include local variables and returns nil when the environment is unavailable.

## [Example](#example)

```
local scripts = getrunningscripts()
if #scripts > 0 then
    local env = getsenv(scripts[1])

    if env then
        print("Globals in script:")
        for key, value in pairs(env) do
            print("-", key, "=", type(value))
        end
    end
end
```

## [Accessing Script Variables](#accessing-script-variables)

```
local function getScriptVariable(scriptName, varName)
    for _, script in ipairs(getrunningscripts()) do
        if script.Name == scriptName then
            local env = getsenv(script)
            return env and env[varName]
        end
    end
    return nil
end

local playerData = getScriptVariable("MainScript", "PlayerData")
if playerData then
    print("Found player data!")
end
```

## [Modifying Script Variables](#modifying-script-variables)

```
local targetScript = getrunningscripts()[1]
local env = targetScript and getsenv(targetScript)

if targetScript and env then
    -- Modify a variable
    env.SomeFlag = true

    -- Call a function from the script
    if env.SomeFunction then
        env.SomeFunction()
    end
else
    warn("No running script environment was available")
end
```

## [Related Functions](#related-functions)

* [`getgenv`](/docs/environment/getgenv) - Get Volt's environment
* [`getrenv`](/docs/environment/getrenv) - Get game environment


---

# isexecutorthread

Source: https://docs.voltbz.net/docs/scripts/isexecutorthread

Checks whether a thread was created by Volt.

## [Syntax](#syntax)

```
isexecutorthread(thread?: thread) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `thread` | `thread?` | Thread to inspect; defaults to the current thread |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True when the thread is an executor thread |

## [Example](#example)

```
print(isexecutorthread()) -- true for a normal Volt script thread

local runningScript = getrunningscripts()[1]
local gameThread = runningScript and getscriptthread(runningScript)

if gameThread then
    print(isexecutorthread(gameThread)) -- false
end
```

## [Related Functions](#related-functions)

* [`checkcaller`](/docs/closures/checkcaller) - Check the current call origin
* [`getscriptfromthread`](/docs/scripts/getscriptfromthread) - Inspect a thread's associated script


---

# loadstring

Source: https://docs.voltbz.net/docs/scripts/loadstring

Compiles a string of Luau code and returns it as a function.

## [Syntax](#syntax)

```
loadstring(code: string, chunkname?: string) -> function?, string?
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `code` | `string` | The Luau source code |
| `chunkname` | `string?` | Optional name for error messages |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function?` | The compiled function, or nil on error |
| `string?` | Error message if compilation failed |

## [Description](#description)

`loadstring` compiles Luau source code into a callable function. This is essential for dynamic code execution.

## [Example](#example)

```
local code = [[
    local message = "Hello from loadstring!"
    print(message)
    return 42
]]

local func, err = loadstring(code)
if func then
    local result = func()
    print("Returned:", result) -- 42
else
    warn("Compile error:", err)
end
```

## [Loading from URL](#loading-from-url)

```
local code = game:HttpGet("https://example.com/script.lua")
local func, err = loadstring(code)
if func then
    func()
end
```

## [With Error Handling](#with-error-handling)

```
local function safeLoadstring(code)
    local func, compileErr = loadstring(code)
    if not func then
        return nil, "Compile error: " .. tostring(compileErr)
    end

    local success, result = pcall(func)
    if not success then
        return nil, "Runtime error: " .. tostring(result)
    end

    return result
end

local result, err = safeLoadstring("return 1 + 1")
if result then
    print("Result:", result)
else
    warn(err)
end
```

## [Named Chunks](#named-chunks)

```
-- Provide a name for better error messages
local func = loadstring("error('test')", "MyScript")
func() -- Error will reference "MyScript"
```

## [Notes](#notes)

* The game normally disables `loadstring` for security
* Volt re-enable this functionality
* Always validate and sanitize code from external sources


---

# LuaStateProxy.Event

Source: https://docs.voltbz.net/docs/luastateproxy/event

Generic event for communication between Lua states.

## [Syntax](#syntax)

```
state.Event: VoltSignal
```

## [Description](#description)

`LuaStateProxy.Event` provides a way to communicate between Lua states, including across VM boundaries.

## [Example](#example)

```
local state = getluastate()

-- Listen for events
state.Event:Connect(function(message)
    print("Received:", message)
end)

-- Fire an event
state.Event:Fire("Hello from this state!")
```

## [Cross-State Communication](#cross-state-communication)

```
local gameState = assert(getgamestate(), "Game state is not available")
local actorState = assert(getactorstates()[1], "No active actor state")

-- Listen on game state
gameState.Event:Connect(function(message, senderId)
    print("Game state received:", message, "from state", senderId)
end)

-- Fire from actor state
actorState.Event:Fire("Hello from actor!", actorState.Id)
```

## [Broadcast to All States](#broadcast-to-all-states)

```
local states = getactorstates()

-- Broadcast to all actor states
for _, state in ipairs(states) do
    if state.IsActorState then
        state.Event:Fire("Broadcast message")
    end
end
```

## [Related Properties](#related-properties)

* [`LuaStateProxy.Id`](/docs/luastateproxy/id) - State identifier for message routing
* [`VoltSignal`](/docs/voltsignal) - Signal documentation


---

# LuaStateProxy:Execute

Source: https://docs.voltbz.net/docs/luastateproxy/execute

Schedules code execution on this Lua state.

## [Syntax](#syntax)

```
state:Execute(source: string, ...: any) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `source` | `string` | The Luau code to execute |
| `...` | `any` | Arguments passed to the script |

## [Returns](#returns)

This method does not return a value.

## [Description](#description)

`LuaStateProxy:Execute` runs Luau source on the selected state and passes additional arguments through `...`.

## [Example](#example)

```
local state = getluastate()

state:Execute([[
    print("Executed on state:", ...)
]], "arg1", "arg2")
```

## [Execute on Actor State](#execute-on-actor-state)

```
local actorState = assert(getactorstates()[1], "No active actor state")
actorState:Execute([[
    print("Running on actor state!")
    print("Arguments:", ...)
]], "test", 123)
```

## [Pass Data to State](#pass-data-to-state)

```
local gameState = assert(getgamestate(), "Game state is not available")

local data = {
    message = "Hello",
    value = 42
}

gameState:Execute([[
    local data = ...
    print("Message:", data.message)
    print("Value:", data.value)
]], data)
```

## [Setup Code on New States](#setup-code-on-new-states)

```
on_actor_state_created:Connect(function(actor)
    local state = getluastate(actor)
    
    state:Execute([[
        -- Setup code runs before any scripts
        print("State initialized!")
        _G.setupComplete = true
    ]])
end)
```

## [Notes](#notes)

* Arguments are passed via varargs (`...`)
* Useful for running setup code on another state

## [Related Methods](#related-methods)

* [`LuaStateProxy:GetActors`](/docs/luastateproxy/getactors) - Get actors for this state
* [`getluastate`](/docs/actors/getluastate) - Get state for an actor


---

# LuaStateProxy:GetActors

Source: https://docs.voltbz.net/docs/luastateproxy/getactors

Returns all Actor instances associated with this Lua state.

## [Syntax](#syntax)

```
state:GetActors() -> {Actor}
```

## [Parameters](#parameters)

This method takes no parameters.

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `{Actor}` | Array of Actor instances for this state |

## [Description](#description)

`LuaStateProxy:GetActors` returns all Actor instances that are associated with this Lua state. For actor states, this will return the actors using that state. For the game state, this will return an empty array.

## [Example](#example)

```
local state = getluastate()
local actors = state:GetActors()

print("Actors in state:", #actors)
for i, actor in ipairs(actors) do
    print(i, actor:GetFullName())
end
```

## [Actor State Example](#actor-state-example)

```
local actorState = assert(getactorstates()[1], "No active actor state")
local actors = actorState:GetActors()

-- Contains the Actors attached to this state
for _, a in ipairs(actors) do
    print("Actor:", a:GetFullName())
end
```

## [Filter by State](#filter-by-state)

```
local allStates = getactorstates()

for _, state in ipairs(allStates) do
    if state.IsActorState then
        local actors = state:GetActors()
        print("State", state.Id, "has", #actors, "actors")
    end
end
```

## [Related Methods](#related-methods)

* [`LuaStateProxy:Execute`](/docs/luastateproxy/execute) - Execute code on the state
* [`getluastate`](/docs/actors/getluastate) - Get state for an actor


---

# LuaStateProxy.Id

Source: https://docs.voltbz.net/docs/luastateproxy/id

Unique identifier for this Lua state.

## [Syntax](#syntax)

```
state.Id: number?
```

## [Description](#description)

`LuaStateProxy.Id` is the read-only identifier for the Lua state.

## [Example](#example)

```
local state = getluastate()
print("State ID:", state.Id)
```

## [Compare States](#compare-states)

```
local gameState = assert(getgamestate(), "Game state is not available")
local currentState = getluastate()

if gameState.Id == currentState.Id then
    print("Running on game state")
else
    print("Running on different state (ID:", currentState.Id, ")")
end
```

## [Track States](#track-states)

```
local states = getactorstates()
local stateIds = {}

for _, state in ipairs(states) do
    table.insert(stateIds, state.Id)
    print("State ID:", state.Id, "Is Actor:", state.IsActorState)
end
```

## [Related Properties](#related-properties)

* [`LuaStateProxy.IsActorState`](/docs/luastateproxy/isactorstate) - Check if state is for actors
* [`LuaStateProxy.Event`](/docs/luastateproxy/event) - Communication event


---

# LuaStateProxy.IsActorState

Source: https://docs.voltbz.net/docs/luastateproxy/isactorstate

Whether this state was created for use by Actors.

## [Syntax](#syntax)

```
state.IsActorState: boolean
```

## [Description](#description)

`LuaStateProxy.IsActorState` is a read-only boolean property that indicates whether the Lua state was created for use by Actors. Returns `true` for actor states and `false` for the main game state.

## [Example](#example)

```
local state = getluastate()
if state.IsActorState then
    print("This is an actor state")
else
    print("This is the game state")
end
```

## [Filter Actor States](#filter-actor-states)

```
local states = getactorstates()
local actorStates = {}

for _, state in ipairs(states) do
    if state.IsActorState then
        table.insert(actorStates, state)
        print("Actor state ID:", state.Id)
    end
end

print("Total actor states:", #actorStates)
```

## [Conditional Behavior](#conditional-behavior)

```
local state = getluastate()

if state.IsActorState then
    -- Actor-specific logic
    print("Running on actor state")
    local actors = state:GetActors()
    print("Actors in state:", #actors)
else
    -- Game state logic
    print("Running on game state")
end
```

## [Related Properties](#related-properties)

* [`LuaStateProxy.Id`](/docs/luastateproxy/id) - Unique state identifier
* [`LuaStateProxy:GetActors`](/docs/luastateproxy/getactors) - Get actors for this state


---

# LuaStateProxy.new

Source: https://docs.voltbz.net/docs/luastateproxy/new

Gets a LuaStateProxy for the current Lua state.

## [Syntax](#syntax)

```
LuaStateProxy.new() -> LuaStateProxy?
```

## [Parameters](#parameters)

This function takes no parameters.

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `LuaStateProxy?` | The current state, or nil if it is unavailable |

## [Description](#description)

`LuaStateProxy.new` returns a proxy for the current Lua state.

## [Example](#example)

```
-- Create a proxy for the current state
local state = assert(LuaStateProxy.new(), "Current state is unavailable")
print("State ID:", state.Id)
print("Is Actor State:", state.IsActorState)
```

## [Get Current State](#get-current-state)

```
local state = assert(LuaStateProxy.new(), "Current state is unavailable")

-- Access state properties
print("State ID:", state.Id)

-- Execute code on this state
state:Execute([[
    print("Executed on current state!")
]])
```

## [Related Functions](#related-functions)

* [`getluastate`](/docs/actors/getluastate) - Get LuaStateProxy for an actor or script
* [`getgamestate`](/docs/actors/getgamestate) - Get the default game Lua state
* [`LuaStateProxy:Execute`](/docs/luastateproxy/execute) - Execute code on the state


---

# oth.get_original_thread

Source: https://docs.voltbz.net/docs/oth/get_original_thread

Returns the original thread associated with the hook, or nil if not in a hook thread.

## [Syntax](#syntax)

```
oth.get_original_thread() -> thread?
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `thread?` | The original thread, or nil if not in a hook thread |

## [Description](#description)

`oth.get_original_thread` returns the thread that originally called the hooked C closure. Outside an OTH hook callback it returns nil.

## [Example](#example)

```
local originalAbs
originalAbs = oth.hook(math.abs, function(value)
    local originalThread = oth.get_original_thread()
    if originalThread then
        print("Original thread:", originalThread)
    end
    return originalAbs(value)
end)

print(math.abs(-5))
```

## [Thread Context](#thread-context)

```
local originalAbs
originalAbs = oth.hook(math.abs, function(value)
    local originalThread = oth.get_original_thread()
    
    if originalThread then
        -- We're in a hook thread
        print("Hook thread, original:", originalThread)
        -- Access thread-local data if needed
    else
        -- Not in a hook thread
        print("Not in hook thread")
    end
    
    return originalAbs(value)
end)
```

## [Notes](#notes)

* Returns `nil` if not currently executing in a hook thread
* The returned thread is the one that originally called the hooked function
* Useful for thread-local data access or debugging

## [Related Functions](#related-functions)

* [`oth.hook`](/docs/oth/hook) - Create a hook
* [`oth.is_hook_thread`](/docs/oth/is_hook_thread) - Check if in a hook thread


---

# oth.get_root_callback

Source: https://docs.voltbz.net/docs/oth/get_root_callback

Returns the root callback while executing inside an OTH hook thread.

## [Syntax](#syntax)

```
oth.get_root_callback() -> function?
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function?` | The root original callback, or nil outside a supported hook call |

## [Description](#description)

`oth.get_root_callback` inspects the original caller thread for the C closure currently dispatching an OTH hook. It takes no arguments and is meaningful only from inside the hook callback.

## [Example](#example)

```
local originalAbs
originalAbs = oth.hook(math.abs, function(value)
    local root = oth.get_root_callback()
    assert(root, "Expected an OTH hook thread")
    return root(value)
end)

print(math.abs(-5)) -- 5
```

## [Notes](#notes)

* Returns nil outside an OTH hook thread or when the root callback cannot be resolved

## [Related Functions](#related-functions)

* [`oth.hook`](/docs/oth/hook) - Create a hook
* [`oth.unhook`](/docs/oth/unhook) - Remove a hook


---

# oth.hook

Source: https://docs.voltbz.net/docs/oth/hook

Hooks a C closure with a Luau callback.

## [Syntax](#syntax)

```
oth.hook(target: function, hook: function) -> function
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `target` | `function` | The C function to hook |
| `hook` | `function` | The replacement Luau closure |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function` | A reference to the original function |

## [Description](#description)

`oth.hook` replaces calls to the target C closure with the supplied Luau callback and returns the original function.

## [Example](#example)

```
-- Hook a C function
local originalAbs
originalAbs = oth.hook(math.abs, function(value)
    print("Hooked call:", value)
    return originalAbs(value)
end)

print(math.abs(-5)) -- Hooked call: -5, then 5
```

## [Notes](#notes)

* Only works with C functions (not Luau closures)
* The hook argument must be a Luau closure, not another C closure
* Use `oth.is_hook_thread()` to detect hook context
* The returned original can be called to bypass the hook
* Remove hooks with `oth.unhook`

## [Related Functions](#related-functions)

* [`oth.unhook`](/docs/oth/unhook) - Remove a hook
* [`oth.get_root_callback`](/docs/oth/get_root_callback) - Get original function
* [`oth.is_hook_thread`](/docs/oth/is_hook_thread) - Check hook thread context


---

# oth.is_hook_thread

Source: https://docs.voltbz.net/docs/oth/is_hook_thread

Returns true if the current thread is a hook thread.

## [Syntax](#syntax)

```
oth.is_hook_thread() -> boolean
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if running in a hook thread, false otherwise |

## [Description](#description)

`oth.is_hook_thread` checks whether the current code is executing within a hook thread created by `oth.hook`. This allows you to detect hook context and behave differently.

## [Example](#example)

```
local originalAbs
originalAbs = oth.hook(math.abs, function(value)
    if oth.is_hook_thread() then
        print("Hook thread detected")
    end
    return originalAbs(value)
end)

print(math.abs(-5)) -- Hook thread detected, then 5
```

## [Conditional Behavior](#conditional-behavior)

```
local originalAbs
originalAbs = oth.hook(math.abs, function(value)
    if oth.is_hook_thread() then
        -- Running in hook thread
        print("Hook context detected")
        -- Do hook-specific logic
    end
    return originalAbs(value)
end)
```

## [Notes](#notes)

* Returns `true` only when executing within a hook created by `oth.hook`
* Returns `false` on the main thread or in other contexts
* Useful for implementing hook-specific behavior

## [Related Functions](#related-functions)

* [`oth.hook`](/docs/oth/hook) - Create a hook
* [`get_original_thread`](/docs/oth/get_original_thread) - Get the original thread


---

# oth.unhook

Source: https://docs.voltbz.net/docs/oth/unhook

Removes a hook created with `oth.hook`.

## [Syntax](#syntax)

```
oth.unhook(target: function) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `target` | `function` | The hooked function to remove |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if the hook was successfully removed |

## [Description](#description)

`oth.unhook` removes a hook from a function that was created with `oth.hook`. The function is restored to its original behavior.

## [Example](#example)

```
-- Hook a function
local originalAbs
originalAbs = oth.hook(math.abs, function(value)
    return originalAbs(value) + 1
end)

-- Later, remove the hook
local success = oth.unhook(math.abs)
if success then
    print("Hook removed successfully")
end
```

## [Check Hook Status](#check-hook-status)

```
local originalAbs
originalAbs = oth.hook(math.abs, function(value)
    return originalAbs(value)
end)

-- Remove hook
if oth.unhook(math.abs) then
    print("Hook removed")
else
    print("No hook to remove")
end
```

## [Notes](#notes)

* Only works on functions hooked with `oth.hook`
* Returns `false` if the function wasn't hooked or hook removal failed
* The original function reference from `oth.hook` remains valid after unhooking

## [Related Functions](#related-functions)

* [`oth.hook`](/docs/oth/hook) - Create a hook
* [`oth.get_root_callback`](/docs/oth/get_root_callback) - Get original function


---

# cloneref

Source: https://docs.voltbz.net/docs/instances/cloneref

Creates a new reference to an instance that compares as different.

## [Syntax](#syntax)

```
cloneref(instance: Instance) -> Instance
```

## [Aliases](#aliases)

* `clonereference`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `instance` | `Instance` | The instance to clone a reference to |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `Instance` | A new reference to the same instance |

## [Description](#description)

`cloneref` creates a new reference to an instance. The cloned reference points to the same underlying object, but the two references are not equal when compared with `==`.

## [Example](#example)

```
local folder = Instance.new("Folder")
folder.Name = "Original"
local clone = cloneref(folder)

-- Both reference the same instance
print(folder.Name) -- "Original"
print(clone.Name)  -- "Original"

-- But they compare as different
print(folder == clone) -- false

-- Changes through one affect the other
clone.Name = "Renamed"
print(folder.Name) -- "Renamed"
```

## [Verification](#verification)

```
-- Verify they're the same underlying instance
print(compareinstances(folder, clone)) -- true
```

## [Related Functions](#related-functions)

* [`compareinstances`](/docs/instances/compareinstances) - Compare two references


---

# compareinstances

Source: https://docs.voltbz.net/docs/instances/compareinstances

Compares if two references point to the same instance.

## [Syntax](#syntax)

```
compareinstances(a: Instance, b: Instance) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `a` | `Instance` | First instance reference |
| `b` | `Instance` | Second instance reference |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | `true` if both point to the same instance |

## [Description](#description)

`compareinstances` checks if two references point to the same underlying instance, even if they were created with `cloneref`.

## [Example](#example)

```
local folder = Instance.new("Folder")
local clone = cloneref(folder)
local other = Instance.new("Folder")

-- Normal comparison fails for cloneref
print(folder == clone) -- false

-- compareinstances works correctly
print(compareinstances(folder, clone)) -- true
print(compareinstances(folder, other)) -- false
```

## [Use Case](#use-case)

```
local function findInTable(tbl, target)
    for _, item in ipairs(tbl) do
        if typeof(item) == "Instance" and compareinstances(item, target) then
            return true
        end
    end
    return false
end
```

## [Related Functions](#related-functions)

* [`cloneref`](/docs/instances/cloneref) - Clone an instance reference


---

# fireclickdetector

Source: https://docs.voltbz.net/docs/instances/fireclickdetector

Triggers a ClickDetector as if it was clicked.

## [Syntax](#syntax)

```
fireclickdetector(detector: ClickDetector, distance?: number, event?: string) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `detector` | `ClickDetector` | The ClickDetector to fire |
| `distance` | `number?` | The simulated click distance (default: 0) |
| `event` | `string?` | Event type: "MouseClick", "RightMouseClick", or "MouseHoverEnter/Leave" |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`fireclickdetector` simulates a click on a ClickDetector, triggering its events without needing to be in range or actually clicking.

## [Example](#example)

```
local part = Instance.new("Part")
part.Parent = workspace

local detector = Instance.new("ClickDetector")
detector.Parent = part

-- Fire it
fireclickdetector(detector)

-- Fire with distance
fireclickdetector(detector, 10)

-- Fire right click
fireclickdetector(detector, 0, "RightMouseClick")

part:Destroy()
```

## [Finding and Clicking All](#finding-and-clicking-all)

```
-- Click all ClickDetectors in a model
local function clickAll(parent)
    for _, desc in ipairs(parent:GetDescendants()) do
        if desc:IsA("ClickDetector") then
            fireclickdetector(desc)
        end
    end
end

-- Supply the container whose ClickDetectors you intend to activate
clickAll(workspace)
```

## [Notes](#notes)

* Omitted distance defaults to 0
* Events: "MouseClick" (default), "RightMouseClick", "MouseHoverEnter", "MouseHoverLeave"


---

# fireproximityprompt

Source: https://docs.voltbz.net/docs/instances/fireproximityprompt

Triggers a ProximityPrompt as if it was activated.

## [Syntax](#syntax)

```
fireproximityprompt(prompt: ProximityPrompt) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `prompt` | `ProximityPrompt` | The ProximityPrompt to fire |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`fireproximityprompt` simulates activation of a ProximityPrompt, bypassing distance and hold time requirements.

## [Example](#example)

```
local part = Instance.new("Part")
part.Parent = workspace

local prompt = Instance.new("ProximityPrompt")
prompt.Parent = part
fireproximityprompt(prompt)

part:Destroy()
```

## [Auto-Activate All Prompts](#auto-activate-all-prompts)

```
local function fireAllPrompts(parent)
    for _, desc in ipairs(parent:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            fireproximityprompt(desc)
        end
    end
end

fireAllPrompts(workspace)
```

The function bypasses both activation distance and `HoldDuration`. Call it once for each activation you want to simulate.


---

# firetouchinterest

Source: https://docs.voltbz.net/docs/instances/firetouchinterest

Triggers a Touched or TouchEnded event between two parts.

## [Syntax](#syntax)

```
firetouchinterest(part: BasePart, target: BasePart, toggle: boolean | number) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `part` | `BasePart` | The touching part |
| `target` | `BasePart` | The part to touch |
| `toggle` | `boolean` or `number` | `false`/`0` starts touch; `true`/`1` ends touch |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`firetouchinterest` simulates a touch between two parts, firing the Touched or TouchEnded events without physical contact.

## [Example](#example)

```
local firstPart = Instance.new("Part")
firstPart.Parent = workspace

local targetPart = Instance.new("Part")
targetPart.Parent = workspace

-- Simulate touch start
firetouchinterest(firstPart, targetPart, 0)

-- Simulate touch end
firetouchinterest(firstPart, targetPart, 1)

firstPart:Destroy()
targetPart:Destroy()
```

## [Touch and Release](#touch-and-release)

```
local function touch(part, target)
    firetouchinterest(part, target, 0) -- Touch
    task.wait()
    firetouchinterest(part, target, 1) -- Release
end

local character = game:GetService("Players").LocalPlayer.Character
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
local targetPart = workspace:FindFirstChild("TouchTarget")

if rootPart and targetPart and targetPart:IsA("BasePart") then
    touch(rootPart, targetPart)
end
```

## [Collecting Items](#collecting-items)

```
local function collectTouchParts(parent)
    local character = game:GetService("Players").LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end
    
    for _, part in ipairs(parent:GetChildren()) do
        if part:IsA("BasePart") then
            firetouchinterest(hrp, part, 0)
            task.wait()
            firetouchinterest(hrp, part, 1)
        end
    end
end
```

## [Notes](#notes)

* Toggle: `false` or `0` starts touch; `true` or `1` ends it
* Both events should be fired for proper simulation


---

# getcallbackmember / getcallbackvalue

Source: https://docs.voltbz.net/docs/instances/getcallbackvalue

Gets the value assigned to an object callback property.

## [Syntax](#syntax)

```
getcallbackmember(object: Object, property: string, returnRaw?: boolean) -> any?
getcallbackvalue(object: Object, property: string, returnRaw?: boolean) -> any? -- alias
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `object` | `Object` | The object, including an `Instance` |
| `property` | `string` | The callback property name |
| `returnRaw` | `boolean?` | Return a non-function callback object instead of filtering it to nil |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `any?` | The callback value, or nil when no callback is assigned |

## [Description](#description)

`getcallbackvalue` reads async callback properties such as `BindableFunction.OnInvoke` that are normally exposed as write-only. By default, values that are not functions are returned as nil; pass `true` to retrieve the raw callback object.

The canonical function name is `getcallbackmember`; `getcallbackvalue` is an alias.

## [Example](#example)

```
-- Create a BindableFunction
local bindable = Instance.new("BindableFunction")
bindable.OnInvoke = function(arg)
    return arg * 2
end

-- Get the callback
local callback = getcallbackvalue(bindable, "OnInvoke")
if callback then
    print(callback(5)) -- 10
end
```

## [Inspecting Remote Callbacks](#inspecting-remote-callbacks)

```
-- Find RemoteFunction callbacks
for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("RemoteFunction") then
        local callback = getcallbackvalue(obj, "OnClientInvoke")
        if callback then
            print("Found callback on:", obj:GetFullName())
        end
    end
end
```

## [Notes](#notes)

* Common callback properties include `OnInvoke`, `OnClientInvoke`, and `OnServerInvoke`
* Returns nil if no callback is set


---

# gethui

Source: https://docs.voltbz.net/docs/instances/gethui

Returns the hidden UI container.

## [Syntax](#syntax)

```
gethui() -> BasePlayerGui
```

## [Aliases](#aliases)

* `get_hidden_gui`

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `BasePlayerGui` | The hidden UI container |

## [Description](#description)

`gethui` returns a special container for UI that is hidden from game scripts.

## [Example](#example)

```
local gui = Instance.new("ScreenGui")
gui.Name = "MyHiddenGui"
gui.Parent = gethui()

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.Parent = gui
```

## [Notes](#notes)

* Use for UIs you want to hide from being accessed by a game script
* The container behaves like a normal GUI container


---

# getinstancecache

Source: https://docs.voltbz.net/docs/instances/getinstancecache

Gets all cached instance references.

## [Syntax](#syntax)

```
getinstancecache() -> table
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Dictionary of cached instances |

## [Description](#description)

`getinstancecache` returns the internal instance cache. Keys are light userdata values and each value is its corresponding `Instance`.

## [Example](#example)

```
local instanceCache = getinstancecache()
local count = 0

for key, instance in pairs(instanceCache) do
    count += 1
    print(key, instance)
end

print("Cached instances:", count)

-- This is the same table used by the cache library
local folder = Instance.new("Folder")
print(cache.iscached(folder)) -- true
folder:Destroy()
```

## [Related Functions](#related-functions)

* [`cache.invalidate`](/docs/cache/invalidate) - Remove from cache
* [`cache.replace`](/docs/cache/replace) - Replace cached instance
* [`cache.iscached`](/docs/cache/iscached) - Check if cached


---

# getinstances

Source: https://docs.voltbz.net/docs/instances/getinstances

Returns the instances currently stored in the internal instance cache.

## [Syntax](#syntax)

```
getinstances() -> table
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Array of cached instances |

## [Description](#description)

`getinstances` returns the `Instance` values currently present in the cache.

## [Example](#example)

```
local instances = getinstances()
print("Total instances:", #instances)

-- Count by class
local counts = {}
for _, inst in ipairs(instances) do
    local class = inst.ClassName
    counts[class] = (counts[class] or 0) + 1
end

for class, count in pairs(counts) do
    print(class, count)
end
```

## [Finding Specific Instances](#finding-specific-instances)

```
-- Find cached Scripts
local scripts = {}
for _, inst in ipairs(getinstances()) do
    if inst:IsA("Script") then
        table.insert(scripts, inst)
    end
end
```

## [Notes](#notes)

* The result is a snapshot of the current cache
* Nil-parented instances are included when they are cached
* Later calls may contain additional entries

## [Related Functions](#related-functions)

* [`getnilinstances`](/docs/instances/getnilinstances) - Get only nil-parented instances


---

# getnilinstances

Source: https://docs.voltbz.net/docs/instances/getnilinstances

Returns cached instances with no parent.

## [Syntax](#syntax)

```
getnilinstances() -> table
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Array of cached, nil-parented instances |

## [Description](#description)

`getnilinstances` returns cached instances whose `Parent` is nil.

## [Example](#example)

```
local nilInstances = getnilinstances()
print("Nil instances:", #nilInstances)

for _, inst in ipairs(nilInstances) do
    print(inst.ClassName, inst.Name)
end
```

## [Finding Hidden Scripts](#finding-hidden-scripts)

```
-- Scripts are sometimes hidden by setting parent to nil
local hiddenScripts = {}
for _, inst in ipairs(getnilinstances()) do
    if inst:IsA("LocalScript") or inst:IsA("ModuleScript") then
        table.insert(hiddenScripts, inst)
    end
end

print("Found", #hiddenScripts, "hidden scripts")
```

## [Use Cases](#use-cases)

* **Finding cached hidden instances**: Locate instances that are no longer parented
* **Script discovery**: Find scripts that were parented to nil
* **Cache inspection**: See which cached instances currently have no parent

## [Related Functions](#related-functions)

* [`getinstances`](/docs/instances/getinstances) - Get cached instances


---

# getrendersteppedlist

Source: https://docs.voltbz.net/docs/instances/getrendersteppedlist

Gets callbacks registered through `RunService:BindToRenderStep` in the current Luau state.

## [Syntax](#syntax)

```
getrendersteppedlist() -> table
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Array of render-step entries |

## [Description](#description)

`getrendersteppedlist` returns live `BindToRenderStep` callbacks owned by the current Luau state. Ordinary `RenderStepped:Connect` connections are not included.

Each entry has the following fields:

| Field | Type | Description |
| --- | --- | --- |
| `Function` | `function?` | Bound callback when it can be resolved |
| `Thread` | `thread?` | Thread associated with the callback |
| `Name` | `string` | Name passed to `BindToRenderStep` |
| `Priority` | `number` | Render priority |

## [Example](#example)

```
local connections = getrendersteppedlist()
print("RenderStepped connections:", #connections)

for _, entry in ipairs(connections) do
    print(entry.Name, entry.Priority, entry.Function, entry.Thread)
end
```

## [Related Functions](#related-functions)

* [`getconnections`](/docs/signals/getconnections) - Get connections for any signal


---

# cache.invalidate

Source: https://docs.voltbz.net/docs/cache/invalidate

Removes an instance from the reference cache.

## [Syntax](#syntax)

```
cache.invalidate(instance: Instance) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `instance` | `Instance` | The instance to invalidate |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`cache.invalidate` removes an instance from the cache. A later lookup may return a different reference to the same instance.

## [Example](#example)

```
local folder = Instance.new("Folder")
folder.Name = "CacheInvalidateExample"
folder.Parent = workspace

local firstReference = folder

-- Invalidate the cache
cache.invalidate(firstReference)

-- Looking up the same instance again may return a new reference
local secondReference = workspace:FindFirstChild("CacheInvalidateExample")

print(rawequal(firstReference, secondReference)) -- false
print(compareinstances(firstReference, secondReference)) -- true

firstReference:Destroy()
```

## [Notes](#notes)

* Existing references remain usable
* Use `compareinstances` to compare references after invalidating the cache

## [Related Functions](#related-functions)

* [`cache.replace`](/docs/cache/replace) - Replace cached instance
* [`cache.iscached`](/docs/cache/iscached) - Check if cached


---

# cache.iscached

Source: https://docs.voltbz.net/docs/cache/iscached

Checks if an instance is in the reference cache.

## [Syntax](#syntax)

```
cache.iscached(instance: Instance) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `instance` | `Instance` | The instance to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if the instance is cached |

## [Description](#description)

`cache.iscached` checks whether an instance currently exists in the reference cache.

## [Example](#example)

```
local folder = Instance.new("Folder")

print(cache.iscached(folder)) -- true

-- After invalidation
cache.invalidate(folder)
print(cache.iscached(folder)) -- false

folder:Destroy()
```

## [Related Functions](#related-functions)

* [`cache.replace`](/docs/cache/replace) - Replace cached instance
* [`cache.invalidate`](/docs/cache/invalidate) - Remove from cache


---

# cache.replace

Source: https://docs.voltbz.net/docs/cache/replace

Replaces a cached instance reference with another.

## [Syntax](#syntax)

```
cache.replace(instance: Instance, replacement: Instance) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `instance` | `Instance` | The instance to replace |
| `replacement` | `Instance` | The replacement instance |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`cache.replace` replaces an instance's cached reference. Existing references are unchanged, while future lookups return the replacement.

## [Example](#example)

```
local original = Instance.new("Folder")
original.Name = "CacheReplaceExample"
original.Parent = workspace

local replacement = Instance.new("Folder")
replacement.Name = "FakePart"

-- Replace the cached reference
cache.replace(original, replacement)

-- Looking up the original instance now returns the replacement
local lookup = workspace:FindFirstChild("CacheReplaceExample")
print(rawequal(lookup, replacement)) -- true
print(rawequal(original, replacement)) -- false

original:Destroy()
replacement:Destroy()
```

## [Notes](#notes)

* The original instance still exists
* References that were obtained before the replacement are unchanged

## [Related Functions](#related-functions)

* [`cache.invalidate`](/docs/cache/invalidate) - Remove from cache
* [`cache.iscached`](/docs/cache/iscached) - Check if cached


---

# cansignalreplicate

Source: https://docs.voltbz.net/docs/signals/cansignalreplicate

Checks if a signal can be replicated to the server.

## [Syntax](#syntax)

```
cansignalreplicate(signal: RBXScriptSignal) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `signal` | `RBXScriptSignal` | The signal to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if the signal can replicate |

## [Description](#description)

`cansignalreplicate` returns whether the signal supports replication.

## [Example](#example)

```
local detector = workspace:FindFirstChildWhichIsA("ClickDetector", true)
assert(detector, "This example requires a server-created ClickDetector")
local signal = detector.MouseActionReplicated

if cansignalreplicate(signal) then
    replicatesignal(signal, game.Players.LocalPlayer, 0)
else
    print("This signal cannot be replicated")
end
```

## [Related Functions](#related-functions)

* [`replicatesignal`](/docs/signals/replicatesignal) - Fire with replication
* [`firesignal`](/docs/signals/firesignal) - Fire locally


---

# firesignal

Source: https://docs.voltbz.net/docs/signals/firesignal

Fires a signal with the given arguments.

## [Syntax](#syntax)

```
firesignal(signal: RBXScriptSignal, ...: any) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `signal` | `RBXScriptSignal` | The signal to fire |
| `...` | `any` | Arguments to pass to handlers |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`firesignal` invokes the Luau connections attached to the signal with the supplied arguments.

## [Example](#example)

```
local folder = Instance.new("Folder")

folder.ChildAdded:Connect(function(child)
    print(typeof(child))
end)

firesignal(folder.ChildAdded)            -- nil
firesignal(folder.ChildAdded, workspace) -- Instance
```

## [Notes](#notes)

* All Luau handlers are called immediately
* Arguments are passed to each handler
* Use `getconnections` to fire specific connections only

## [Related Functions](#related-functions)

* [`getconnections`](/docs/signals/getconnections) - Get signal connections
* [`replicatesignal`](/docs/signals/replicatesignal) - Fire with replication


---

# getconnections

Source: https://docs.voltbz.net/docs/signals/getconnections

Gets all connections to a signal.

## [Syntax](#syntax)

```
getconnections(signal: RBXScriptSignal) -> {Connection}
```

## [Aliases](#aliases)

* `get_signal_cons`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `signal` | `RBXScriptSignal` | The signal |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `{Connection}` | Array of Connection objects |

## [Description](#description)

`getconnections` returns all current connections to a signal, allowing you to inspect, fire, disable, or disconnect them individually.

## [Example](#example)

```
local event = Instance.new("BindableEvent")
event.Event:Connect(function(message)
    print(message)
end)

local connections = getconnections(event.Event)

print("Total connections:", #connections)

for i, conn in ipairs(connections) do
    print(i, "Enabled:", conn.Enabled)
end

event:Destroy()
```

## [Disconnecting All](#disconnecting-all)

```
local function disconnectAll(signal)
    for _, conn in ipairs(getconnections(signal)) do
        conn:Disconnect()
    end
end

local event = Instance.new("BindableEvent")
event.Event:Connect(function() end)

disconnectAll(event.Event)
print(#getconnections(event.Event)) -- 0
event:Destroy()
```

## [Disabling Specific Connections](#disabling-specific-connections)

```
local event = Instance.new("BindableEvent")
event.Event:Connect(function() end)

local connections = getconnections(event.Event)

for _, conn in ipairs(connections) do
    if conn.Function then
        -- Check if it's the function we want to disable
        conn:Disable()
    end
end

event:Destroy()
```

## [Inspecting Connection Functions](#inspecting-connection-functions)

```
local event = Instance.new("BindableEvent")
event.Event:Connect(function()
    print("inspect me")
end)

local connections = getconnections(event.Event)

for _, conn in ipairs(connections) do
    if conn.LuaConnection and conn.Function then
        print("Found Luau connection")
        for index, constant in ipairs(debug.getconstants(conn.Function)) do
            print(index, constant)
        end
    end
end

event:Destroy()
```

## [The Connection Object](#the-connection-object)

Each connection returned has the following properties and methods:

| Property/Method | Type | Description |
| --- | --- | --- |
| `Enabled` | `boolean` | Whether the connection is active |
| `ForeignState` | `boolean` | Whether it's from a different Luau state |
| `LuaConnection` | `boolean` | Whether it's a Luau connection |
| `LuaWaitConnection` | `boolean` | Whether the connection represents a waiting thread |
| `Function` | `function?` | The connected function, or nil for a foreign/C connection |
| `Thread` | `thread?` | The connection's thread, or nil for a foreign/C connection |
| `Fire(...)` | `method` | Fire this connection only |
| `Defer(...)` | `method` | Deferred fire |
| `Disconnect()` | `method` | Disconnect this connection |
| `Disable()` | `method` | Temporarily disable |
| `Enable()` | `method` | Re-enable after disable |

## [Related Functions](#related-functions)

* [`firesignal`](/docs/signals/firesignal) - Fire all connections


---

# getsignalarguments

Source: https://docs.voltbz.net/docs/signals/getsignalarguments

Gets the argument types for a signal.

## [Syntax](#syntax)

```
getsignalarguments(signal: RBXScriptSignal) -> table
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `signal` | `RBXScriptSignal` | The signal to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Array of argument type names |

## [Description](#description)

`getsignalarguments` returns information about the expected argument types for a signal.

## [Example](#example)

```
local Players = game:GetService("Players")
local args = getsignalarguments(Players.PlayerAdded)

print("PlayerAdded expects:")
for i, argType in ipairs(args) do
    print(i, argType)
end
```

## [Related Functions](#related-functions)

* [`getsignalargumentsinfo`](/docs/signals/getsignalargumentsinfo) - Get detailed arg info
* [`firesignal`](/docs/signals/firesignal) - Fire a signal


---

# getsignalargumentsinfo

Source: https://docs.voltbz.net/docs/signals/getsignalargumentsinfo

Gets detailed information about a signal's expected arguments.

## [Syntax](#syntax)

```
getsignalargumentsinfo(signal: RBXScriptSignal) -> table
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `signal` | `RBXScriptSignal` | The signal to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Array of argument information entries |

## [Description](#description)

`getsignalargumentsinfo` returns detailed information about each argument a signal expects, including argument names and types.

## [Return Structure](#return-structure)

Each entry in the returned array contains:

| Field | Type | Description |
| --- | --- | --- |
| `Type` | `string` | The type name of the argument |
| `Name` | `string` | The parameter name |

## [Example](#example)

```
local Players = game:GetService("Players")
local argsInfo = getsignalargumentsinfo(Players.PlayerAdded)

print("PlayerAdded arguments:")
for i, arg in ipairs(argsInfo) do
    print(string.format("  %d. %s: %s", i, arg.Name, arg.Type))
end
```

## [Output Example](#output-example)

```
PlayerAdded arguments:
  1. player: Instance
```

## [Use Cases](#use-cases)

* Understanding signal argument structure
* Building dynamic signal handlers
* Debugging signal connections

## [Related Functions](#related-functions)

* [`getsignalarguments`](/docs/signals/getsignalarguments) - Get argument type names only
* [`firesignal`](/docs/signals/firesignal) - Fire a signal


---

# getsignalwhitelist

Source: https://docs.voltbz.net/docs/signals/getsignalwhitelist

Gets information about signals that support replication.

## [Syntax](#syntax)

```
getsignalwhitelist() -> table
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Array of whitelisted signal information |

## [Description](#description)

`getsignalwhitelist` returns the available event names and their parent classes.

## [Return Structure](#return-structure)

Each entry in the returned array contains:

| Field | Type | Description |
| --- | --- | --- |
| `Event` | `string` | The name of the event/signal |
| `Parent` | `string` | The class that owns the signal |

## [Example](#example)

```
local whitelist = getsignalwhitelist()

for i, entry in ipairs(whitelist) do
    print(string.format("%s.%s", entry.Parent, entry.Event))
end
```

## [Related Functions](#related-functions)

* [`replicatesignal`](/docs/signals/replicatesignal) - Fire with replication
* [`cansignalreplicate`](/docs/signals/cansignalreplicate) - Check if signal can replicate


---

# replicatesignal

Source: https://docs.voltbz.net/docs/signals/replicatesignal

Fires a signal with server replication.

## [Syntax](#syntax)

```
replicatesignal(signal: RBXScriptSignal, ...: any) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `signal` | `RBXScriptSignal` | The signal to fire |
| `...` | `any` | Arguments to pass |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`replicatesignal` asks the engine to replicate a supported signal to the server. The argument list must exactly match the signal's engine signature; unsupported signals cannot be replicated.

## [Example](#example)

```
local Players = game:GetService("Players")
local detector = workspace:FindFirstChildWhichIsA("ClickDetector", true)
assert(detector, "This example requires a server-created ClickDetector")

replicatesignal(
    detector.MouseActionReplicated,
    Players.LocalPlayer,
    0
)
```

## [Difference from firesignal](#difference-from-firesignal)

| Function | Local | Replicates |
| --- | --- | --- |
| `firesignal` | ✅ | ❌ |
| `replicatesignal` | Depends on the signal | ✅ for supported signals |

## [Use Cases](#use-cases)

* **Interaction testing**: Exercise supported engine interactions from the client
* **Argument validation**: Verify that an engine signal accepts the expected signature

## [Notes](#notes)

* Not all signals can be replicated
* Incorrect argument counts or types throw an error
* Server validation may still reject the action

## [Related Functions](#related-functions)

* [`firesignal`](/docs/signals/firesignal) - Fire locally only
* [`getconnections`](/docs/signals/getconnections) - Get connections


---

# VoltSignal:Connect

Source: https://docs.voltbz.net/docs/voltsignal/connect

Connects a handler function to the signal.

## [Syntax](#syntax)

```
VoltSignal:Connect(f: function) -> VoltConnection
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `f` | `function` | The handler function to call when the signal fires |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `VoltConnection` | A connection object that can be used to disconnect |

## [Description](#description)

`VoltSignal:Connect` registers a function to be called whenever the signal is fired. The function will receive any arguments passed to `Fire`. Returns a `VoltConnection` that can be used to disconnect the handler.

## [Example](#example)

```
local signal = VoltSignal.new()

-- Connect a handler
local connection = signal:Connect(function(message)
    print("Received:", message)
end)

-- Fire the signal
signal:Fire("Hello, World!")
-- Output: Received: Hello, World!

-- Disconnect when done
connection:Disconnect()
```

## [Multiple Connections](#multiple-connections)

```
local signal = VoltSignal.new()

signal:Connect(function(value)
    print("Handler 1:", value)
end)

signal:Connect(function(value)
    print("Handler 2:", value * 2)
end)

signal:Fire(10)
-- Output:
-- Handler 1: 10
-- Handler 2: 20
```

## [Related Functions](#related-functions)

* [`VoltSignal.new`](/docs/voltsignal/new) - Create a signal
* [`VoltSignal:Once`](/docs/voltsignal/once) - Connect for one fire
* [`VoltConnection:Disconnect`](/docs/voltsignal/disconnect) - Disconnect a handler


---

# VoltConnection.Connected

Source: https://docs.voltbz.net/docs/voltsignal/connected

Reports whether a VoltConnection is still active.

## [Syntax](#syntax)

```
connection.Connected: boolean
```

## [Description](#description)

`Connected` is a read-only boolean. It becomes false after `Disconnect()` or after a `Once` connection handles its first fire.

## [Example](#example)

```
local signal = VoltSignal.new()
local connection = signal:Connect(function() end)

print(connection.Connected) -- true
connection:Disconnect()
print(connection.Connected) -- false
```


---

# VoltConnection:Disconnect

Source: https://docs.voltbz.net/docs/voltsignal/disconnect

Disconnects the connection from the signal.

## [Syntax](#syntax)

```
VoltConnection:Disconnect() -> ()
```

## [Parameters](#parameters)

This method takes no parameters.

## [Returns](#returns)

This method does not return a value.

## [Description](#description)

`VoltConnection:Disconnect` removes the handler from the signal. After disconnecting, the handler will no longer be called when the signal fires.

The read-only `Connected` property reports whether the connection is still active.

## [Example](#example)

```
local signal = VoltSignal.new()

local connection = signal:Connect(function()
    print("This will only print once")
end)

signal:Fire()
-- Output: This will only print once

-- Disconnect the handler
connection:Disconnect()

signal:Fire()
-- No output - handler is disconnected
```

## [One-Time Connection Pattern](#one-time-connection-pattern)

```
local signal = VoltSignal.new()

local connection
connection = signal:Connect(function(value)
    print("Received:", value)
    connection:Disconnect() -- Disconnect after first fire
end)

signal:Fire("First")  -- Output: Received: First
signal:Fire("Second") -- No output
```

## [Cleanup Pattern](#cleanup-pattern)

```
local signal = VoltSignal.new()
local connections = {}

-- Store connections for cleanup
table.insert(connections, signal:Connect(function()
    print("Handler 1")
end))

table.insert(connections, signal:Connect(function()
    print("Handler 2")
end))

-- Cleanup all connections
for _, conn in ipairs(connections) do
    conn:Disconnect()
end
```

## [Related Functions](#related-functions)

* [`VoltSignal:Connect`](/docs/voltsignal/connect) - Create a connection
* [`VoltConnection.Connected`](/docs/voltsignal/connected) - Check connection state


---

# VoltSignal:Fire

Source: https://docs.voltbz.net/docs/voltsignal/fire

Fires the signal with the given arguments.

## [Syntax](#syntax)

```
VoltSignal:Fire(...: any) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `...` | `any` | Arguments to pass to connected handlers |

## [Returns](#returns)

This method does not return a value.

## [Description](#description)

`VoltSignal:Fire` triggers all connected handlers and resumes any threads waiting on the signal. All provided arguments are passed to each handler and returned by `Wait`.

`Fire` is exposed only on signals that scripts are allowed to fire, including values created by `VoltSignal.new()` and `LuaStateProxy.Event`. Internal read-only signals such as `on_actor_state_created` do not expose it.

## [Example](#example)

```
local signal = VoltSignal.new()

signal:Connect(function(a, b, c)
    print(a, b, c)
end)

-- Fire with multiple arguments
signal:Fire("hello", 42, true)
-- Output: hello 42 true
```

## [Firing Without Arguments](#firing-without-arguments)

```
local onComplete = VoltSignal.new()

onComplete:Connect(function()
    print("Task completed!")
end)

onComplete:Fire()
-- Output: Task completed!
```

## [Firing With Tables](#firing-with-tables)

```
local onDataReceived = VoltSignal.new()

onDataReceived:Connect(function(data)
    print("Received:", data.name, data.value)
end)

onDataReceived:Fire({ name = "Score", value = 100 })
-- Output: Received: Score 100
```

## [Related Functions](#related-functions)

* [`VoltSignal:Connect`](/docs/voltsignal/connect) - Connect handlers
* [`VoltSignal:Wait`](/docs/voltsignal/wait) - Wait for fire


---

# VoltSignal.new

Source: https://docs.voltbz.net/docs/voltsignal/new

Creates a new VoltSignal instance.

## [Syntax](#syntax)

```
VoltSignal.new() -> VoltSignal
```

## [Parameters](#parameters)

This function takes no parameters.

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `VoltSignal` | A new VoltSignal instance |

## [Description](#description)

`VoltSignal.new` creates a new signal object that can be used to implement custom events. The returned signal can have handlers connected to it and can be fired with arguments.

## [Example](#example)

```
-- Create a new signal
local onPlayerDamaged = VoltSignal.new()

-- Connect a handler
onPlayerDamaged:Connect(function(player, damage)
    print(player.Name .. " took " .. damage .. " damage!")
end)

-- Fire the signal
onPlayerDamaged:Fire(game.Players.LocalPlayer, 50)
```

## [Related Functions](#related-functions)

* [`VoltSignal:Connect`](/docs/voltsignal/connect) - Connect a handler
* [`VoltSignal:Fire`](/docs/voltsignal/fire) - Fire the signal


---

# VoltSignal:Once

Source: https://docs.voltbz.net/docs/voltsignal/once

Connects a handler that disconnects itself after the signal fires once.

## [Syntax](#syntax)

```
VoltSignal:Once(f: function) -> VoltConnection
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `f` | `function` | Handler to invoke on the next fire |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `VoltConnection` | The one-shot connection |

## [Description](#description)

`VoltSignal:Once` behaves like `Connect`, but automatically disconnects the handler after its first invocation.

## [Example](#example)

```
local signal = VoltSignal.new()

local connection = signal:Once(function(value)
    print("Received:", value)
end)

signal:Fire("first")  -- Received: first
signal:Fire("second") -- No output
print(connection.Connected) -- false
```


---

# VoltSignal:Wait

Source: https://docs.voltbz.net/docs/voltsignal/wait

Yields the current thread until the signal fires.

## [Syntax](#syntax)

```
VoltSignal:Wait() -> any
```

## [Parameters](#parameters)

This method takes no parameters.

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `any` | The arguments passed to `Fire` |

## [Description](#description)

`VoltSignal:Wait` pauses the current thread until the signal is fired. When the signal fires, the thread resumes and returns any arguments that were passed to `Fire`.

This method has no built-in timeout.

## [Example](#example)

```
local signal = VoltSignal.new()

-- In another thread, fire after 2 seconds
task.spawn(function()
    task.wait(2)
    signal:Fire("Data loaded!", 100)
end)

-- Wait for the signal
local message, value = signal:Wait()
print(message, value)
-- Output (after 2 seconds): Data loaded! 100
```

## [Related Functions](#related-functions)

* [`VoltSignal:Fire`](/docs/voltsignal/fire) - Fire the signal
* [`VoltSignal:Connect`](/docs/voltsignal/connect) - Connect without yielding


---

# create_comm_channel

Source: https://docs.voltbz.net/docs/actors/create_comm_channel

Creates a communication channel for sending messages between actors.

## [Syntax](#syntax)

```
create_comm_channel() -> (number, ChannelReceiver)
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `number` | The one-based channel identifier |
| `ChannelReceiver` | The receiver used to listen for messages |

## [Description](#description)

`create_comm_channel` creates a new communication channel that can be used to send and receive messages between actors and the main thread.

## [Channel Object](#channel-object)

| Property/Method | Description |
| --- | --- |
| `Event` | Signal used to receive messages |
| `connect(callback)` | Connect a message callback |
| `Internal` | BindableEvent used by the channel |

## [Example](#example)

```
local id, channel = create_comm_channel()

-- Listen for messages
channel.Event:Connect(function(message)
    print("Received:", message)
end)

local actor = assert(getactors()[1], "No active actor state")
run_on_actor(actor, [[
    local channelId = ...
    local channel = get_comm_channel(channelId)
    channel:Fire("Hello from actor!") -- get_comm_channel returns a BindableEvent
]], id)
```

## [Bidirectional Communication](#bidirectional-communication)

```
-- Main thread
local id, channel = create_comm_channel()
channel.Event:Connect(function(response)
    print("Actor responded:", response)
end)

local actor = assert(getactors()[1], "No active actor state")
run_on_actor(actor, [[
    local id = ...
    local channel = get_comm_channel(id)
    channel:Fire("Message received!")
]], id)
```

## [Related Functions](#related-functions)

* [`get_comm_channel`](/docs/actors/get_comm_channel) - Retrieve a channel
* [`run_on_actor`](/docs/actors/run_on_actor) - Run code on an actor


---

# get_comm_channel

Source: https://docs.voltbz.net/docs/actors/get_comm_channel

Retrieves an existing communication channel by its identifier.

## [Syntax](#syntax)

```
get_comm_channel(id: number) -> BindableEvent
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `id` | `number` | The one-based channel identifier |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `BindableEvent` | The requested communication channel |

## [Description](#description)

`get_comm_channel` retrieves the `BindableEvent` created by `create_comm_channel`. An invalid ID raises an error.

## [Example](#example)

```
-- On main thread
local id, channel = create_comm_channel()
channel.Event:Connect(print)

-- Inside actor (via run_on_actor)
local actor = assert(getactors()[1], "No active actor state")
run_on_actor(actor, [[
    local channelId = ...
    local channel = get_comm_channel(channelId)
    channel:Fire("Hello from actor!")
]], id)
```

## [Notes](#notes)

* The channel ID is passed from the main thread to the actor
* Use this inside actors to communicate back to the main thread

## [Related Functions](#related-functions)

* [`create_comm_channel`](/docs/actors/create_comm_channel) - Create a channel
* [`run_on_actor`](/docs/actors/run_on_actor) - Run code on an actor


---

# get_current_actor

Source: https://docs.voltbz.net/docs/actors/get_current_actor

Returns the Actor associated with the calling Luau state.

## [Syntax](#syntax)

```
get_current_actor() -> Actor?
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `Actor?` | The current state's Actor, or nil in the main game state |

## [Example](#example)

```
local actor = get_current_actor()

if actor then
    print("Running in Actor:", actor:GetFullName())
else
    print("Running in the main game state")
end
```

## [Related Functions](#related-functions)

* [`isparallel`](/docs/actors/isparallel) - Check whether the current thread is executing in parallel
* [`getluastate`](/docs/actors/getluastate) - Get a state proxy for an Actor


---

# getactors

Source: https://docs.voltbz.net/docs/actors/getactors

Gets all active Actors.

## [Syntax](#syntax)

```
getactors() -> {Actor}
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `{Actor}` | Array of active Actors |

## [Description](#description)

`getactors` returns the Actors that are currently active.

## [Example](#example)

```
local actors = getactors()
print("Total actors:", #actors)

for i, actor in ipairs(actors) do
    print(i, actor:GetFullName())
end
```

## [Related Functions](#related-functions)

* [`run_on_actor`](/docs/actors/run_on_actor) - Run code on an actor
* [`isparallel`](/docs/actors/isparallel) - Check if running in parallel


---

# getactorstates

Source: https://docs.voltbz.net/docs/actors/getactorstates

Returns LuaStateProxy objects for active Actors.

## [Syntax](#syntax)

```
getactorstates() -> {LuaStateProxy}
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `{LuaStateProxy}` | Array of Actor Lua states |

## [Description](#description)

Use `getgamestate()` when you need the game state instead.

## [Example](#example)

```
local states = getactorstates()
print("Total Lua states:", #states)

for i, state in ipairs(states) do
    print(i, "State ID:", state.Id, "Is Actor:", state.IsActorState)
end
```

## [Filter Actor States](#filter-actor-states)

```
local states = getactorstates()
local actorStates = {}

for _, state in ipairs(states) do
    if state.IsActorState then
        table.insert(actorStates, state)
    end
end

print("Actor states:", #actorStates)
```

## [Related Functions](#related-functions)

* [`getluastate`](/docs/actors/getluastate) - Get LuaStateProxy for a specific actor or script
* [`getgamestate`](/docs/actors/getgamestate) - Get the default game Lua state
* [`getactors`](/docs/actors/getactors) - Get all Actor instances


---

# getgamestate

Source: https://docs.voltbz.net/docs/actors/getgamestate

Returns the game Lua state.

## [Syntax](#syntax)

```
getgamestate() -> LuaStateProxy?
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `LuaStateProxy?` | The game state, or nil if it is unavailable |

## [Description](#description)

`getgamestate` returns a `LuaStateProxy` for the game state.

## [Example](#example)

```
local gameState = assert(getgamestate(), "Game state is not available")
print("Game state ID:", gameState.Id)
print("Is Actor State:", gameState.IsActorState) -- false
```

## [Execute Code on Game State](#execute-code-on-game-state)

```
local gameState = assert(getgamestate(), "Game state is not available")
gameState:Execute([[
    print("Executed on game state!")
]])
```

## [Compare States](#compare-states)

```
local gameState = assert(getgamestate(), "Game state is not available")
local currentState = getluastate()

if gameState.Id == currentState.Id then
    print("Running on game state")
else
    print("Running on different state")
end
```

## [Related Functions](#related-functions)

* [`getluastate`](/docs/actors/getluastate) - Get LuaStateProxy for a specific actor or script
* [`getactorstates`](/docs/actors/getactorstates) - Get all active LuaStateProxy objects
* [`getactors`](/docs/actors/getactors) - Get all Actor instances


---

# getluastate

Source: https://docs.voltbz.net/docs/actors/getluastate

Returns the LuaStateProxy for an Actor, script, or the current state.

## [Syntax](#syntax)

```
getluastate(actor_or_script: (Actor | LocalScript | ModuleScript | Script)?) -> LuaStateProxy?
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `actor_or_script` | `Actor`, `BaseScript`, or nil | The Actor or script to get the state for. If omitted, returns current state |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `LuaStateProxy?` | The matching state, or nil if it is unavailable |

## [Description](#description)

If no argument is provided, `getluastate` returns the current Lua state.

## [Example](#example)

```
-- Get current state
local currentState = getluastate()
print("Current state ID:", currentState.Id)

-- Get state for an actor
local actor = getactors()[1]
local actorState = actor and getluastate(actor)
if actorState then
    print("Actor state ID:", actorState.Id, "Is Actor:", actorState.IsActorState)
end
```

## [Get State for Script](#get-state-for-script)

```
-- Get state for a specific script
local script = workspace.SomeScript
local scriptState = getluastate(script)
print("Script state ID:", scriptState.Id)
```

## [Access State Properties](#access-state-properties)

```
local state = getluastate()
print("State ID:", state.Id)
print("Is Actor State:", state.IsActorState)

-- Get all actors for this state
local actors = state:GetActors()
print("Actors in state:", #actors)
```

## [Related Functions](#related-functions)

* [`getactorstates`](/docs/actors/getactorstates) - Get all active LuaStateProxy objects
* [`getgamestate`](/docs/actors/getgamestate) - Get the default game Lua state
* [`getactors`](/docs/actors/getactors) - Get all Actor instances


---

# isparallel

Source: https://docs.voltbz.net/docs/actors/isparallel

Checks if the current thread is running in parallel.

## [Syntax](#syntax)

```
isparallel() -> boolean
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if running in a parallel context |

## [Description](#description)

`isparallel` returns whether the current thread is running in parallel.

## [Example](#example)

```
if isparallel() then
    print("Running in parallel!")
    -- Safe to do parallel-safe operations
else
    print("Running on main thread")
end
```

## [Use in Actor](#use-in-actor)

```
local actor = assert(getactors()[1], "No active actor state")
run_on_actor(actor, [[
    -- Reports the state at the moment this code runs; being in an Actor does
    -- not guarantee true.
    print("Is parallel:", isparallel())
]])

print("Is parallel:", isparallel())
```

## [Notes](#notes)

* The result reflects the current execution phase
* Use `LuaStateProxy.IsActorState` when you need to test state ownership instead

## [Related Functions](#related-functions)

* [`run_on_actor`](/docs/actors/run_on_actor) - Run code on an actor
* [`getactors`](/docs/actors/getactors) - Get active Actors


---

# on_actor_state_created

Source: https://docs.voltbz.net/docs/actors/on_actor_state_created

Event fired when an Actor Lua state becomes available.

## [Syntax](#syntax)

```
on_actor_state_created: VoltSignal
```

## [Description](#description)

`on_actor_state_created` is a global `VoltSignal` that passes the related Actor to each callback.

## [Event Arguments](#event-arguments)

| Argument | Type | Description |
| --- | --- | --- |
| `actor` | `Actor` | The Actor instance whose state was created |

## [Example](#example)

```
on_actor_state_created:Connect(function(actor)
    print("New actor state created:", actor:GetFullName())
    
    -- Get the state for this actor
    local state = getluastate(actor)
    print("State ID:", state.Id)
end)
```

## [Setup Hooks on New States](#setup-hooks-on-new-states)

```
on_actor_state_created:Connect(function(actor)
    local state = getluastate(actor)
    
    -- Execute setup code on the new state
    state:Execute([[
        -- This runs before any scripts execute on the actor
        print("Actor state initialized!")
    ]])
end)
```

## [With Communication Channel](#with-communication-channel)

```
local id, channel = create_comm_channel()
channel.Event:Connect(function(actorName)
    print("Actor state ready:", actorName)
end)

on_actor_state_created:Connect(function(actor)
    local state = getluastate(actor)
    state:Execute([[
        local channelId = ...
        local channel = get_comm_channel(channelId)
        channel:Fire(script:GetFullName())
    ]], id)
end)
```

## [Notes](#notes)

* Fires when an Actor state becomes available
* The callback receives the Actor instance

## [Related Functions](#related-functions)

* [`getluastate`](/docs/actors/getluastate) - Get LuaStateProxy for an actor
* [`getactorstates`](/docs/actors/getactorstates) - Get all active LuaStateProxy objects


---

# run_on_actor

Source: https://docs.voltbz.net/docs/actors/run_on_actor

Runs a script on an actor's state.

## [Syntax](#syntax)

```
run_on_actor(actor: Actor, script: string, ...: any) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `actor` | `Actor` | The actor to run the script on |
| `script` | `string` | The Luau code to execute |
| `...` | `any` | Arguments passed to the script |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`run_on_actor` executes the provided Luau source on the specified Actor.

## [Example](#example)

```
local actor = assert(getactors()[1], "No active actor state")

run_on_actor(actor, [[
    print("Hello from actor!")
    print("Arguments:", ...)
]], "arg1", "arg2")
```

## [With Communication Channel](#with-communication-channel)

```
local id, channel = create_comm_channel()
channel.Event:Connect(function(message)
    print("Received:", message)
end)

local actor = assert(getactors()[1], "No active actor state")
run_on_actor(actor, [[
    local channelId = ...
    local channel = get_comm_channel(channelId)
    channel:Fire("Hello from actor!")
]], id)
```

## [Notes](#notes)

* The Actor must be active
* Use communication channels to send data back
* Arguments are passed via varargs (`...`)

## [Related Functions](#related-functions)

* [`getactors`](/docs/actors/getactors) - Get active Actors
* [`create_comm_channel`](/docs/actors/create_comm_channel) - Create communication channel


---

# appendfile

Source: https://docs.voltbz.net/docs/filesystem/appendfile

Appends data to the end of a file.

## [Syntax](#syntax)

```
appendfile(path: string, data: string) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The file path |
| `data` | `string` | The data to append |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`appendfile` adds data to the end of an existing file without overwriting its contents. If the file doesn't exist, it will be created.

## [Example](#example)

```
-- Create initial file
writefile("log.txt", "Log started\n")

-- Append entries
appendfile("log.txt", "Entry 1: Hello\n")
appendfile("log.txt", "Entry 2: World\n")

-- Read the result
print(readfile("log.txt"))
--[[
Log started
Entry 1: Hello
Entry 2: World
]]
```

## [Logging Example](#logging-example)

```
local function log(message)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    appendfile("debug.log", "[" .. timestamp .. "] " .. message .. "\n")
end

log("Script started")
log("Player joined")
log("Event triggered")
```

## [Related Functions](#related-functions)

* [`writefile`](/docs/filesystem/writefile) - Overwrite a file
* [`readfile`](/docs/filesystem/readfile) - Read a file


---

# delfile

Source: https://docs.voltbz.net/docs/filesystem/delfile

Deletes a file.

## [Syntax](#syntax)

```
delfile(path: string) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The file path to delete |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`delfile` permanently deletes a file at the specified path.

## [Example](#example)

```
-- Create a file
writefile("temp.txt", "Temporary data")

-- Verify it exists
print(isfile("temp.txt")) -- true

-- Delete it
delfile("temp.txt")

-- Verify it's gone
print(isfile("temp.txt")) -- false
```

## [Safe Delete](#safe-delete)

```
local function safeDelete(path)
    if isfile(path) then
        delfile(path)
        return true
    end
    return false
end

if safeDelete("myfile.txt") then
    print("File deleted")
else
    print("File didn't exist")
end
```

## [Related Functions](#related-functions)

* [`isfile`](/docs/filesystem/isfile) - Check if file exists
* [`delfolder`](/docs/filesystem/delfolder) - Delete a folder


---

# delfolder

Source: https://docs.voltbz.net/docs/filesystem/delfolder

Deletes a folder and its contents.

## [Syntax](#syntax)

```
delfolder(path: string) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The folder path to delete |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`delfolder` permanently deletes a folder and all of its contents, including files and subfolders.

## [Example](#example)

```
-- Create a folder structure
makefolder("testfolder")
writefile("testfolder/file1.txt", "Data 1")
writefile("testfolder/file2.txt", "Data 2")

-- Verify it exists
print(isfolder("testfolder")) -- true

-- Delete the entire folder
delfolder("testfolder")

-- Verify it's gone
print(isfolder("testfolder")) -- false
```

This operation is irreversible. All files and subfolders will be permanently deleted.

## [Related Functions](#related-functions)

* [`isfolder`](/docs/filesystem/isfolder) - Check if folder exists
* [`delfile`](/docs/filesystem/delfile) - Delete a single file
* [`makefolder`](/docs/filesystem/makefolder) - Create a folder


---

# dofile

Source: https://docs.voltbz.net/docs/filesystem/dofile

Loads and executes a Luau file.

## [Syntax](#syntax)

```
dofile(path: string) -> ()
```

## [Aliases](#aliases)

* `runfile`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | Path to the Luau file |

## [Returns](#returns)

This function does not return values from the executed file.

## [Description](#description)

`dofile` reads a Luau file from the workspace folder, compiles it, and executes it. Compilation and runtime errors propagate to the caller. Values returned by the file are discarded.

## [Example](#example)

```
-- Create a script file
writefile("greet.lua", [[
    print("Hello from greet.lua!")
]])

-- Compile and execute it
dofile("greet.lua")
```

## [Execute Script](#execute-script)

```
-- Create and run a script
writefile("script.lua", [[
    print("Script executed!")
    for i = 1, 5 do
        print("Count:", i)
    end
]])

dofile("script.lua")
```

## [Notes](#notes)

* This is a yielding function
* File must contain valid Luau code
* Return values from the file are discarded; use `loadfile` when they are needed
* Errors in the file will propagate

## [Related Functions](#related-functions)

* [`loadfile`](/docs/filesystem/loadfile) - Load without executing
* [`readfile`](/docs/filesystem/readfile) - Read file as string


---

# getcustomasset

Source: https://docs.voltbz.net/docs/filesystem/getcustomasset

Returns a content URL for a local file that can be used in the game.

## [Syntax](#syntax)

```
getcustomasset(path: string) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The file path |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | A content URL usable in the game |

## [Description](#description)

`getcustomasset` returns an `rbxasset://` URL for a file in the workspace. It raises an error if the path is invalid or the file does not exist.

## [Example: Custom Image](#example-custom-image)

```
-- The file must already exist in Volt's workspace
assert(isfile("myimage.png"), "Add myimage.png to the workspace first")

-- Get a usable URL
local imageUrl = getcustomasset("myimage.png")

-- Use it in a GUI
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.fromOffset(256, 256)
imageLabel.Image = imageUrl
imageLabel.Parent = gethui()
```

## [Notes](#notes)

* The file must exist in the workspace folder
* The returned URL retains the source file's extension
* Whether the returned URL can be loaded depends on the API and file format used


---

# isfile

Source: https://docs.voltbz.net/docs/filesystem/isfile

Checks if a path points to a file.

## [Syntax](#syntax)

```
isfile(path: string) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The path to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | `true` if the path is a file |

## [Description](#description)

`isfile` returns whether the specified path exists and is a file (not a folder).

## [Example](#example)

```
writefile("test.txt", "Hello")
makefolder("testfolder")

print(isfile("test.txt"))     -- true
print(isfile("testfolder"))   -- false (it's a folder)
print(isfile("nonexistent"))  -- false (doesn't exist)
```

## [Safe File Reading](#safe-file-reading)

```
local function safeRead(path)
    if isfile(path) then
        return readfile(path)
    end
    return nil
end

local content = safeRead("config.json")
if content then
    print("Config loaded")
else
    print("Config not found")
end
```

## [Related Functions](#related-functions)

* [`isfolder`](/docs/filesystem/isfolder) - Check if path is a folder
* [`readfile`](/docs/filesystem/readfile) - Read file contents


---

# isfolder

Source: https://docs.voltbz.net/docs/filesystem/isfolder

Checks if a path points to a folder.

## [Syntax](#syntax)

```
isfolder(path: string) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The path to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | `true` if the path is a folder |

## [Description](#description)

`isfolder` returns whether the specified path exists and is a folder (not a file).

## [Example](#example)

```
makefolder("myfolder")
writefile("myfile.txt", "Hello")

print(isfolder("myfolder"))    -- true
print(isfolder("myfile.txt"))  -- false (it's a file)
print(isfolder("nonexistent")) -- false (doesn't exist)
```

## [Ensuring Folder Exists](#ensuring-folder-exists)

```
local function ensureFolder(path)
    if not isfolder(path) then
        makefolder(path)
    end
end

ensureFolder("data")
ensureFolder("data/saves")
writefile("data/saves/save1.json", "{}")
```

## [Related Functions](#related-functions)

* [`isfile`](/docs/filesystem/isfile) - Check if path is a file
* [`makefolder`](/docs/filesystem/makefolder) - Create a folder


---

# listfiles

Source: https://docs.voltbz.net/docs/filesystem/listfiles

Lists all files and folders in a directory.

## [Syntax](#syntax)

```
listfiles(path: string) -> table
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The folder path |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `table` | Array of file and folder paths |

## [Description](#description)

`listfiles` returns a table containing the paths of all files and folders within the specified directory.

## [Example](#example)

```
-- Create some files and folders
makefolder("mydata")
writefile("mydata/file1.txt", "Hello")
writefile("mydata/file2.txt", "World")
makefolder("mydata/subfolder")

-- List contents
local files = listfiles("mydata")
for _, path in ipairs(files) do
    print(path)
end
--[[
mydata/file1.txt
mydata/file2.txt
mydata/subfolder
]]
```

## [Filtering Files and Folders](#filtering-files-and-folders)

```
local function getFiles(path)
    local files = {}
    for _, item in ipairs(listfiles(path)) do
        if isfile(item) then
            table.insert(files, item)
        end
    end
    return files
end

local function getFolders(path)
    local folders = {}
    for _, item in ipairs(listfiles(path)) do
        if isfolder(item) then
            table.insert(folders, item)
        end
    end
    return folders
end
```

## [Recursive Listing](#recursive-listing)

```
local function listAllFiles(path, results)
    results = results or {}
    for _, item in ipairs(listfiles(path)) do
        if isfile(item) then
            table.insert(results, item)
        elseif isfolder(item) then
            listAllFiles(item, results)
        end
    end
    return results
end

local allFiles = listAllFiles("mydata")
```

## [Related Functions](#related-functions)

* [`isfile`](/docs/filesystem/isfile) - Check if path is a file
* [`isfolder`](/docs/filesystem/isfolder) - Check if path is a folder


---

# loadfile

Source: https://docs.voltbz.net/docs/filesystem/loadfile

Loads a Luau file and returns it as a function.

## [Syntax](#syntax)

```
loadfile(path: string) -> function?, string?
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The file path |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `function?` | The compiled chunk, or nil when compilation fails |
| `string?` | The compiler error when compilation fails |

## [Description](#description)

`loadfile` reads a Luau file from Volt's workspace and compiles it in the global environment. Compilation errors return nil and an error string. Invalid paths, missing files, and non-file paths raise errors.

## [Example](#example)

```
-- Create a Luau file
writefile("mymodule.lua", [[
    local message = "Hello from file!"
    return message
]])

-- Load and execute it
local chunk, err = loadfile("mymodule.lua")
if chunk then
    print(chunk()) -- "Hello from file!"
else
    warn(err)
end
```

## [Module System](#module-system)

```
-- Create a module file
writefile("utils.lua", [[
    local Utils = {}
    
    function Utils.greet(name)
        return "Hello, " .. name .. "!"
    end
    
    function Utils.add(a, b)
        return a + b
    end
    
    return Utils
]])

-- Load and use the module
local Utils = loadfile("utils.lua")()
print(Utils.greet("World")) -- "Hello, World!"
print(Utils.add(2, 3))      -- 5
```

## [Error Handling](#error-handling)

```
local function safeLoadFile(path)
    if not isfile(path) then
        return nil, "File not found"
    end

    return loadfile(path)
end
```

## [Related Functions](#related-functions)

* [`readfile`](/docs/filesystem/readfile) - Read raw file contents
* [`loadstring`](/docs/scripts/loadstring) - Load Luau from a string


---

# makefolder

Source: https://docs.voltbz.net/docs/filesystem/makefolder

Creates a new folder.

## [Syntax](#syntax)

```
makefolder(path: string) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The folder path to create |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`makefolder` creates a new folder at the specified path. Parent folders are created automatically if they don't exist.

## [Example](#example)

```
-- Create a simple folder
makefolder("configs")

-- Create nested folders
makefolder("data/saves/player1")

-- Verify they exist
print(isfolder("configs"))           -- true
print(isfolder("data/saves/player1")) -- true
```

## [Ensure Folder Exists](#ensure-folder-exists)

```
local function ensureFolder(path)
    if not isfolder(path) then
        makefolder(path)
        return true -- Created
    end
    return false -- Already existed
end

if ensureFolder("logs") then
    print("Created logs folder")
end
```

## [Related Functions](#related-functions)

* [`isfolder`](/docs/filesystem/isfolder) - Check if folder exists
* [`delfolder`](/docs/filesystem/delfolder) - Delete a folder
* [`listfiles`](/docs/filesystem/listfiles) - List folder contents


---

# readfile

Source: https://docs.voltbz.net/docs/filesystem/readfile

Reads the contents of a file.

## [Syntax](#syntax)

```
readfile(path: string) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The file path |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The file contents |

## [Description](#description)

`readfile` reads and returns the entire contents of a file as a string.

## [Example](#example)

```
-- Write and then read a file
writefile("message.txt", "Hello, World!")
local content = readfile("message.txt")
print(content) -- "Hello, World!"
```

## [Reading JSON](#reading-json)

```
local HttpService = game:GetService("HttpService")

-- Write JSON data
local data = {name = "Player", score = 100}
writefile("save.json", HttpService:JSONEncode(data))

-- Read and parse JSON
local content = readfile("save.json")
local loaded = HttpService:JSONDecode(content)
print(loaded.name, loaded.score) -- "Player" 100
```

## [Error Handling](#error-handling)

```
local function safeRead(path)
    local success, result = pcall(readfile, path)
    if success then
        return result
    else
        warn("Failed to read:", result)
        return nil
    end
end
```

## [Related Functions](#related-functions)

* [`writefile`](/docs/filesystem/writefile) - Write to a file
* [`isfile`](/docs/filesystem/isfile) - Check if file exists
* [`loadfile`](/docs/filesystem/loadfile) - Load Luau file as function


---

# writefile

Source: https://docs.voltbz.net/docs/filesystem/writefile

Writes data to a file.

## [Syntax](#syntax)

```
writefile(path: string, data: string) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `path` | `string` | The file path |
| `data` | `string` | The data to write |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`writefile` writes data to a file, creating the file if it doesn't exist or overwriting it if it does. Parent folders are created automatically.

## [Example](#example)

```
-- Write a simple text file
writefile("hello.txt", "Hello, World!")

-- Verify the content
print(readfile("hello.txt")) -- "Hello, World!"
```

## [Writing JSON](#writing-json)

```
local HttpService = game:GetService("HttpService")

local settings = {
    volume = 0.5,
    graphics = "high",
    keybinds = {
        toggle = "F1",
        menu = "F2"
    }
}

writefile("settings.json", HttpService:JSONEncode(settings))
```

## [Writing to Subfolders](#writing-to-subfolders)

```
-- Parent folders are created automatically
writefile("data/saves/slot1.txt", "Save data here")

-- Or create them explicitly
makefolder("logs")
writefile("logs/session.log", "Session started")
```

## [Binary Data](#binary-data)

```
-- Write binary data (as string)
local binary = string.char(0, 1, 2, 3, 255)
writefile("binary.bin", binary)
```

## [Related Functions](#related-functions)

* [`readfile`](/docs/filesystem/readfile) - Read a file
* [`appendfile`](/docs/filesystem/appendfile) - Append to a file
* [`isfile`](/docs/filesystem/isfile) - Check if file exists


---

# iswindowactive

Source: https://docs.voltbz.net/docs/input/iswindowactive

Checks if the game window is currently focused.

## [Syntax](#syntax)

```
iswindowactive() -> boolean
```

## [Aliases](#aliases)

* `isrbxactive`
* `isgameactive`

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if game window is focused |

## [Description](#description)

`iswindowactive` returns whether the game window is currently active and focused. This is useful for ensuring simulated input occurs only while the game is focused.

## [Example](#example)

```
-- Only simulate input when game is focused
if iswindowactive() then
    keypress(0x20) -- Press space
    task.wait(0.1)
    keyrelease(0x20)
end
```

## [Wait for Focus](#wait-for-focus)

```
-- Wait until game is focused before executing
repeat task.wait() until iswindowactive()
print("Game is now focused!")
```

## [Related Functions](#related-functions)

* [`keypress`](/docs/input/keypress) - Simulate key press
* [`mouse1click`](/docs/input/mouse1click) - Simulate mouse click


---

# keyclick

Source: https://docs.voltbz.net/docs/input/keyclick

Simulates a complete key press and release.

## [Syntax](#syntax)

```
keyclick(keycode: number) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `keycode` | `number` | Windows virtual-key code to press and release |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`keyclick` simulates pressing and releasing a keyboard key in one operation.

## [Example](#example)

```
-- Click the E key
keyclick(0x45)

-- Click space multiple times
for i = 1, 5 do
    keyclick(0x20)
    task.wait(0.1)
end
```

## [Related Functions](#related-functions)

* [`keypress`](/docs/input/keypress) - Press a key
* [`keyrelease`](/docs/input/keyrelease) - Release a key


---

# keypress

Source: https://docs.voltbz.net/docs/input/keypress

Simulates pressing a keyboard key.

## [Syntax](#syntax)

```
keypress(keycode: number) -> ()
```

## [Aliases](#aliases)

* `keytap`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `keycode` | `number` | Windows virtual-key code to press |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`keypress` simulates pressing a keyboard key down. The key stays pressed until `keyrelease` is called.

## [Common Key Codes](#common-key-codes)

| Key | Code |
| --- | --- |
| Space | `0x20` |
| Enter | `0x0D` |
| Escape | `0x1B` |
| Shift | `0x10` |
| Control | `0x11` |
| A-Z | `0x41-0x5A` |
| 0-9 | `0x30-0x39` |

## [Example](#example)

```
-- Press and release the W key
keypress(0x57)
task.wait(0.5)
keyrelease(0x57)
```

## [Notes](#notes)

* Use Windows virtual-key codes
* Always release keys that you press
* Check `iswindowactive()` before simulating input

## [Related Functions](#related-functions)

* [`keyrelease`](/docs/input/keyrelease) - Release a key
* [`keyclick`](/docs/input/keyclick) - Press and release


---

# keyrelease

Source: https://docs.voltbz.net/docs/input/keyrelease

Simulates releasing a keyboard key.

## [Syntax](#syntax)

```
keyrelease(keycode: number) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `keycode` | `number` | Windows virtual-key code to release |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`keyrelease` simulates releasing a keyboard key that was previously pressed with `keypress`.

## [Example](#example)

```
-- Hold shift for 1 second
keypress(0x10) -- Shift
task.wait(1)
keyrelease(0x10)
```

## [Related Functions](#related-functions)

* [`keypress`](/docs/input/keypress) - Press a key
* [`keyclick`](/docs/input/keyclick) - Press and release


---

# mouse1click

Source: https://docs.voltbz.net/docs/input/mouse1click

Simulates a left mouse click.

## [Syntax](#syntax)

```
mouse1click() -> ()
```

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`mouse1click` simulates a complete left mouse button click (press and release).

## [Example](#example)

```
-- Single click
mouse1click()

-- Double click
mouse1click()
task.wait(0.05)
mouse1click()
```

## [Related Functions](#related-functions)

* [`mouse1press`](/docs/input/mouse1press) - Press left mouse
* [`mouse1release`](/docs/input/mouse1release) - Release left mouse
* [`mouse2click`](/docs/input/mouse2click) - Right click


---

# mouse1press

Source: https://docs.voltbz.net/docs/input/mouse1press

Simulates pressing the left mouse button.

## [Syntax](#syntax)

```
mouse1press() -> ()
```

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`mouse1press` simulates pressing down the left mouse button. Use `mouse1release` to release it.

## [Example](#example)

```
-- Hold left mouse for 1 second
mouse1press()
task.wait(1)
mouse1release()
```

## [Drag Example](#drag-example)

```
-- Simulate dragging
mouse1press()
for i = 1, 100 do
    mousemoverel(5, 0)
    task.wait(0.01)
end
mouse1release()
```

## [Related Functions](#related-functions)

* [`mouse1release`](/docs/input/mouse1release) - Release left mouse
* [`mouse1click`](/docs/input/mouse1click) - Click left mouse


---

# mouse1release

Source: https://docs.voltbz.net/docs/input/mouse1release

Simulates releasing the left mouse button.

## [Syntax](#syntax)

```
mouse1release() -> ()
```

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`mouse1release` simulates releasing the left mouse button that was pressed with `mouse1press`.

## [Example](#example)

```
mouse1press()
task.wait(0.5)
mouse1release()
```

## [Related Functions](#related-functions)

* [`mouse1press`](/docs/input/mouse1press) - Press left mouse
* [`mouse1click`](/docs/input/mouse1click) - Click left mouse


---

# mouse2click

Source: https://docs.voltbz.net/docs/input/mouse2click

Simulates a right mouse click.

## [Syntax](#syntax)

```
mouse2click() -> ()
```

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`mouse2click` simulates a complete right mouse button click (press and release).

## [Example](#example)

```
-- Right click to open context menu
mouse2click()
```

## [Related Functions](#related-functions)

* [`mouse2press`](/docs/input/mouse2press) - Press right mouse
* [`mouse2release`](/docs/input/mouse2release) - Release right mouse
* [`mouse1click`](/docs/input/mouse1click) - Left click


---

# mouse2press

Source: https://docs.voltbz.net/docs/input/mouse2press

Simulates pressing the right mouse button.

## [Syntax](#syntax)

```
mouse2press() -> ()
```

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`mouse2press` simulates pressing down the right mouse button. Use `mouse2release` to release it.

## [Example](#example)

```
mouse2press()
task.wait(0.5)
mouse2release()
```

## [Related Functions](#related-functions)

* [`mouse2release`](/docs/input/mouse2release) - Release right mouse
* [`mouse2click`](/docs/input/mouse2click) - Click right mouse


---

# mouse2release

Source: https://docs.voltbz.net/docs/input/mouse2release

Simulates releasing the right mouse button.

## [Syntax](#syntax)

```
mouse2release() -> ()
```

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`mouse2release` simulates releasing the right mouse button that was pressed with `mouse2press`.

## [Example](#example)

```
mouse2press()
task.wait(0.5)
mouse2release()
```

## [Related Functions](#related-functions)

* [`mouse2press`](/docs/input/mouse2press) - Press right mouse
* [`mouse2click`](/docs/input/mouse2click) - Click right mouse


---

# mousemoveabs

Source: https://docs.voltbz.net/docs/input/mousemoveabs

Moves the mouse cursor to an absolute screen position.

## [Syntax](#syntax)

```
mousemoveabs(x: number, y: number) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `x` | `number` | X coordinate in pixels |
| `y` | `number` | Y coordinate in pixels |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`mousemoveabs` moves the physical cursor to coordinates relative to the game client area. Volt ignores simulated input while the game window is not focused.

## [Example](#example)

```
-- Move to top-left corner
mousemoveabs(0, 0)

-- Move to center of screen (assuming 1920x1080)
mousemoveabs(960, 540)

-- Move to specific button location
mousemoveabs(500, 300)
mouse1click()
```

## [Related Functions](#related-functions)

* [`mousemoverel`](/docs/input/mousemoverel) - Move relative to current position


---

# mousemoverel

Source: https://docs.voltbz.net/docs/input/mousemoverel

Moves the mouse cursor relative to its current position.

## [Syntax](#syntax)

```
mousemoverel(dx: number, dy: number) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `dx` | `number` | Horizontal offset in pixels |
| `dy` | `number` | Vertical offset in pixels |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`mousemoverel` moves the physical cursor relative to its current position. Volt ignores simulated input while the game window is not focused.

## [Example](#example)

```
-- Move right 100 pixels
mousemoverel(100, 0)

-- Move down 50 pixels
mousemoverel(0, 50)

-- Move diagonally
mousemoverel(50, 50)
```

## [Circle Motion](#circle-motion)

```
-- Draw a circle with mouse movement
for i = 0, 360, 5 do
    local rad = math.rad(i)
    local dx = math.cos(rad) * 2
    local dy = math.sin(rad) * 2
    mousemoverel(dx, dy)
    task.wait(0.01)
end
```

## [Related Functions](#related-functions)

* [`mousemoveabs`](/docs/input/mousemoveabs) - Move to absolute position


---

# mousescroll

Source: https://docs.voltbz.net/docs/input/mousescroll

Simulates mouse wheel scrolling.

## [Syntax](#syntax)

```
mousescroll(delta: number) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `delta` | `number` | Signed wheel delta; positive scrolls up and negative scrolls down |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`mousescroll` sends a mouse-wheel event at the current cursor position.

## [Example](#example)

```
-- Scroll up
mousescroll(120)

-- Scroll down
mousescroll(-120)

-- Three wheel steps up
mousescroll(120 * 3)
```

## [Related Functions](#related-functions)

* [`mousemoverel`](/docs/input/mousemoverel) - Move mouse relative
* [`mousemoveabs`](/docs/input/mousemoveabs) - Move mouse absolute


---

# rconsoleclear

Source: https://docs.voltbz.net/docs/console/rconsoleclear

Clears all text from the console window.

## [Syntax](#syntax)

```
rconsoleclear() -> ()
```

## [Aliases](#aliases)

* `consoleclear`

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`rconsoleclear` removes all text from the console window, giving you a clean slate.

## [Example](#example)

```
rconsoleshow()
rconsoleprint("This will be cleared\n")
rconsoleprint("So will this\n")

task.wait(2)
rconsoleclear()

rconsoleprint("Fresh start!\n")
```

## [Related Functions](#related-functions)

* [`rconsoleprint`](/docs/console/rconsoleprint) - Print to console


---

# rconsoleerr

Source: https://docs.voltbz.net/docs/console/rconsoleerr

Prints an error message to the console.

## [Syntax](#syntax)

```
rconsoleerr(data: any, async?: boolean) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `any` | Value to format after the `[ERROR]` prefix |
| `async` | `boolean?` | Yield while writing on the console task (default: true) |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`rconsoleerr` prints an error-level message to the console, typically displayed in red or with an error prefix.

## [Example](#example)

```
rconsoleshow()

rconsoleerr("Failed to load module!")
rconsoleerr("Connection timed out")
```

## [Related Functions](#related-functions)

* [`rconsoleprint`](/docs/console/rconsoleprint) - Print plain text
* [`rconsoleinfo`](/docs/console/rconsoleinfo) - Print info
* [`rconsolewarn`](/docs/console/rconsolewarn) - Print warning


---

# rconsolehidden

Source: https://docs.voltbz.net/docs/console/rconsolehidden

Checks if the console window is hidden.

## [Syntax](#syntax)

```
rconsolehidden() -> boolean
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | True if console is hidden/closed |

## [Description](#description)

`rconsolehidden` returns whether the console window is currently hidden or not visible.

## [Example](#example)

```
rconsoleshow()

if not rconsolehidden() then
    rconsoleprint("Console is visible!\n")
end

rconsolehide()

if rconsolehidden() then
    print("Console is now hidden")
end
```

## [Related Functions](#related-functions)

* [`rconsoletoggle`](/docs/console/rconsoletoggle) - Toggle visibility
* [`rconsoleshow`](/docs/console/rconsoleshow) - Show the console
* [`rconsolehide`](/docs/console/rconsolehide) - Hide the console


---

# rconsolehide

Source: https://docs.voltbz.net/docs/console/rconsolehide

Hides the console window without destroying it.

## [Syntax](#syntax)

```
rconsolehide() -> ()
```

## [Aliases](#aliases)

* `rconsoledestroy`
* `consoledestroy`

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`rconsolehide` hides the existing console window. Its contents remain available when the console is shown again.

## [Example](#example)

```
-- Show console and print something
rconsoleshow()
rconsoleprint("This console will close in 5 seconds...\n")

-- Wait and then hide
task.wait(5)
rconsolehide()
```

## [Notes](#notes)

* Use `rconsoleshow` or `rconsoletoggle` to reveal it again

## [Related Functions](#related-functions)

* [`rconsoleshow`](/docs/console/rconsoleshow) - Show the console
* [`rconsoletoggle`](/docs/console/rconsoletoggle) - Toggle console visibility


---

# rconsoleinfo

Source: https://docs.voltbz.net/docs/console/rconsoleinfo

Prints an info message to the console.

## [Syntax](#syntax)

```
rconsoleinfo(data: any, async?: boolean) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `any` | Value to format after the `[INFO]` prefix |
| `async` | `boolean?` | Yield while writing on the console task (default: true) |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`rconsoleinfo` prints an info-level message to the console, typically with a distinct color or prefix to indicate it's informational.

## [Example](#example)

```
rconsoleshow()

rconsoleinfo("Script loaded successfully")
rconsoleinfo("Found 5 players in game")
```

## [Related Functions](#related-functions)

* [`rconsoleprint`](/docs/console/rconsoleprint) - Print plain text
* [`rconsolewarn`](/docs/console/rconsolewarn) - Print warning
* [`rconsoleerr`](/docs/console/rconsoleerr) - Print error


---

# rconsoleinput

Source: https://docs.voltbz.net/docs/console/rconsoleinput

Gets input from the user via the console.

## [Syntax](#syntax)

```
rconsoleinput() -> string
```

## [Aliases](#aliases)

* `consoleinput`

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The user's input |

## [Description](#description)

`rconsoleinput` waits for the user to type something in the console and press Enter, then returns the input as a string. This is a yielding function.

## [Example](#example)

```
rconsoleshow()

rconsoleprint("What is your name? ")
local name = rconsoleinput()

rconsoleprint("Hello, " .. name .. "!\n")
```

## [Interactive Menu Example](#interactive-menu-example)

```
rconsoleshow()
rconsolename("Script Menu")

rconsoleprint("Select an option:\n")
rconsoleprint("1. Option A\n")
rconsoleprint("2. Option B\n")
rconsoleprint("3. Exit\n\n")
rconsoleprint("Enter choice: ")

local choice = rconsoleinput()

if choice == "1" then
    rconsoleprint("You selected Option A\n")
elseif choice == "2" then
    rconsoleprint("You selected Option B\n")
else
    rconsoleprint("Goodbye!\n")
    task.wait(1)
    rconsolehide()
end
```

## [Notes](#notes)

* This function yields until the user presses Enter
* Returns an empty string if the console is closed

## [Related Functions](#related-functions)

* [`rconsoleprint`](/docs/console/rconsoleprint) - Print to console


---

# rconsolename

Source: https://docs.voltbz.net/docs/console/rconsolename

Sets the console window title.

## [Syntax](#syntax)

```
rconsolename(title: string) -> ()
```

## [Aliases](#aliases)

* `rconsolesettitle`
* `consolesettitle`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `title` | `string` | The new window title |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`rconsolename` sets the title of the console window, which appears in the title bar.

## [Example](#example)

```
rconsoleshow()

-- Set a custom title
rconsolename("My Script v1.0")

rconsoleprint("Console is ready!\n")
```

## [Related Functions](#related-functions)

* [`rconsoleshow`](/docs/console/rconsoleshow) - Show the console


---

# rconsoleprint

Source: https://docs.voltbz.net/docs/console/rconsoleprint

Prints text to the console window.

## [Syntax](#syntax)

```
rconsoleprint(data: any, async?: boolean, escape?: boolean) -> ()
```

## [Aliases](#aliases)

* `consoleprint`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `any` | Value to convert with `tostring` and print |
| `async` | `boolean?` | Yield while writing on the console task (default: true) |
| `escape` | `boolean?` | Preserve the full string length, including embedded nulls (default: true) |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`rconsoleprint` outputs text to the console window. Unlike the other console print functions, this prints plain text without any formatting or prefix.

## [Example](#example)

```
rconsoleshow()

rconsoleprint("Hello, World!")
rconsoleprint({ answer = 42 }, false)
```

## [Notes](#notes)

* A newline is appended automatically
* Tokens such as `@@RED@@` change the console color instead of printing text

## [Related Functions](#related-functions)

* [`rconsoleinfo`](/docs/console/rconsoleinfo) - Print info message
* [`rconsolewarn`](/docs/console/rconsolewarn) - Print warning
* [`rconsoleerr`](/docs/console/rconsoleerr) - Print error


---

# rconsoleshow

Source: https://docs.voltbz.net/docs/console/rconsoleshow

Creates and shows the console window.

## [Syntax](#syntax)

```
rconsoleshow() -> ()
```

## [Aliases](#aliases)

* `rconsolecreate`
* `consolecreate`

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`rconsoleshow` creates a new console window if one doesn't exist, and shows it. The console can be used to display output and receive user input.

## [Example](#example)

```
-- Create and show the console
rconsoleshow()

-- Print a welcome message
rconsoleprint("Welcome to the console!\n")

-- Set a custom title
rconsolename("My Script Console")
```

## [Notes](#notes)

* Only one console window can exist at a time
* The console persists until `rconsolehide` is called or the game closes
* Use `\n` for newlines in console output

## [Related Functions](#related-functions)

* [`rconsolehide`](/docs/console/rconsolehide) - Hide the console
* [`rconsoleprint`](/docs/console/rconsoleprint) - Print to console
* [`rconsolename`](/docs/console/rconsolename) - Set console title


---

# rconsoletoggle

Source: https://docs.voltbz.net/docs/console/rconsoletoggle

Toggles the console window visibility.

## [Syntax](#syntax)

```
rconsoletoggle() -> ()
```

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`rconsoletoggle` toggles the visibility of the console window. If hidden, it shows the console; if visible, it hides the console.

## [Example](#example)

```
-- Create console first
rconsoleshow()
rconsoleprint("Console is visible\n")

-- Toggle it off
rconsoletoggle()
print("Console is now hidden")

-- Toggle it back on
rconsoletoggle()
rconsoleprint("Console is visible again\n")
```

## [Related Functions](#related-functions)

* [`rconsoleshow`](/docs/console/rconsoleshow) - Show the console
* [`rconsolehide`](/docs/console/rconsolehide) - Hide the console
* [`rconsolehidden`](/docs/console/rconsolehidden) - Check if hidden


---

# rconsoletop

Source: https://docs.voltbz.net/docs/console/rconsoletop

Sets whether the console window stays above other windows.

## [Syntax](#syntax)

```
rconsoletop(shouldBeTop: boolean) -> ()
```

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`rconsoletop` makes the console topmost when passed `true` and removes that state when passed `false`. It also shows the console.

## [Example](#example)

```
rconsoleshow()
rconsoleprint("This console is now on top!\n")

-- Bring console to front
rconsoletop(true)
```

## [Notes](#notes)

* Call `rconsoletop(false)` to restore normal window ordering

## [Related Functions](#related-functions)

* [`rconsoleshow`](/docs/console/rconsoleshow) - Show the console


---

# rconsolewarn

Source: https://docs.voltbz.net/docs/console/rconsolewarn

Prints a warning message to the console.

## [Syntax](#syntax)

```
rconsolewarn(data: any, async?: boolean) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `any` | Value to format after the `[WARN]` prefix |
| `async` | `boolean?` | Yield while writing on the console task (default: true) |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`rconsolewarn` prints a warning-level message to the console, typically displayed in yellow or with a warning prefix.

## [Example](#example)

```
rconsoleshow()

rconsolewarn("Config file not found, using defaults")
rconsolewarn("Low memory detected")
```

## [Related Functions](#related-functions)

* [`rconsoleprint`](/docs/console/rconsoleprint) - Print plain text
* [`rconsoleinfo`](/docs/console/rconsoleinfo) - Print info
* [`rconsoleerr`](/docs/console/rconsoleerr) - Print error


---

# crypt.decrypt

Source: https://docs.voltbz.net/docs/crypt/decrypt

Decrypts data using a specified algorithm and key.

## [Syntax](#syntax)

```
crypt.decrypt(data: string, key: string, iv: string, mode?: string) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `string` | Base64-encoded ciphertext returned by `crypt.encrypt` |
| `key` | `string` | Base64-encoded 32-byte AES key |
| `iv` | `string` | Base64-encoded IV returned by `crypt.encrypt` |
| `mode` | `string?` | `CBC`, `ECB`, `CTR`, `CFB`, `OFB`, or `GCM` (default: `CBC`) |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The decrypted data |

## [Description](#description)

`crypt.decrypt` decrypts data returned by `crypt.encrypt`. The key, IV, and mode must match the encryption call. GCM verifies the appended authentication tag and raises an error if verification fails.

## [Example](#example)

```
local key = crypt.generatekey()
local original = "Hello, World!"

-- Encrypt and decrypt
local encrypted, iv = crypt.encrypt(original, key, nil, "CBC")
local decrypted = crypt.decrypt(encrypted, key, iv, "CBC")

print(decrypted) -- "Hello, World!"
```

## [Related Functions](#related-functions)

* [`crypt.encrypt`](/docs/crypt/encrypt) - Encrypt data
* [`crypt.generatekey`](/docs/crypt/generatekey) - Generate a key


---

# crypt.encrypt

Source: https://docs.voltbz.net/docs/crypt/encrypt

Encrypts data using a specified algorithm and key.

## [Syntax](#syntax)

```
crypt.encrypt(data: string, key: string, iv?: string, mode?: string) -> string, string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `string` | The data to encrypt |
| `key` | `string` | Base64-encoded 32-byte AES key |
| `iv` | `string?` | Base64-encoded IV; generated when omitted |
| `mode` | `string?` | `CBC`, `ECB`, `CTR`, `CFB`, `OFB`, or `GCM` (default: `CBC`) |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | Base64-encoded ciphertext |
| `string` | Base64-encoded IV used for encryption |

## [Description](#description)

`crypt.encrypt` performs AES-256 encryption and returns both the ciphertext and the IV. CBC and ECB use PKCS#7 padding; GCM appends a 16-byte authentication tag before Base64 encoding.

## [Supported Algorithms](#supported-algorithms)

* `CBC` (default)
* `ECB`
* `CTR`
* `CFB`
* `OFB`
* `GCM`

## [Example](#example)

```
local key = crypt.generatekey()
local data = "Secret message"

-- Encrypt with default algorithm
local encrypted, iv = crypt.encrypt(data, key)
print("Encrypted:", encrypted)

-- Decrypt to verify
local decrypted = crypt.decrypt(encrypted, key, iv, "CBC")
print("Decrypted:", decrypted)
```

## [With Custom IV](#with-custom-iv)

```
local key = crypt.generatekey()
local iv = crypt.generatebytes(16)
local data = "Secret message"

local encrypted = crypt.encrypt(data, key, iv, "CBC")
local decrypted = crypt.decrypt(encrypted, key, iv, "CBC")
```

## [Related Functions](#related-functions)

* [`crypt.decrypt`](/docs/crypt/decrypt) - Decrypt data
* [`crypt.generatekey`](/docs/crypt/generatekey) - Generate a key


---

# crypt.generatebytes

Source: https://docs.voltbz.net/docs/crypt/generatebytes

Generates cryptographically secure random bytes.

## [Syntax](#syntax)

```
crypt.generatebytes(length: number) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `length` | `number` | Number of bytes to generate |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | Base64-encoded random bytes |

## [Description](#description)

`crypt.generatebytes` generates `length` cryptographically secure random bytes and returns their Base64 representation. `length` must be between 0 and 512.

## [Example](#example)

```
-- Generate 16 bytes for an IV
local iv = crypt.generatebytes(16)
assert(#crypt.base64decode(iv) == 16)

-- Generate 32 bytes for a salt
local salt = crypt.generatebytes(32)
assert(#crypt.base64decode(salt) == 32)
```

## [Related Functions](#related-functions)

* [`crypt.random`](/docs/crypt/random) - Generate raw random bytes
* [`crypt.generatekey`](/docs/crypt/generatekey) - Generate encryption key


---

# crypt.generatekey

Source: https://docs.voltbz.net/docs/crypt/generatekey

Generates a random encryption key.

## [Syntax](#syntax)

```
crypt.generatekey() -> string
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | A Base64-encoded random key |

## [Description](#description)

`crypt.generatekey` generates 32 random bytes and returns them as Base64, which is the key format accepted by `crypt.encrypt` and `crypt.decrypt`.

## [Example](#example)

```
-- Generate a key
local key = crypt.generatekey()
print("Generated key:", key)

-- Use the key for encryption
local data = "Secret message"
local encrypted, iv = crypt.encrypt(data, key)
local decrypted = crypt.decrypt(encrypted, key, iv, "CBC")

print("Original:", data)
print("Decrypted:", decrypted)
```

## [Notes](#notes)

* The key is suitable for AES encryption
* Keys should be stored securely and not shared

## [Related Functions](#related-functions)

* [`crypt.encrypt`](/docs/crypt/encrypt) - Encrypt data
* [`crypt.decrypt`](/docs/crypt/decrypt) - Decrypt data
* [`crypt.generatebytes`](/docs/crypt/generatebytes) - Generate raw bytes


---

# crypt.hash

Source: https://docs.voltbz.net/docs/crypt/hash

Generates a hash of the provided data.

## [Syntax](#syntax)

```
crypt.hash(data: string, algorithm: string, key?: string) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `string` | The data to hash |
| `algorithm` | `string` | Required hash algorithm name |
| `key` | `string?` | Optional key for `BLAKE2B`; ignored by other algorithms |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The hexadecimal hash string |

## [Description](#description)

`crypt.hash` generates a cryptographic hash of the input data using the specified algorithm.

## [Supported Algorithms](#supported-algorithms)

* `MD5`
* `SHA1`
* `SHA224`
* `SHA256`
* `SHA384`
* `SHA512`
* `SHA3-224`
* `SHA3-256`
* `SHA3-384`
* `SHA3-512`
* `BLAKE2B`

## [Example](#example)

```
local data = "Hello, World!"

local hash = crypt.hash(data, "SHA256")
print("SHA256:", hash)

-- Other algorithms
print("MD5:", crypt.hash(data, "MD5"))
print("SHA1:", crypt.hash(data, "SHA1"))
print("SHA512:", crypt.hash(data, "SHA512"))
```

## [Use Cases](#use-cases)

* Verifying data integrity
* Creating unique identifiers
* Content fingerprints and integrity checks (not password storage)

## [Related Functions](#related-functions)

* [`crypt.hmac`](/docs/crypt/hmac) - HMAC authentication


---

# crypt.hmac

Source: https://docs.voltbz.net/docs/crypt/hmac

Generates an HMAC (Hash-based Message Authentication Code).

## [Syntax](#syntax)

```
crypt.hmac(key: string, data: string, algorithm: string) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `key` | `string` | The secret key |
| `data` | `string` | The data to authenticate |
| `algorithm` | `string` | Required hash algorithm name |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The HMAC as a Base64 string |

## [Description](#description)

`crypt.hmac` generates a keyed-hash message authentication code, which provides both data integrity and authentication.

## [Supported Algorithms](#supported-algorithms)

* `MD5`
* `SHA1`
* `SHA224`
* `SHA256`
* `SHA384`
* `SHA512`
* `SHA3-224`, `SHA3-256`, `SHA3-384`, `SHA3-512`
* `BLAKE2B`

## [Example](#example)

```
local data = "Important message"
local key = "secret_key"

local mac = crypt.hmac(key, data, "SHA256")
print("HMAC:", mac)
```

## [Verification Example](#verification-example)

```
local function verifyMessage(data, key, expectedHmac)
    local computed = crypt.hmac(key, data, "SHA256")
    return computed == expectedHmac
end

local key = "my_secret"
local message = "Hello"
local signature = crypt.hmac(key, message, "SHA256")

-- Later, verify the message
if verifyMessage(message, key, signature) then
    print("Message is authentic!")
end
```

## [Related Functions](#related-functions)

* [`crypt.hash`](/docs/crypt/hash) - Simple hashing


---

# crypt.random

Source: https://docs.voltbz.net/docs/crypt/random

Generates cryptographically secure random bytes.

## [Syntax](#syntax)

```
crypt.random(length: number) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `length` | `number` | Number of random bytes to generate |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | Random byte string |

## [Description](#description)

`crypt.random` generates cryptographically secure random bytes, suitable for security-sensitive operations.

`length` must be between 0 and 512. Unlike `crypt.generatebytes`, this function returns raw bytes rather than Base64 text.

## [Example](#example)

```
-- Generate 16 random bytes
local randomBytes = crypt.random(16)
print("Random bytes length:", #randomBytes)

-- Convert to hex for display
local hex = ""
for i = 1, #randomBytes do
    hex = hex .. string.format("%02x", string.byte(randomBytes, i))
end
print("Hex:", hex)
```

## [Use Cases](#use-cases)

* Generating session tokens
* Creating random IVs for encryption
* Generating salts for password hashing

## [Related Functions](#related-functions)

* [`crypt.generatebytes`](/docs/crypt/generatebytes) - Generate Base64-encoded random bytes
* [`crypt.generatekey`](/docs/crypt/generatekey) - Generate encryption key


---

# base64decode

Source: https://docs.voltbz.net/docs/encoding/base64decode

Decodes a Base64 encoded string.

## [Syntax](#syntax)

```
base64decode(data: string) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `string` | The Base64 encoded string |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The decoded binary data |

## [Description](#description)

`base64decode` converts a Base64 encoded string back to its original binary form.

## [Example](#example)

```
local encoded = "SGVsbG8sIFdvcmxkIQ=="
local decoded = base64decode(encoded)
print(decoded) -- "Hello, World!"
```

## [Round-trip Example](#round-trip-example)

```
local original = "This is a test message!"

-- Encode then decode
local encoded = base64encode(original)
local decoded = base64decode(encoded)

print(original == decoded) -- true
```

## [Use Cases](#use-cases)

* **API responses**: Decode Base64 data from web APIs
* **Embedded data**: Extract binary data from encoded strings
* **Deserialization**: Decode stored or transmitted data

## [Related Functions](#related-functions)

* [`base64encode`](/docs/encoding/base64encode) - Encode to Base64

## [Aliases](#aliases)

* `base64_decode`
* `base64.decode`
* `crypt.base64decode`
* `crypt.base64_decode`
* `crypt.base64.decode`


---

# base64encode

Source: https://docs.voltbz.net/docs/encoding/base64encode

Encodes data to Base64 format.

## [Syntax](#syntax)

```
base64encode(data: string) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `string` | The binary data to encode |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The Base64 encoded string |

## [Description](#description)

`base64encode` converts binary data into a Base64 encoded string that contains only ASCII characters.

## [Example](#example)

```
local data = "Hello, World!"
local encoded = base64encode(data)
print(encoded) -- "SGVsbG8sIFdvcmxkIQ=="
```

## [Encoding Binary Data](#encoding-binary-data)

```
-- Encode binary data (like file contents)
local binaryData = "\0\1\2\3\255\254"
local encoded = base64encode(binaryData)
print(encoded) -- Safe ASCII string
```

## [Use Cases](#use-cases)

* **Data transmission**: Send binary data over text protocols
* **Storage**: Store binary data in JSON or other text formats
* **Obfuscation**: Light obfuscation of string data

## [Related Functions](#related-functions)

* [`base64decode`](/docs/encoding/base64decode) - Decode from Base64

## [Aliases](#aliases)

* `base64_encode`
* `base64.encode`
* `crypt.base64encode`
* `crypt.base64_encode`
* `crypt.base64.encode`


---

# lz4compress

Source: https://docs.voltbz.net/docs/encoding/lz4compress

Compresses data using the LZ4 algorithm.

## [Syntax](#syntax)

```
lz4compress(data: string) -> string
```

Also available as `crypt.lz4compress`.

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `string` | The data to compress |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The LZ4 compressed data |

## [Description](#description)

`lz4compress` compresses a string using the LZ4 compression algorithm. LZ4 is optimized for speed over compression ratio, making it ideal for real-time applications.

## [Example](#example)

```
local data = string.rep("Hello, World! ", 1000)
print("Original size:", #data) -- 14000

local compressed = lz4compress(data)
print("Compressed size:", #compressed) -- Much smaller

local decompressed = lz4decompress(compressed, #data)
print(data == decompressed) -- true
```

## [Compression Ratio](#compression-ratio)

LZ4 works best with:

* Repetitive data
* Text with patterns
* Structured data

```
-- High compression (repetitive data)
local repetitive = string.rep("AAAA", 10000)
local comp1 = lz4compress(repetitive)
print(#comp1 / #repetitive) -- Very small ratio

-- Lower compression (random data)
local random = ""
for i = 1, 1000 do
    random = random .. string.char(math.random(0, 255))
end
local comp2 = lz4compress(random)
print(#comp2 / #random) -- Closer to 1
```

## [Related Functions](#related-functions)

* [`lz4decompress`](/docs/encoding/lz4decompress) - Decompress LZ4 data


---

# lz4decompress

Source: https://docs.voltbz.net/docs/encoding/lz4decompress

Decompresses LZ4 compressed data.

## [Syntax](#syntax)

```
lz4decompress(data: string, size: number) -> string
```

Also available as `crypt.lz4decompress`.

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `string` | The LZ4 compressed data |
| `size` | `number` | Maximum size of the decompressed output |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The decompressed data |

## [Description](#description)

`lz4decompress` restores data produced by `lz4compress`. The supplied size must be large enough for the original data.

## [Example](#example)

```
local original = "This is the original data that will be compressed!"
local compressed = lz4compress(original)
local decompressed = lz4decompress(compressed, #original)

print(original == decompressed) -- true
```

If `size` is too small, decompression fails. When persisting compressed data, store the original byte length alongside it.

## [Related Functions](#related-functions)

* [`lz4compress`](/docs/encoding/lz4compress) - Compress with LZ4


---

# clearqueueonteleport

Source: https://docs.voltbz.net/docs/miscellaneous/clearqueueonteleport

Clears the teleport script queue.

## [Syntax](#syntax)

```
clearqueueonteleport() -> ()
```

## [Aliases](#aliases)

* `clearteleportqueue`
* `clear_teleport_queue`

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`clearqueueonteleport` removes any script that was queued to run after teleporting.

## [Example](#example)

```
-- Queue a script
queueonteleport("print('Hello after teleport')")

-- Change our mind
clearqueueonteleport()

-- Now nothing will run after teleporting
```

## [Related Functions](#related-functions)

* [`queueonteleport`](/docs/miscellaneous/queueonteleport) - Queue a teleport script


---

# get_process_identifier

Source: https://docs.voltbz.net/docs/miscellaneous/get_process_identifier

Returns the operating-system process identifier for the current game process.

## [Syntax](#syntax)

```
get_process_identifier() -> number
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `number` | Current process ID |

## [Example](#example)

```
local processId = get_process_identifier()
print("Game process ID:", processId)
print(processId > 0) -- true
```

## [Notes](#notes)

* The identifier is assigned by the operating system
* It can differ the next time the game starts


---

# getfflag

Source: https://docs.voltbz.net/docs/miscellaneous/getfflag

Gets a Fast Flag value.

## [Syntax](#syntax)

```
getfflag(name: string) -> string
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `name` | `string` | The flag name |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The flag value |

## [Description](#description)

`getfflag` retrieves the current value of a Fast Flag.

## [Example](#example)

```
-- Get current target FPS
local fps = getfflag("DFIntTaskSchedulerTargetFps")
print("Target FPS:", fps)

-- Check if a feature is enabled
local enabled = getfflag("FFlagSomeFeature")
print("Feature enabled:", enabled == "true")
```

## [Related Functions](#related-functions)

* [`setfflag`](/docs/miscellaneous/setfflag) - Set flag value


---

# getfpscap

Source: https://docs.voltbz.net/docs/miscellaneous/getfpscap

Gets the current FPS cap.

## [Syntax](#syntax)

```
getfpscap() -> number
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `number` | Current FPS cap |

## [Description](#description)

`getfpscap` returns the current maximum FPS setting.

## [Example](#example)

```
local currentCap = getfpscap()
print("Current FPS cap:", currentCap)

if currentCap == 0 then
    setfpscap(60)
else
    setfpscap(0)
end
```

## [Related Functions](#related-functions)

* [`setfpscap`](/docs/miscellaneous/setfpscap) - Set FPS cap


---

# gethwid

Source: https://docs.voltbz.net/docs/miscellaneous/gethwid

Gets Volt's external user identifier.

## [Syntax](#syntax)

```
gethwid() -> string
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | The current user's opaque external identifier |

## [Description](#description)

Despite its compatibility name, `gethwid` returns the external identifier stored by Volt's environment. Scripts should treat it as an opaque string and should not infer which hardware or account properties were used to produce it.

## [Example](#example)

```
local identifier = gethwid()
print("Volt identifier:", identifier)
```

## [Notes](#notes)

* Do not parse the identifier or assume a particular format
* Avoid logging or transmitting it unless the user expects that behavior

## [Related Functions](#related-functions)

* [`identifyexecutor`](/docs/miscellaneous/identifyexecutor) - Get executor info


---

# identifyexecutor

Source: https://docs.voltbz.net/docs/miscellaneous/identifyexecutor

Returns information about Volt.

## [Syntax](#syntax)

```
identifyexecutor() -> string, string
```

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `string` | Volt |
| `string` | Version |

## [Description](#description)

`identifyexecutor` returns the name and version of Volt.

## [Example](#example)

```
local name, version = identifyexecutor()
print("Name:", name)
print("Version:", version)
```

## [Aliases](#aliases)

* `getexecutorname`


---

# messagebox

Source: https://docs.voltbz.net/docs/miscellaneous/messagebox

Displays a message box dialog.

## [Syntax](#syntax)

```
messagebox(text: string, caption: string, flags: number) -> number
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `text` | `string` | The message text |
| `caption` | `string` | The window title |
| `flags` | `number` | Button and icon flags accepted by the Windows `MessageBoxA` API |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `number` | The button pressed by the user |

## [Description](#description)

`messagebox` displays a Windows-style message box with customizable buttons and icons.

See Microsoft's [`MessageBoxA` documentation](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messageboxa#parameters) for the complete flag and return-value reference.

## [Common Flags](#common-flags)

| Flag | Description |
| --- | --- |
| `0` | OK button |
| `1` | OK + Cancel |
| `4` | Yes + No |
| `16` | Error icon |
| `32` | Question icon |
| `48` | Warning icon |
| `64` | Info icon |

## [Return Values](#return-values)

| Value | Description |
| --- | --- |
| `1` | OK |
| `2` | Cancel |
| `6` | Yes |
| `7` | No |

## [Example](#example)

```
-- Simple message
messagebox("Hello!", "Greeting", 0)

-- Confirmation dialog
local result = messagebox("Are you sure?", "Confirm", 4 + 32)
if result == 6 then
    print("User clicked Yes")
else
    print("User clicked No")
end

-- Warning message
messagebox("Something went wrong!", "Warning", 0 + 48)
```

## [Notes](#notes)

* Flags can be combined with addition
* This is a yielding function


---

# queueonteleport

Source: https://docs.voltbz.net/docs/miscellaneous/queueonteleport

Queues a script to run after teleporting.

## [Syntax](#syntax)

```
queueonteleport(script: string) -> ()
```

## [Aliases](#aliases)

* `queue_on_teleport`
* `queueteleport`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `script` | `string` | The Luau code to run after teleport |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`queueonteleport` queues Luau code to be executed after the player teleports to another place. The script will run once the new place loads.

## [Example](#example)

```
-- Queue a script to run after teleporting
queueonteleport([[
    print("Teleported successfully!")
    -- Your script code here
]])

-- Teleport the player
game:GetService("TeleportService"):Teleport(placeId)
```

## [Auto-Execute Example](#auto-execute-example)

```
-- Queue the current script to run again
queueonteleport(game:HttpGet("https://example.com/script.luau"))
```

## [Notes](#notes)

* Use `clearqueueonteleport` to clear the queue
* Every queued script is removed by `clearqueueonteleport`

## [Related Functions](#related-functions)

* [`clearqueueonteleport`](/docs/miscellaneous/clearqueueonteleport) - Clear the queue


---

# request

Source: https://docs.voltbz.net/docs/miscellaneous/request

Sends an HTTP request and yields until the response is available.

## [Syntax](#syntax)

```
request(options: table) -> table
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `options` | `table` | Request configuration |

### [Options Table](#options-table)

| Field | Type | Description |
| --- | --- | --- |
| `Url` | `string` | The URL to request |
| `Method` | `string?` | HTTP method; defaults to `GET` |
| `Headers` | `table?` | Request headers |
| `Body` | `string?` | Request body |

## [Returns](#returns)

### [Response Table](#response-table)

| Field | Type | Description |
| --- | --- | --- |
| `Success` | `boolean` | Whether the request succeeded |
| `StatusCode` | `number` | HTTP status code |
| `StatusMessage` | `string` | HTTP status message |
| `Headers` | `table` | Response headers |
| `Body` | `string` | Response body |

## [Example: GET Request](#example-get-request)

```
local response = request({
    Url = "https://httpbin.org/get",
    Method = "GET"
})

if response.Success then
    print("Status:", response.StatusCode)
    print("Body:", response.Body)
end
```

## [Example: POST Request](#example-post-request)

```
local HttpService = game:GetService("HttpService")

local response = request({
    Url = "https://httpbin.org/post",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        username = "player",
        score = 100
    })
})

if response.Success then
    local data = HttpService:JSONDecode(response.Body)
    print(data)
end
```

## [Error Handling](#error-handling)

```
local success, response = pcall(request, {
    Url = "https://example.com/api",
    Method = "GET"
})

if success and response.Success then
    print("Got data:", response.Body)
elseif success then
    warn("HTTP Error:", response.StatusCode, response.StatusMessage)
else
    warn("Request failed:", response)
end
```

## [Aliases](#aliases)

* `http_request`
* `http.request`


---

# setclipboard

Source: https://docs.voltbz.net/docs/miscellaneous/setclipboard

Copies a value's string representation to the system clipboard.

## [Syntax](#syntax)

```
setclipboard(data: any) -> ()
```

## [Aliases](#aliases)

* `toclipboard`

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `data` | `any` | The value to convert to a string and copy |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`setclipboard` calls `tostring` on the value and copies the result.

## [Example](#example)

```
-- Copy a simple message
setclipboard("Hello, World!")

-- Copy player information
local player = game.Players.LocalPlayer
setclipboard(player.Name .. " - " .. player.UserId)

-- Copy a table as JSON
local HttpService = game:GetService("HttpService")
local data = {name = "Player", score = 100}
setclipboard(HttpService:JSONEncode(data))
```

## [Notes](#notes)

* Tables are not automatically JSON-encoded; encode structured data explicitly when needed

## [Related Functions](#related-functions)

* [`identifyexecutor`](/docs/miscellaneous/identifyexecutor) - Get executor info


---

# setfflag

Source: https://docs.voltbz.net/docs/miscellaneous/setfflag

Sets a Fast Flag value.

## [Syntax](#syntax)

```
setfflag(name: string, value: string) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `name` | `string` | The flag name |
| `value` | `string` | The value to set |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`setfflag` sets the value of a Fast Flag (FFlag). These flags control various engine features and behaviors.

## [Example](#example)

```
-- Enable a flag
setfflag("DFIntTaskSchedulerTargetFps", "240")

-- Disable graphics features
setfflag("FFlagDebugDisableTelemetryEphemeralCounter", "true")
```

## [Notes](#notes)

* Flag names are case-sensitive
* Values are always strings
* Some flags require restart to take effect
* Not all flags can be modified

## [Related Functions](#related-functions)

* [`getfflag`](/docs/miscellaneous/getfflag) - Get flag value


---

# setfpscap

Source: https://docs.voltbz.net/docs/miscellaneous/setfpscap

Sets the FPS cap for the game.

## [Syntax](#syntax)

```
setfpscap(fps: number) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `fps` | `number` | The FPS cap to set |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`setfpscap` sets the maximum frame rate. Pass `0` to remove the cap.

## [Example](#example)

```
-- Cap at 60 FPS
setfpscap(60)

-- Remove the cap
setfpscap(0)

-- Cap at 144 FPS
setfpscap(144)
```

## [Notes](#notes)

* The value must be non-negative
* Higher FPS may increase CPU/GPU usage

## [Related Functions](#related-functions)

* [`getfpscap`](/docs/miscellaneous/getfpscap) - Get current FPS cap


---

# setrbxclipboard

Source: https://docs.voltbz.net/docs/miscellaneous/setrbxclipboard

Copies a value to the internal Studio clipboard.

## [Syntax](#syntax)

```
setrbxclipboard(value: any) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `value` | `any` | Value to convert with Luau's `tostring` and copy |

## [Returns](#returns)

This function does not return a value.

## [Example](#example)

```
setrbxclipboard("Text for the Studio clipboard")
```

## [Notes](#notes)

* This is distinct from the operating-system clipboard used by `setclipboard`
* Non-string values use the same `tostring` conversion as `setclipboard`

## [Related Functions](#related-functions)

* [`setclipboard`](/docs/miscellaneous/setclipboard) - Copy to the operating-system clipboard


---

# cleardrawcache

Source: https://docs.voltbz.net/docs/drawing/cleardrawcache

Stops all drawing objects from rendering.

## [Syntax](#syntax)

```
cleardrawcache() -> ()
```

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`cleardrawcache` removes all drawing objects. Existing variables may still reference removed objects, but those objects no longer render.

## [Example](#example)

```
-- Create several drawings
local drawings = {}
for i = 1, 10 do
    local circle = Drawing.new("Circle")
    circle.Position = Vector2.new(100 * i, 100)
    circle.Radius = 50
    circle.Visible = true
    table.insert(drawings, circle)
end

-- Later, clear everything at once
cleardrawcache()
-- All 10 circles are no longer rendered
```

## [Use Cases](#use-cases)

* **Script cleanup**: Remove all drawings when a script ends
* **Reset**: Clear all visuals before recreating them
* **Cleanup**: Stop every active drawing from rendering

## [Notes](#notes)

* This clears all drawings in the current environment, not only drawings created by the calling script
* Use with caution in multi-script environments
* Individual drawings can be removed with `:Remove()` or `:Destroy()`


---

# DrawFont

Source: https://docs.voltbz.net/docs/drawing/drawfont

Registers and measures fonts used by Drawing text APIs.

## [Syntax](#syntax)

```
DrawFont.Register(data: string, options: DrawFontOptions) -> DrawFont?
font:GetTextBounds(size: number, text: string) -> Vector2
```

## [DrawFontOptions](#drawfontoptions)

| Field | Type | Description |
| --- | --- | --- |
| `PixelSize` | `number` | Required rasterization size |
| `Glyphs` | `{{number}}?` | Optional nested arrays of Unicode code points to include |

## [Description](#description)

`DrawFont.Register` loads font bytes from memory and yields while rebuilding the font atlas. It returns nil if the font data is invalid. A `DrawFont` is read-only and exposes only `GetTextBounds`.

## [Example](#example)

```
local fontData = readfile("fonts/example.ttf")
local font = assert(DrawFont.Register(fontData, {
    PixelSize = 18,
    Glyphs = {
        {32, 33, 34, 35},
        {65, 66, 67, 68},
    },
}), "Font data was invalid")

local bounds = font:GetTextBounds(18, "ABCD")
print(bounds.X, bounds.Y)

local text = Drawing.new("Text")
text.Font = font
text.Size = 18
text.Text = "ABCD"
text.Visible = true
```

## [Related](#related)

* [`Drawing`](/docs/drawing)
* [`DrawingImmediate`](/docs/drawing/immediate)


---

# getrenderproperty

Source: https://docs.voltbz.net/docs/drawing/getrenderproperty

Gets a property value from a drawing object.

## [Syntax](#syntax)

```
getrenderproperty(drawing: Drawing, property: string) -> any
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `drawing` | `Drawing` | The drawing object |
| `property` | `string` | The property name |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `any` | The value of the property |

## [Description](#description)

`getrenderproperty` retrieves the current value of a property on a drawing object. This is an alternative to directly accessing properties.

## [Example](#example)

```
local circle = Drawing.new("Circle")
circle.Position = Vector2.new(500, 500)
circle.Radius = 100
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Visible = true

-- Get properties using getrenderproperty
local pos = getrenderproperty(circle, "Position")
local radius = getrenderproperty(circle, "Radius")
local color = getrenderproperty(circle, "Color")

print(pos)    -- 500, 500
print(radius) -- 100
print(color)  -- 1, 0, 0
```

## [Related Functions](#related-functions)

* [`Drawing`](/docs/drawing) - View drawing types and their properties
* [`setrenderproperty`](/docs/drawing/setrenderproperty) - Set a property
* [`isrenderobj`](/docs/drawing/isrenderobj) - Check if value is a drawing


---

# DrawingImmediate

Source: https://docs.voltbz.net/docs/drawing/immediate

Draws transient primitives from a render-frame callback.

## [Paint Signal](#paint-signal)

```
DrawingImmediate.GetPaint(zIndex: number?) -> VoltSignal
```

`GetPaint` returns the signal for a Z index. Drawing functions may only be called while a paint callback is running.

```
local paint = DrawingImmediate.GetPaint(0)

paint:Connect(function()
    DrawingImmediate.Line(
        Vector2.new(20, 20),
        Vector2.new(220, 20),
        Color3.new(1, 1, 1),
        1,
        2
    )
end)
```

## [Functions](#functions)

```
DrawingImmediate.Line(p1: Vector2, p2: Vector2, color: Color3, opacity: number, thickness: number) -> ()

DrawingImmediate.Circle(center: Vector2, radius: number, color: Color3, opacity: number, numSides: number, thickness: number) -> ()
DrawingImmediate.FilledCircle(center: Vector2, radius: number, color: Color3, opacity: number, numSides: number) -> ()

DrawingImmediate.Triangle(p1: Vector2, p2: Vector2, p3: Vector2, color: Color3, opacity: number, thickness: number) -> ()
DrawingImmediate.FilledTriangle(p1: Vector2, p2: Vector2, p3: Vector2, color: Color3, opacity: number) -> ()

DrawingImmediate.Rectangle(topLeft: Vector2, size: Vector2, color: Color3, opacity: number, rounding: number, thickness: number) -> ()
DrawingImmediate.FilledRectangle(topLeft: Vector2, size: Vector2, color: Color3, opacity: number, rounding: number) -> ()

DrawingImmediate.Quad(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, color: Color3, opacity: number, thickness: number) -> ()
DrawingImmediate.FilledQuad(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, color: Color3, opacity: number) -> ()

DrawingImmediate.Text(position: Vector2, font: DrawFont | number, fontSize: number, color: Color3, opacity: number, text: string, center: boolean) -> ()
DrawingImmediate.OutlinedText(position: Vector2, font: DrawFont | number, fontSize: number, color: Color3, opacity: number, outlineColor: Color3, outlineOpacity: number, text: string, center: boolean) -> ()
```

The numeric font form accepts a value from `DrawingImmediate.Fonts`, which is the same table as `Drawing.Fonts`.

## [Example](#example)

```
local paint = DrawingImmediate.GetPaint(10)

paint:Connect(function()
    DrawingImmediate.FilledRectangle(
        Vector2.new(24, 24),
        Vector2.new(180, 42),
        Color3.fromRGB(20, 20, 24),
        0.9,
        6
    )

    DrawingImmediate.Text(
        Vector2.new(34, 34),
        DrawingImmediate.Fonts.Monospace,
        16,
        Color3.new(1, 1, 1),
        1,
        "Volt",
        false
    )
end)
```


---

# isrenderobj

Source: https://docs.voltbz.net/docs/drawing/isrenderobj

Checks if a value is a drawing object.

## [Syntax](#syntax)

```
isrenderobj(value: any) -> boolean
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `value` | `any` | The value to check |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `boolean` | `true` if the value is a drawing object |

## [Description](#description)

`isrenderobj` determines whether a given value is a valid drawing object created by `Drawing.new()`.

## [Example](#example)

```
local circle = Drawing.new("Circle")
local normalTable = {}
local number = 123

print(isrenderobj(circle))      -- true
print(isrenderobj(normalTable)) -- false
print(isrenderobj(number))      -- false
print(isrenderobj(nil))         -- false
```

## [Use Cases](#use-cases)

* **Validation**: Verify that a value is a drawing before manipulating it
* **Cleanup**: Filter drawing objects from a mixed table
* **Debugging**: Identify the type of unknown values

## [Example: Safe Removal](#example-safe-removal)

```
local function safeRemove(obj)
    if isrenderobj(obj) then
        obj:Remove()
        return true
    end
    return false
end
```

## [Related Functions](#related-functions)

* [`getrenderproperty`](/docs/drawing/getrenderproperty) - Get a drawing property
* [`setrenderproperty`](/docs/drawing/setrenderproperty) - Set a drawing property


---

# setrenderproperty

Source: https://docs.voltbz.net/docs/drawing/setrenderproperty

Sets a property value on a drawing object.

## [Syntax](#syntax)

```
setrenderproperty(drawing: Drawing, property: string, value: any) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `drawing` | `Drawing` | The drawing object |
| `property` | `string` | The property name |
| `value` | `any` | The new value |

## [Returns](#returns)

This function does not return a value.

## [Description](#description)

`setrenderproperty` sets the value of a property on a drawing object. This is an alternative to directly assigning properties.

## [Example](#example)

```
local text = Drawing.new("Text")

-- Set properties using setrenderproperty
setrenderproperty(text, "Position", Vector2.new(100, 100))
setrenderproperty(text, "Text", "Hello, World!")
setrenderproperty(text, "Size", 24)
setrenderproperty(text, "Color", Color3.fromRGB(255, 255, 255))
setrenderproperty(text, "Outline", true)
setrenderproperty(text, "Visible", true)
```

## [Batch Updates](#batch-updates)

```
local function updateDrawing(drawing, properties)
    for property, value in pairs(properties) do
        setrenderproperty(drawing, property, value)
    end
end

local circle = Drawing.new("Circle")
updateDrawing(circle, {
    Position = Vector2.new(400, 300),
    Radius = 50,
    Color = Color3.fromRGB(0, 255, 0),
    Filled = true,
    Visible = true
})
```

## [Related Functions](#related-functions)

* [`getrenderproperty`](/docs/drawing/getrenderproperty) - Get a property
* [`isrenderobj`](/docs/drawing/isrenderobj) - Check if value is a drawing


---

# WebSocket:Close

Source: https://docs.voltbz.net/docs/websocket/close

Closes the WebSocket connection.

## [Syntax](#syntax)

```
WebSocket:Close() -> ()
```

## [Parameters](#parameters)

This method takes no parameters.

## [Returns](#returns)

This method does not return a value.

## [Description](#description)

`WebSocket:Close` closes the connection. `IsClosed` becomes true and `OnClose` fires when closing completes. Later `Send` and `Close` calls have no effect.

## [Example](#example)

```
local ws = WebSocket.connect("wss://your-server.example/socket")

ws.OnClose:Connect(function()
    print("Connection closed")
end)

-- Use the connection
ws:Send("Hello!")

-- Close after 10 seconds
task.wait(10)
ws:Close()
```

## [Cleanup Pattern](#cleanup-pattern)

```
local ws = WebSocket.connect("wss://your-server.example/socket")

local function cleanup()
    if ws then
        ws:Close()
        ws = nil
    end
end

-- Close on script end or when done
cleanup()
```

## [Notes](#notes)

* A locally closed client cannot be reopened
* `Close` is safe to call multiple times
* Use `IsClosed` to inspect the local closed state

## [Related](#related)

* [`WebSocket.connect`](/docs/websocket/connect) - Create connection
* [`OnClose`](/docs/websocket/onclose) - Close event


---

# WebSocket.connect

Source: https://docs.voltbz.net/docs/websocket/connect

Creates a new WebSocket connection to the specified URL.

## [Syntax](#syntax)

```
WebSocket.connect(url: string) -> WebSocket
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `url` | `string` | The WebSocket URL to connect to |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `WebSocket` | A WebSocket object with methods and events |

## [Description](#description)

`WebSocket.connect` yields while Volt establishes a connection. It returns a WebSocket object after a successful handshake and raises an error if the connection fails.

## [Example](#example)

```
-- Replace this with a WebSocket endpoint you control
local ws = WebSocket.connect("wss://your-server.example/socket")

-- Handle incoming messages
ws.OnMessage:Connect(function(message, isBinary)
    print("Received:", message, "binary:", isBinary)
end)

-- Handle connection close
ws.OnClose:Connect(function()
    print("Connection closed")
end)

-- Send a message
ws:Send("Hello, WebSocket!")
```

## [Notes](#notes)

* Use a `ws://` or `wss://` WebSocket URL; `wss://` encrypts the connection
* Volt attempts to reconnect automatically after a remote disconnection
* Call `Close` to stop the client intentionally

## [Related](#related)

* [`WebSocket:Send`](/docs/websocket/send) - Send messages
* [`WebSocket:Close`](/docs/websocket/close) - Close connection
* [`OnMessage`](/docs/websocket/onmessage) - Receive messages


---

# WebSocket.OnClose

Source: https://docs.voltbz.net/docs/websocket/onclose

Signal that fires when the WebSocket connection is closed.

## [Syntax](#syntax)

```
WebSocket.OnClose:Connect(callback: () -> ()) -> VoltConnection
```

## [Callback Parameters](#callback-parameters)

This callback receives no parameters.

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `VoltConnection` | A connection that can be disconnected |

## [Description](#description)

`OnClose` is a `VoltSignal` that fires after a local `Close()` or a remote close. Volt may reconnect automatically after a remote close; `IsClosed` becomes true only when the client is closed locally.

## [Example](#example)

```
local ws = WebSocket.connect("wss://your-server.example/socket")

ws.OnClose:Connect(function()
    print("Connection closed")
end)

-- Later...
ws:Close()
```

## [Reconnection Pattern](#reconnection-pattern)

```
local function createConnection()
    local ws = WebSocket.connect("wss://your-server.example/socket")
    
    ws.OnClose:Connect(function()
        print("Disconnected, reconnecting in 5 seconds...")
        task.wait(5)
        createConnection()
    end)
    
    ws.OnMessage:Connect(function(msg)
        print("Message:", msg)
    end)
    
    return ws
end

local connection = createConnection()
```

## [Cleanup on Close](#cleanup-on-close)

```
local ws = WebSocket.connect("wss://your-server.example/socket")

ws.OnClose:Connect(function()
    print("Cleaning up...")
    -- Perform cleanup tasks
end)

-- Check connection state before sending
if not ws.IsClosed then
    ws:Send("Hello!")
end
```

## [Related](#related)

* [`WebSocket.connect`](/docs/websocket/connect) - Create connection
* [`WebSocket:Close`](/docs/websocket/close) - Close connection
* [`OnMessage`](/docs/websocket/onmessage) - Message event


---

# WebSocket.OnMessage

Source: https://docs.voltbz.net/docs/websocket/onmessage

Signal that fires when a message is received from the server.

## [Syntax](#syntax)

```
WebSocket.OnMessage:Connect(callback: (message: string, isBinary: boolean) -> ()) -> VoltConnection
```

## [Callback Parameters](#callback-parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `message` | `string` | The received message |
| `isBinary` | `boolean` | Whether the message arrived as a binary frame |

## [Returns](#returns)

| Type | Description |
| --- | --- |
| `VoltConnection` | A connection that can be disconnected |

## [Description](#description)

`OnMessage` is a `VoltSignal` that fires for each message frame received from the server. Text and binary payloads are both returned as Luau strings; use `isBinary` to distinguish the frame type.

## [Example](#example)

```
local ws = WebSocket.connect("wss://your-server.example/socket")

ws.OnMessage:Connect(function(message, isBinary)
    print("Received:", message, "binary:", isBinary)
end)

ws:Send("Hello!")
```

## [JSON Messages](#json-messages)

```
local HttpService = game:GetService("HttpService")
local ws = WebSocket.connect("wss://your-server.example/socket")

ws.OnMessage:Connect(function(message, isBinary)
    if isBinary then
        return
    end

    local data = HttpService:JSONDecode(message)
    
    if data.type == "update" then
        print("Update:", data.payload)
    elseif data.type == "error" then
        warn("Error:", data.message)
    end
end)
```

## [Message Queue Pattern](#message-queue-pattern)

```
local ws = WebSocket.connect("wss://your-server.example/socket")
local messageQueue = {}

ws.OnMessage:Connect(function(message, isBinary)
    table.insert(messageQueue, {
        content = message,
        binary = isBinary,
        time = os.time()
    })
end)

-- Process messages elsewhere
local function processQueue()
    for _, msg in ipairs(messageQueue) do
        print(msg.time, msg.content, "binary:", msg.binary)
    end
    table.clear(messageQueue)
end
```

## [Related](#related)

* [`WebSocket.connect`](/docs/websocket/connect) - Create connection
* [`WebSocket:Send`](/docs/websocket/send) - Send messages
* [`OnClose`](/docs/websocket/onclose) - Connection close event


---

# WebSocket:Send

Source: https://docs.voltbz.net/docs/websocket/send

Sends a message through the WebSocket connection.

## [Syntax](#syntax)

```
WebSocket:Send(message: string, isBinary?: boolean) -> ()
```

## [Parameters](#parameters)

| Parameter | Type | Description |
| --- | --- | --- |
| `message` | `string` | The message to send |
| `isBinary` | `boolean?` | Send a binary frame when true; defaults to false |

## [Returns](#returns)

This method does not return a value.

## [Description](#description)

`WebSocket:Send` transmits the bytes in `message` as a text frame by default, or as a binary frame when `isBinary` is true. Calling it after `Close` is a no-op.

## [Example](#example)

```
local ws = WebSocket.connect("wss://your-server.example/socket")

-- Send a simple message
ws:Send("Hello, Server!")
```

## [JSON Communication](#json-communication)

```
local HttpService = game:GetService("HttpService")
local ws = WebSocket.connect("wss://your-server.example/socket")

-- Send JSON data
local function sendJSON(data)
    ws:Send(HttpService:JSONEncode(data))
end

sendJSON({
    type = "subscribe",
    channel = "updates"
})

sendJSON({
    type = "message",
    content = "Hello!",
    timestamp = os.time()
})
```

## [Binary Message](#binary-message)

```
local ws = WebSocket.connect("wss://your-server.example/socket")
local bytes = string.char(0x00, 0x01, 0x02, 0xFF)
ws:Send(bytes, true)
```

## [Notes](#notes)

* Luau strings can contain arbitrary bytes
* `Send` does not return a delivery acknowledgement
* Check `IsClosed` before sending if another part of your script may close the client

## [Related](#related)

* [`WebSocket.connect`](/docs/websocket/connect) - Create connection
* [`OnMessage`](/docs/websocket/onmessage) - Receive responses


---

# Getting Started

Source: https://docs.voltbz.net/docs/guides/getting-started

This guide takes you from a fresh machine to running your first script with Volt.

## [1. Download Volt](#1-download-volt)

Go to [voltbz.net](https://voltbz.net) and click **Download** to grab the latest
build. Volt is a desktop application for Windows.

VOLTBZ.NET is the only official domain for this software. Do not download Volt
from anywhere else.

## [2. Install](#2-install)

Run the downloaded installer and follow the prompts. When it finishes, open Volt
from your Start menu or desktop shortcut.

## [3. Sign in](#3-sign-in)

Volt accounts are created through a reseller invite.

* **Have an invite code?** Choose **Register** in the app, then enter a username,
  a password, and your invite code.
* **Already have an account?** Choose **Sign in** and enter your credentials.

Need an account or a key? Ask on [Discord](https://discord.gg/voltbz) or buy
through an authorized reseller.

## [4. Activate a license](#4-activate-a-license)

Volt runs on a license key tied to your account.

1. Purchase a plan from the [pricing page](https://voltbz.net/pricing), or redeem
   a key from a reseller.
2. In the app, open the license panel and paste your key to activate it.
3. Your plan, expiry date, and concurrent-instance limit appear once the key is
   active.

## [5. Launch and run](#5-launch-and-run)

With an active license:

1. Open the game, then start Volt.
2. Wait for Volt to attach. The status indicator turns green when it is ready.
3. Paste or open a script in the editor and run it.

You are now set up.

## [Next steps](#next-steps)

[### Account Manager

Store multiple accounts and launch many instances at once.](/docs/account-manager)[### Function reference

Browse the full scripting API, grouped by category.](/docs)


---

# Volt 1.3

Source: https://docs.voltbz.net/docs/releases/1.3

Volt 1.3 adds tools for inspecting games, viewing and decompiling scripts,
saving instances, and managing account launches. It also includes executor API
updates and UI 1.0.

| Component | Version |
| --- | --- |
| Module | `1.3.0.0` |
| UI | `1.0.0` |

## [Executor](#executor)

This release fixes various executor bugs and introduces new behavior across the
runtime and API. Luau LSP types were also updated.

### [Runtime and API updates](#runtime-and-api-updates)

* Fixed issues affecting [`hookfunction`](/docs/closures/hookfunction),
  [`oth.hook`](/docs/oth/hook), RakNet packet hooks, auto-execution, workspace
  folder creation, and keyboard paste input.
* Fixed `setfenv` interactions with
  [`setstackhidden`](/docs/closures/setstackhidden) and `oth` hooks.
* [`gethiddenproperty`](/docs/reflection/gethiddenproperty),
  [`gethiddenproperties`](/docs/reflection/gethiddenproperties),
  [`sethiddenproperty`](/docs/reflection/sethiddenproperty),
  [`getproperties`](/docs/reflection/getproperties),
  [`isscriptable`](/docs/reflection/isscriptable),
  [`setscriptable`](/docs/reflection/setscriptable), and
  [`getcallbackvalue`](/docs/instances/getcallbackvalue) now accept `Object`
  instead of only `Instance`.
* [`getconnections`](/docs/signals/getconnections) now works with
  non-scriptable signals.
* [`getscriptbytecode`](/docs/scripts/getscriptbytecode),
  [`getscriptclosure`](/docs/scripts/getscriptclosure), and
  [`getscripthash`](/docs/scripts/getscripthash) now support CoreScripts.
* Added [`raknet.is_enabled(): boolean`](/docs/raknet).
* Added [`setrbxclipboard(data: any)`](/docs/miscellaneous/setrbxclipboard)
  for copying Studio-compatible data.
* Added [`saveinstance`](/docs/miscellaneous/saveinstance) and
  [`saveplace`](/docs/miscellaneous/saveplace).

## [Internal UI](#internal-ui)

Volt 1.3 adds Game Explorer and Script Viewer to the internal UI. It also uses
themes from the desktop interface for consistent styling.

Volt DarkCatppuccin MochaSakura Drift

![Volt internal UI using the Volt Dark theme](/img/internal-ui-volt-dark.png)

![Volt internal UI using the Catppuccin Mocha theme](/img/internal-ui-catppuccin-mocha.png)

![Volt internal UI using the Sakura Drift theme](/img/internal-ui-sakura-drift.png)

### [Game Explorer](#game-explorer)

Game Explorer shows the live game tree and a properties panel for viewing and
editing the selected instances.

* Hold `CTRL` to select multiple instances.
* Use the instance context menu to copy, rename, or paste into an instance.
* Use **Copy Path** to copy a Luau path for a property.
* Use **Copy Name** to copy only the property name.
* Use **Copy Value** to copy the value in Luau format.
* Tags and attributes can be removed from their context menus.
* **Save Place** displays progress while the place is being written.

### [Script Viewer](#script-viewer)

Script Viewer displays decompiled script output with variable renaming,
reference navigation, and bracket pair colorization.

* Right-click a variable or press `X` to view its references.
* Press `R` to rename the selected variable.

## [Decompiler](#decompiler)

Volt 1.3 introduces a built-in Luau decompiler. [`decompile`](/docs/scripts/decompile)
accepts a script or raw Luau bytecode and returns source text.

* [`DecompilerOptions`](/docs/scripts/decompile#decompileroptions) controls
  variable naming, function declarations, guard clauses, conditional
  structuring, constant folding, scope block insertion, and formatting.
* [`DecompilerFormatter`](/docs/scripts/decompile#decompilerformatter) controls
  indentation, column limit, condition parentheses, semicolons, and function
  metadata.

The decompiler is still in development, so some bugs are expected. See the
[Decompiler guide](/docs/decompiler) for usage details and current behavior.

## [Save Instance](#save-instance)

[`saveinstance`](/docs/miscellaneous/saveinstance) and
[`saveplace`](/docs/miscellaneous/saveplace) export instance hierarchies using
the game's binary serialization format. They can run from scripts or from the
internal UI.

Use [`SaveInstanceOptions`](/docs/miscellaneous/saveinstance#saveinstanceoptions)
to configure:

* Output file path
* Script decompilation
* Clipboard output
* An `IgnoreList` property (currently readable, but not assignable from Luau)
* Decompiler options
* Player and character filters
* Nil instance filters
* Non-creatable instance filters

## [Desktop UI 1.0](#desktop-ui-10)

UI 1.0 introduces a redesigned desktop interface with a more compact layout,
refreshed branding, updated app icons, and a cleaner default theme.

![Volt UI 1.0 home and setup screen](/img/home.png)

Home and setup view

![Volt UI 1.0 editor screen](/img/editor.png)

Editor view

### [Workspace](#workspace)

* Pinned tabs, with Home pinned by default, and dedicated pinned-tab controls.
* Saved layouts that restore splits, open tabs, pane sizes, sidebar and terminal
  state, window placement, and unsaved tabs.
* Detachable Terminals, Account Manager, and Theme Editor windows. Terminals
  include search and filtering, connection status, and topmost mode.
* Instance groups, including an `All` group, with support for binding tabs to a
  group.
* A searchable command palette for common actions.

### [Editor and files](#editor-and-files)

* Editor breadcrumbs with folder and file navigation.
* Separate Scripts and Autoexec trees with search and folder creation.
* Drag-and-drop file organization and support for opening external `.txt`,
  `.lua`, and `.luau` files.
* Installed system font detection and font selection in Settings.
* Dynamic source maps that keep Luau LSP completions and types synchronized
  with the live game tree.

### [Setup and settings](#setup-and-settings)

* One-click setup from Home, supported game version checks, and prompts to
  install the required version when needed.
* Background Volt update checks and an API health check during startup.
* Decompiler settings with live output previews and Save Instance default
  settings.
* Theme schema v3 with expanded customization and theme import and export.
* Windows 7 Aero, Volt Ware, and Voltmillion themes, with updated built-in
  Monaco styling.
* A Theme Editor with collapsible sections and a responsive color picker, plus
  a keybind editor for the internal UI.

## [Account Manager](#account-manager)

Volt 1.3 introduces Account Manager as a public feature. It stores accounts,
launches multiple clients, tracks running instances, and manages private server
launches.

![Volt Account Manager launch settings and account table](/img/account_manager_1.png)

Launch settings and account table

![Volt Account Manager compact performance overlay](/img/overlay_1.png)

Performance overlay

It includes:

* Browser login and bulk cookie import, with protected cookie storage and
  cookie health checks.
* Multi-account launching with launch delays, stop controls, connection
  tracking, and Place ID validation.
* Private server launching with none, round-robin, and assigned server modes.
* Automatic relaunching for closed instances, with relaunch countdowns.
* Per-account and total CPU and memory usage.
* A configurable performance overlay showing account status, process count,
  CPU and memory usage, and relaunch state.
* Memory Guard with automatic and fixed committed-memory limits.
* Autosaved launch and private server settings.

## [Related docs](#related-docs)

* [Decompiler](/docs/decompiler)
* [Save Instance](/docs/miscellaneous/saveinstance)
* [Account Manager](/docs/account-manager)
