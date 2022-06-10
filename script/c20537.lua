--星辉先锋
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)>1
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,e:GetHandler())
end