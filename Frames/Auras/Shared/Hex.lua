local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown
local UnitCreatureType = UnitCreatureType

-- Cache Global Addon Variables
local Hex = SSA.Hex

-- Initialize Data Variables
Hex.spellID = 51514
Hex.pulseTime = 0
Hex.condition = function()
	return IsSpellKnown(51514)
end

Hex:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingAura(self)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
		Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration)
		
		Auras:SpellRangeCheck(self,self.spellID,(UnitCreatureType('target') == 'Humanoid' or UnitCreatureType('target') == 'Beast' or UnitCreatureType('target') == 'Critter'))	
		
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)

local hexIDs = {
	[51514] = true,  -- Frog
	[210873] = true, -- Compy
	[211004] = true, -- Spider
	[211010] = true, -- Snake
	[211015] = true, -- Cockroach
	[269352] = true, -- Skeletal Hatchling
	[277778] = true, -- Zandalari Tendonripper (Horde Only)
	[277784] = true, -- Wicker Mongrel (Alliance only)
}

Hex:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
Hex:SetScript('OnEvent',function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED" or Auras.db.char.isFirstEverLoad) then
		return
	end
	
	local spec = GetSpecialization()
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	local glow = Auras.db.char.auras[spec].auras[self:GetName()].glow
	
	if ((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_REMOVED") and srcGUID == UnitGUID("player") and hexIDs[spellID]) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if (trigger.type == "debuff") then
					local _,_,_,_,duration = Auras:RetrieveAuraInfo("target",spellID,"HARMFUL")
					
					trigger.start = GetTime()
					trigger.duration = duration
				end
			end
		elseif (subevent == "SPELL_AURA_REMOVED") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if (trigger.type == "debuff") then
					trigger.start = 0
				end
			end
		end
	end
end)