local iPN = ...;
assert(iPN,"[Graphics/ShockArrowDisplay Icon.lua] No PlayerNumber Provided.");

local function GetRadarData( pnPlayer, rcRadarCategory )
	local tRadarValues;
	local StepsOrTrail;
	local fDesiredValue = 0;
	if GAMESTATE:GetCurrentSteps( pnPlayer ) then
		StepsOrTrail = GAMESTATE:GetCurrentSteps( pnPlayer );
		fDesiredValue = StepsOrTrail:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory );
	elseif GAMESTATE:GetCurrentTrail( pnPlayer ) then
		StepsOrTrail = GAMESTATE:GetCurrentTrail( pnPlayer );
		fDesiredValue = StepsOrTrail:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory );
	else
		StepsOrTrail = nil;
	end;
	return fDesiredValue;
end;


local function CreatPanelDisplayShockArrowIcon(_pnPlayer, _sLabel, _rcRadarCategory )
	--Returning LoadActor instead of an ActorFrame causes a weird bug... so don't do it.
	return Def.ActorFrame {
		LoadActor( "_ShockArrow" )..{
			InitCommand=cmd(zoom,0);
			OnCommand=cmd(playcommand,"Set");
			--CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			["CurrentSteps"..ToEnumShortString(_pnPlayer).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end,
			["CurrentTrail"..ToEnumShortString(_pnPlayer).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end,
			--CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local course = GAMESTATE:GetCurrentCourse()
				local selection = GAMESTATE:GetCurrentSteps(_pnPlayer);
				if GAMESTATE:IsCourseMode() then
						self:stoptweening();
						self:decelerate(0.2);
						self:zoom(0);
				else
					if selection then
						if GetRadarData( _pnPlayer, _rcRadarCategory) ==0 or not song and not course then
							self:stoptweening();
							self:decelerate(0.2);
							self:zoom(0);
						else
							self:stoptweening();
							self:decelerate(0.2);
							
							self:zoom(1);
						end;
					end;
				end;
			end;	
			OffCommand=cmd(decelerate,0.05;diffusealpha,0;);
		};
	};
end;



--[[ Numbers ]]
return CreatPanelDisplayShockArrowIcon(iPN, "Mines", 'RadarCategory_Mines');
