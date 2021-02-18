local t = Def.ActorFrame {

	OnCommand=function(self)
		local player = GAMESTATE:GetMasterPlayerNumber()
		GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(player))
		if GAMESTATE:IsCourseMode() then
			GAMESTATE:UpdateDiscordScreenInfo("Selecting Course","",1)
		else
			if GAMESTATE:IsEventMode() then
				GAMESTATE:UpdateDiscordScreenInfo("Selecting Song (Event)","",1)
			else
				local StageIndex = GAMESTATE:GetCurrentStageIndex()
				GAMESTATE:UpdateDiscordScreenInfo("Selecting Song (Stage ".. StageIndex+1 .. ")","",1)
			end;
		end;
	end;

	LoadActor("ScorePanel");

	LoadActor("ChartInfo");

	LoadActor("DifficultyBar");

	LoadActor("SongPreview");

	LoadActor(THEME:GetPathG("","CornerArrows"));

	LoadActor(THEME:GetPathG("","ModDisplay"));

};

t[#t+1] = LoadActor(THEME:GetPathS("","OpenCommandWindow"))..{
	CodeMessageCommand=function(self, params)
		if params.Name == "OpenOpList" then
			opListPn = params.PlayerNumber;
			SCREENMAN:GetTopScreen():OpenOptionsList(opListPn);
			self:play();
		end;
	end;
};

t[#t+1] = LoadActor(THEME:GetPathS("","CloseCommandWindow"))..{
	OptionsListClosedMessageCommand=function(self)
		self:play();
	end;
};

t[#t+1] = LoadActor(THEME:GetPathS("","OpListScroll"))..{
	OptionsListRightMessageCommand=function(self)self:queuecommand("Refresh")end;
	OptionsListLeftMessageCommand=function(self)self:queuecommand("Refresh")end;
	OptionsListQuickChangeMessageCommand=function(self)self:queuecommand("Refresh")end;
	RefreshCommand=function(self)
		self:play();
	end;
};

t[#t+1] = LoadActor(THEME:GetPathS("","OpListChoose"))..{
	OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
	OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
	OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
	OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
	RefreshCommand=function(self)
		self:play();
	end;
};

for pn in ivalues(PlayerNumber) do
	t[#t+1] = LoadActor(THEME:GetPathG("","OpList")) ..{
		InitCommand=function(self,params)
			self:draworder(100)
			:diffusealpha(0)
			:zoom(0.5)
			:y(SCREEN_CENTER_Y);

			if pn then
				if pn == PLAYER_1 then
					self:x(SCREEN_LEFT-100);
				elseif pn == PLAYER_2 then
					self:x(SCREEN_RIGHT+100);
				end;
			end;
		end;

		OptionsListOpenedMessageCommand=function(self,params)
			if params.Player == pn then
				self:playcommand("slideOn");
			end;
		end;

		OptionsListClosedMessageCommand=function(self,params)
			if params.Player == pn then
				self:playcommand("slideOff");
			end;
		end;

		slideOnCommand=function(self)
			self:diffusealpha(1):decelerate(0.25);
			if pn then
				if pn == PLAYER_1 then
					self:x(SCREEN_LEFT+100);
				elseif pn == PLAYER_2 then
					self:x(SCREEN_RIGHT-100);
				end;
			end;
		end;

		slideOffCommand=function(self)
			self:diffusealpha(1):decelerate(0.25);
			if pn then
				if pn == PLAYER_1 then
					self:x(SCREEN_LEFT-100);
				elseif pn == PLAYER_2 then
					self:x(SCREEN_RIGHT+100);
				end;
			end;
		end;
	};
end;

t[#t+1] = LoadActor("GroupSelect");

-- Text and Stage Count
t[#t+1] = LoadFont("Montserrat Semibold 40px")..{
	InitCommand=function(self)
		if GetScreenAspectRatio() >= 1.5 then
			self:x(SCREEN_CENTER_X-250)
		else
			self:x(SCREEN_CENTER_X- 190)
		end;
		self:zoom(0.4)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:diffuse(0,0,0,1)
		:y(SCREEN_TOP-150)
		:settext("SELECT")
	end;
	OnCommand=function(self)
		self:decelerate(1)
		:y(SCREEN_TOP+20)
	end;
};

t[#t+1] = LoadFont("Montserrat normal 40px")..{
	InitCommand=function(self)
		if GetScreenAspectRatio() >= 1.5 then
			self:x(SCREEN_CENTER_X-192)
		else
			self:x(SCREEN_CENTER_X-132)
		end;
		self:zoom(0.4)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:diffuse(0,0,0,1)
		:y(SCREEN_TOP-150)
		:settext("MUSIC")
	end;
	OnCommand=function(self)
		self:decelerate(1)
		:y(SCREEN_TOP+20)
	end;
};

t[#t+1] = LoadFont("Montserrat normal 40px")..{
	InitCommand=function(self)
		local CurStage = string.format("%02d", GAMESTATE:GetCurrentStageIndex() + 1)
		if GetScreenAspectRatio() >= 1.5 then
			self:x(SCREEN_CENTER_X-164)
		else
			self:x(SCREEN_CENTER_X-132)
		end;
		self:zoom(0.35)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:horizalign(right)
		:diffuse(0,0,0,1)
		:y(SCREEN_TOP-125)
		:settext("STAGE "..CurStage)
	end;
	OnCommand=function(self)
		self:decelerate(1)
		:y(SCREEN_TOP+35)
	end;
};

return t;
