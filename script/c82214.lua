local m=82214
local cm=_G["c"..m]
cm.name="杀手皇后第二炸弹·枯萎穿心攻击"
function cm.initial_effect(c)
	aux.AddCodeList(c,82206)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCost(cm.cost)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)  
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)	
end
function cm.cfilter(c)  
	return c:IsCode(82206) and c:IsFaceup()  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("给我看这里…！")
end
function cm.desfilter(c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and cm.desfilter(chkc) and chkc:IsControler(1-tp) end  
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)   
	end  
end  