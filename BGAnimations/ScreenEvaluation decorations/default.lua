local t = LoadFallbackB();

t[#t+1] = LoadActor("underlay.png")..{
	InitCommand=cmd(FullScreen);
	OffCommand=cmd(linear,0.15;diffusealpha,0);
	};
t[#t+1] = LoadActor("LabelP1")..{
		InitCommand=cmd(x,SCREEN_LEFT+80;y,SCREEN_CENTER_Y-268-2;player,PLAYER_1;zoom,0.675);
		OffCommand=cmd(linear,0.15;addx,-300);
	};
t[#t+1] = LoadActor("LabelP2")..{
		InitCommand=cmd(x,SCREEN_RIGHT-80;y,SCREEN_CENTER_Y-268-2;player,PLAYER_2;zoom,0.675);
		OffCommand=cmd(linear,0.15;addx,300);
	};
--------�����I��----------

--[[function getOppositePlayerNumber(pn)
	if pn == PLAYER_1 then
		return PLAYER_2
	else
		return PLAYER_1
	end;
end;]]


--t[#t+1] = LoadActor("qrcode", PLAYER_1)..{};

-- If single player
if #GAMESTATE:GetEnabledPlayers() == 1 then
	--P1 Frame
	t[#t+1] = LoadActor("frame", GAMESTATE:GetMasterPlayerNumber(),PLAYER_1,(GAMESTATE:GetMasterPlayerNumber() ~= PLAYER_1))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X-250,SCREEN_BOTTOM-205);
	};
	--P2 Frame
	t[#t+1] = LoadActor("frame", GAMESTATE:GetMasterPlayerNumber(),PLAYER_2,(GAMESTATE:GetMasterPlayerNumber() ~= PLAYER_2))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X+250,SCREEN_BOTTOM-205);
	};
else --If multiplayer
	--P1 Frame
	t[#t+1] = LoadActor("frame", PLAYER_1,PLAYER_1,false)..{
		InitCommand=cmd(xy,SCREEN_CENTER_X-250,SCREEN_BOTTOM-205);
	};
	--P2 Frame
	t[#t+1] = LoadActor("frame", PLAYER_2,PLAYER_2,false)..{
		InitCommand=cmd(xy,SCREEN_CENTER_X+250,SCREEN_BOTTOM-205);
	};

end;

--ScoreLabelP1
t[#t+1] = LoadActor("Score_Label")..{
	InitCommand=cmd(diffusealpha,1;draworder,11;x,SCREEN_CENTER_X-320-100-10;y,SCREEN_CENTER_Y-90+5;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);zoom,0.7);
	OffCommand=cmd(sleep,0.2;linear,0.2;diffusealpha,0);
};
--Song jacket border
t[#t+1] = Def.Quad{
	InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y-110-5-50-20-10-5;diffusealpha,1;draworder,1;diffuse,color("#000000");setsize,226,226);
	OffCommand=cmd(sleep,0.2;bouncebegin,0.175;zoomy,0);
	};
--song jacket--
t[#t+1] = Def.ActorFrame {
 	InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y-110-5-50-20-10-5;diffusealpha,1;draworder,1);
	Def.Sprite {
		OnCommand=function(self)
		local course = GAMESTATE:GetCurrentCourse();
		if GAMESTATE:IsCourseMode() then
			if course:GetBackgroundPath() then
				self:Load( course:GetBackgroundPath() )
				self:setsize(220,220);
			else
				-- default to the Banner of the first song in the course
				self:Load(THEME:GetPathG("","Common fallback jacket"));
				self:setsize(220,220);
			end
		else
			local song = GAMESTATE:GetCurrentSong();
				if song then
					if song:HasJacket() then
						self:diffusealpha(1);
						self:LoadBackground(song:GetJacketPath());
						self:setsize(220,220);
					elseif song:HasBackground() then
						self:diffusealpha(1);
						self:LoadFromSongBackground(GAMESTATE:GetCurrentSong());
						self:setsize(220,220);
					else
						self:Load(THEME:GetPathG("","Common fallback jacket"));
						self:setsize(220,220);
					end;
				else
					self:diffusealpha(0);
			end;
		end;
		end;
	OffCommand=cmd(sleep,0.2;bouncebegin,0.175;zoomy,0);
	};
};



