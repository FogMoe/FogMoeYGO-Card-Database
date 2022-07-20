--守城油
local m=95714
local cm=_G["c"..m]
function c95714.initial_effect(c)
				--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
		--Equip limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_EQUIP_LIMIT)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetValue(cm.eqlimit)
	c:RegisterEffect(e9)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_BOTH_BATTLE_DAMAGE)
	e3:SetCondition(cm.indcon)
	c:RegisterEffect(e3)
	--no damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetCondition(cm.damcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--damage double
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetCondition(cm.damcon2)
	e5:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e5)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	e7:SetValue(cm.defval)
	c:RegisterEffect(e7)
end
function cm.indcon(e)
	return e:GetHandler():GetEquipTarget():IsDefensePos()
end
function cm.atkval(e,c)
	if c:IsDefensePos() then return 0 else return -(c:GetBaseAttack()/2) end
end
function cm.defval(e,c)
	if c:IsAttackPos() then return 0 else return c:GetAttack()/2 end
end
function cm.damcon2(e)
	return e:GetHandler():GetEquipTarget():GetBattleTarget()~=nil
end
function cm.damcon(e)
	return e:GetHandler():GetEquipTarget():GetControler()==e:GetHandlerPlayer() and e:GetHandler():GetEquipTarget():IsDefensePos()
end
function cm.eqlimit(e,c)
	return c:IsSetCard(0x9905)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9905)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end