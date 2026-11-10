package com.example.backend.dto;

import com.example.backend.entity.Vehicle;
import java.time.Instant;

public record VehicleResponse(
        Long id,
        String vehicleNumber,
        String brand,
        String model,
        Integer manufactureYear,
        String vehicleType,
        String color,
        Instant createdAt,
        Instant updatedAt
) {
    public static VehicleResponse fromEntity(Vehicle vehicle) {
        return new VehicleResponse(
                vehicle.getId(),
                vehicle.getVehicleNumber(),
                vehicle.getBrand(),
                vehicle.getModel(),
                vehicle.getManufactureYear(),
                vehicle.getVehicleType(),
                vehicle.getColor(),
                vehicle.getCreatedAt(),
                vehicle.getUpdatedAt()
        );
    }
}

