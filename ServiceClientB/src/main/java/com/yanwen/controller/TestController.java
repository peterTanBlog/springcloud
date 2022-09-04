package com.yanwen.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;



@RestController
public class TestController {
    Logger logger = LoggerFactory.getLogger(TestController.class);

    // 这里配置的是我们要调用的服务实例名，我们要调用USER服务，因此这里的地址是USER
    private String rest_url_prefix = "http://SERVICECLIENT";
    @Autowired
    private RestTemplate restTemplate;

    @RequestMapping(value = "users/{id}", method = RequestMethod.GET)
    @HystrixCommand(fallbackMethod = "getUserFallBack")
    public String getUser(@PathVariable("id") String id) {
        // 调用USER服务中的/users/{id}服务
        return restTemplate.getForObject(rest_url_prefix + "/users/" + id, String.class);
    }

    public String getUserFallBack(String id) {
        return "error";
    }
}
