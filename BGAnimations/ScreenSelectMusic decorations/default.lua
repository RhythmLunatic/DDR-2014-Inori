local t = LoadFallbackB();

--do return t end;

-- the only arg is arg 1, the player number
local function m(metric)
	metric = metric:gsub("PN", ToEnumShortString(args[1]))
	return THEME:GetMetric(Var "LoadingScreen",metric)
end


-- Legacy StepMania 4 Function
--???
local function StepsDisplay(pn)
	local function set(self, player)
		self:SetFromGameState( player );
	end

	local t = Def.StepsDisplay {
		InitCommand=cmd(Load,"StepsDisplay",GAMESTATE:GetPlayerState(pn););
	};

	--This only adds the command for the corresponding player, so it's technically not wasteful
	if pn == PLAYER_1 then
		t.CurrentStepsP1ChangedMessageCommand=function(self) set(self, pn); end;
		t.CurrentTrailP1ChangedMessageCommand=function(self) set(self, pn); end;
	else
		t.CurrentStepsP2ChangedMessageCommand=function(self) set(self, pn); end;
		t.CurrentTrailP2ChangedMessageCommand=function(self) set(self, pn); end;
	end

	return t;
end

--default difficulty stuff
local function GetLargeDiffInd(d)
	return Difficulty:Reverse()[d];
end;

local function GetDifListX(self,pn,offset,fade)
	if pn==PLAYER_1 then
		self:x(SCREEN_LEFT+150-offset);
		if fade>0 then
			self:faderight(fade);
		end;
	else
		self:x(SCREEN_RIGHT-150+offset);
		if fade>0 then
			self:fadeleft(fade);
		end;
	end;
	return r;
end;

local function DrawDifList(pn,diff)
	return Def.ActorFrame {
		InitCommand=cmd(y,SCREEN_CENTER_Y-150-43.5-25+42*GetLargeDiffInd(diff));
		--meter
		LoadFont("_itc avant garde std bk 20px")..{
			InitCommand=cmd(diffuse,color("#000000");strokecolor,Color("White");zoom,0.9);
			SetCommand=function(self)
				local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				local song=GAMESTATE:GetCurrentSong();
				--local course = GAMESTATE:GetCurrentCourse();
				if song then
					GetDifListX(self,pn,110,0);
					if song:HasStepsTypeAndDifficulty(st,diff) then
						local steps = song:GetOneSteps( st, diff );
						self:settext(steps:GetMeter());
					else
						self:settext("");
					end;
				end;
			end;
			
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(playcommand,"Set");
			["CurrentTrail"..pname(pn).."ChangedMessageCommand"]=cmd(playcommand,"Set");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		};
	};
end;

if not GAMESTATE:IsCourseMode() then
	for player in ivalues(GAMESTATE:GetEnabledPlayers()) do
		t[#t+1] = LoadActor("DiffBlocks.png")..{
			InitCommand=cmd(vertalign,top;x,(player == PLAYER_1 and 14 or SCREEN_RIGHT-14);y,SCREEN_CENTER_Y-160-43-6.5-25;zoom,0.66);
			OffCommand=cmd(linear,0.25;addx,-500);
		};
	
		for diff in ivalues(Difficulty) do
			t[#t+1]=DrawDifList(player,diff)..{
				OffCommand=function(self)
					self:linear(0.25);
					self:addx(player == PLAYER_1 and -500 or 500);
				end;
			};
		end;
		
		--default meter stuff
		t[#t+1] = LoadActor("GRP_"..pname(player))..{
			InitCommand=cmd(x,(player == PLAYER_1 and 260-15 or SCREEN_RIGHT-260+15);y,SCREEN_CENTER_Y-80;draworder,-1;diffusealpha,0.8;zoom,0.96);
			OffCommand=cmd(bouncebegin,0.25;zoom,0);
		};
		--default radar
		t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadar"..pname(player).."_Default", "GrooveRadar"..pname(player).."_Default" );
		
		--Meterp1
		t[#t+1] = LoadFont("ScreenSelectMusic difficulty.ini") .. {
			InitCommand=cmd(x,(player == PLAYER_1 and SCREEN_LEFT+260-15 or SCREEN_RIGHT-260+15);y,SCREEN_CENTER_Y-70;);
			OffCommand=cmd(bouncebegin,0.25;zoom,0);
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			["CurrentSteps"..pname(player).."ChangedMessageCommand"]=cmd(queuecommand,"Set");
			SetCommand=function(self)
				if GAMESTATE:GetCurrentSong() then
					self:settext(GAMESTATE:GetCurrentSteps(player):GetMeter());
				else
					self:settext("");
				end;
			end;
		};

		--descriptionP1
		t[#t+1] = Def.Sprite{
			Texture = "LargeDiff 1x6.png";
			InitCommand=cmd(x,(player == PLAYER_1 and 260-15 or SCREEN_RIGHT-260+15);y,SCREEN_CENTER_Y-190-13;pause);
			OffCommand=cmd(bouncebegin,0.25;zoom,0);
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			["CurrentSteps"..pname(player).."ChangedMessageCommand"]=cmd(queuecommand,"Set");
			SetCommand=function(self)
				if GAMESTATE:GetCurrentSong() then
					self:diffusealpha(1)
					self:setstate(GetLargeDiffInd(GAMESTATE:GetCurrentSteps(player):GetDifficulty()))
				else
					self:diffusealpha(0)
				end;
			end;
		};
	end;
