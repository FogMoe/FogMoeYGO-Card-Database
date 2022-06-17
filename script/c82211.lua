local m=82211
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,82206)  
	--Activate  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)  
	--disable attack  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.atkcon)  
	e2:SetOperation(cm.atkop)  
	c:RegisterEffect(e2)  
end
function cm.cfilter(c)  
	return c:IsCode(82206) and c:IsFaceup()  
end  
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetAttacker():IsControler(1-tp)  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateAttack()  
end  