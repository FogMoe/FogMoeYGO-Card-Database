--棘魔灵 白羊
local cm,m,o=GetID()
fu_Mugettsu = fu_Mugettsu or {}

function fu_Mugettsu.graveSP(c,code)
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(m,0))
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e:SetProperty(EFFECT_FLAG_DELAY)
	e:SetRange(LOCATION_GRAVE)
	e:SetCode(EVENT_REMOVE)
	e:SetCountLimit(1,code)
	e:SetCondition(fu_Mugettsu.graveSP_con)
	e:SetTarget(fu_Mugettsu.graveSP_tg)
	e:SetOperation(fu_Mugettsu.graveSP_op)
	c:RegisterEffect(e)
	local cm=_G["c"..code]
	if not cm.global_check then
		cm.global_check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD)
		ge:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge:SetTarget(aux.TargetBoolFunction(Card.IsCode,code))
		ge:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge,0)
	end
	return e
end
--fu_Mugettsu.graveSP
function fu_Mugettsu.graveSP_con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x6fd5)
end
function fu_Mugettsu.graveSP_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function fu_Mugettsu.graveSP_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
--
if not cm then return end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.cos1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=fu_Mugettsu.graveSP(c,m)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end