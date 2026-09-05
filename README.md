<div align="center">
<a href="https://github.com/saucekid/sauceVR"><img src="assets/images/logo.png" alt="sauceVR logo" width="256"></img></a>
<br>
<a href="https://github.com/richie0866/Rostruct/releases/latest"><img src="https://img.shields.io/github/v/release/saucekid/sauceVR?include_prereleases" alt="Latest Release" /></a>
<br>
Roblox Universal Full-Body VR - Updated for 2026
</div>


## Install

To install sauceVR for your script executor, save the `package.lua` file located in this repository to your `scripts/` folder.


You can also use the loadstring:

```lua
loadstring(
game:HttpGetAsync("https://raw.githubusercontent.com/saucekid/sauceVR/main/package.lua")
)()
```

**Note:** This version has been updated for 2026 with improved compatibility for modern Roblox clients and executors. Some features may require specific executor capabilities.

## Options

All options are configurable in the UI menu. Press `M` on keyboard or face both hands towards the floor in VR to open the menu.

## Controls

`Grip Buttons` ▶︎ *Climb wall / Hold tool / Pick up unanchored part*

`Right Thumbstick Forward` ▶︎ *Jump* 

**(To open menu, rotate both your hands towards the floor)**

### Keyboard Controls (Non-VR Mode)
- `M` - Toggle menu
- `Q` / `ButtonL1` - Left hand interact
- `E` / `ButtonR1` - Right hand interact

## Compatibility Notes (2026 Update)

This version includes several fixes for modern Roblox:

1. **Executor Function Detection** - Safely detects executor-specific functions (`getgenv`, `hookfunction`, `sethiddenproperty`, etc.) before using them
2. **Modern Chat Support** - Updated chat fix supports both legacy DefaultChatSystem and newer TextChatService
3. **VR Fallback** - Gracefully handles non-VR mode by falling back to camera controls
4. **Error Handling** - Added pcall wrappers around potentially failing operations
5. **BodyMover Bypass** - Conditionally applies BodyMover bypasses only when executor supports required functions

### Required Executor Features
For full functionality, your executor should support:
- `getgenv()` / `getfenv()` - For global environment access
- `hookfunction()` / `hookmetamethod()` - For BodyMover bypass (optional)
- `getconnections()` - For connection manipulation (optional)
- `sethiddenproperty()` - For advanced character features (optional)
- `firesignal()` - For chat fix compatibility

## Credits
`TheNexusAvenger` - [NexusVR](https://github.com/TheNexusAvenger/Nexus-VR-Character-Model)

`richie0866` - [Rostruct](https://github.com/richie0866/Rostruct)

`cl1ents` - Arm solver

`Stefanuk12` - Original Chatted fix

## License

sauceVR is available under the MIT license. See [LICENSE](https://github.com/saucekid/sauceVR/blob/main/LICENSE) for more details.

<p align="right">(<a href="#top">back to top</a>)</p>
