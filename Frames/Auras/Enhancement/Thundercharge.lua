local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local Thundercharge = SSA.Thundercharge

-- Initialize Data Variables
Thundercharge.spellID = 204366
Thundercharge.condition = function()
	return select(10,GetPvpTalentInfoByID(725))
end

Thundercharge:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,"725")) then
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
--/script local name = {AuraUtil.FindAuraByName("Resounding Protection","player")}; for k,v in pairs(name) do print(k.." = "..tostring(v)) end