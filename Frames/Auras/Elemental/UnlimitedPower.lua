local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local UnlimitedPower = SSA.UnlimitedPower

-- Initialize Data Variables
UnlimitedPower.spellID = 260895
UnlimitedPower.pulseTime = 0
UnlimitedPower.charges = 0
UnlimitedPower.condition = function()
	return select(4,GetTalentInfo(7,1,1))
end

UnlimitedPower:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,7,1)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local buff,_,count,_,duration,expires,caster = Auras:RetrieveAuraInfo("player", 272737)
		
		self.charges = count or 0
		
		Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,272373,"buff")
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
		
		self.CD.text:SetText('')
		
		if ((count or 0) >= 1) then
			self.Charges.text:SetText(count)
		else
			self.Charges.text:SetText('')
		end
		
		if (Auras:IsPlayerInCombat()) then
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
end)

UnlimitedPower:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED" or Auras.db.char.isFirstEverLoad or SSA.spec ~= 1) then
		return
	end

	local glow = Auras.db.char.auras[SSA.spec].auras[self:GetName()].glow
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID,_,_,_,count = CombatLogGetCurrentEventInfo()
	
	if ((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_APPLIED_DOSE" or subevent == "SPELL_AURA_REMOVED") and srcGUID == UnitGUID("player") and spellID == 272737) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID and trigger.type ~= "charges") then
					trigger.start = GetTime()
				end
			end
		elseif (subevent == "SPELL_AURA_REMOVED") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID) then
					trigger.start = 0
				end
			end
		elseif (subevent == "SPELL_AURA_APPLIED_DOSE") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if (trigger.type == "charges") then
					if (count >= trigger.threshold and count > 0) then
						trigger.start = GetTime()
					else
						trigger.start = 0
					end
				end
			end
		end
	end
end)