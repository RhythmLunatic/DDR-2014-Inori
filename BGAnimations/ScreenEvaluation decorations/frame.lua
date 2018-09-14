local pn = ...;
local FRAME_WIDTH, FRAME_HEIGHT = 467, 250;
local paneState = 0;
local paneColors = { color("#988B89"), color("#00A3DA"), color("#00DE14"), color("#F953ED") }

return Def.ActorFrame{
	--Input handler
	CodeMessageCommand=function(self,params)
		if params.PlayerNumber==pn then
			if params.Name=="Left" then
				if paneState > 0 then
					paneState = paneState - 1;
				end;
			elseif params.Name=="Right" then
				if paneState < 3 then
					paneState = paneState + 1;
				end;
			else
				SCREENMAN:SystemMessage("Unknown button: "..params.Name);
			end;
		end;
	end;
	--Background
	Def.Quad{
		Name="DefaultFrame";
		InitCommand=cmd(setsize,FRAME_WIDTH,FRAME_HEIGHT;diffuse,color("1.0,1.0,1.0,0.65"););
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
	};
	--Tabs
	LoadActor("tabs 1x4.png")..{
		InitCommand=cmd(vertalign,bottom;horizalign,left;xy,-FRAME_WIDTH/2,-FRAME_HEIGHT/2-5;animate,false;zoom,0.675;);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==pn then
				self:setstate(paneState);
			end;
		end;
	};
	--Pane border
	Def.ActorFrame{
		InitCommand=cmd(diffuse,paneColors[paneState+1]);
		CodeMessageCommand=function(self,params)
				if params.PlayerNumber==pn then
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
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==pn then
				if paneState == 0 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};
	--Full combo over the "clear!!" thingy
	Def.ActorFrame{
		OffCommand=cmd(sleep,0.2;linear,0.2;diffusealpha,0);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==pn then
				if paneState == 0 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
		--FCTextP1--
		LoadActor("NFC")..{
			InitCommand=cmd(player,pn;x,SCREEN_CENTER_X-355+140;y,SCREEN_CENTER_Y+180;zoom,0;diffusealpha,0);
			OnCommand=function(self)
			local pssp1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
				if pssp1:FullComboOfScore('TapNoteScore_W4') and
				not pssp1:FullComboOfScore('TapNoteScore_W3') and
				not pssp1:FullComboOfScore('TapNoteScore_W2') and
				not pssp1:FullComboOfScore('TapNoteScore_W1')then
					(cmd(sleep,0.316;linear,0.266;diffusealpha,1;zoom,1))(self);
				end;
			end;
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
	--2nd pane, Judgement image
	LoadActor("judgment.png")..{
		InitCommand=cmd(diffusealpha,0;zoom,0.675);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==pn then
				if paneState == 1 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
		};
	LoadActor("statsUnified", pn)..{
		InitCommand=cmd(xy,200,-325;zoom,1.2575;diffusealpha,0);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==pn then
				if params.PlayerNumber==pn then
					if paneState == 1 then
						self:diffusealpha(1);
					else
						self:diffusealpha(0);
					end;
				end;
			end;
		end;
	};
	--3rd pane, rankings
	LoadActor("scoresUnified", pn)..{
		InitCommand=cmd(diffusealpha,0;draworder,3;xy,-400,-500);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==pn then
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
			if params.PlayerNumber==pn then
				if paneState == 3 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};
	LoadActor("caloriesP1")..{
		InitCommand=cmd(addy,115;x,50;zoom,1.25;diffusealpha,0);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==pn then
				if paneState == 3 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};
	LoadActor("kcalP1")..{
		InitCommand=cmd(diffusealpha,0;zoom,0.675);
		OffCommand=cmd(sleep,0.2;linear,0.2;addx,-700);
		CodeMessageCommand=function(self,params)
			if params.PlayerNumber==pn then
				if paneState == 3 then
					self:diffusealpha(1);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};
}