local SSA, Auras, _, LSM = unpack(select(2,...))

-- Cache Global WoW API Functions
local CreateFrame = CreateFrame
local GetTotemInfo, GetTotemTimeLeft = GetTotemInfo, GetTotemTimeLeft

-- Cache Global Addon Variables
local BackdropCB = SSA.BackdropCB
local AuraBase = SSA.AuraBase

local Cloudburst = CreateFrame('Frame','Cloudburst',AuraBase)
Cloudburst:SetFrameLevel(1)
--Cloudburst:SetWidth(150)
--Cloudburst:SetHeight(32)
Cloudburst:SetPoint('CENTER',AuraBase,'CENTER',-200,0)
Cloudburst:SetBackdrop(BackdropCB)
Cloudburst:SetBackdropColor(1,1,1,1)
Cloudburst:SetBackdropBorderColor(1,1,1,1)
Cloudburst:SetAlpha(0)
Cloudburst:Show()

Cloudburst.text = Cloudburst:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
Cloudburst.text:SetPoint('RIGHT',Cloudburst,'RIGHT',-5,-1)
--Cloudburst.text:SetPoint('CENTER',0,0)
Cloudburst.text:SetTextColor(0,1,0,1)
Cloudburst.text:SetFont([[Fonts\FRIZQT__.TTF]],22,'OUTLINE')
Cloudburst.text:SetJustifyH('LEFT')
Cloudburst.text:SetText('0')
--[[Cloudburst.inner = CreateFrame('Frame',nil,Cloudburst)
Cloudburst.inner:SetPoint('TOPLEFT',Cloudburst,'TOPLEFT',8,-8)
Cloudburst.inner:SetPoint('BOTTOMRIGHT',Cloudburst,'BOTTOMRIGHT',-8,8)
Cloudburst.inner:SetBackdrop(BackdropCBInner)
Cloudburst.inner:SetBackdropColor(0.15,0.8,1,0)
Cloudburst.inner:SetBackdropBorderColor(1,1,1,1)]]

Cloudburst.icon = CreateFrame('Frame',nil,Cloudburst)
Cloudburst:SetFrameLevel(2)
Cloudburst.icon:SetWidth(40)
Cloudburst.icon:SetHeight(40)
Cloudburst.icon:SetPoint('LEFT',Cloudburst,'LEFT',0,0)
Cloudburst.icon:SetBackdrop(BackdropCB)
Cloudburst.icon:SetBackdropColor(1,1,1,0)
Cloudburst.icon:SetBackdropBorderColor(1,1,1,1)

Cloudburst.icon.texture = Cloudburst.icon:CreateTexture(nil,'BACKGROUND')
Cloudburst.icon.texture:SetTexture([[Interface\addons\ShamanAuras\Media\icons\totems\cloudburst_totem_bevel]])
Cloudburst.icon.texture:SetAllPoints(Cloudburst.icon)

Cloudburst.icon.text = Cloudburst.icon:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
Cloudburst.icon.text:SetAllPoints(Cloudburst.icon)
Cloudburst.icon.text:SetPoint('CENTER',0,0)
Cloudburst.icon.text:SetTextColor(1,1,0,1)
Cloudburst.icon.text:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 20,'OUTLINE')

Cloudburst:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:CharacterCheck(3)) then
		local db = Auras.db.char
	
		local _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,absorbed = Auras:RetrieveBuffInfo('player',Auras:GetSpellName(157153))
	
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:ToggleFrameMove(self,db.elements.isMoving)
		
		if (not self:IsShown()) then
			self:Show()
		end
		
		for i=1,5 do
			_,name = GetTotemInfo(i)
			if (name == 'Cloudburst Totem') then
				duration = GetTotemTimeLeft(i)
			end
		end

		if (not db.elements.isMoving) then
			if (not self:GetBackdrop()) then
				self:SetBackdrop(BackdropCB)
			end
			
			if (absorbed and db.elements[3].frames.Cloudburst.isEnabled) then
				self.icon.text:SetText(duration)
				self:SetAlpha(1)
				self.text:SetText(absorbed)
			else
				self:SetAlpha(0)
				self.text:SetText('0')
				SSA.CloudburstTotemBar:Hide()
			end
		else
			self:SetAlpha(1)
		end
		
		
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)

Cloudburst:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseDown(self,'AuraBase',button)
	end
end)

Cloudburst:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[3].frames[self:GetName()])
	end
end)

SSA.Cloudburst = Cloudburst