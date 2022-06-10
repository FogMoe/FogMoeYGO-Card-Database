--心灵构成
function c11165.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11165+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11165.tg1)
	e1:SetOperation(c11165.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c11165.con2)
	e2:SetTarget(c11165.tg2)
	e2:SetOperation(c11165.op2)
	c:RegisterEffect(e2)
--
end
--
function c11165.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,11165,0,0,0)
end
function c11165.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_UPDATE_ATTACK)
	e1_1:SetTargetRange(LOCATION_MZONE,0)
	e1_1:SetTarget(aux.TargetBoolFunction(Card.IsCode,11151))
	e1_1:SetValue(200)
	Duel.RegisterEffect(e1_1,tp)
	if Duel.GetFlagEffect(tp,11165)>2
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11153,0,TYPES_TOKEN_MONSTER,100,100,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP)
		and Duel.SelectYesNo(tp,aux.Stringid(11165,0)) then
		local token=Duel.CreateToken(tp,11153)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c11165.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c11165.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c11165.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<1 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
--
