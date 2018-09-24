local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local Thundercharge = SSA.Thundercharge

Thundercharge:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,"725")) then
		local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(204366))
		
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
--/script local name = {AuraUtil.FindAuraByName("Resounding Protection","player")}; for k,v in pairs(name) do print(k.." = "..tostring(v)) end