--I don't even know what this is
t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	--Grade
	--Positioning handled by metrics.
	t[#t+1] = LoadActor("grade", pn)..{
		InitCommand=cmd(diffusealpha,1;draworder,11);
		OffCommand=cmd(sleep,0.2;linear,0.2;diffusealpha,0);
	};
	--Score
	--TODO: Fix this, because what the fuck is this positioning? It's not even aligned
	local xVal = (pn == PLAYER_1) and SCREEN_CENTER_X-310+23 or SCREEN_CENTER_X+310+75; --Ternary
	t[#t+1] = Def.RollingNumbers {
		File = THEME:GetPathF("ScreenEvaluation", "ScoreNumbers");
		InitCommand=cmd(DiffuseAndStroke,Color("Black"),Color("HoloBlue");x,xVal;y,SCREEN_CENTER_Y-47.5;player,pn;playcommand,"Set");
		SetCommand = function(self)
			local score = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore();
			self:Load("RollingNumbersEvaluation");
			self:targetnumber(score);
		end;
		OffCommand=cmd(sleep,0.067;zoom,0);
	};
end;
		
-- Style, Difficulty, Difficulty Number.
if ShowStandardDecoration("StepsDisplay") then
	for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
		local xOffset = (pn == PLAYER_1) and -150 or 150;
		local alignment = (pn == PLAYER_1) and right or left;
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+xOffset;y,SCREEN_CENTER_Y-295;);
		
			LoadFont("_itc avant garde std bk 20px")..{
				InitCommand=cmd(horizalign,alignment;shadowlength,1);
				OffCommand=cmd(linear,0.25;diffusealpha,0);
				OnCommand=function(self)
					local style = GAMESTATE:GetCurrentStyle();
					if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
						self:settext("DOUBLE");
						self:diffuse(color("#f700d7"));
					elseif style:GetStyleType() == "StyleType_OnePlayerOneSide" then
						self:settext("SINGLE");
						self:diffuse(color("#01b4ff"));
					elseif style:GetStyleType() == "StyleType_TwoPlayersTwoSides" then
						self:settext("VERSUS");
						self:diffuse(color("#f78c03"));
					end;
				end;
			};
			LoadFont("_itc avant garde std bk 20px")..{
				InitCommand=cmd(addy,25;horizalign,alignment;shadowlength,1);
				OffCommand=cmd(linear,0.25;diffusealpha,0);
				OnCommand=function(self)
					local diffname = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
					self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diffname)));
					self:diffuse(GameColor.Difficulty[diffname])
				end;
			};
			LoadFont("_itc avant garde std bk 50px")..{
				InitCommand=cmd(addy,40;horizalign,alignment;vertalign,top;--[[shadowlength,1;]]diffuse,Color("Black"));
				OffCommand=cmd(linear,0.25;diffusealpha,0);
				OnCommand=function(self)
					local meter = GAMESTATE:GetCurrentSteps(pn):GetMeter();
					self:settext(meter);
				end;
			};
		}
	end
end

--[[for pn in ivalues(PlayerNumber) do
	local MetricsName = "MachineRecord" .. PlayerNumberToString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "MachineRecord"), pn ) .. {
		InitCommand=function(self)
			self:player(pn);
			self:name(MetricsName);
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen");
		end;
	};
end

for pn in ivalues(PlayerNumber) do
	local MetricsName = "PersonalRecord" .. PlayerNumberToString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "PersonalRecord"), pn ) .. {
		InitCommand=function(self)
			self:player(pn);
			self:name(MetricsName);
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen");
		end;
	};
end

for pn in ivalues(PlayerNumber) do
	local MetricsName = "StageAward" .. PlayerNumberToString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "StageAward"), pn ) .. {
		InitCommand=function(self)
			self:player(pn);
			self:name(MetricsName);
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen");
		end;
		BeginCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			local tStats = THEME:GetMetric(Var "LoadingScreen", "Summary") and STATSMAN:GetAccumPlayedStageStats() or STATSMAN:GetCurStageStats();
			tStats = tStats:GetPlayerStageStats(pn);
			if tStats:GetStageAward() then
				self:settext( THEME:GetString( "StageAward", ToEnumShortString( tStats:GetStageAward() ) ) );
			else
				self:settext( "" );
			end
		end;
	};
