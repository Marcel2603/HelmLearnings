package de.herhold.helloservice.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping(value = "/hello")
    public ResponseEntity<String> sayHallo() {
        return new ResponseEntity<>("Hello, second new World!", HttpStatus.OK);
    }
}