end;
for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("Label"..pname(pn))..{
		InitCommand=cmd(x,(pn == PLAYER_1 and 50 or SCREEN_RIGHT-50);y,SCREEN_CENTER_Y-268-3;);
		OffCommand=cmd(linear,0.15;addx,(pn==PLAYER_1 and -300 or 300));
	};
	t[#t+1] = LoadActor("Information.png")..{
		InitCommand=cmd(x,(pn==PLAYER_1 and SCREEN_RIGHT-230 or 230);y,SCREEN_CENTER_Y-90;diffusealpha,0.8;zoom,0.8);
		OnCommand=function(self)
			local style = GAMESTATE:GetCurrentStyle():GetStyleType()
			if style == "StyleType_TwoPlayersTwoSides" then
				self:diffusealpha(0);
			end;
		end;
		OffCommand=cmd(linear,0.15;diffusealpha,0);
	};
end;

--arrows shown on the music wheel--
t[#t+1] = LoadActor("arrow.png") .. {
		InitCommand=cmd(draworder,200;x,SCREEN_CENTER_X+90;y,SCREEN_BOTTOM-160);
		OnCommand=cmd(bounce;effectmagnitude,8,0,0;effectclock,'beatnooffset');
		OffCommand=cmd(sleep,0.15;linear,0.15;diffusealpha,0);
		StartSelectingStepsMessageCommand=cmd(sleep,0.15;linear,0.15;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,1);
	};
t[#t+1] = LoadActor("arrow.png") .. {
		InitCommand=cmd(draworder,200;x,SCREEN_CENTER_X-90;y,SCREEN_BOTTOM-160;rotationy,180);
		OnCommand=cmd(bounce;effectmagnitude,-8,0,0;effectclock,'beatnooffset');
		OffCommand=cmd(sleep,0.15;linear,0.15;diffusealpha,0);
		StartSelectingStepsMessageCommand=cmd(sleep,0.15;linear,0.15;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,1);
	};
t[#t+1] = LoadActor("press.png") .. {
		InitCommand=cmd(diffusealpha,0;draworder,201;x,SCREEN_CENTER_X+90;y,SCREEN_BOTTOM-160);
		OnCommand=cmd(bounce;effectmagnitude,8,0,0;effectclock,'beatnooffset');
		NextSongMessageCommand=cmd(stoptweening;linear,0;diffusealpha,1;decelerate,0.5;diffusealpha,0);
	};
t[#t+1] = LoadActor("press.png") .. {
		InitCommand=cmd(diffusealpha,0;draworder,201;x,SCREEN_CENTER_X-90;y,SCREEN_BOTTOM-160;rotationy,180);
		OnCommand=cmd(bounce;effectmagnitude,-8,0,0;effectclock,'beatnooffset');
		PreviousSongMessageCommand=cmd(stoptweening;linear,0;diffusealpha,1;decelerate,0.5;diffusealpha,0);
	};

if not GAMESTATE:IsCourseMode() then



end;
--Sound
t[#t+1] = LoadActor( THEME:GetPathS("","Pane Sound" ) ) .. {
	CodeMessageCommand=function(self,params)
		if params.Name=="OpenPanes1" or params.Name=="OpenPanes2" or params.Name=="OpenPanes3"then
			self:play();
		elseif params.Name=="ClosePanes"then
			self:stop();
		end;
	end;
};
--for course mode
if GAMESTATE:IsCourseMode() then
	t[#t+1] = LoadActor("Course_PaneNumbers")..{
		InitCommand=cmd(x,SCREEN_LEFT+351-100-12-6-3;y,SCREEN_CENTER_Y-90-164-20+10;diffusealpha,1;zoom,0.85;draworder,2;player,PLAYER_1;animate,false);
		CodeMessageCommand=function(self,params)
		local style = GAMESTATE:GetCurrentStyle():GetStyleType()
		local pn= params.PlayerNumber
		if pn==PLAYER_1 then
			if params.Name=="OpenPanes1"then
				self:diffusealpha(1);
				self:setstate(0);
			elseif params.Name=="OpenPanes3"then
				self:diffusealpha(1);
				self:setstate(1);
			elseif params.Name=="ClosePanes"then
				self:diffusealpha(0);
			end;
		end;
	end;
	OffCommand=cmd(sleep,0.15;linear,0.25;addx,-500);
	};
	t[#t+1] = LoadActor("Course_PaneNumbers")..{
		InitCommand=cmd(x,SCREEN_RIGHT-351+100+12+6-60-40+2;y,SCREEN_CENTER_Y-90-164-20+10;diffusealpha,1;zoom,0.85;draworder,2;player,PLAYER_2;animate,false);
		CodeMessageCommand=function(self,params)
		local style = GAMESTATE:GetCurrentStyle():GetStyleType()
		local pn= params.PlayerNumber
		if pn==PLAYER_2 then
			if params.Name=="OpenPanes1"then
				self:diffusealpha(1);
				self:setstate(0);
			elseif params.Name=="OpenPanes3"then
				self:diffusealpha(1);
				self:setstate(1);
			elseif params.Name=="ClosePanes"then
				self:diffusealpha(0);
			end;
		end;
	end;
	OffCommand=cmd(sleep,0.15;linear,0.25;addx,500);
	};
	t[#t+1] = LoadActor("PaneFrameBase 3x1")..{
		InitCommand=cmd(x,SCREEN_LEFT+190-38;y,SCREEN_CENTER_Y-90-15-4;diffusealpha,1;zoomx,0.8;zoomy,0.7;draworder,2;player,PLAYER_1;animate,false);
		CodeMessageCommand=function(self,params)
		local style = GAMESTATE:GetCurrentStyle();
		local pn= params.PlayerNumber
		if pn==PLAYER_1 then
			if params.Name=="OpenPanes1"then
				self:diffusealpha(1);
				self:setstate(0);
				self:linear(0.15);
				self:x(SCREEN_LEFT+190-38);
			elseif params.Name=="OpenPanes3"then
				self:diffusealpha(1);
				self:setstate(2);
				self:linear(0.15);
				self:x(SCREEN_LEFT+190-38);
			end;
		end;
	end;
	OffCommand=cmd(sleep,0.15;linear,0.25;addx,-500);
	};
	t[#t+1] = LoadActor("PaneFrameBase 3x1")..{
		InitCommand=cmd(x,SCREEN_RIGHT-190+38;y,SCREEN_CENTER_Y-90-15-4;diffusealpha,1;zoomx,0.8;zoomy,0.7;draworder,2;player,PLAYER_2;rotationy,180;animate,false);
		CodeMessageCommand=function(self,params)
			local style = GAMESTATE:GetCurrentStyle();
			local pn= params.PlayerNumber
			if pn==PLAYER_2 then
				if params.Name=="OpenPanes1"then
					self:diffusealpha(1);
					self:setstate(0);
					self:linear(0.15);
					self:x(SCREEN_RIGHT-190+38);
				elseif params.Name=="OpenPanes3"then
					self:diffusealpha(1);
					self:setstate(2);
					self:linear(0.15);
					self:x(SCREEN_RIGHT-190+38);
				end;
			end;
		end;
		OffCommand=cmd(sleep,0.15;linear,0.25;addx,500);
	};
