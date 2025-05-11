# Loadstring
```luau
local Params = {
	RepoURL = "https://raw.githubusercontent.com/Chriismorph/Robloxer/refs/heads/main/",
	SSI = "main"
}

local AutoDefenseScript = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
local Config = {
	Keybinds = {
		Hide = Enum.KeyCode.RightControl, -- Key to toggle the visibility of the script UI
		Toggle = Enum.KeyCode.Backspace -- Key to enable or disable the auto defense script
	},
	TOOLS_TO_FIND = { -- List of tool names the script will detect and use. Avoid adding "Kick" or "Baseball Bat" for better stability.
		"Punch",
		"Haymaker",
		"Uppercut",
	},
	Hitbox = {
		Size = Vector3.new(2, 2.2, 2), -- The detection box around your arm. Increasing this size may trigger attacks from farther away.
	},
	SCRIPT_NAME = "HelloWord123" -- The name of the UI ScreenGui. You can change it, but it must be unique to avoid conflicts.
}


AutoDefenseScript(Config)
```

# Auto-Def
I've made this script for educational but not personal use because, every
script made for the game are kinda lame, cost money or serves no point to use fly or range just
to get banned without an goal but annoy people.

> [!WARNING]  
> Use this at your own risk. As you might get **BANNED** from roblox if you use
> Exploits. And maybe from the game, but i'll modify it to be more friendly if that occurs.
> * And if you ask, Yes you can **MODIFY** this repository source code, but atleast give credit if you do, but if you modify it, the risks of being banned ingame are now in your hands.

> [!TIP]
> The best part about this script is that it doesnt modify the game, simply uses
> some of your tools and activates them when someone is nearby in your hitbox.
> The only `evil` part of this script is the fact it does an sort of macro. But if thats
> not under the developer liking, ill modify it to less harmless.

> [!CAUTION]
> Dont use this for personal usage. This isnt meant to be used as an daily thing at the game or for bad usages.
> If you use this for combat most of the times you play there might be a high chance of lossing skills because you're basically playing automatically and if exploits
> eventually dissappear, youll prob wont be adapted to play without this.

- for sarkrinth if he ever reads this!!1!!
