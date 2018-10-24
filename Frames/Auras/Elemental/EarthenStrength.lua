local SSA, Auras = unpack(select(2,...))

-- Cache Global Lua Functions
local pairs = pairs
local twipe = table.wipe

-- Cache Global WoW Functions
local IsEquippedItem = IsEquippedItem

-- Cache Global Addon Variables
local EarthenStrength = SSA.EarthenStrength

-- Initialize Data Variables
EarthenStrength.spellID = 252141
EarthenStrength.pulseTime = 0
EarthenStrength.GetEleT21SetCount = function()
	local numSetPieces = 0
	local setPieces = {
		[152169] = true, -- Helm
		[152171] = true, -- Shoulders
		[152167] = true, -- Cloak
		[152166] = true, -- Chest
		[152168] = true, -- Hands
		[152170] = true, -- Legs
	}
	
	for setID in pairs(setPieces) do
		if (IsEquippedItem(setID)) then
			numSetPieces = numSetPieces + 1
		end
	end
	
	twipe(setPieces)
	
	return numSetPieces
end
EarthenStrength.condition = function()
	return EarthenStrength.GetEleT21SetCount() >= 2
end

EarthenStrength:SetScript('OnUpdate', function(self)
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingAura(self)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local buff,_,_,_,duration,expires = Auras:RetrieveAuraInfo("player", self.spellID)

		Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,self.spellID,"buff")
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
		
		if (Auras:IsPlayerInCombat(true)) then
			if (buff) then
				self:SetAlpha(1)
				--Auras:ToggleOverlayGlow(self.glow,true,false)
			else
				self:SetAlpha(0.5)
				--Auras:ToggleOverlayGlow(self.glow,false)
			end
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)