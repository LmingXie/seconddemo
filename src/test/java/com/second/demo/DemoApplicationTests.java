package com.second.demo;

import com.second.demo.controller.SecondController;
import com.second.demo.util.ServerResponseUtil;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@SpringBootTest
class DemoApplicationTests {
    @Autowired
    private SecondController secondController;

    @Test
    void contextLoads() throws InterruptedException {
        String skuId = "1";
        int amount = 40;
        ServerResponseUtil serverResponseUtil = secondController.skuAdd(skuId, amount);
        System.out.println(serverResponseUtil.getMsg());

        ExecutorService executorService = Executors.newFixedThreadPool(20);
        for (int i = 0; i < 200; i++) {
            executorService.execute(() -> {
                // 取余SKU，模拟多次购买
                int userid = (int) (Math.random() * 1000 % amount);
                ServerResponseUtil responseUtil = secondController.skuSecond(String.valueOf(userid), 1, "1", 2);
                System.out.println(responseUtil.getMsg());
            });
        }
        Thread.sleep(1000 * 60);
    }

}
