package com.example.backend.config;

import com.example.backend.entity.Vehicle;
import com.example.backend.entity.VehicleStatus;
import com.example.backend.entity.VehicleType;
import com.example.backend.repository.VehicleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner initDatabase(VehicleRepository vehicleRepository) {
        return args -> {
            if (vehicleRepository.count() == 0) {
                Vehicle v1 = new Vehicle(
                        "DHAKA-METRO-GA-11-2233",
                        "Toyota",
                        "Hiace",
                        "Stark Logistics",
                        VehicleType.VAN,
                        VehicleStatus.ACTIVE
                );
                Vehicle v2 = new Vehicle(
                        "DHAKA-METRO-BA-12-3456",
                        "Hino",
                        "1J",
                        "Stark Transit",
                        VehicleType.BUS,
                        VehicleStatus.ACTIVE
                );
                Vehicle v3 = new Vehicle(
                        "DHAKA-METRO-CHA-55-6789",
                        "Honda",
                        "Civic",
                        "Stark Industries",
                        VehicleType.CAR,
                        VehicleStatus.MAINTENANCE
                );
                vehicleRepository.saveAll(List.of(v1, v2, v3));
            }
        };
    }
}
