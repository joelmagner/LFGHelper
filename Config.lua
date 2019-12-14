local _, core = ...;
core.Config = {};

local Config = core.Config;
local UIConfig;

if(LFGHelperDB == nil) then
    LFGHelperDB = {
        ["general"] = true,
        ["world"] = true,
        ["lfg"] = true,
        ["lookingforgroup"] = true,
        ["delay"] = 25,
        ["channels"] = {

        }
    };
end

userMessage = "";
toggleSlider = true;
hasMenuBeenOpened = false;
function Config:SetUserMessage(msg)
    userMessage = msg;
end

function Config:WriteMessageToChat()
    local generalChat = GetChannelName("General");
    local worldChat = GetChannelName("World");
    local lfgChat = GetChannelName("Lfg");
    local lookingforgroupChat = GetChannelName("LookingForGroup");
    if (generalChat~=nil and LFGHelperDB.general) then
        SendChatMessage(userMessage, "CHANNEL", nil, generalChat);
    end
    if (worldChat~=nil and LFGHelperDB.world) then
        SendChatMessage(userMessage, "CHANNEL", nil, worldChat);
    end
    if (lfgChat~=nil and LFGHelperDB.lfg) then
        SendChatMessage(userMessage, "CHANNEL", nil, lfgChat);
    end
    if (lfgChat~=nil and LFGHelperDB.lookingforgroup) then
        SendChatMessage(userMessage, "CHANNEL", nil, lookingforgroupChat);
    end
end

function Config:Start()
    print("|cff00cc66LFG Helper:|r Started (delay timer is |cfff00066"..tostring(LFGHelperDB.delay).."|r seconds)\n");
    ticker = C_Timer.NewTicker(LFGHelperDB.delay, Config.WriteMessageToChat);
end

function Config:Stop()
    ticker:Cancel();
    print("|cff00cc66LFG Helper:|r Stopped");
end

function Config:Delay(seconds)
    print("|cff00cc66LFG Helper:|r You set the delay to: |cfff00066"..seconds.."|r seconds between messages");
    LFGHelperDB.delay = seconds;
end

function Config:DisableOrEnableSlider(sliderStatus)
    toggleSlider = not sliderStatus;
    if hasMenuBeenOpened then UIConfig.delaySlider:SetEnabled(toggleSlider); end
    if(toggleSlider == false and hasMenuBeenOpened) then
        UIConfig.delayText:SetText("Delay (|cfff00066Turn off active message!|r)");
    else
        if hasMenuBeenOpened then UIConfig.delayText:SetText("Delay"); end
    end
end