end;

if not GAMESTATE:IsCourseMode() then
	--Panes
	for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
		local currentPane = nil;
		t[#t+1] = Def.ActorFrame{
			OffCommand=cmd(sleep,0.15;linear,0.25;addx,(pn == PLAYER_1 and -500 or 500));
			InitCommand=cmd(x,(pn == PLAYER_1 and -500 or 500));
			StartSelectingStepsMessageCommand=cmd(playcommand,"Off");
			CodeMessageCommand=function(self,params)
				if params.PlayerNumber ~= pn then return end;
				if params.Name == "OpenPanes1" then
					currentPane = 0
				elseif params.Name == "OpenPanes2" then
					currentPane = 1
				elseif params.Name == "OpenPanes3" then
					currentPane = 2
				elseif params.Name == "ClosePanes" then
					self:linear(.15):x(pn == PLAYER_1 and -500 or 500);
					currentPane = nil;
					return
				end;
				--Because there are some other codemessage commands and I don't want this to trigger when none of the panes are open
				if currentPane then
					self:linear(.15):x(pn == PLAYER_1 and SCREEN_LEFT or 0);
					self:GetChild("PaneBG"):setstate(currentPane);
					self:GetChild("PaneNumbers"):setstate(currentPane);
					
					self:GetChild("Difficulty"):visible(currentPane==0);
					self:GetChild("Radar"):visible(currentPane==1);
					self:GetChild("Scores"):visible(currentPane==2);
					self:playcommand("Set2");
				end;
			end;
			--Only update the opened pane, because these panes are lagtastic
			CurrentSongChangedMessageCommand=function(self) self:playcommand("Set2") end,
			["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:playcommand("Set2") end,
			["CurrentTrail"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:playcommand("Set2") end,
			CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set2") end,
			Set2Command=function(self)
				if currentPane==0 then
					self:GetChild("Difficulty"):playcommand("Set");
				elseif currentPane==1 then
				
				elseif currentPane==2 then
					self:GetChild("Scores"):playcommand("Set");
				end;
			end;
			
			--The pane background
			LoadActor("PaneFrameBase 3x1")..{
				Name="PaneBG";
				InitCommand=function(self)
					self:xy(pn == PLAYER_1 and SCREEN_LEFT+150 or SCREEN_RIGHT-150,SCREEN_CENTER_Y-90-15-4);
					self:zoomx(pn == PLAYER_1 and 0.8 or -0.8);
					self:zoomy(0.7):animate(false);
				end;
			};
			
			LoadActor("PaneNumbers")..{
				Name="PaneNumbers";
				InitCommand=cmd(x,(pn == PLAYER_1 and SCREEN_LEFT+351-100-12-6-3 or SCREEN_RIGHT-351+100+12+6+3);y,SCREEN_CENTER_Y-90-164-20+10;zoom,0.85;draworder,2;animate,false);
			};
			
			--The difficulty listing on tab 1
			LoadActor("Difficulty.lua", pn)..{
				Name="Difficulty";
				InitCommand=cmd(visible,false;draworder,3; addy,-19),
			};
			--The radar on tab 2
			Def.ActorFrame{
				Name="Radar";
				StandardDecorationFromFileOptional( "GrooveRadar"..pname(pn).."_Pane", "GrooveRadar"..pname(pn).."_Pane" );
				StandardDecorationFromFileOptional("PaneDisplayText"..pname(pn),"PaneDisplayText"..pname(pn));
				InitCommand=cmd(visible,false;draworder,3;addy,-23);
				LoadActor("PaneRadar")..{
					InitCommand=cmd(x,(pn == PLAYER_1 and SCREEN_LEFT+175 or SCREEN_RIGHT-175);y,SCREEN_CENTER_Y-118+12;zoom,0.9);
				};
			};
			
			--The scores on tab 3
			LoadActor("scores",pn)..{
				Name="Scores";
				InitCommand=function(self)
					(cmd(visible,false;draworder,3;y,SCREEN_CENTER_Y-160-30;addx,5))(self);
					if pn == PLAYER_1 then 
						self:x(SCREEN_LEFT+175);
					else
						self:x(SCREEN_RIGHT-175);
					end;
				end;
			};
		};
	end
end;
t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");
t[#t+1] = StandardDecorationFromFileOptional("BPMLabel","BPMLabel");
t[#t+1] = StandardDecorationFromFileOptional("SegmentDisplay","SegmentDisplay");

--LoadActor(THEME:GetPathG("ShockArrowDisplay","Icon"),PLAYER_1);
--[[
ShowShockArrowDisplayP1=true
ShockArrowDisplayP1X=SCREEN_CENTER_X-203
ShockArrowDisplayP1Y=SCREEN_CENTER_Y-95-40-11
ShockArrowDisplayP1OnCommand=player,PLAYER_1;draworder,100;zoom,0;decelerate,0.2;zoom,0.95;
ShockArrowDisplayP1OffCommand=decelerate,0.2;zoom,0;
ShockArrowDisplayP1PlayerJoinedMessageCommand=%function(self,params) if params.Player == PLAYER_1 then self:playcommand("On") end end
#
ShowShockArrowDisplayP2=true
ShockArrowDisplayP2X=SCREEN_CENTER_X+203
ShockArrowDisplayP2Y=SCREEN_CENTER_Y-95-40-11
ShockArrowDisplayP2OnCommand=player,PLAYER_2;draworder,100;zoom,0;decelerate,0.2;zoom,0.95;
ShockArrowDisplayP2OffCommand=decelerate,0.2;zoom,0;
ShockArrowDisplayP2PlayerJoinedMessageCommand=%function(self,params) if params.Player == PLAYER_2 then self:playcommand("On") end end
]]
--t[#t+1] = StandardDecorationFromFileOptional("ShockArrowDisplayP1","ShockArrowDisplayP1");
--t[#t+1] = StandardDecorationFromFileOptional("ShockArrowDisplayP2","ShockArrowDisplayP2");
for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
	t[#t+1] = LoadActor(THEME:GetPathG("ShockArrowDisplay","Icon"),pn)..{
		InitCommand=function(self) 
			self:x(pn == PLAYER_1 and SCREEN_CENTER_X-203 or SCREEN_CENTER_X+203):y(SCREEN_CENTER_Y-95-40-11)
		end;
		OnCommand=function(self) self:draworder(100):zoom(0):decelerate(.2):zoom(.95) end;
		OffCommand=function(self) self:decelerate(.2):zoom(0) end;
	};
end;

if not GAMESTATE:IsCourseMode() then
	t[#t+1] = StandardDecorationFromFileOptional("NewSong","NewSong") .. {
	-- 	ShowCommand=THEME:GetMetric(Var "LoadingScreen", "NewSongShowCommand" );
	-- 	HideCommand=THEME:GetMetric(Var "LoadingScreen", "NewSongHideCommand" );
		InitCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
	-- 		local pTargetProfile;
			--local sSong;
			-- Start!
			if GAMESTATE:GetCurrentSong() then
				if PROFILEMAN:IsSongNew(GAMESTATE:GetCurrentSong()) then
					self:playcommand("Show");
				else
					self:playcommand("Hide");
				end
			else
				self:playcommand("Hide");
			end
		end;
	};
	t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
end;


t[#t+1] = StandardDecorationFromFileOptional("DifficultyDisplay","DifficultyDisplay");
t[#t+1] = StandardDecorationFromFileOptional("SortOrderFrame","SortOrderFrame") .. {};
t[#t+1] = StandardDecorationFromFileOptional("SortOrder","SortOrderText") .. {
	BeginCommand=cmd(playcommand,"Set");
	SortOrderChangedMessageCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		local s = SortOrderToLocalizedString( GAMESTATE:GetSortOrder() );
		self:settext( s );
		self:playcommand("Sort");
	end;
};
t[#t+1] = StandardDecorationFromFileOptional("SongOptionsFrame","SongOptionsFrame") .. {
	ShowPressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameShowCommand");
	ShowEnteringOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameEnterCommand");
	HidePressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameHideCommand");
};
t[#t+1] = StandardDecorationFromFileOptional("SongOptions","SongOptionsText") .. {
	ShowPressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsShowCommand");
	ShowEnteringOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsEnterCommand");
	HidePressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsHideCommand");
};
--gradient (on the left)--
t[#t+1] = Def.Quad{
	InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+100-50;y,SCREEN_BOTTOM-255-25;setsize,170,26;faderight,1);
	OnCommand=cmd(addx,-300;linear,0.15;addx,300);
	OffCommand=cmd(linear,0.15;addx,-300);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		local group;
		local so = GAMESTATE:GetSortOrder();
		if not GAMESTATE:IsCourseMode() and song then
			if so == "SortOrder_Group" then
				local group = song:GetGroupName()
				if group_name[group] then
					self:diffuse(color(group_name[group][4]));
				else
					self:diffuse(color("#195c64"));
				end;
			elseif so == "SortOrder_Title" then
				self:diffuse(color("#f98b2d"));
			elseif so == "SortOrder_Artist" then
				self:diffuse(color("#f98b2d"));
			elseif so == "SortOrder_BPM" then
				self:diffuse(color("#2ed1b4"));
			elseif so == "SortOrder_AllDifficultyMeter" then
				self:diffuse(color("#2d56d1"));
			elseif so == "SortOrder_Popularity" then
				self:diffuse(color("#be32f9"));
			elseif so == "SortOrder_TopGrades" then
				self:diffuse(color("#7bd128"));
			elseif so == "SortOrder_Genre" then
				self:diffuse(color("#008392"));
			--else
			end;
		else
			self:diffusealpha(0);
		end;
	end;
	};
--group title (on the left)--
t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+100-45;y,SCREEN_BOTTOM-255-25;zoom,0.8;diffuse,color("#ffffff"););
	OnCommand=cmd(addx,-300;linear,0.15;addx,300);
	OffCommand=cmd(linear,0.15;addx,-300);
	CurrentSongChangedMessageCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
	local so = GAMESTATE:GetSortOrder();

	if song then
		if so == "SortOrder_Group" then
			local group = song:GetGroupName()
			if group_name[group] then
				self:strokecolor(ColorDarkTone(color(group_name[group][4])));
				self:settext(group_name[group][3]);
			else
				self:strokecolor(color("#195c64"))
				self:settext("Version/"..string.gsub(song:GetGroupName(),"^%d%d? ?%- ?", ""));
			end;
			self:diffusealpha(1);
			return;
		end;
		
		local group_colors= {
			["SortOrder_Title"]= "#864b21",
			["SortOrder_Artist"]= "#864b21",
			["SortOrder_BPM"]= "#006a56",
			["SortOrder_BeginnerMeter"]= "#1e1e68",
			["SortOrder_EasyMeter"]= "#1e1e68",
			["SortOrder_MediumMeter"]= "#1e1e68",
			["SortOrder_HardMeter"]= "#1e1e68",
			["SortOrder_ChallengeMeter"]= "#1e1e68",
			["SortOrder_Popularity"]= "#2e0d54",
			["SortOrder_TopGrades"]= "#254f07",
			["SortOrder_Genre"]= "#015b61",
		}
		local color_str= group_colors[GAMESTATE:GetSortOrder()] or "#000000"
		self:strokecolor(color(color_str));
		if so == "SortOrder_Title" then
				self:settext("Song Title/");
		elseif so == "SortOrder_Artist" then
				self:settext("Artist/");
		elseif so == "SortOrder_BPM" then
				self:settext("BPM");
		elseif so == "SortOrder_BeginnerMeter" then
				self:settext("Beginner/");
		elseif so == "SortOrder_EasyMeter" then
				self:settext("Basic/");
		elseif so == "SortOrder_MediumMeter" then
				self:settext("Difficult/");
		elseif so == "SortOrder_HardMeter" then
				self:settext("Expert/");
		elseif so == "SortOrder_ChallengeMeter" then
				self:settext("Challenge/");
		elseif so == "SortOrder_Popularity" then
				self:settext("Popularity/");
		elseif so == "SortOrder_TopGrades" then
				self:settext("Cleared Rank/");
		elseif so == "SortOrder_Genre" then
				self:settext("Genre/");
			end;
		else
			self:settext("");
		end
	end;
};

--SONG & GROUP LARGE JACKET
local musicWheel;
t[#t+1] = Def.ActorFrame{
 	InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y-110-5-15-8;diffusealpha,1;draworder,1);
	OnCommand=function(self)
		musicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
	end;
	OffCommand=cmd(sleep,0.2;bouncebegin,0.175;zoomy,0);
	
	
	Def.Quad{
		InitCommand=cmd(diffuse,color("#000000");setsize,310,310);
	};
	--This is the one that shows song jackets
	Def.ActorProxy{
		InitCommand=cmd(zoom,2.37);
		SetCommand=function(self)
			if centerObjectProxy then
				self:SetTarget(centerObjectProxy)
			end;
			self:visible(GAMESTATE:GetCurrentSong() ~= nil)
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	};

	--This is the one that shows group jackets
	Def.Banner {
		InitCommand=cmd(scaletoclipped,304,304);
		SetCommand=function(self,params)
			local song = GAMESTATE:GetCurrentSong();
			if song or GAMESTATE:IsCourseMode() or not musicWheel then 
				self:visible(false);
				return
			end;
			self:visible(true);
			if musicWheel:GetSelectedType() == 'WheelItemDataType_Sort' then
				self:Load(THEME:GetPathG("","_jackets/"..getenv("getgroupname")));
				
			elseif musicWheel:GetSelectedType() == 'WheelItemDataType_Section' then
				local so = GAMESTATE:GetSortOrder()
				if so == "SortOrder_Group" then
					local group = musicWheel:GetSelectedSection();
					--local group = getenv("getgroupname")
					local g = GetSongGroupJacketPath(group)
					if g then
						self:Load(g)
					else
						self:LoadFromSongGroup(group);
					end;
					self:scaletoclipped(304,304);
				else
					self:Load(THEME:GetPathG("","_jackets/"..THEME:GetString("MusicWheel",ToEnumShortString(so).."Text")))
				end;
			end;
				
	  end;
	  CurrentSongChangedMessageCommand=function(self, params)
		self:playcommand("Set", params);
	  end;
  };
}






--[[--song title black--
t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+70;zoom,1;diffuse,color("#000000");strokecolor,color("#ffffff"));
	OnCommand=cmd(playcommand,"CurrentSongChangedMessage");
	OffCommand=cmd(linear,0.15;diffusealpha,0);
	CurrentSongChangedMessageCommand=function(self)
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
			self:maxwidth(SCREEN_WIDTH-80);
			self:settext(tit);
		else
			self:diffusealpha(0);
		end;
	end;
};
--artist--
t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+100;zoom,0.8;diffuse,color("#000000");strokecolor,color("#ffffff");draworder,2);
	OffCommand=cmd(linear,0.15;diffusealpha,0);
	CurrentSongChangedMessageCommand=function(self)
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
			self:maxwidth(SCREEN_WIDTH-80);
			self:settext(tit);
		else
			self:diffusealpha(0);
		end;
	end;
};--]]

