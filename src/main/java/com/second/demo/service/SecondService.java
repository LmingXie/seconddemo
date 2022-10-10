package com.second.demo.service;

public interface SecondService {
    boolean skuAdd(String actId, String skuId, int amount);

    String skuSecond(String actId, String userId, int buyNum, String skuId, int perSkuLim, int perActLim);
}
