local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local UnitPower = UnitPower

-- Cache Global Addon Variables
local LavaLash = SSA.LavaLash

LavaLash:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,60103)) then
		local spec,groupID = Auras:GetAuraInfo(self,'LavaLash')
		local db = Auras.db.char
		local start,duration = GetSpellCooldown(Auras:GetSpellName(60103))
		local buff = Auras:RetrieveBuffInfo('player',Auras:GetSpellName(201900))
		local _,_,count = Auras:RetrieveDebuffInfo('target',Auras:GetSpellName(240842))
		
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		
		Auras:SpellRangeCheck(self,60103,true,spec)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration)
		
		if (count and db.settings[spec].lavaLash.stacks.isEnabled) then
			self.Charges.text:SetText(count)
		else
			self.Charges.text:SetText('')
		end
		
		if ((buff or (count or 0) >= db.settings[spec].lavaLash.stacks.value) and db.settings[spec].lavaLash.glow) then
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
			Auras:NoCombatDisplay(self,spec,groupID)
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
