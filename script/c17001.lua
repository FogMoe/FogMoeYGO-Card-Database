--粲星魔术
local m=66917001
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,66917000)
	--fusion
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
	--synchro effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(cm.sctg)
	e4:SetOperation(cm.scop)
	c:RegisterEffect(e4)
end
function cm.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.spfilter1(c,e)
    return not c:IsImmuneToEffect(e)
end
function cm.spfilter2(c,e,tp,m,f,chkf)
    if not (c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,66917000) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
    aux.FCheckAdditional=c.starlight_fusion_check or c66917001.fcheck
    local res=c:CheckFusionMaterial(m,nil,chkf)
    aux.FCheckAdditional=nil
    return res
end
function cm.fcheck(tp,sg,fc)
    return sg:IsExists(Card.IsFusionCode,1,nil,66917000)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
         and Duel.IsPlayerCanSpecialSummonMonster(tp,66917008,0,0x4011,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT,POS_FACEUP) and Duel.IsExistingTarget(cm.thfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,cm.thfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,66917008,0,0x4011,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
    local token=Duel.CreateToken(tp,66917008)
    if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e1:SetValue(tc:GetAttribute())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        token:RegisterEffect(e1)
        local f=function(ee)
            Duel.SendtoGrave(ee:GetHandler(),REASON_RULE)
        end
        local e2=Effect.CreateEffect(token)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CANNOT_INACTIVATE|EFFECT_FLAG_CANNOT_NEGATE|EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL|EFFECT_FLAG_UNCOPYABLE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EVENT_CHAIN_END)
        e2:SetOperation(f)
        token:RegisterEffect(e2)
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(c66917001.spfilter1,nil,e)
        local res=Duel.IsExistingMatchingCard(c66917001.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c66917001.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
            end
        end
        if res and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
            local sg1=Duel.GetMatchingGroup(c66917001.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
            local mg3=nil
            local sg2=nil
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                sg2=Duel.GetMatchingGroup(c66917001.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
            end
            if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
                local sg=sg1:Clone()
                if sg2 then sg:Merge(sg2) end
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local tg=sg:Select(tp,1,1,nil)
                local tc=tg:GetFirst()
                aux.FCheckAdditional=tc.starlight_fusion_check or c66917001.fcheck
                if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
                    local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
                    tc:SetMaterial(mat1)
                    Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
                    Duel.BreakEffect()
                    Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
                else
                    local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
                    local fop=ce:GetOperation()
                    fop(ce,e,tp,tc,mat2)
                end
                tc:CompleteProcedure()
                aux.FCheckAdditional=nil
            end
        end
    end
end
function cm.mfilter(c)
	return c:IsCode(66917000) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_TUNER) 
end
function cm.mfilter2(c)
	return not c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER)
end
function cm.cfilter(c,syn)
	return syn:IsSynchroSummonable(c)
end
function cm.spfilter(c,mg)
	return mg:IsExists(cm.cfilter,1,nil,c)
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		 and Duel.IsPlayerCanSpecialSummonMonster(tp,66917008,0,0x4011,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT,POS_FACEUP) and Duel.IsExistingTarget(cm.thfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.thfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,66917008,0,0x4011,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,66917008)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local f=function(ee)
			Duel.SendtoGrave(ee:GetHandler(),REASON_RULE)
		end
		local e2=Effect.CreateEffect(token)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CANNOT_INACTIVATE|EFFECT_FLAG_CANNOT_NEGATE|EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL|EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_CHAIN_END)
		e2:SetOperation(f)
		token:RegisterEffect(e2)
		local mg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,66917000)
		if #mg==0 then return end
		local extraSet=Group.CreateGroup()
		local matTable={}
		local i=mg:GetFirst()
		repeat
			local temp=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,i)
			if #temp>0 then
				local j=temp:GetFirst()
				repeat
					if not extraSet:IsContains(j) then
						extraSet:AddCard(j)
						matTable[j]=Group.CreateGroup()
					end
					matTable[j]:AddCard(i)
					j=temp:GetNext()
				until not j
			end
			i=mg:GetNext()
		until not i
		if #extraSet==0 then 
			return
		end
		Duel.BreakEffect()
		local tg=nil
		if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=extraSet:Select(tp,1,1,nil):GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			tg=matTable[tc]:Select(tp,1,1,nil):GetFirst()
			Duel.SynchroSummon(tp,tc,tg)
		end
	end
end