end

for pn in ivalues(PlayerNumber) do
	local MetricsName = "PeakComboAward" .. PlayerNumberToString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "PeakComboAward"), pn ) .. {
		InitCommand=function(self)
			self:player(pn);
			self:name(MetricsName);
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen");
		end;
		BeginCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			local tStats = THEME:GetMetric(Var "LoadingScreen", "Summary") and STATSMAN:GetAccumPlayedStageStats() or STATSMAN:GetCurStageStats();
			tStats = tStats:GetPlayerStageStats(pn);
			if tStats:GetPeakComboAward() then
				self:settext( THEME:GetString( "PeakComboAward", ToEnumShortString( tStats:GetPeakComboAward() ) ) );
			else
				self:settext( "" );
			end
		end;
	};
end]]

--song title black--
t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-70-2;zoom,1;diffuse,color("#000000");strokecolor,color("#ffffff"));
	OffCommand=cmd(linear,0.15;diffusealpha,0);
	OnCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
	local course = GAMESTATE:GetCurrentCourse();
		if song or course then
			local tit="";
			if GAMESTATE:IsCourseMode() then
				song=GAMESTATE:GetCurrentCourse();
				tit=song:GetDisplayFullTitle();
			else
				song=GAMESTATE:GetCurrentSong();
				tit=song:GetDisplayMainTitle();
			end;
			self:diffusealpha(1);
			self:maxwidth(350);
			self:settext(tit);
			self:diffuse(Color("Black"));
		else
			self:diffusealpha(0);
		end;
	end;
};
if not GAMESTATE:IsCourseMode() then
	--artist--
	t[#t+1] = LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+30-70-5;zoom,0.8;diffuse,color("#000000");strokecolor,color("#ffffff");draworder,2);
		OffCommand=cmd(linear,0.15;diffusealpha,0);
		OnCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		local course = GAMESTATE:GetCurrentCourse();
			if song or course then
				local tit="";
				if GAMESTATE:IsCourseMode() then
					song=GAMESTATE:GetCurrentCourse();
					tit=song:GetDisplayFullTitle();

				else
					song=GAMESTATE:GetCurrentSong();
					tit=song:GetDisplayArtist();
				end;
				self:diffusealpha(1);
				self:maxwidth(400);
				self:settext(tit);
			else
				self:diffusealpha(0);
			end;
		end;
	};
end;
t[#t+1] = StandardDecorationFromFileOptional("GameType","GameType");
t[#t+1] = Def.ActorFrame {
	Condition=GAMESTATE:HasEarnedExtraStage() and GAMESTATE:IsExtraStage() and not GAMESTATE:IsExtraStage2();
	InitCommand=cmd(draworder,105);
	LoadActor( THEME:GetPathS("ScreenEvaluation","try Extra1" ) ) .. {
		Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false;
		OnCommand=cmd(play);
	};
	-- LoadActor( THEME:GetPathG("ScreenStageInformation","Stage extra1" ) ) .. {
		-- Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false;
		-- InitCommand=cmd(Center);
		-- OnCommand=cmd(diffusealpha,0;zoom,0.85;bounceend,1;zoom,1;diffusealpha,1;sleep,0;glow,Color("White");decelerate,1;glow,Color("Invisible");smooth,0.35;zoom,0.25;y,SCREEN_BOTTOM-72);
	-- };
};
t[#t+1] = Def.ActorFrame {
	Condition=GAMESTATE:HasEarnedExtraStage() and not GAMESTATE:IsExtraStage() and GAMESTATE:IsExtraStage2();
	InitCommand=cmd(draworder,105);
	LoadActor( THEME:GetPathS("ScreenEvaluation","try Extra2" ) ) .. {
		Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false;
		OnCommand=cmd(play);
	};
	-- LoadActor( THEME:GetPathG("ScreenStageInformation","Stage extra2" ) ) .. {
		-- Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false;
		-- InitCommand=cmd(Center);
		-- OnCommand=cmd(diffusealpha,0;zoom,0.85;bounceend,1;zoom,1;diffusealpha,1;sleep,0;glow,Color("White");decelerate,1;glow,Color("Invisible");smooth,0.35;zoom,0.25;y,SCREEN_BOTTOM-72);
	-- };
};
return t
