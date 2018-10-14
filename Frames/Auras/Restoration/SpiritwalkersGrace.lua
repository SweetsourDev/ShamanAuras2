local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local SpiritwalkersGrace = SSA.SpiritwalkersGrace

-- Initialize Data Variables
SpiritwalkersGrace.spellID = 79206
SpiritwalkersGrace.pulseTime = 0
SpiritwalkersGrace.condition = function()
	return IsSpellKnown(79206)
end

SpiritwalkersGrace:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		local _,_,_,_,buffDuration,buffExpire = Auras:RetrieveAuraInfo("player",self.spellID,"HELPFUL")
	
		Auras:SetAuraStartTime(self,start,duration,self.spellID,"cooldown")
		Auras:SetAuraStartTime(self,((buffExpire or 0) - (buffDuration or 0)),buffDuration,self.spellID,"buff")
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat(true)) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)