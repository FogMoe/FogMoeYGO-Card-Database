local m=82243
local cm=_G["c"..m]
cm.name="孑影之梦魇"
function cm.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--pierce  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e2)  
end
function cm.matfilter(c)  
	return c:IsLinkSetCard(0x3299) and not c:IsCode(m)
end  