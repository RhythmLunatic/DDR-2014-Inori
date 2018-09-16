local t = LoadFallbackB()

setenv("MIXMODE",false);

t[#t+1] = StandardDecorationFromFile("Version","Version")

--if Endless mode didn't get a chance to clean up after itself properly,
--ComboContinuesBetweenSongs will still be set. IMO it's not commonly used enough
--that just forcing it off will be a problem. Maybe it could be a theme pref.
if PREFSMAN:GetPreference("ComboContinuesBetweenSongs") then
	print("ComboContinuesBetweenSongs was disabled.")
	PREFSMAN:SetPreference("ComboContinuesBetweenSongs", false)
end

local counter = 0;
local t = Def.ActorFrame{};

local languageToRegion = {
ja = "J",
en = "U",
ch = "C"
}

t[#t+1] = Def.ActorFrame {
	Def.BitmapText{
		Font="_handelgothic bt 20px",
		--Text=themeInfo["Name"] .. " " .. themeInfo["Version"] .. " by " .. themeInfo["Author"],
		InitCommand=function(self)
			(cmd(halign,0;valign,0;x,SCREEN_LEFT+10;y,SCREEN_TOP+10;shadowlength,1;))(self)
			local pref = ThemePrefs.Get("TitleScreenVersion");
			local region = languageToRegion[THEME:GetCurLanguage()];
			if region == nil then
				region = "?";
			end;
			if pref == "DDR 2014" then
				self:settext("MDX:"..region..":A:A:2015122100");
			elseif pref == "Current Date" then
				self:settextf("MDX:"..region..":A:A:%04d%02d%02d%02d",Year(),MonthOfYear(),DayOfMonth(),0);
			else
				self:settext(themeInfo["Name"] .. " " .. themeInfo["Version"] .. " by " .. themeInfo["Author"]);
				--self:settext(languageToRegion[THEME:GetCurLanguage()]);
			end;
		end;
	};
}

if PROFILEMAN:GetNumLocalProfiles() <1 then
	t[#t+1] = Def.ActorFrame{
		LoadActor("../profile")..{
			InitCommand=cmd(Center);
			OnCommand=cmd(bob;effectmagnitude,0,5,0);
			OffCommand=cmd(sleep,0.2;linear,0.3;zoomy,0;diffusealpha,0);
		};
	};
end

return t
