--赤刀狐
function c11150.initial_effect(c)
--
	c:SetSPSummonOnce(11150)
	aux.AddLinkProcedure(c,c11150.MatFilter,1,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6e26))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11150.con2)
	e2:SetOperation(c11150.op2)
	c:RegisterEffect(e2)
--
end
--
function c11150.MatFilter(c)
	return c:IsLinkCode(11153)
end
--
function c11150.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(11151)
		and bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)~=0
end
function c11150.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local dc=Duel.GetOperatedGroup():GetFirst()
		dc:RegisterFlagEffect(11150,RESET_EVENT+RESETS_STANDARD,nil,1)
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2_1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2_1:SetLabelObject(dc)
		e2_1:SetCode(EVENT_CHAIN_END)
		e2_1:SetOperation(c11150.op2_1)
		Duel.RegisterEffect(e2_1,tp)
	end
end
function c11150.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local dc=e:GetLabelObject()
	if dc:GetFlagEffect(11150)<1 then return end
	Duel.SendtoDeck(dc,nil,2,REASON_EFFECT)
end
--
