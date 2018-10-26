local SSA, Auras, _, LSM = unpack(select(2,...))

-- Cache Global WoW API Functions
local CreateFrame = CreateFrame
local GetTotemInfo, GetTotemTimeLeft = GetTotemInfo, GetTotemTimeLeft

-- Cache Global Addon Variables
local BackdropCB = SSA.BackdropCB
local AuraBase = SSA.AuraBase

local CloudburstBar = CreateFrame('Frame','CloudburstBar',AuraBase)
CloudburstBar:SetFrameLevel(1)
CloudburstBar:SetWidth(150)
CloudburstBar:SetHeight(40)
CloudburstBar:SetPoint('CENTER',AuraBase,'CENTER',-200,0)
CloudburstBar:SetBackdrop(BackdropCB)
CloudburstBar:SetBackdropColor(1,1,1,1)
CloudburstBar:SetBackdropBorderColor(1,1,1,1)
CloudburstBar:SetAlpha(0)
CloudburstBar:Show()

CloudburstBar.text = CloudburstBar:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
CloudburstBar.text:SetPoint('RIGHT',CloudburstBar,'RIGHT',-5,-1)
--CloudburstBar.text:SetPoint('CENTER',0,0)
CloudburstBar.text:SetTextColor(0,1,0,1)
CloudburstBar.text:SetFont([[Fonts\FRIZQT__.TTF]],22,'OUTLINE')
CloudburstBar.text:SetJustifyH('LEFT')
CloudburstBar.text:SetText('0')
--[[CloudburstBar.inner = CreateFrame('Frame',nil,CloudburstBar)
CloudburstBar.inner:SetPoint('TOPLEFT',CloudburstBar,'TOPLEFT',8,-8)
CloudburstBar.inner:SetPoint('BOTTOMRIGHT',CloudburstBar,'BOTTOMRIGHT',-8,8)
CloudburstBar.inner:SetBackdrop(BackdropCBInner)
CloudburstBar.inner:SetBackdropColor(0.15,0.8,1,0)
CloudburstBar.inner:SetBackdropBorderColor(1,1,1,1)]]

CloudburstBar.icon = CreateFrame('Frame',nil,CloudburstBar)
CloudburstBar:SetFrameLevel(2)
CloudburstBar.icon:SetWidth(40)
CloudburstBar.icon:SetHeight(40)
CloudburstBar.icon:SetPoint('LEFT',CloudburstBar,'LEFT',0,0)
CloudburstBar.icon:SetBackdrop(BackdropCB)
CloudburstBar.icon:SetBackdropColor(1,1,1,0)
CloudburstBar.icon:SetBackdropBorderColor(1,1,1,1)

CloudburstBar.icon.texture = CloudburstBar.icon:CreateTexture(nil,'BACKGROUND')
CloudburstBar.icon.texture:SetTexture([[Interface\addons\ShamanAuras\Media\icons\totems\cloudburst_totem_bevel]])
CloudburstBar.icon.texture:SetAllPoints(CloudburstBar.icon)

CloudburstBar.icon.text = CloudburstBar.icon:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
CloudburstBar.icon.text:SetAllPoints(CloudburstBar.icon)
CloudburstBar.icon.text:SetPoint('CENTER',0,0)
CloudburstBar.icon.text:SetTextColor(1,1,0,1)
CloudburstBar.icon.text:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 20,'OUTLINE')

CloudburstBar.isLoaded = false
CloudburstBar.condition = function()
	local _,_,_,selected = GetTalentInfo(6,3,1)
	
	return selected
end

CloudburstBar:SetScript('OnUpdate',function(self,elapsed)
	if ((Auras:CharacterCheck(nil,3) and self.condition()) or Auras.db.char.settings.move.isMoving) then
		local db = Auras.db.char
		local isMoving = db.settings.move.isMoving
		local _,_,_,x,y = self:GetPoint()
		local _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,absorbed = Auras:RetrieveAuraInfo('player',Auras:GetSpellName(157153))
	
		if (not self.isLoaded or not isMoving) then
			if (x ~= db.miscellaneous[3][self:GetName()].layout.x or y ~= db.miscellaneous[3][self:GetName()].layout.y) then
				local cbLayout = db.miscellaneous[3][self:GetName()].layout
				self:SetPoint(cbLayout.point,SSA[cbLayout.relativeTo],cbLayout.relativePoint,cbLayout.x,cbLayout.y)
			end
			self.isLoaded = true
		end
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:ToggleFrameMove(self,isMoving)
		
		for i=1,5 do
			_,name = GetTotemInfo(i)
			if (name == 'Cloudburst Totem') then
				duration = GetTotemTimeLeft(i)
			end
		end

		if (not isMoving) then
			
			if (not self:GetBackdrop()) then
				self:SetBackdrop(BackdropCB)
			end
			
			if (absorbed and db.miscellaneous[3].CloudburstBar.isEnabled) then
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

CloudburstBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseDown(self,button)
	end
end)

CloudburstBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.miscellaneous[3][self:GetName()])
	end
end)

SSA.CloudburstBar = CloudburstBar
_G["SSA_CloudburstBar"] = CloudburstBar