function Config:OpenMenu()
    hasMenuBeenOpened = true;
    UIConfig = CreateFrame("Frame", "LFGHelperConfig", UIParent);
    UIConfig.headerText = UIConfig:CreateFontString(nil,"ARTWORK","GameFontNormal")
    UIConfig.headerText:SetPoint("LEFT",30,95);
    UIConfig.headerText:SetFont("Fonts\\ARIALN.TTF", 15, "OUTLINE, MONOCHROME");
    UIConfig.headerText:SetText("LFG Helper Options");
    UIConfig.delayText = UIConfig:CreateFontString(nil,"ARTWORK","GameFontNormal")
    UIConfig.delayText:SetPoint("BOTTOMLEFT",3,37);
    UIConfig.delayText:SetText("Delay");
    -- Draggable logic
    UIConfig:EnableMouse(true);
    UIConfig:SetMovable(true);
    UIConfig:SetClampedToScreen(true);
    UIConfig:SetUserPlaced(true);
    UIConfig:RegisterForDrag("LeftButton");
    UIConfig:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and not self.isMoving then
         self:StartMoving();
         self.isMoving = true;
        end
    end);
    UIConfig:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and self.isMoving then
         self:StopMovingOrSizing();
         self.isMoving = false;
        end
    end);
    UIConfig:SetScript("OnHide", function(self)
        if ( self.isMoving ) then
         self:StopMovingOrSizing();
         self.isMoving = false;
        end
    end);
    UIConfig:SetPoint("CENTER"); 
    UIConfig:SetWidth(200); UIConfig:SetHeight(210);
    local tex = UIConfig:CreateTexture(nil, "BACKGROUND");
    tex:SetAllPoints();
    tex:SetColorTexture(0, 0, 0,0.8);
      
    -- General:
	UIConfig.generalChatOpt = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate");
	UIConfig.generalChatOpt:SetPoint("TOPLEFT", UIConfig, "BOTTOMLEFT", 5, 170);
	UIConfig.generalChatOpt.text:SetText("General Channel");
    UIConfig.generalChatOpt:SetChecked(LFGHelperDB.general);
    UIConfig.generalChatOpt.tooltip = "test";
    UIConfig.generalChatOpt:SetScript("OnClick", function(self) 
        LFGHelperDB.general = not LFGHelperDB.general;
        print("|cff00cc66LFG Helper:|r You have set posting in |cfff00066General Chat|r to: |cfff00066"..tostring(LFGHelperDB.general));
    end);
	-- World:
	UIConfig.worldChatOpt = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate");
	UIConfig.worldChatOpt:SetPoint("TOPLEFT", UIConfig, "BOTTOMLEFT", 5, 140);
	UIConfig.worldChatOpt.text:SetText("World Channel");
    UIConfig.worldChatOpt:SetChecked(LFGHelperDB.world);
    UIConfig.worldChatOpt:SetScript("OnClick", function(self) 
        LFGHelperDB.world = not LFGHelperDB.world;
        print("|cff00cc66LFG Helper:|r You have set posting in |cfff00066World Chat|r to: |cfff00066"..tostring(LFGHelperDB.world));
    end);
    -- LFG:
	UIConfig.lfgChatOpt = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate");
	UIConfig.lfgChatOpt:SetPoint("TOPLEFT", UIConfig, "BOTTOMLEFT", 5, 110);
	UIConfig.lfgChatOpt.text:SetText("LFG Channel");
    UIConfig.lfgChatOpt:SetChecked(LFGHelperDB.lfg);
    UIConfig.lfgChatOpt:SetScript("OnClick", function(self) 
        LFGHelperDB.lfg = not LFGHelperDB.lfg;
        print("|cff00cc66LFG Helper:|r You have set posting in |cfff00066LFG Chat|r to: |cfff00066"..tostring(LFGHelperDB.lfg));
    end);
    -- LookingForGroup:
	UIConfig.lfgChatOpt = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate");
	UIConfig.lfgChatOpt:SetPoint("TOPLEFT", UIConfig, "BOTTOMLEFT", 5, 80);
	UIConfig.lfgChatOpt.text:SetText("LookingForGroup Channel");
    UIConfig.lfgChatOpt:SetChecked(LFGHelperDB.lookingforgroup);
    UIConfig.lfgChatOpt:SetScript("OnClick", function(self) 
        LFGHelperDB.lookingforgroup = not LFGHelperDB.lookingforgroup;
        print("|cff00cc66LFG Helper:|r You have set posting in |cfff00066LookingForGroup Chat|r to: |cfff00066"..tostring(LFGHelperDB.lookingforgroup));
    end);
    -- Close Btn:
    UIConfig.closeBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
    UIConfig.closeBtn:SetPoint("CENTER", UIConfig, "TOP", 92, -9);
    UIConfig.closeBtn:SetSize(20, 20);
    UIConfig.closeBtn:SetText("X");
    UIConfig.closeBtn:SetNormalFontObject("GameFontNormalLarge");
    UIConfig.closeBtn:SetHighlightFontObject("GameFontHighlightLarge");
    UIConfig.closeBtn:SetScript("OnClick", function() 
        UIConfig:Hide();
    end);
    -- delay slider:
    UIConfig.delaySlider = CreateFrame("SLIDER", nil, UIConfig, "OptionsSliderTemplate");
    UIConfig.delaySlider:SetPoint("TOPLEFT", UIConfig, "BOTTOMLEFT", 10, 30);
    UIConfig.delaySlider:SetMinMaxValues(5, 100);
    UIConfig.delaySlider:SetValueStep(5);
    UIConfig.delaySlider:SetObeyStepOnDrag(true);
    UIConfig.delaySlider:SetValue(LFGHelperDB.delay);
    UIConfig.delaySlider:SetScript("OnValueChanged", function(self,value)
        LFGHelperDB.delay = value;
        UIConfig.delaySlider.tooltipText = "Delay is |cfff00066"..string.format("%0.1f",tostring(LFGHelperDB.delay)).."|r seconds";
      end);
end