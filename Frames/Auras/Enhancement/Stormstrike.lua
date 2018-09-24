local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local UnitPower = UnitPower

-- Cache Global Addon Variables
local Stormstrike = SSA.Stormstrike

Stormstrike:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,17364)) then
		local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local buff,_,_,_,_,expires = Auras:RetrieveBuffInfo('player',Auras:GetSpellName(201846))
		local start,duration = GetSpellCooldown(Auras:GetSpellName(17364))
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		
		Auras:SpellRangeCheck(self,17364,true,spec)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration,true)
		
		if (Auras:IsPlayerInCombat()) then
			if ((duration or 0) > 2) then
				Auras:ToggleOverlayGlow(self.glow,false)
				Auras:CooldownHandler(self,spec,groupID,start,duration)
				
				if (power >= 40) then
					self:SetAlpha(1)
				else
					self:SetAlpha(0.5)
				end
			elseif (not buff) then
				Auras:ToggleOverlayGlow(self.glow,false)
				self.CD:SetAlpha(1)
				self.CD.text:SetAlpha(1)
				
				if (power >= 40) then
					self:SetAlpha(1)
				else
					self:SetAlpha(0.5)
				end
			elseif (buff and Auras:IsPlayerInCombat(true)) then
				Auras:ToggleOverlayGlow(self.glow,true)
				self.CD:SetAlpha(0)
				
				if (power >= 20) then
					self:SetAlpha(1)
				else
					self:SetAlpha(0.5)
				end
				
				self.CD:SetCooldown(0,0)
				self.CD.text:SetText('')
			end
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)