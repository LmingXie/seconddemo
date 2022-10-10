package com.second.demo.service;

public interface SecondService {
    boolean skuAdd(String skuId, int amount);

    String skuSecond(String userId, int buyNum, String skuId, int perSkuLim);
}
