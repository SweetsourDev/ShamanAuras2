local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local CounterstrikeTotem = SSA.CounterstrikeTotem

-- Initialize Data Variables
CounterstrikeTotem.spellID = 204331
CounterstrikeTotem.condition = function()
	return (SSA.spec == 1 and 3490) or (SSA.spec == 2 and 3489) or (SSA.spec == 3 and 708)
end

CounterstrikeTotem:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3490") or Auras:CharacterCheck(self,2,"3489") or Auras:CharacterCheck(self,3,"708")) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)