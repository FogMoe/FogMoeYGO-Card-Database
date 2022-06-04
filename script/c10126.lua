function c10126.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c10126.matfilter,1,1)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7f7))
	c:RegisterEffect(e1)
    	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10126,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10126)
	e2:SetTarget(c10126.thtg)
	e2:SetOperation(c10126.thop)
	c:RegisterEffect(e2)
    end
function c10126.matfilter(c)
	return c:IsLinkType(TYPE_NORMAL) and c:IsSetCard(0x7f7) 
end
function c10126.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c10126.filter(c)
	return c:IsSetCard(0x7f7) and c:IsType(TYPE_MONSTER) and not c:IsCode(10126) and c:IsAbleToHand()
end
function c10126.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10126.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10126.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10126.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10126.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end