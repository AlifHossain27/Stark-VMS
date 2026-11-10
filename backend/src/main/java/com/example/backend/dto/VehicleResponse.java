package com.example.backend.dto;

import com.example.backend.entity.Vehicle;
import com.example.backend.entity.VehicleStatus;
import com.example.backend.entity.VehicleType;

import java.time.Instant;

public record VehicleResponse(
        Long id,
        String vehicleNumber,
        String brand,
        String model,
        String company,
        VehicleType vehicleType,
        VehicleStatus status,
        Instant createdAt,
        Instant updatedAt
) {
    public static VehicleResponse fromEntity(Vehicle vehicle) {
        return new VehicleResponse(
                vehicle.getId(),
                vehicle.getVehicleNumber(),
                vehicle.getBrand(),
                vehicle.getModel(),
                vehicle.getCompany(),
                vehicle.getVehicleType(),
                vehicle.getStatus(),
                vehicle.getCreatedAt(),
                vehicle.getUpdatedAt()
        );
    }
}
