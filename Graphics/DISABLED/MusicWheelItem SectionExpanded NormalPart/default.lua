local testvar;

local group;

local t = Def.ActorFrame{
	OnCommand=function(self)
		--testvar = self:GetParent():GetName()
		testvar = self:GetName();
		--testvar = "aaa";
	end;

	--group backing
	Def.Sprite {
		SetMessageCommand=function(self,params)
			group = params.Text;
			local so = GAMESTATE:GetSortOrder();
			if group then
				if group_name[group] then
					local filePath = THEME:GetPathG("","_jackets/group/"..group_name[group]..".png");
					self:Load(filePath)
					self:diffusealpha(1);
					self:y(-2)
				else
					self:Load(THEME:GetPathG("","MusicWheelItem SectionExpanded NormalPart/OpenBacking.png"));
					self:y(-2)
					self:diffusealpha(1):setsize(174,210)
					if so == "SortOrder_Title" then
						local so = GAMESTATE:GetSortOrder();
						self:diffuse(color("#fff582"));
						--self:Load(THEME:GetPathG("group name","Alphabet"));
					elseif so == "SortOrder_BeginnerMeter" or so == "SortOrder_EasyMeter" or so == "SortOrder_MediumMeter" or so == "SortOrder_HardMeter" or so == "SortOrder_ChallengeMeter" then
						self:diffusealpha(1);
						self:diffuse(color("#0167ae"));
					elseif so == "SortOrder_BPM" then
						self:diffusealpha(1);
						self:diffuse(color("#69ebca"));
					elseif so == "SortOrder_Popularity" then
						self:diffusealpha(1);
						self:Load(THEME:GetPathG("group name","Popularity"));
					elseif so == "SortOrder_TopGrades" then
						self:diffusealpha(1);
						self:diffuse(color("#7dff44"));
					else
						local color_grp= group_colors[group] or "#FFFFFF"
						self:diffuse(color(color_grp));
					end;
				end;
				
			end;
		end;
	};
	
	--Hide the group backing thing with "_extend" graphics
	Def.Sprite {
		SetMessageCommand=function(self,params)
			group = params.Text;
			if group then
				if group_name[group] then
					local filePath = THEME:GetPathG("","_jackets/group/_extend/"..group_extend[group_name[group]]..".png");
					self:Load(filePath)
					self:diffusealpha(1);
					self:y(-2)
					self:x(74);
				else
					self:diffusealpha(0);
				end;
				
			end;
		end;
	};

	--Shadow
	--[[Def.Quad{
		InitCommand=cmd(scaletoclipped,128,138;addx,-4;addy,4;diffusealpha,0;diffuse,color("0,0,0,1"));
		SetMessageCommand=function(self,params)
				group = params.Text;
		if group then
			if group_name[group] ~= nil then
				self:diffusealpha(0);
			else
				self:diffusealpha(1);
				self:fadebottom(0.75)
			end;
		else
			-- call fallback
			self:diffusealpha(0.5);
		end;

	end;
	};]]
	--Jacket (or other object to put in the center)
	Def.Banner {
		Name="SongBanner";
		InitCommand=cmd(scaletoclipped,128,128;addx,-4;addy,2;diffusealpha,0;);
		SetMessageCommand=function(self,params)
			local pt_text = params.Text;
			local group = params.Text;
			if group then
				if params.HasFocus then
					setenv("getgroupname",pt_text);
				end;
				local so = GAMESTATE:GetSortOrder();
				if so == "SortOrder_Title" then
					if group ~= "" then
						self:Load(THEME:GetPathG("group title",group));
						self:diffusealpha(1);
					end;
				elseif so == "SortOrder_BPM" then
					local n = tonumber(split("-",group)[1]);
					if n == nil then
						self:Load( THEME:GetPathG("group bpm","NA"));
					elseif n < 1000 then
						self:Load(THEME:GetPathG("group bpm",tostring(n)));
					elseif n == 1000 then
						self:Load(THEME:GetPathG("group bpm","a1000"));
					else
						self:Load( THEME:GetPathG("group bpm","NA"));
					end;
					self:diffusealpha(1);
				elseif so == "SortOrder_TopGrades" then
					if group == "???" then
						self:Load(THEME:GetPathG("group cleared rank","unplayed"));
					else
						local t = split("x",string.gsub(group,"%s+",""))[1]
						if t == "" then
							self:Load(THEME:GetPathG("group cleared rank","unplayed"));
						else
							self:Load(THEME:GetPathG("group grade",t..".png"));
						end;
					end;
					self:diffusealpha(1);
					
				elseif so == "SortOrder_BeginnerMeter" or so == "SortOrder_EasyMeter" or so == "SortOrder_MediumMeter" or so == "SortOrder_HardMeter" or so == "SortOrder_ChallengeMeter" then
					local n = tonumber(group)
					if n and n <= 20 then
						self:Load(THEME:GetPathG("group diff",group))
					else
						self:Load(THEME:GetPathG("group global","NA"));
					end;
					self:diffusealpha(1);
				else
					if group_name[group] ~= nil then
						self:Load( THEME:GetPathG("","_No banner") );
						self:diffusealpha(0);
					else
						local g = GetSongGroupJacketPath(group)
						if g then
							self:Load(g)
						else
							self:LoadFromSongGroup(group);
						end;
						self:diffusealpha(1);
					end;
				end;
			else
				-- call fallback
				self:Load( THEME:GetPathG("","_No banner") );
				self:diffusealpha(1);
			end;

		end;
	};
	--Titles
	Def.Sprite {
		InitCommand=cmd(addx,-5;addy,-40;zoom,.7);
		SetMessageCommand=function(self,params)
		group = params.Text;
		local so = GAMESTATE:GetSortOrder();
			if group then
			if so == "SortOrder_Title" then
				self:diffusealpha(1);
				self:Load(THEME:GetPathG("group name","Alphabet"));
			elseif so == "SortOrder_BeginnerMeter" or so == "SortOrder_EasyMeter" or so == "SortOrder_MediumMeter" or so == "SortOrder_HardMeter" or so == "SortOrder_ChallengeMeter" then
				self:diffusealpha(1);
				self:Load(THEME:GetPathG("group name","Dance Level"));
			elseif so == "SortOrder_BPM" then
				self:diffusealpha(1);
				self:Load(THEME:GetPathG("group name","BPM"));
			elseif so == "SortOrder_Popularity" then
				self:diffusealpha(1);
				self:Load(THEME:GetPathG("group name","Popularity"));
			elseif so == "SortOrder_TopGrades" then
				self:diffusealpha(1);
				self:Load(THEME:GetPathG("group name","Cleared Rank"));
			elseif so == "SortOrder_Genre" then
				self:diffusealpha(1);
				--genre sort
				if group == "Pop" then
				self:Load(THEME:GetPathG("group name genre","Pop"));
				elseif group == "Anime/Game" then
				self:Load(THEME:GetPathG("group name genre","AnimeGame"));
				elseif group == "Variety" then
				self:Load(THEME:GetPathG("group name genre","Variety"));
				elseif group == "GUMI 5th anniversary" then
				self:Load(THEME:GetPathG("group name genre","GUMI"));
				elseif group == "U.M.U. x BEMANI" then
				self:Load(THEME:GetPathG("group name genre","UMU"));
				elseif group == "KONAMI originals" then
				self:Load(THEME:GetPathG("group name genre","KONAMI"));
				--series sort
				elseif group == "beatmania IIDX" then
				self:Load(THEME:GetPathG("group name series","IIDX"));
				elseif group == "pop'n music" then
				self:Load(THEME:GetPathG("group name series","popn"));
				elseif group == "GITADORA" then
				self:Load(THEME:GetPathG("group name series","GITADORA"));
				elseif group == "jubeat" then
				self:Load(THEME:GetPathG("group name series","jubeat"));
				elseif group == "REFLEC BEAT" then
				self:Load(THEME:GetPathG("group name series","RB"));
				elseif group == "DanceEvolution" then
				self:Load(THEME:GetPathG("group name series","DanceEvolution"));
				elseif group == "SOUND VOLTEX" then
				self:Load(THEME:GetPathG("group name series","SDVX"));
				elseif group == "FutureTomTom" then
				self:Load(THEME:GetPathG("group name series","FutureTomTom"));
				elseif group == "DDR" then
				self:Load(THEME:GetPathG("group name","DDR"));
				else
					self:diffusealpha(0);
				end;
			elseif so == "SortOrder_Group" then
					--[[if group=='DanceDanceRevolution 1stMIX' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","1st"));
					elseif group=='DanceDanceRevolution 2ndMIX' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","2nd"));
					elseif group=='DanceDanceRevolution 3rdMIX' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","3rd"));
					elseif group=='DanceDanceRevolution 4thMIX' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","4th"));	
					elseif group=='DanceDanceRevolution 5thMIX' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","5th"));	
					elseif group=='DanceDanceRevolution 6thMIX MAX' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","MAX1"));	
					elseif group=='DanceDanceRevolution 7thMIX MAX2' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","MAX2"));	
					elseif group=='DanceDanceRevolution 8thMIX EXTREME' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","Extreme"));	
					elseif group=='DanceDanceRevolution SuperNOVA' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","SN1"));
					elseif group=='DanceDanceRevolution SuperNOVA2' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","SN2"));
					elseif group=='DanceDanceRevolution X' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","X1"));
					elseif group=='DanceDanceRevolution X2' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","X2"));
					elseif group=='DanceDanceRevolution X3' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","X3"));
					elseif group=='DDR 2013' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","2013"));
					elseif group=='DDR 2014' then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","DDR"));
					else
					self:diffusealpha(0);
					end;]]
					self:diffusealpha(0);
				end;
			end;
		end;
		};
	LoadFont("_itc avant garde std bk 20px")..{
		InitCommand=cmd(y,-84;addx,-4;maxwidth,150);
		SetMessageCommand=function(self, params)
			local song = params.Song;
			group = params.Text;
			local so = GAMESTATE:GetSortOrder();
			if group_name[group] ~= nil then
				self:settext("");
			else
				if so == "SortOrder_Group" then
					self:settext(string.gsub(params.Text,"^%d%d? ?%- ?", ""));
					self:strokecolor(color("#000000"))
					self:diffuse(color("#000000"));
				elseif so == "SortOrder_TopGrades" then
					--self:settext(group);
					self:settext("");
				else
					self:settext("");
				end;
			end;
		end;
	};
	LoadFont("_itc avant garde std bk 20px")..{
		InitCommand=cmd(y,-86;addx,-4;maxwidth,150);
		SetMessageCommand=function(self, params)
			local song = params.Song;
			group = params.Text;
			local so = GAMESTATE:GetSortOrder();
			if group_name[group] ~= nil then
				self:settext("");
			else
				if so == "SortOrder_Group" then
					--self:settext(string.gsub(params.Text,"^%d%d? ?%- ?", ""));
					self:settext(testvar);
					self:strokecolor(color("#000000"))
					self:diffuse(color("#FFFFFF"));
				else
					self:settext("");
				end;
			end;
		end;
	};
};
return t;
