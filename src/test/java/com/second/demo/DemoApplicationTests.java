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
        ExecutorService executorService = Executors.newFixedThreadPool(20);
        for (int i = 2; i < 112; i++) {
            String userId = String.valueOf(i + 1);
            executorService.execute(() -> {
                ServerResponseUtil responseUtil = secondController.skuSecond("1", userId, 1, "3", 2, 2);
                System.out.println(responseUtil.getMsg());
            });
        }

        Thread.sleep(1000 * 60);
    }

}
