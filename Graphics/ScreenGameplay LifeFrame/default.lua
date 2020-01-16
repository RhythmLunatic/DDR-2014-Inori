-- gameplay life frame

-- The math.floor(10000*aspect) trick is used to circumvent float precision problems.
local aspectRatioSuffix = {
	[math.floor(10000*4/3)] = " 4_3",
	[math.floor(10000*16/9)] = " 16_9",
	[math.floor(10000*16/10)] = " 16_9"
}
--fall back on the 4:3 frame if we don't know about this aspect ratio at all
setmetatable(aspectRatioSuffix,{__index=function() return " standard" end})
local suffix = aspectRatioSuffix[math.floor(10000*PREFSMAN:GetPreference("DisplayAspectRatio"))]

local lifeFrame = "normal"

-- todo: show oni on life meter battery as well
if GAMESTATE:GetPlayMode() == 'PlayMode_Oni' then lifeFrame = "special" end
if GAMESTATE:GetPlayMode() == 'PlayMode_Nonstop' then lifeFrame = "special" end
if GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then lifeFrame = "special" end
if GAMESTATE:IsAnExtraStage() then lifeFrame = "special" end

if ResolveRelativePath(lifeFrame..suffix,1,true) then
	lifeFrame = lifeFrame .. suffix
else
	Warn("ScreenGameplay LifeFrame: missing frame \""..lifeFrame..suffix.."\". Using fallback assets.")
	lifeFrame = lifeFrame.." 4_3"
end

local xPosPlayer = {
    P1 = (SCREEN_CENTER_X-367),
    P2 = (SCREEN_CENTER_X+367)
}

local xPosPlayerRave = {
	P1 = -(640/6.7),
    P2 = (640/6.7)
};

local t = Def.ActorFrame{}
t[#t+1] = LoadActor("flicker")
for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			local short = ToEnumShortString(pn)
			self:x(xPosPlayer[short])
		end,
		OnCommand=function(s) s:zoomx(pn=='PlayerNumber_P2' and -1 or 1) end,
		Def.Sprite{
			InitCommand=function(self)
				--Preload trick so the OS caches the files
				self:Load(THEME:GetPathG("ScreenGameplay","LifeFrame/gauge_rainbow (stretch).png"))
				self:Load(THEME:GetPathG("ScreenGameplay","LifeFrame/gauge_normal (stretch).png"))
				self:x(5);
			end;
			--Texture = "gauge_normal (stretch)";
			BeginCommand=cmd(zoomtowidth,450;);
			OnCommand=function(self) 
				self:MaskDest():ztestmode("ZTestMode_WriteOnFail");
				self:customtexturerect(0,0,1,1) 
				if pn == PLAYER_1 then 
					self:texcoordvelocity(-.75,0)
				else 
					self:texcoordvelocity(.75,0)
				end;
			end;
			HealthStateChangedMessageCommand=function(self, param)
				if param.PlayerNumber == pn then
					if param.HealthState == "HealthState_Danger" then
						--self:Load(THEME:GetPathB("","ScreenGameplay decorations/danger (stretch).png")) :setsize(672,42)
					elseif param.HealthState == "HealthState_Hot" then 
						self:Load(THEME:GetPathG("ScreenGameplay","LifeFrame/gauge_rainbow (stretch).png")) :zoomtowidth(500);
					else
						self:Load(THEME:GetPathG("ScreenGameplay","LifeFrame/gauge_normal (stretch).png")) :zoomtowidth(500);
					end;
				end;
			end;
		};
		LoadActor(lifeFrame)..{
			Name = pn,
		};
	};
end;

--Player 1 Danger
t[#t+1] = LoadActor("danger 2x1")..{
		InitCommand=cmd(x,WideScale(-160,-213.5);visible,false);
		HealthStateChangedMessageCommand=function(self, param)
			if GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
				if param.HealthState == "HealthState_Danger" then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		end;
};
--Player 2 Danger
t[#t+1] = LoadActor("danger 2x1")..{
		InitCommand=cmd(x,WideScale(160,213.5);visible,false);
		HealthStateChangedMessageCommand=function(self, param)
			if GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
				if param.HealthState == "HealthState_Danger" then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		end;
};


return t
