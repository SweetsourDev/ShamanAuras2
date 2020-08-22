local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID

-- Cache Global Addon Variables
local StaticCling = SSA.StaticCling

-- Initialize Data Variables
StaticCling.spellID = 211062
StaticCling.pulseTime = 0
StaticCling.elapsed = 0
StaticCling.condition = function()
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(720)
	
	return selected and Auras:IsPvPZone()
end

StaticCling:SetScript('OnUpdate', function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if (Auras:CharacterCheck(self,2,"720")) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local buff = Auras:RetrieveAuraInfo("player", 211400,"HELPFUL PLAYER")
				
				Auras:GlowHandler(self,groupID)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				
				if (Auras:IsPlayerInCombat(true)) then
					if (buff) then
						self:SetAlpha(1)
					else
						self:SetAlpha(0.5)
					end
				else
					Auras:NoCombatDisplay(self,groupID)
				end
			else
				Auras:ToggleAuraVisibility(self,false,'showhide')
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

StaticCling:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
StaticCling:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED" or Auras.db.char.isFirstEverLoad or SSA.spec ~= 2) then
		return
	end

	local glow = Auras.db.char.auras[SSA.spec].auras[self:GetName()].glow
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID,_,_,_,count = CombatLogGetCurrentEventInfo()
	
	if ((((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") and srcGUID == UnitGUID("player")) or (subevent == "SPELL_AURA_REMOVED" and destGUID == UnitGUID("player")))and spellID == 211400) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID and trigger.type == "buff") then
					trigger.start = GetTime()
					--self.isTriggered = false
				end
			end
		elseif (subevent == "SPELL_AURA_REMOVED") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID and trigger.type == "buff") then
					trigger.start = 0
				end
			end
		end
	end
end)