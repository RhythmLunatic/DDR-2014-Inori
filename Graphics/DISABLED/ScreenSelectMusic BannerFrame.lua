local musicWheel;
return Def.ActorFrame{
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
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	};
	--[[Def.Banner {
		SetCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse();
			if course then
				self:LoadFromCourse(GAMESTATE:GetCurrentCourse());
				self:zoomtowidth(304);
				self:zoomtoheight(304);
			end;
		end;
	};]]
	

	--This is the one that shows group jackets
	Def.Banner {
		SetCommand=function(self,params)
			local song = GAMESTATE:GetCurrentSong();
			if song or GAMESTATE:IsCourseMode() or not musicWheel then 
				self:visible(false);
				return
			end;
			
			--[[local groupName = musicWheel:GetSelectedSection();
			if groupName ~= nil or groupName ~= "" then
				self:settext("Select from origin "..groupName.." category");
				ANNOUNCER_PlaySound("Song Category Names", groupName);
				--SOUND:PlayAnnouncer("Song Category Names/"..groupName); --Unfortunately, does not work.
			else
				self:settext("");
			end;]]
			if group==group_name[group] then
				self:diffusealpha(0)
			else
				local g = GetSongGroupJacketPath(group)
				if g then
					self:Load(g)
				else
					self:LoadFromSongGroup(group);
				end;
				self:zoomtowidth(304);
				self:zoomtoheight(304);
			end;
	  end;
	  CurrentSongChangedMessageCommand=function(self, params)
		self:playcommand("Set", params);
	  end;
  };
  --[[Def.Sprite {
	SetCommand=function(self,params)
		if not GAMESTATE:IsCourseMode() then
			local song = GAMESTATE:GetCurrentSong();
			if not song then
				local group = getenv("getgroupname");
				if group==group_name[group] then
					self:Load(THEME:GetPathG("","_jackets/group/big jacket/"..group_name[group]..".png"))
					self:diffusealpha(1)
				else
					self:diffusealpha(0)
				end;
			else
				self:diffusealpha(0);
				self:Load(THEME:GetPathG("","Common fallback jacket"));
				self:zoomtowidth(304);
				self:zoomtoheight(304);
			end;
		else
			self:diffusealpha(0);
		end;
	end;
	
	CurrentSongChangedMessageCommand=function(self, params)
		self:playcommand("Set", params);
	end;
  };]]
	--[[Def.Sprite {
    SetCommand=function(self,params)
    	local song = GAMESTATE:GetCurrentSong();
      if SCREENMAN:GetTopScreen():GetChild('MusicWheel'):GetSelectedType() == 'WheelItemDataType_Random' then
        self:Load(THEME:GetPathG("","_jackets/random.png"))
        self:diffusealpha(1)
				self:zoomtowidth(304);
				self:zoomtoheight(304);
			else
				self:diffusealpha(0)
      end;
    end;
    CurrentSongChangedMessageCommand=function(self, params)
      self:playcommand("Set", params);
    end;
  };]]--
}

