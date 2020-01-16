return Def.ActorFrame {
	Def.Sprite{
		--Not sure why but the sort graphics and the folder graphics are a bit misaligned, so this aligns them
		--InitCommand=cmd(y,2);

		InitCommand=cmd(setsize,174,210;y,-2);
		--params.Label is set from en.ini MusicWheel
		SetMessageCommand=function(self,params)
			if params.Label ~= "" then
				self:Load( THEME:GetPathG("","_jackets/sort/"..params.Label) );
				self:setsize(174,210)
			end;
		end;
	};
};
