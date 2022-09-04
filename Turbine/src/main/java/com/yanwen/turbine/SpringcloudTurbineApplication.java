package com.yanwen.turbine;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.netflix.hystrix.dashboard.EnableHystrixDashboard;
import org.springframework.cloud.netflix.turbine.EnableTurbine;

@SpringBootApplication
@EnableTurbine
@EnableHystrixDashboard
@EnableEurekaClient
public class SpringcloudTurbineApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringcloudTurbineApplication.class, args);
    }
}
