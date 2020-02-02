local expanded = ...
local backingSprite
if expanded == true then
	backingSprite = THEME:GetPathG("","MusicWheelItem SectionCollapsed NormalPart/OpenBacking.png")
else
	backingSprite = THEME:GetPathG("","MusicWheelItem SectionCollapsed NormalPart/ClosedBacking.png")
end;

local so;
local song;
local group;

local t = Def.ActorFrame{
	OnCommand=function(self)
		--assert(false,"ASADADASDSADASDD");
		--SCREENMAN:SystemMessage("Asdadsasdadad");
		--self:playcommandonchildren("Update");
	end;
	SetMessageCommand=function(self,params)
		group = params.Text;
		song = params.Song;
		so = GAMESTATE:GetSortOrder();
		--Does not work
		--self:playcommandonchildren("Update");
		--[[for i,a in ipairs(self:GetChildren()) do
			--a:playcommand("Update");
			SCREENMAN:SystemMessage(a:GetName());
			--i:GetName
		end;]]
		--self:GetChildren()[1]:playcommand("Update");
		--SCREENMAN:SystemMessage(#self:GetChildren())
		
		--This is beyond stupid
		if group then
			if params.HasFocus then
				setenv("getgroupname",group);
			end;
			self:GetChild("Backing"):playcommand("Update");
			self:GetChild("SongBanner"):playcommand("Update");
			self:GetChild("Title"):playcommand("Update");
			self:GetChild("TitleLeftOutline"):playcommand("Update");
			self:GetChild("TitleLeft"):playcommand("Update");
		end;
	end;



	--group backing
	Def.Sprite {
		Name="Backing";
		UpdateCommand=function(self)
			--SCREENMAN:SystemMessage("asdasda");
			if group then
				--SCREENMAN:SystemMessage(group)
				if group_name[group] ~= nil then
					local filePath = THEME:GetPathG("","_jackets/group/"..group_name[group]..".png");
					self:Load(filePath)
					self:diffusealpha(1);
					self:y(-2)
				else
					self:Load(backingSprite);
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
		Condition=expanded;
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
		UpdateCommand=function(self)
			if group then
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
		Name="Title";
		InitCommand=cmd(addx,-5;addy,-80;zoom,.7);
		UpdateCommand=function(self)
			if group then
				if so == "SortOrder_Title" then
					self:diffusealpha(1);
					self:Load(THEME:GetPathG("group name","Alphabet"));
				elseif so == "SortOrder_AllDifficultyMeter" then
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
						self:diffusealpha(0);
					end;
				end;
			end;
		};
	LoadFont("_itc avant garde std bk 20px")..{
		Name="TitleLeftOutline";
		InitCommand=cmd(y,-84;addx,-4;maxwidth,150);
		UpdateCommand=function(self)
			if so == "SortOrder_Group" then
				if group_name[group] then
					self:settext("");
				else
					self:settext(string.gsub(group,"^%d%d? ?%- ?", ""));
					self:strokecolor(color("#000000"))
					self:diffuse(color("#000000"));
				end;
			elseif so == "SortOrder_TopGrades" then
				--self:settext(group);
				self:settext("");
			else
				self:settext("");
			end;
		end;
	};
	LoadFont("_itc avant garde std bk 20px")..{
		Name="TitleLeft";
		InitCommand=cmd(y,-86;addx,-4;maxwidth,150);
		UpdateCommand=function(self)
			if so == "SortOrder_Group" then
				
				if group_name[group] then
					self:settext("");
				else
					self:settext(string.gsub(group,"^%d%d? ?%- ?", ""));
					self:strokecolor(color("#000000"))
					self:diffuse(color("#FFFFFF"));
				end;
			else
				self:settext("");
			end;
		end;
	};
};
return t;
