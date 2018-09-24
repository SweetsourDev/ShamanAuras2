local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpecialization = GetSpecialization
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local CapacitorTotem = SSA.CapacitorTotem

CapacitorTotem:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,192058)) then
		--[[local spec = GetSpecialization()
		local groupID = Auras.db.char.auras[spec].spells[self:GetName()].group]]
		local spec,groupID = Auras:GetAuraInfo(self,'CapacitorTotem')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(192058))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)