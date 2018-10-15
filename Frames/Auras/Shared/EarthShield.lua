local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
--local AuraUtil = AuraUtil

-- Cache Global Addon Variables
local EarthShield = SSA.EarthShield

-- Initialize Data Variables
EarthShield.spellID = 974
EarthShield.start = {
	[0] = 0,
	[974] = 0,
}
--[[EarthShield.buff = {
	start = 0,
	duration = 600,
}]]
EarthShield.pulseTime = 0
EarthShield.activePriority = 0
EarthShield.charges = 0
--EarthShield.triggerTime = 0
EarthShield.isTriggered = false
EarthShield.isGlowing = false
EarthShield.condition = function()
	local row,col = (SSA.spec == 1 and 3) or (SSA.spec == 2 and 3) or (SSA.spec == 3 and 2), (SSA.spec == 1 and 2) or (SSA.spec == 2 and 2) or (SSA.spec == 3 and 3)
	
	return select(4,GetTalentInfo(row,col,1))
end

EarthShield:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

EarthShield:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,self.spellID)) then
		--local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local buff,_,count,_,duration,expires = Auras:RetrieveAuraInfo("player",self.spellID,"HELPFUL")
		--local buff,_,count,_,duration,expires = AuraUtil.FindAuraByName(Auras:GetSpellName(self.spellID),"player")
		local tarBuff,_,tarCount,_,tarDuration,tarExpires,tarCaster = Auras:RetrieveAuraInfo("target",self.spellID,"HELPFUL PLAYER")
		--local tarBuff,_,tarCount,_,tarDuration,tarExpires,tarCaster = AuraUtil.FindAuraByName("target", Auras:GetSpellName(self.spellID))
		
		--[[if ((duration or 0) > 1.5) then
			self.buff.start = expires - duration
			--self.duration = duration
		elseif ((tarDuration or 0) > 1.5) then
			self.buff.start = tarExpires - tarDuration
			--self.duration = tarDuration
		end]]
		
		self.charges = ((count or 0) > 0 and count) or ((tarCount or 0) > 0 and tarCount) or 0
		
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		
		if (buff) then
			Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
		elseif (tarBuff and tarCaster == 'player') then
			Auras:CooldownHandler(self,groupID,((tarExpires or 0) - (tarDuration or 0)),tarDuration)
		end
		
		-- Hide the cooldown text
		self.CD.text:SetText('')
		
		if ((count or 0) >= 1 or (tarCount or 0) >= 1) then
			self.Charges.text:SetText(count or tarCount)
		else
			self.Charges.text:SetText('')
		end
		
		-- If no buff is found, reset the cooldown widget duration
		if (not buff and not tarBuff) then
			Auras:CooldownHandler(self,groupID,0,0)
		end
		
		if (Auras:IsPlayerInCombat()) then
			if (buff or tarBuff) then
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

EarthShield:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED" or Auras.db.char.isFirstEverLoad) then
		return
	end
	local spec = SSA.spec or GetSpecialization()
	
	local glow = Auras.db.char.auras[spec].auras[self:GetName()].glow
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID,_,_,_,count = CombatLogGetCurrentEventInfo()
	
	if ((((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_REMOVED_DOSE") and srcGUID == UnitGUID("player")) or (subevent == "SPELL_AURA_REMOVED" and destGUID == UnitGUID("player")))and spellID == self.spellID) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID and trigger.type ~= "charges") then
					trigger.start = GetTime()
					--self.isTriggered = false
				end
			end
		elseif (subevent == "SPELL_AURA_REMOVED") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID) then
					trigger.start = 0
				end
			end
		elseif (subevent == "SPELL_AURA_REMOVED_DOSE") then
			
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if (trigger.type == "charges") then
					if (count <= trigger.threshold and count > 0) then
						trigger.start = GetTime()
					else
						trigger.start = 0
						--self.isTriggered = false
					end
				end
			end
		end
	end
end)