local ut = Def.ActorFrame{
	LoadFont("Common Normal")..{
		Name="songTitle";
		InitCommand=cmd(horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+70-30;zoom,1;diffuse,color("#000000");strokecolor,color("#ffffff"));
		OffCommand=cmd(decelerate,0.05;addy,900);
	};
	LoadFont("Common Normal")..{
		Name="songArtist";
		InitCommand=cmd(horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+90-30;zoom,0.8;diffuse,color("#000000");strokecolor,color("#ffffff");draworder,2);
		OffCommand=cmd(decelerate,0.05;addy,900);
	};
};


--ºq¦±¼ÐÃD§@ªÌ
local function updateTitle(self)
	local upTit = self:GetChild("songTitle");
	local upArt = self:GetChild("songArtist");
	local curSelection = GAMESTATE:GetCurrentSong();
	local curSelCourse = GAMESTATE:GetCurrentCourse();
	upTit:maxwidth(330);
	upArt:maxwidth(330);
	if curSelection or curSelCourse then
		local song;
		local tit="";
		local sub="";
		local art="";
		if GAMESTATE:IsCourseMode() then
			song=GAMESTATE:GetCurrentCourse();
			tit=song:GetDisplayFullTitle();
			upTit:settextf("%s",tit);
		else
			song=GAMESTATE:GetCurrentSong();
			tit=song:GetDisplayMainTitle();
			sub=song:GetDisplaySubTitle();
			art=song:GetDisplayArtist();
			upTit:settextf("%s",tit..sub);
		end;
		upTit:diffuse(color("0.15,0.15,0.15,1"));
		upTit:strokecolor(Color("White"));

		upArt:settextf("\n%s",art);
		upArt:diffuse(color("0.15,0.15,0.15,1"));
		upArt:strokecolor(Color("White"));
	else
		if musicWheel:GetSelectedType() == 'WheelItemDataType_Sort' then
			upTit:settext(getenv("getgroupname") or "nil?");
		else
			if GAMESTATE:GetSortOrder() == "SortOrder_Group" then
				upTit:settext(musicWheel:GetSelectedSection() or "");
			else
				upTit:settext("Music Sort "..musicWheel:GetSelectedSection() or "");
			end;
		end;
		upArt:settext("");
	end;
