# Player Ping Leaderboard Guide
A simple new leaderboard for the Titanfall Northstar Client. This mod is client side only. The leaderboard mod is toggled in-game by pressing the the F1 Key. As of right now this will be the only option for a keybind. If someone asks I will create a guide on how to change the mod's keybind.

# What this mod does
This mod adds a leaderboard that shows the connected players in a server in a relitivly simple layout. It also shows their K/D for the match as well as the player's ping. One thing that was missing from the orignal TF2 leaderboard. It also supports 24-player server, showing all the players without cutting anyone off and allows you to still see your own ping.

# How do I open the leaderboard?
Simply press the **F1** key to bring up the overlay, press it again to turn it off.

# How to install
Download the PlayerPing.zip from [Releases](https://github.com/YellingTree/Player-Ping-Leaderboard/releases) and place the extrated file **PlayerPing** into the R2Northstar mods folder located here:
>(Location of TF2 Install)\R2Northstar\mods\

# How to Customize
Simply open the **playerping.nut** located here: 
>\R2Northstar\mods\PlayerPing\mod\scipts\vscripts\playerping.nut

You will find various settings that you can change at the top of the file related to position and apperance. Open with prefered text editor.

**NOTE:** Currently moving the overlay too far right can cause issues with the mod trying to place elements. This will be addressed in a later update and this note will be removed.

# Updating
Follow the steps for installing and overwrite the files when prompted.

# Suggestions or Issues?
Open a issue! Or create a message in a thread under my mod in the discord server and I'll try and address it when I have the time.

# What it looks like
Usernames are just pixilated for screenshot
### No background (Default)
![Background Off](https://github.com/YellingTree/Player-Ping-Leaderboard/blob/main/github-assets/Leaderboard_Bg_Off.png?raw=true)
### Background On (Changed in settings)
![Background On](https://github.com/YellingTree/Player-Ping-Leaderboard/blob/main/github-assets/Leaderboard_Bg_On.png?raw=true)

# Old Changelogs from Discord
All new changes will be listed with each [Release](https://github.com/YellingTree/Player-Ping-Leaderboard/releases)
### Version 1.0 (First Release)
- Adds a simple overlay into Titanfall 2 Matches which simply lists the players connected and their pings
### Version 2.0
- Separated users for easier reading, creating dividers between each entry. This can be changed back to the old view in the settings.
- Added player's K/D to the leaderboad
- Ajusted defualt placement
### Version 2.5
- Changed how the overlay works under the hood to better separate information
- Text now remains in a static place (E.g going from a K/D of 9/9 to 10/9 won't cause the ping to shift over)
- Long names *should* no longer cause information to spill off screen
- Overlay now shows on top of other hud screen elements such as kill feed, drop cards, and faction leader comms.
- Option to disable dividers removed, dividers will be the only option going forward, sorry.
### Version 2.6: First GitHub Version
Find changes on [Releases](https://github.com/YellingTree/Player-Ping-Leaderboard/releases)


