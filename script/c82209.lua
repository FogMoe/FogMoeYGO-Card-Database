local m=82209
local cm=_G["c"..m]
cm.name="吉良宅"
function cm.initial_effect(c)
	aux.AddCodeList(c,82206)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)
	--Cannot Become Target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(cm.filter)  
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2)  
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCost(cm.cost)
	e4:SetCountLimit(1,m)   
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)
end
function cm.filter(e,c)  
	return (c:IsCode(82206) or aux.IsCodeListed(c,82206)) and c:IsFaceup()  
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
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(500)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Recover(p,d,REASON_EFFECT)  
end  