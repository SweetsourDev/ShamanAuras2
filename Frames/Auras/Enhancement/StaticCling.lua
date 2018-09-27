local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID

-- Cache Global Addon Variables
local StaticCling = SSA.StaticCling

-- Initialize Data Variables
StaticCling.spellID = 211062
StaticCling.condition = function()
	return select(10,GetPvpTalentInfoByID(720))
end

StaticCling:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,"720")) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local debuff,_,_,_,duration,expires,caster = Auras:RetrieveAuraInfo("target", self.spellID,"HARMFUL PLAYER")

		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
		
		if (Auras:IsPlayerInCombat(true)) then
			if (debuff and caster) then
				self:SetAlpha(1)
				Auras:ToggleOverlayGlow(self.glow,true,false)
			else
				self:SetAlpha(0.5)
				Auras:ToggleOverlayGlow(self.glow,false)
			end
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)