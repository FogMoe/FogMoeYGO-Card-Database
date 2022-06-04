--水彩童话·林中小屋
function c11101.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11101,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c11101.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(0x10000000+11101)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
--
end
--
function c11101.ofilter1(c)
	return c:IsSetCard(0x3e16) and c:IsType(TYPE_MONSTER)
		and not c:IsPublic()
end
function c11101.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c11101.ofilter1,tp,LOCATION_HAND,0,nil)
	if mg:GetCount()<1 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(11101,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local dg=mg:Select(tp,1,mg:GetCount(),nil)
	for tc in aux.Next(dg) do
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_PUBLIC)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1)
	end
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetDescription(aux.Stringid(11101,2))
	e1_2:SetType(EFFECT_TYPE_FIELD)
	e1_2:SetCode(EFFECT_SPSUMMON_PROC)
	e1_2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1_2:SetRange(LOCATION_HAND)
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1_3:SetTargetRange(LOCATION_HAND,0)
	e1_3:SetLabelObject(e1_2)
	e1_3:SetTarget(c11101.tg1_3)
	e1_3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_3,tp)
end
function c11101.tfilter1_3(c,tc)
	return tc:IsCode(c:GetCode()) and c:IsPublic()
end
function c11101.tg1_3(e,c)
	return Duel.IsExistingMatchingCard(c11101.tfilter1_3,c:GetControler(),LOCATION_HAND,0,1,nil,c)
		and c:IsSetCard(0x3e16) and not c:IsPublic()
end
--
