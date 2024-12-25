package com.example.quizz;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = { SecurityAutoConfiguration.class })
@EntityScan(basePackages = "com.example.quizz.models")
public class QuizzApplication {

	public static void main(String[] args) {
		SpringApplication.run(QuizzApplication.class, args);
	}

}
