--Note: DDR 2014 does not have a course mode, so course mode support was dropped
--Check the OLD file if you need it back

local sStage = GAMESTATE:GetCurrentStage();
local song = GAMESTATE:GetCurrentSong();

local function stageToNum(stage)
	return Stage:Reverse()[stage]+1;
end;

if stageToNum(sStage) == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
elseif not GAMESTATE:IsEventMode() and song:IsLong() and stageToNum(sStage)+1 == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
elseif not GAMESTATE:IsEventMode() and song:IsMarathon() and stageToNum(sStage)+2 == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
else
	sStage = sStage;
end;

return Def.ActorFrame{
	LoadActor("normal");
	
	LoadFont("_arial Bold 24px") .. {
		InitCommand=cmd(maxwidth,144;addy,1;zoomx,1.1;vertalign,top;shadowlength,1);
		OnCommand=function(self)
			local curStage = GAMESTATE:GetCurrentStage();
			local stageText;
			if GAMESTATE:IsEventMode() then
				stageText = "EVENT";
				--stageText = stageToNum("Stage_1st");
			else
				stageText = StageToLocalizedString(sStage);
				--stageColor = StageToColor(curStage);
			end;
			self:settext( stageText );

		end;
	};
};
