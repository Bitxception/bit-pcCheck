# Free PC-Check Script for ESX

This script provides a PC-Check command for FiveM servers, to temporarily teleport a target player by their ID to a designated location, freeze them, display an overlay, and disable most of their input actions. 
Only players of the "team" or the "admin" groups can access the command.

## Features

- **Teleport & Freeze:** Teleports the target player to a preset location (default is "maze") and freezes their movement.
- **Overlay Display:** Shows a red overlay with a notification that the player is undergoing a PC-Check.
- **Input Blocking:** Disables all inputs while in PC-Check mode, except for camera movement and the chat (key "T") so the player can still look around and chat.
- **Toggle Functionality:** The command acts as a toggle—invoking it again returns the player to their original position and re-enables their inputs.

**Dependencies:**
   - Make sure to use ESX as i have only implemented that as an option. If people like to, i can convert it to QB-Core and add an configuration file in the future. 

## Usage

- **Command:** `/pccheck <id> [location]`
  
- **Available Locations:**
  - `maze`
  - `fib`
  - `iaa`
  - `mile`
  - `arcadius`
  - `schlong`

- **Permissions:**
  - Only users with group "admin" or "team" can execute the command.
  
- **Toggle Behavior:**
  - The first execution saves the player's current position, teleports and freezes them at the specified location.
  - A second execution returns the player to their saved position and restores their controls.

## License

This script is free to use and modify. Attribution is appreciated but not required. My first ever script i made public. 
I provide this without any warranty of any kind, and i shall not be liable for any damages, losses, or legal claims arising from its use.
