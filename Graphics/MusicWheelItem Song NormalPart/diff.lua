local pn = ...

local function setDiffBG(self,param)
  local st = GAMESTATE:GetCurrentStyle():GetStepsType()
  if self.ParamSong then
    local steps = GAMESTATE:GetCurrentSteps(pn)
    if steps then
      local sDiff = steps:GetDifficulty()
			 local diff = self.ParamSong:GetOneSteps( st, sDiff)
      local diffname = GAMESTATE:GetCurrentSteps(pn):GetDifficulty()
      if diff then
  			self:diffuse(CustomDifficultyToColor(diffname));
  		else
  			self:diffuse(color("1,1,1,0"))
  		end;
  	else
  		self:diffuse(color("1,1,1,0"))
  	end;
  end;
end;

local function setDiff(self,param)
	local st = GAMESTATE:GetCurrentStyle():GetStepsType()
	if self.ParamSong then
		local steps = GAMESTATE:GetCurrentSteps(pn)
		if steps then
			local sDiff = steps:GetDifficulty()
			local diff = self.ParamSong:GetOneSteps( st, sDiff)
			local diffname = GAMESTATE:GetCurrentSteps(pn):GetDifficulty()
			if diff then
				self:settext(diff:GetMeter());
			else
				self:settext("")
			end;
		else
			self:settext("")
		end;
	end;
end;



return Def.ActorFrame{
	--InitCommand=cmd(draworder,1);
	Def.Quad{
		Name = "Difficulty_Beginner";
  		InitCommand=cmd(setsize,24,24);
		SetCommand=function(self,param)
			self.ParamSong = param.Song
			setDiffBG(self)
		end;
		["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) setDiffBG(self) end;
		CurrentSongChangedMessageCommand=function(self) setDiffBG(self) end;
	};
	Def.BitmapText{
		InitCommand=cmd(diffuse,color("#FFFFFF");strokecolor,color("#000000");zoom,0.7;draworder,2);
		Font="Common Normal";
		SetCommand=function(self,param)
			self.ParamSong = param.Song
			setDiff(self)
		end;
		["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) setDiff(self) end;
		CurrentSongChangedMessageCommand=function(self) setDiff(self) end;
	};
};
