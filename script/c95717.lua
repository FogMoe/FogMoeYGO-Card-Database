--守城使者
local m=95717
local cm=_G["c"..m]
function c95717.initial_effect(c)
	--spsummon proc
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,0))
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e9:SetRange(LOCATION_HAND)
	e9:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e9:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e9:SetCondition(cm.spcon)
	c:RegisterEffect(e9)
		--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.adchange)
	c:RegisterEffect(e2)
		--defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e3)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.poscon1)
	e4:SetOperation(cm.posop1)
	c:RegisterEffect(e4)
end
function cm.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9905) and c:IsFaceup()
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.poscon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function cm.posop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsAttackPos() then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function cm.adchange(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local batk=c:GetBaseAttack()
	local bdef=c:GetBaseDefense()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
	e2:SetValue(bdef)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
	e3:SetValue(batk)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)	
	e1:SetValue(c:GetDefense()/2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end