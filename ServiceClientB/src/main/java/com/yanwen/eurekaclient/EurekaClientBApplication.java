package com.yanwen.eurekaclient;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.netflix.hystrix.EnableHystrix;
import org.springframework.cloud.netflix.hystrix.dashboard.EnableHystrixDashboard;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@SpringBootApplication
@EnableEurekaClient
@ComponentScan(basePackages = {"com.yanwen"})
@Configuration
@EnableCircuitBreaker
@EnableHystrix
@EnableHystrixDashboard
public class EurekaClientBApplication {

    public static void main(String[] args) {
        SpringApplication.run(EurekaClientBApplication.class, args);
    }

}
