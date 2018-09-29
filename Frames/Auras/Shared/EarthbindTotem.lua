local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local EarthbindTotem = SSA.EarthbindTotem

-- Initialize Data Variables
EarthbindTotem.spellID = 2484
EarthbindTotem.isGlowing = false
EarthbindTotem.start = 0
EarthbindTotem.duration = 0
EarthbindTotem.triggerTime = 0
EarthbindTotem.condition = function()
	return IsSpellKnown(2484)
end

EarthbindTotem:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		local aura = Auras.db.char.auras[SSA.spec].auras[self:GetName()]
		
		if (duration > 1.5) then
			self.start = start
			self.duration = duration
		end
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration)
		Auras:GlowHandler(self)
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)