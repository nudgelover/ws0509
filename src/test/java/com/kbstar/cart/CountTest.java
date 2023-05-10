package com.kbstar.cart;

import com.kbstar.Service.CartService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@Slf4j
@SpringBootTest
class CountTest {

    @Autowired
    CartService service;
    @Test
    void contextLoads() {
        try {
            service.count();
        } catch (Exception e) {
            log.info("select error-----------------------------");
            e.printStackTrace();
        }
        }
    }

