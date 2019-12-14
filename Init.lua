local _, core = ...;

active = false

core.commands = {
    ["start"] = core.Config.Start,
    ["stop"] = core.Config.Stop,
    ["delay"] = core.Config.Delay,
    ["menu"] = core.Config.OpenMenu,
    ["help"] = function()
		print("|cff00cc66***************************************");
        print("|cff00cc66LFG Helper by|r <|cfff00066Joel|r>");
        print("Commands");
		print("|cff00cc66/lfg|r                         - Shows GUI");
		print("|cff00cc66/lfg|r |cffffcc66YOUR MESSAGE|r     - Starts sending your message");
		print("|cff00cc66/lfg|r |cffffcc66delay=|r|c333fff00SECONDS|r     - Delay between msgs (default 30sec)");
		print("|cff00cc66/lfg|r |cffffcc66stop|r                   - Stops active message");
        print("|cff00cc66/lfg|r |cffffcc66help|r                   - Help menu");
		print("|cff00cc66***************************************");
		print(" ");
	end
};

local function HandleSlashCommands(str)
    if(#str == 0) then
        core.Config:OpenMenu();
        return;
    end
    message = string.lower(str);
    if(message == "stop") then
        core.commands.stop();
        active = false;
        core.Config:DisableOrEnableSlider(active);
    end
    if(message ~= "stop" and message ~= "help" and message ~= string.match(message,"delay=%d+") and message ~= "menu") then
        if (active == false) then
            active = true;
            core.Config:DisableOrEnableSlider(active);
            core.Config:SetUserMessage(str);
            core.commands.start();
        else
            print("|cff00cc66LFG Helper:|r |cfff00066Stop the current message before starting a new one!\n");
        end
    end
    if(message == "help") then
        core.commands.help();
    end
    if(message:match "delay=%d+") then
        if (active == false) then
            seconds = string.match(message,"%d+");
            core.Config:Delay(tonumber(seconds));
        else
            print("|cff00cc66LFG Helper:|r |cfff00066Stop the current message before changing the delay!");
        end
    end
end

function core:init(event, name)
    if(name ~= "LFGHelper") then return end
    -- / commands
    SLASH_LFGHelper1 = "/lfg";
    SlashCmdList.LFGHelper = HandleSlashCommands;
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:RegisterEvent("PLAYER_LOGIN");
events:SetScript("OnEvent", core.init);
