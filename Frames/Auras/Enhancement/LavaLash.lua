local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local Enum = Enum
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown
local UnitPower = UnitPower

-- Cache Global Addon Variables
local LavaLash = SSA.LavaLash

-- Intialize Data Variables
LavaLash.spellID = 60103
LavaLash.condition = function()
	return IsSpellKnown(60103)
end

LavaLash:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local db = Auras.db.char
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		local buff = Auras:RetrieveAuraInfo('player',201900)
		local _,_,count = Auras:RetrieveAuraInfo('target',240842,"HARMFUL PLAYER")
		
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration)
		
		if (count and db.settings[2].lavaLash.stacks.isEnabled) then
			self.Charges.text:SetText(count)
		else
			self.Charges.text:SetText('')
		end
		
		if ((buff or (count or 0) >= db.settings[2].lavaLash.stacks.value) and db.settings[2].lavaLash.glow) then
			Auras:ToggleOverlayGlow(self.glow,true)
		else
			Auras:ToggleOverlayGlow(self.glow,false)
		end
		
		if (Auras:IsPlayerInCombat()) then
			if (power >= 30 or buff) then
				self:SetAlpha(1)
			else
				self:SetAlpha(0.5)
			end
		else
			Auras:NoCombatDisplay(self,groupID)
		end
		--[[if (UnitAffectingCombat('player')) then
			if (power >= 30 or buff) then
				self:SetAlpha(1)
			else
				self:SetAlpha(0.5)
			end
		else
			if (Auras.db.char.elements[2].cooldowns.primary[1].isPreview) then
				self:SetAlpha(1)
			else
				self:SetAlpha(Auras.db.char.settings[2].OoCAlpha)
			end
		end]]
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)
