local m=82216
local cm=_G["c"..m]
cm.name="川尻浩作·阵亡形态"
function cm.initial_effect(c)
	aux.AddCodeList(c,82206)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),6,2)
	c:EnableReviveLimit()
	--name change  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e0:SetCode(EFFECT_CHANGE_CODE)  
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)  
	e0:SetValue(82206)  
	c:RegisterEffect(e0)
	--maintain  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCondition(cm.mtcon)  
	e1:SetOperation(cm.mtop)  
	c:RegisterEffect(e1)  
	--atklimit  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_CANNOT_ATTACK)  
	e2:SetCondition(cm.con)  
	c:RegisterEffect(e2) 
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==tp  
end  
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.SetLP(tp, Duel.GetLP(tp) - 2000)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then  
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
	else  
		Duel.Destroy(e:GetHandler(),REASON_COST)  
	end  
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
end