package com.devops.vitrine;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Application principale Spring Boot
 * Point d'entrée de l'API REST
 */
@SpringBootApplication
public class VitrineApplication {

    public static void main(String[] args) {
        SpringApplication.run(VitrineApplication.class, args);
    }
}
