local t = Def.ActorFrame{
	LoadActor("mid")..{
		InitCommand=cmd(CenterX);
	};
	--[[LoadFont("Common Normal") .. {
		InitCommand=cmd(CenterX;addx,-100;addy,-10);
		--Text="asduahshdiaufhaifjaifujiasdjs";
		CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
		RefreshCommand=function(self)
			local vSong = GAMESTATE:GetCurrentSong();
			local vCourse = GAMESTATE:GetCurrentCourse();
			local sText = ""
			if vSong then
				sText = vSong:GetDisplayFullTitle() .. "\n" .. vSong:GetDisplayArtist()
			end
			if vCourse then
				sText = vSong:GetDisplayFullTitle() .. "\n" .. vSong:GetDisplayArtist()
			end
			self:settext( sText );
			self:horizalign(left);
			self:playcommand( "On" );
			self:strokecolor(color("#000000"));
			self:maxwidth(376);
		end;
	};]]
	Def.TextBanner{
		InitCommand = function(self) self:Load("TextBannerGameplay")
        	:x(SCREEN_CENTER_X-170):y(-14)
			if GAMESTATE:IsAnExtraStage() then
				self:zoomy(-1)
			end
        	if GAMESTATE:GetCurrentSong() then
        		self:SetFromSong(GAMESTATE:GetCurrentSong())
        	end
        end;
        CurrentSongChangedMessageCommand = function(self)
        	self:SetFromSong(GAMESTATE:GetCurrentSong())
        end;
	};
	
};

if GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
--P1 Score Frame
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(addy,-14);
	Def.Quad{
		InitCommand=cmd(halign,0;x,SCREEN_LEFT;setsize,388,32;diffuse,color("#666666"));
	};
	Def.Quad{
		InitCommand=cmd(halign,0;x,SCREEN_LEFT;setsize,382,28;diffuse,color("0,0,0,1"));
	};
};
end;

if GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(addy,-14);
	Def.Quad{
		InitCommand=cmd(halign,1;x,SCREEN_RIGHT;setsize,388,32;diffuse,color("#666666"));
	};
	Def.Quad{
		InitCommand=cmd(halign,1;x,SCREEN_RIGHT;setsize,382,28;diffuse,color("0,0,0,1"));
	};
};
end;

return t;
