--机械世界
local m=6017
local cm=_G["c"..m]
function c6017.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_MACHINE)
	c:RegisterEffect(e2)
	--boost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--halve damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetCondition(cm.condition2)
	e5:SetValue(cm.val)
	c:RegisterEffect(e5)
	--token
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTarget(cm.sptg)
	e6:SetCondition(cm.spcon)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function cm.condition2(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.val(e,re,dam,r,rp,rc)
	return math.floor(dam/2)
end

function cm.sfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.sfilter,1,nil)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetTurnPlayer()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,6018,0,TYPES_TOKEN_MONSTER,500,500,2,RACE_MACHINE,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK,p) then return end
	local token=Duel.CreateToken(tp,6018)
	if Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(cm.fuslimit)
		token:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e4,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e6,true)
		token:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(cm.descon)
		e1:SetOperation(cm.desop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		e1:SetCountLimit(1)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(token)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SpecialSummonComplete()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(m)~=0
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end

function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end