local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local Enum = Enum
local GetSpellCooldown = GetSpellCooldown
local IsPlayerKnown = IsPlayerKnown
local UnitPower = UnitPower

-- Cache Global Addon Variables
local Stormstrike = SSA.Stormstrike

-- Initialize Data Variables
Stormstrike.spellID = 17364
Stormstrike.pulseTime = 0
Stormstrike.elapsed = 0
Stormstrike.condition = function()
	return IsPlayerSpell(17364)
end

Stormstrike:SetScript('OnUpdate', function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			local buff,_,_,_,buffDuration,expires = Auras:RetrieveAuraInfo('player',201846) -- Stormbringer
			local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
			--local power = UnitPower('player',Enum.PowerType.Maelstrom)

			Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
			Auras:SetGlowStartTime(self,((expires or 0) - (buffDuration or 0)),buffDuration,201846,"buff")
			Auras:GlowHandler(self)
			Auras:SpellRangeCheck(self,self.spellID,true)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			Auras:CooldownHandler(self,groupID,start,duration,true)
			
			if (Auras:IsPlayerInCombat()) then
				--local powerCost = GetSpellPowerCost(self.spellID)
				self:SetAlpha(1)

				if ((duration or 0) > 2) then
					--Auras:ToggleOverlayGlow(self.glow,false)
					Auras:CooldownHandler(self,groupID,start,duration)
					
					--[[if (power >= powerCost[1].cost) then
						self:SetAlpha(1)
					else
						self:SetAlpha(0.5)
					end]]
				elseif (not buff) then
					--Auras:ToggleOverlayGlow(self.glow,false)
					self.CD:SetAlpha(1)
					self.CD.text:SetAlpha(1)
					
					--[[if (power >= powerCost[1].cost) then
						self:SetAlpha(1)
					else
						self:SetAlpha(0.5)
					end]]
				elseif (buff and Auras:IsPlayerInCombat(true)) then
					--Auras:ToggleOverlayGlow(self.glow,true)
					self.CD:SetAlpha(0)
					
					--if (power >= powerCost) then
						self:SetAlpha(1)
					--else
						--self:SetAlpha(0.5)
					--end
					
					self.CD:SetCooldown(0,0)
					self.CD.text:SetText('')
				end
			else
				Auras:NoCombatDisplay(self,groupID)
			end
		else
			Auras:ToggleAuraVisibility(self,false,'showhide')
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)