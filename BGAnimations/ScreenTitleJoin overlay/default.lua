return Def.ActorFrame{
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y+200);
	OnCommand=function(self)
		if GAMESTATE:GetCoinMode() == 'CoinMode_Pay' then
			self:visible(false)
		else
			self:visible(true)
		end;
	end;
	CoinInsertedMessageCommand=function(self)
		if GAMESTATE:EnoughCreditsToJoin() then
			self:visible(true)
		end;
	end;
	
    LoadActor( "eam2.png" )..{
		

	};
	LoadActor( "eam2.png" )..{
		
		OnCommand=cmd(blend,'BlendMode_Add';diffusealpha,1;glowshift;effectperiod,0.6);

	};

}