local m=82217
local cm=_G["c"..m]
cm.name="川尻忍"
function cm.initial_effect(c)
	--lvup  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetCost(cm.cost)  
	e2:SetOperation(cm.operation)  
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local p=tc:GetControler()
	if Duel.Remove(tc,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e1:SetCode(EVENT_PHASE+PHASE_END)  
		e1:SetReset(RESET_PHASE+PHASE_END)  
		e1:SetLabel(p)
		e1:SetLabelObject(tc)  
		e1:SetCountLimit(1)  
		e1:SetOperation(cm.retop)  
		Duel.RegisterEffect(e1,tp)
	end
end  
function cm.retop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.SendtoHand(e:GetLabelObject(),e:GetLabel(),nil)
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsFaceup() and c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_LEVEL)  
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)  
		e1:SetValue(2)  
		e1:SetReset(RESET_EVENT+0x1ff0000)  
		c:RegisterEffect(e1)  
	end  
end  