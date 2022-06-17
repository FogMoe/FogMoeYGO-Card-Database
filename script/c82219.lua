local m=82219
local cm=_G["c"..m]
cm.name="已经到极限了！我要按下去！"
function cm.initial_effect(c)
	aux.AddCodeList(c,82206)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1) 
end
function cm.cfilter(c)  
	return c:IsCode(82206) and c:IsFaceup()  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,3,e:GetHandler()) end  
	Debug.Message("已经到极限了！我要按下去！")
	Duel.DiscardHand(tp,Card.IsDiscardable,3,3,REASON_COST+REASON_DISCARD)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end  
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)  
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then  
		Duel.SetChainLimit(cm.chainlm)  
	end  
end  
function cm.chainlm(e,rp,tp)  
	return not e:GetHandler():IsType(TYPE_MONSTER)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)  
	Duel.Destroy(sg,REASON_EFFECT)  
end  