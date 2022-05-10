--机艺AF0301-01
local m = 20400
fu_hd = fu_hd or {}
function fu_hd.AttackTrigger(c,Give)
	--这张卡的攻击宣言时
	local code=c:GetOriginalCodeRule()
	aux.AddCodeList(c,m,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,code)
	e1:SetOperation(fu_hd.SpSummon(code,Give))
	c:RegisterEffect(e1)
	return e1
end
function fu_hd.BeAttackTrigger(c,Give)
	--这张卡成为攻击对象时
	local code=c:GetOriginalCodeRule()
	aux.AddCodeList(c,m,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,code)
	e1:SetOperation(fu_hd.SpSummon(code,Give))
	c:RegisterEffect(e1)
	return e1
end
function fu_hd.TargetTrigger(c,Give,loc)
	--以loc(默认Mzone)的这张卡为对象的卡的效果发动时(场上,魔陷,墓地,remove)
	local code=c:GetOriginalCodeRule()
	aux.AddCodeList(c,m,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	if loc then e1:SetRange(loc)
	else e1:SetRange(LOCATION_MZONE) end
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,code)
	e1:SetCondition(fu_hd.TargetTriggerCondtion)
	e1:SetOperation(fu_hd.SpSummon(code,Give))
	c:RegisterEffect(e1)
	return e1
end
function fu_hd.GiveEffect(c,pro,val,cod,con,tg,op,reset)
	--赋予效果模板
	local code=c:GetOriginalCodeRule()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty((pro or 0)+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(val)
	e1:SetCode(cod)
	e1:SetCondition(con)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(fu_hd.GiveTarget)
	e2:SetReset(RESET_PHASE+PHASE_END+(reset or 0))
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
function fu_hd.GiveTarget(e,c)
	return fu_hd.Infinity(c)
end
function fu_hd.Infinity(c)
	return c:IsCode(m) and c:IsFaceup()
end
function fu_hd.TargetTriggerCondtion(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(e:GetHandler()) then return false end
	return true
end
function fu_hd.SpFilter(c,e,tp,code)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.IsExistingMatchingCard(fu_hd.Infinity,tp,LOCATION_MZONE,0,1,nil) then
		return c:IsSetCard(0xfd4) and not c:IsCode(code)
	end
	return c:IsCode(m)
end
function fu_hd.SpSummon(code,Give)
		return function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler()
					if Duel.IsExistingMatchingCard(fu_hd.SpFilter,tp,LOCATION_DECK,0,1,nil,e,tp,code) and Duel.SelectYesNo(tp,aux.Stringid(code,0)) then
						if c:IsFacedown() then Duel.ConfirmCards(1-c:GetControler(),c) end
						Duel.Hint(HINT_CARD,0,code)
						if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) then
							local sc=Duel.SelectMatchingCard(tp,fu_hd.SpFilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
							Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
							if Give then Give(c) end
						end
					end
				end
end