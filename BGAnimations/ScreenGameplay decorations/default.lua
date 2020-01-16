local t = Def.ActorFrame{};
t[#t+1] = StandardDecorationFromFileOptional("StageFrame","StageFrame");
t[#t+1] = StandardDecorationFromFile("LifeFrame","LifeFrame")


-- The thing at the bottom
t[#t+1] = StandardDecorationFromFile("ScoreFrame","ScoreFrame")


local xPosPlayer = {
    P1 = (THEME:GetMetric(Var "LoadingScreen","PlayerP1OnePlayerOneSideX")),
    P2 = (THEME:GetMetric(Var "LoadingScreen","PlayerP2OnePlayerOneSideX"))
}

--options--
if not getenv("OLDMIX") then
t[#t+1] = LoadActor( THEME:GetPathB("","optionicon_P1") ) .. {
		InitCommand=cmd(player,PLAYER_1;zoomx,2;zoomy,1.5;x,WideScale(SCREEN_CENTER_X-221,SCREEN_CENTER_X-296);draworder,1);
		OnCommand=function(self)
			if GAMESTATE:PlayerIsUsingModifier(PLAYER_1,'reverse') then
				self:y(SCREEN_CENTER_Y-276);
			else
				self:y(SCREEN_CENTER_Y+252);
			end;
		end;
	};
t[#t+1] = LoadActor( THEME:GetPathB("","optionicon_P2") ) .. {
	InitCommand=cmd(player,PLAYER_2;zoomx,2;zoomy,1.5;x,WideScale(SCREEN_CENTER_X+221,SCREEN_CENTER_X+296);draworder,1);
	OnCommand=function(self)
		if GAMESTATE:PlayerIsUsingModifier(PLAYER_2,'reverse') then
			self:y(SCREEN_CENTER_Y-276);
		else
			self:y(SCREEN_CENTER_Y+252);
		end;
	end;
};
t[#t+1] = LoadActor("Frame")..{
  InitCommand=cmd(player,PLAYER_1;halign,0;x,SCREEN_LEFT;draworder,100);
  OnCommand=function(self)
    if GAMESTATE:PlayerIsUsingModifier(PLAYER_1,'reverse') then
      self:y(SCREEN_CENTER_Y-301.5);
      self:rotationx(180);
    else
      self:y(SCREEN_CENTER_Y+275);
    end;
  end;
};

t[#t+1] = LoadActor("Frame")..{
  InitCommand=cmd(player,PLAYER_2;halign,0;x,SCREEN_RIGHT;zoomx,-1);
  OnCommand=function(self)
    if GAMESTATE:PlayerIsUsingModifier(PLAYER_2,'reverse') then
      self:y(SCREEN_CENTER_Y-301.5);
      self:rotationx(180);
    else
      self:y(SCREEN_CENTER_Y+275);
    end;
  end;
};
end;

return t