end;

ut.InitCommand=cmd(SetUpdateFunction,updateTitle);


t[#t+1] = ut;

t[#t+1] = LoadActor("Tip_Song")..{
	CurrentSongChangedMessageCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
	if song then
		self:playcommand("On");
		self:stoptweening();
		self:diffusealpha(1);
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y+85);
		self:draworder(999);
	else
		self:diffusealpha(0);
	end;
	end;
	OnCommand=cmd(zoomx,0.6;zoomy,0;sleep,3;linear,0.15;zoomy,0.65;bounce;effectmagnitude,0,3,0);
	OffCommand=cmd(linear,0.15;zoomy,0);
	StartSelectingStepsMessageCommand=cmd(linear,0.15;zoomy,0);
	SongUnchosenMessageCommand=cmd(queuecommand,"CurrentSongChanged");
	};

if GAMESTATE:IsCourseMode() then
	t[#t+1] = StandardDecorationFromFileOptional("CourseContentsListP1","CourseContentsListP1")..{
		InitCommand=cmd(diffusealpha,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);draworder,101;zoom,0.8;addy,90);
		CodeMessageCommand=function(self,params)
		local pn = params.PlayerNumber
			if pn==PLAYER_1 then
				if params.Name=="OpenPanes1"then
					self:diffusealpha(1);
				elseif params.Name=="OpenPanes2"then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};
	t[#t+1] = StandardDecorationFromFileOptional("CourseContentsListP2","CourseContentsListP2")..{
		InitCommand=cmd(diffusealpha,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);draworder,101;zoom,0.8;addy,90);
		CodeMessageCommand=function(self,params)
			local pn = params.PlayerNumber
			if pn==PLAYER_2 then
				if params.Name=="OpenPanes1"then
					self:diffusealpha(1);
				elseif params.Name=="OpenPanes2"then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};
