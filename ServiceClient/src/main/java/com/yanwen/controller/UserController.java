package com.yanwen.controller;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;



@RestController
public class UserController {
    Logger logger = LoggerFactory.getLogger(UserController.class);

    @RequestMapping(value = "users/{id}", method = RequestMethod.GET)
    public String getUser(@PathVariable("id") String id, HttpServletRequest request) {
        logger.info("接收到请求[/users/" + id + "]");
        return "接收到请求[/users/" + id + "] serverip:" + request.getServerName() + ":" + request.getServerPort() + " "
                + "request ip：" + request.getRemoteHost() + ":" + request.getRemotePort();
    }
}
