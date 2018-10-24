local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetTalentInfo = GetTalentInfo
local GetTime = GetTime

-- Cache Global Addon Variables
local NaturesGuardian = SSA.NaturesGuardian

-- Initialize Data Variables
NaturesGuardian.spellID = 31616
NaturesGuardian.pulseTime = 0
NaturesGuardian.condition = function()
	local _,_,_,selected = GetTalentInfo(5,1,1)
	
	return selected
end

NaturesGuardian:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingAura(self)) then
		local spec = SSA.spec or GetSpecialization()
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local trigger = Auras.db.char.auras[spec].auras[self:GetName()].glow.triggers[1]
		
		if (GetTime() > (trigger.start + trigger.duration)) then
			trigger.start = 0
		end
		
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,trigger.start,((trigger.start > 0 and trigger.duration) or 0))
			
		if (Auras:IsPlayerInCombat()) then
			if (trigger.start > 0) then
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

NaturesGuardian:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
NaturesGuardian:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	local _,subevent,_,srcGUID,_,_,_,_,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if (subevent == "SPELL_HEAL" and srcGUID == UnitGUID("player") and spellID == self.spellID) then
		local spec = SSA.spec or GetSpecialization()
		local trigger = Auras.db.char.auras[spec].auras[self:GetName()].glow.triggers[1]

		trigger.start = GetTime()
	end
end)