
local userId = KEYS[1]
local buyNum = tonumber(KEYS[2])

local skuId = KEYS[3]
local perSkuLim = tonumber(KEYS[4])

local orderTime = KEYS[5]

--用到的各个hash
local user_sku_hash = 'sec_u_sku_hash'
local user_act_hash = 'sec_u_act_hash'
local sku_amount_hash = 'sec_sku_amount_hash'
local second_log_hash = 'sec_log_hash'

--当前sku是否还有库存
local skuAmountStr = redis.call('hget',sku_amount_hash,skuId)
if skuAmountStr == false then
        redis.log(redis.LOG_NOTICE,'skuAmountStr is nil ')
        return '-3'
end;
local skuAmount = tonumber(skuAmountStr)
 redis.log(redis.LOG_NOTICE,'sku:'..skuId..';skuAmount:'..skuAmount)
 if skuAmount <= 0 then
   return '0'
end

local goodsUserKey = userId..'_'..skuId
redis.log(redis.LOG_NOTICE,'perSkuLim:'..perSkuLim)
--当前用户已购买此sku多少件
if perSkuLim > 0 then
   local goodsUserNum = redis.call('hget',user_sku_hash,goodsUserKey)
   local goodsUserNumint = 0
   if goodsUserNum == false then
      redis.log(redis.LOG_NOTICE,'goodsUserNum is nil')
      goodsUserNumint = buyNum
   else
      redis.log(redis.LOG_NOTICE,'goodsUserNum:'..goodsUserNum..';perSkuLim:'..perSkuLim)
      local curSkuUserNumint = tonumber(goodsUserNum)
      goodsUserNumint =  curSkuUserNumint+buyNum
   end

   redis.log(redis.LOG_NOTICE,'------goodsUserNumint:'..goodsUserNumint..';perSkuLim:'..perSkuLim)
   if goodsUserNumint > perSkuLim then
       return '-1'
   end
end

--判断是否还有库存满足当前秒杀数量
if skuAmount >= buyNum then
     local decrNum = 0-buyNum
     redis.call('hincrby',sku_amount_hash,skuId,decrNum)
     redis.log(redis.LOG_NOTICE,'second success:'..skuId..'-'..buyNum)

     if perSkuLim > 0 then
         redis.call('hincrby',user_sku_hash,goodsUserKey,buyNum)
     end

     local orderKey = userId..'_'..skuId..'_'..buyNum..'_'..orderTime
     local orderStr = '1'
     redis.call('hset',second_log_hash,orderKey,orderStr)

   return orderKey
else
   return '0'
end