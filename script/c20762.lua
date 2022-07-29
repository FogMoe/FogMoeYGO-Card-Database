--共魂
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local nc=g:GetNext()
	if tc:IsRelateToEffect(e) and nc:IsRelateToEffect(e) then
		cm.reg(c,tc,nc)
		cm.reg(c,nc,tc)
	end
end
function cm.reg(c,tc,nc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(nc)
	e1:SetCondition(cm.con5)
	e1:SetOperation(cm.op5)
	tc:RegisterEffect(e1)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and eg:IsContains(tc)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end