end;
for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
	--grades
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(addy,-110);
		Def.Quad{
			InitCommand=cmd(zoom,0.8;shadowlength,1;x,(pn==PLAYER_1 and SCREEN_CENTER_X-204 or SCREEN_CENTER_X+204);y,SCREEN_CENTER_Y+100;horizalign,center;draworder,2);
			OffCommand=cmd(bouncebegin,0.15;zoom,0);
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				local SongOrCourse, StepsOrTrail;
				if GAMESTATE:IsCourseMode() then
					SongOrCourse = GAMESTATE:GetCurrentCourse();
					StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
				else
					SongOrCourse = GAMESTATE:GetCurrentSong();
					StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
				end;

				local profile, scorelist;
				local text = "";
				if SongOrCourse and StepsOrTrail then
					local st = StepsOrTrail:GetStepsType();
					local diff = StepsOrTrail:GetDifficulty();
					local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;

					if PROFILEMAN:IsPersistentProfile(pn) then
						-- player profile
						profile = PROFILEMAN:GetProfile(pn);
					else
						-- machine profile
						profile = PROFILEMAN:GetMachineProfile();
					end;

					scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
					assert(scorelist);
						local scores = scorelist:GetHighScores();
						assert(scores);
						local topscore=0;
						if scores[1] then
							topscore = scores[1]:GetScore();
						end;
						assert(topscore);
						local topgrade;
						if scores[1] then
							topgrade = scores[1]:GetGrade();
							assert(topgrade);
							if scores[1]:GetScore()>1  then
								if scores[1]:GetScore()==1000000 and topgrade=="Grade_Tier07" then
									self:LoadBackground(THEME:GetPathG("myMusicWheel","Tier01"));
									self:diffusealpha(1);
								else
									self:LoadBackground(THEME:GetPathG("myMusicWheel",ToEnumShortString(topgrade)));
									self:diffusealpha(1);
								end;
							else
								self:diffusealpha(0);
							end;
						else
							self:diffusealpha(0);
						end;
				else
					self:diffusealpha(0);
				end;
			end;
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(playcommand,"Set");
			["CurrentTrail"..pname(pn).."ChangedMessageCommand"]=cmd(playcommand,"Set");
		};
	};
	
	t[#t+1] = StandardDecorationFromFileOptional("DifficultyList"..pname(pn),"DifficultyList"..pname(pn));
end;

--[[t[#t+1] = Def.ActorFrame{
	LoadActor("base")..{
		InitCommand=cmd(Center;diffusealpha,0;draworder,20);
		StartSelectingStepsMessageCommand=cmd(diffusealpha,0);
		SongUnchosenMessageCommand=cmd(diffusealpha,0)
	};
};]]



--DIFFICULTY DISPLAY
local stepsArray

local function SortCharts(a,b)
    local bST = StepsType:Compare(a:GetStepsType(),b:GetStepsType()) < 0
    if a:GetStepsType() == b:GetStepsType() then
        return a:GetMeter() < b:GetMeter()
    else
        return bST
    end;
end

local function GetCurrentStepsIndex(pn)
	local playerSteps = GAMESTATE:GetCurrentSteps(pn);
	for i=1,#stepsArray do
		if playerSteps == stepsArray[i] then
			return i;
		end;
	end;
	--If it reaches this point, the selected steps doesn't equal anything.
	return -1;
end;

local function diffIcon(player, pos)
	return Def.ActorFrame{
	
		--Nothing in this controls the coloring, the middle item is always the selected one so it's not dimmed
		["CurrentSteps"..pname(player).."ChangedMessageCommand"]=function(self)
			if not stepsArray then return end;
			local index = GetCurrentStepsIndex(player);
			if index+pos > 0 and index+pos < #stepsArray+1 then
				self:visible(true);
				local stepsForThisItem = stepsArray[index+pos];
				local diffName = ToEnumShortString(stepsForThisItem:GetDifficulty())
				self:GetChild("Base"):Load(THEME:GetPathG("","StepsDisplayListRow frame/bases/"..diffName));
				self:GetChild("Color"):diffuse(CustomDifficultyToColor(diffName));
				if pos == 0 then
					self:GetChild("Color"):finishtweening():cropright(1):decelerate(.3):cropright(0);
				end;
				self:GetChild("Title"):Load(THEME:GetPathG("","StepsDisplayListRow frame/titles/"..diffName));
				self:GetChild("Meter"):settext(stepsForThisItem:GetMeter());
			else
				self:visible(false);
			end;
		end;
		
		Def.Sprite{
			Name="Base";
			--InitCommand=cmd(visible,true);
			
			SetCommand=function(self,param)
				if param.CustomDifficulty and param.CustomDifficulty ~= "" then
					self:Load(THEME:GetPathG("","StepsDisplayListRow frame/bases/"..param.CustomDifficulty));
				end;
			end;
		};
		Def.Quad{
			Name="Color";
			InitCommand=cmd(xy,-187,-30;setsize,374,55;halign,0;cropright,1);
			SetCommand=function(self,param)
				if param.CustomDifficulty and param.CustomDifficulty ~= "" then
					self:diffuse(CustomDifficultyToColor(param.CustomDifficulty) );
				else
					self:diffuse(color('1,1,1,1'));
				end;
			end;
		};
		Def.Sprite{
			Name="Title";
			InitCommand=cmd(halign,0;x,-140;y,-30);
			SetCommand=function(self,param)
				if param.CustomDifficulty and param.CustomDifficulty ~= "" then
					self:Load(THEME:GetPathG("","StepsDisplayListRow frame/titles/"..param.CustomDifficulty));
				end;
			end;
		};
		LoadFont("_itc avant garde std bk 50px")..{
			Name="Meter";
			Text="999";
			InitCommand=cmd(zoom,0.8;halign,1;x,174;y,-30);
			OnCommand=function(self,param)
				self:diffuse(color("#000000"))
				self:strokecolor(color("#FFFFFF"))
				--self:settext(param.Meter)
			end;
		};
	}
end;

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.ActorFrame{
		CurrentSongChangedMessageCommand=function(self)
			if GAMESTATE:GetCurrentSong() then
				--stepsArray = GAMESTATE:GetCurrentSong():GetAllSteps();
				stepsArray = GAMESTATE:GetCurrentSong():GetStepsByStepsType('StepsType_Dance_Single');
				table.sort(stepsArray, SortCharts);
			end;
		end;
		StartSelectingStepsMessageCommand=cmd(finishtweening;linear,0.2;addx,(pn==PLAYER_1 and 500 or -500));

		SongUnchosenMessageCommand=function(s) s:playcommand("Unset") end;
		OffCommand=function(s) s:playcommand("Unset") end;
		UnsetCommand=function(s) s:finishtweening():linear(0.3):addx(pn==PLAYER_1 and -500 or 500) end;
		InitCommand=cmd(xy,(pn==PLAYER_1 and SCREEN_CENTER_X-384-500 or SCREEN_CENTER_X+384+500),SCREEN_CENTER_Y);
		LoadActor("DifficultyList/backer");
		diffIcon(pn, -1)..{
			InitCommand=cmd(addy,-150;diffuse,color(".5,.5,.5,1"));
		};
		diffIcon(pn, 0)..{
			InitCommand=cmd();
		};
		
		Def.ActorFrame{
			InitCommand=cmd(xy,-165,-30;bob;effectmagnitude,3,0,0);
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(stopeffect;stoptweening;zoomy,0;linear,.25;zoomy,1;bob;effectmagnitude,3,0,0);
			Def.Sprite{
				Texture=THEME:GetPathG("StepsDisplayListRow","frame/arrow shadow");
			};
			Def.Sprite{
				Texture=THEME:GetPathG("StepsDisplayListRow","frame/arrow color");	
				InitCommand=cmd(diffuseshift;effectcolor1,color("#22ff00");effectcolor2,color("#FFFFFF");effectperiod,.3);
			}
		};
		
		diffIcon(pn, 1)..{
			InitCommand=cmd(addy,150;diffuse,color(".5,.5,.5,1"));
		};
		


	};
end;

--END DIFFICULTY DISPLAY

--wheel open animation, input handler, difficulty adjustment, etc

--Copypasted from the source of ScreenSelectMusic.cpp
local function ChangePreferredDifficulty(pn,dir)
	local d = Enum.Reverse(Difficulty)[GAMESTATE:GetPreferredDifficulty(pn)]
	--SCREENMAN:SystemMessage(d+dir)
	if d+dir > 0 and d+dir<5 then
		GAMESTATE:SetPreferredDifficulty(pn,Difficulty[1+d+dir])
		SOUND:PlayOnce(THEME:GetPathS("ScreenSelectMusic", "difficulty harder"))
	end;
	--SCREENMAN:SystemMessage(Difficulty[1+d+dir])
end;


local function ChangeSteps(pn,dir)
	if (GAMESTATE:GetCurrentSong()) then
		local selection = GetCurrentStepsIndex(pn) + dir
		if selection < #stepsArray+1 and selection > 0 then
			GAMESTATE:SetCurrentSteps(pn,stepsArray[selection])
			GAMESTATE:SetPreferredDifficulty(pn,stepsArray[selection]:GetDifficulty())
			SOUND:PlayOnce(THEME:GetPathS("ScreenSelectMusic", "difficulty harder"))
		end;
	else
		ChangePreferredDifficulty(pn,dir)
	end;
end;


local numwh = THEME:GetMetric("MusicWheel","NumWheelItems")+2
local twoPartSelectActive = false;
local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	--if not pn or not SCREENMAN:get_input_redirected(pn) then return end
	if not pn then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	if button == "Center" or button == "Start" and musicWheel:GetSelectedType() == 'WheelItemDataType_Section' then
		if musicWheel then
			--[[	musicWheel:GetWheelItem(musicWheel:GetCurrentIndex())
				--:sleep( (i > numwh/2) and i/20 or 0 )
				:decelerate(.25):addy(-500)
				:sleep(0)
				:accelerate(0.25):addy(500)]]
			--local wheel = musicWheel:GetChild("MusicWheelItem")
			for i=0,numwh-1 do
				--local inv = numwh-math.round( (i-numwh/2) )+1
				local w = musicWheel:GetWheelItem(i)
				--musicWheel:SetDrawByZPosition(false):zbuffer(false);
				if w:GetType() == 2 then
					local prevX = w:GetX();
					w:stoptweening()
					--:draworder(i):Draw()
					:z(i)
					:x(0):decelerate(.25):x(prevX);
					--w:x(SCREEN_CENTER_X);
					--:sleep( (i > numwh/2) and i/20 or 0 )
					--:decelerate(.25):addy(-500)
					--:sleep(0)
					--:accelerate(0.25):addy(500)
				else
					w:z(100);
				end;
			end
		end
	elseif not twoPartSelectActive and button == "MenuDown" then
		ChangeSteps(pn,1)
	elseif not twoPartSelectActive and button == "MenuUp" then
		ChangeSteps(pn,-1)
	elseif button == "Select" then
		SCREENMAN:AddNewScreenToTop("ScreenPlayerOptions");
		--return true
	else
		--SCREENMAN:SystemMessage(button)
		
	end;
end;

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
	StartSelectingStepsMessageCommand=function(self)
		twoPartSelectActive = true
	end;
	SongChosenMessageCommand=function(self)
		twoPartSelectActive = true
	end;
	SongUnchosenMessageCommand=function(self)
		twoPartSelectActive = false
	end;
}

return t;
