--[[
pn = Which player's stats to display.
controller = which controller controls the panel
showInstructionsTab = If the fifth tab should also be shown. (It's too much work to replicate DDR 2014 exactly, so it's the fifth tab)
If showInstructionsTab is true, it will start on the instructions tab.

In DDR2014, two panels are loaded and P2 controller
moves the right panel, while P1 controller moves
the left panel.
]]
local pn, controller, showInstructionsTab, paneState = ...;
local tabCount = 4
local paneState = 0;

if showInstructionsTab then
	tabCount = 5;
	paneState = 4;
end;
local FRAME_WIDTH, FRAME_HEIGHT = 467, 250;
local paneColors = { color("#988B89"), color("#00A3DA"), color("#00DE14"), color("#F953ED"), color("#9B3AF9") }

local tabsToLoad = showInstructionsTab and "tabsExtended 1x5" or "tabsNormal 1x4";

--If PLAYER_1, zoom the frame to the left -700, else zoom it to the right 700.
local zoomTowards = (controller == PLAYER_1) and -700 or 700;
--local soundeffect;
local t = Def.ActorFrame{
	--Input handler
	CodeMessageCommand=function(self,params)
		if params.PlayerNumber==controller then
			if params.Name=="Left" then
				if paneState > 0 then
					--soundeffect:play();
					SOUND:PlayOnce(THEME:GetPathS("ScreenOptions","change" ));
					paneState = paneState - 1;
				end;
			elseif params.Name=="Right" then
				if paneState < (tabCount-1) then
					--soundeffect:play();
					SOUND:PlayOnce(THEME:GetPathS("ScreenOptions","change" ));
					paneState = paneState + 1;
				end;
			else
				SCREENMAN:SystemMessage("Unknown button: "..params.Name);
			end;
		end;
	end;
	
	--Loading the sound into memory isn't any faster than SOUND:PlayOnce so there's no point
	--[[LoadActor(THEME:GetPathS("ScreenOptions","change" ))..{
		InitCommand=cmd(set_is_action,true);
		OnCommand=function(self)
			soundeffect = self;
		end;
	};]]
	--Background
	Def.Quad{
		Name="DefaultFrame";
		InitCommand=cmd(setsize,FRAME_WIDTH,FRAME_HEIGHT;diffuse,color("1.0,1.0,1.0,0.65"););
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,zoomTowards);
	};
	--Tabs
	LoadActor(tabsToLoad)..{
		InitCommand=cmd(vertalign,bottom;horizalign,left;xy,-FRAME_WIDTH/2,-FRAME_HEIGHT/2-5;animate,false;zoom,0.675;setstate,paneState);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,zoomTowards);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==controller then
				self:setstate(paneState);
			end;
		end;
	};
	--Pane border
	Def.ActorFrame{
		InitCommand=cmd(diffuse,paneColors[paneState+1]);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,zoomTowards);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==controller then
				self:diffuse(paneColors[paneState+1]);
			end;
		end;
			
		Def.Quad{
			InitCommand=cmd(setsize,FRAME_WIDTH,7;vertalign,bottom;y,-FRAME_HEIGHT/2);
		};
		Def.Quad{
			InitCommand=cmd(setsize,FRAME_WIDTH,7;vertalign,top;y,FRAME_HEIGHT/2);
		};
	};
	--1st pane, "Clear!!" image
	Def.ActorFrame{
		InitCommand=function(self)
			if paneState ~= 0 then
				self:diffusealpha(0);
			end;
			self:addy(-50);
		end;
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==controller then
				if paneState == 0 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
		
		Def.Sprite{
			InitCommand=cmd(diffusealpha,1;zoom,0.675);
			OnCommand=function(self)
				if(STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetGrade()=="Grade_Failed") then
					self:Load(THEME:GetPathB("ScreenEvaluation","decorations/Info_Failed.png"));
				else
					self:Load(THEME:GetPathB("ScreenEvaluation","decorations/Info_Clear.png"));
				end;
			end;
			OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
		};
		--Full combo over the "clear!!" thingy
		Def.ActorFrame{
			OffCommand=cmd(sleep,0.2;linear,0.2;diffusealpha,0);
			--FCTextP1--
			LoadActor("NFC")..{
				InitCommand=cmd(zoom,0;diffusealpha,0;addy,40;addx,100;);
				OnCommand=function(self)
					local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
					if stats:FullCombo() then
						--do nothing
					elseif stats:GetGrade()=="Grade_Failed" then
						--do nothing
					else
						(cmd(sleep,0.316;linear,0.266;diffusealpha,1;zoom,1))(self)
						self:queuecommand("Animate");
					end;
				--[[local pssp1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
					if pssp1:FullComboOfScore('TapNoteScore_W4') and
					not pssp1:FullComboOfScore('TapNoteScore_W3') and
					not pssp1:FullComboOfScore('TapNoteScore_W2') and
					not pssp1:FullComboOfScore('TapNoteScore_W1')then
						(cmd(sleep,0.316;linear,0.266;diffusealpha,1;zoom,1))(self);
					end;]]
				end;
				AnimateCommand=cmd(linear,.1;zoom,1.1;glow,color("1,1,1,.3");linear,.1;zoom,1.0;glow,color("1,1,1,0");sleep,.5;queuecommand,"Animate");
				OffCommand=cmd(linear,0.2;zoom,0);
			};
			LoadActor("GFC")..{
				InitCommand=cmd(player,pn;x,SCREEN_CENTER_X-355+140;y,SCREEN_CENTER_Y+180;zoom,0;diffusealpha,0);
				OnCommand=function(self)
				local staw = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetStageAward();
					if((staw =="StageAward_SingleDigitW3") or (staw =="StageAward_OneW3") or (staw =="StageAward_FullComboW3") ) then
						(cmd(sleep,0.316;linear,0.266;diffusealpha,1;zoom,0.675))(self);
					end;
				end;
				OffCommand=cmd(linear,0.2;zoom,0);
			};
			LoadActor("PFC")..{
				InitCommand=cmd(player,pn;x,SCREEN_CENTER_X-355+140;y,SCREEN_CENTER_Y+180;zoom,0;diffusealpha,0);
				OnCommand=function(self)
					local staw = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetStageAward();
					if((staw =="StageAward_SingleDigitW2") or (staw =="StageAward_OneW2") or (staw =="StageAward_FullComboW2") ) then
						(cmd(sleep,0.316;linear,0.266;diffusealpha,1;zoom,0.675))(self);
					end;
				end;
				OffCommand=cmd(linear,0.2;zoom,0);
			};
			LoadActor("MFC")..{
				InitCommand=cmd(player,pn;x,SCREEN_CENTER_X-355+140;y,SCREEN_CENTER_Y+180;zoom,0;diffusealpha,0);
				OnCommand=function(self)
					local staw = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetStageAward();
					if(staw =="StageAward_FullComboW1") then
						(cmd(sleep,0.316;linear,0.266;diffusealpha,1;zoom,0.675))(self);
					end;
				end;
				OffCommand=cmd(linear,0.2;zoom,0);

			};
		};
	};
	--2nd pane, Judgement image
	Def.ActorFrame{
		InitCommand=cmd(diffusealpha,0;addy,-15);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==controller then
				if paneState == 1 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
			
		LoadActor("judgment.png")..{
			InitCommand=cmd(zoom,0.675;addx,-1);
		};
		LoadActor("statsUnified", pn)..{
			InitCommand=cmd(xy,75,-325;zoom,1.2575;);
		};
	};
	--3rd pane, rankings
	LoadActor("scoresUnified", pn)..{
		InitCommand=cmd(diffusealpha,0;draworder,3;xy,-400,-500);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==controller then
				if paneState == 2 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};
	--4th pane, calories
	Def.Quad{
		InitCommand=cmd(setsize,FRAME_WIDTH,40;diffuse,Color("Black");y,-FRAME_HEIGHT/2;diffusealpha,0;vertalign,top;);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==controller then
				if paneState == 3 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};
	LoadActor("caloriesUnified", pn)..{
		InitCommand=cmd(addy,115;x,50;zoom,1.25;diffusealpha,0);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==controller then
				if paneState == 3 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};
	LoadActor("kcalP1", pn)..{
		InitCommand=cmd(diffusealpha,0;zoom,0.675);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==controller then
				if paneState == 3 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};
}

if showInstructionsTab then
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			if paneState == 4 then
				self:diffusealpha(1);
			else
				self:diffusealpha(0);
			end;
		end;
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==controller then
				if paneState == 4 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
		
		LoadFont("Common Normal")..{
			Text="Press left and right to switch between tabs for more detailed information.";
			InitCommand=cmd(DiffuseAndStroke,color(".3,.3,.3,1"),Color("White");wrapwidthpixels,FRAME_WIDTH-100);
		}
	}
end


return t;