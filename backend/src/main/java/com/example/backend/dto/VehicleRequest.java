package com.example.backend.dto;

import com.example.backend.entity.VehicleStatus;
import com.example.backend.entity.VehicleType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record VehicleRequest(
        @NotBlank(message = "Vehicle number is required")
        @Size(min = 3, max = 30, message = "Vehicle number must be between 3 and 30 characters")
        String vehicleNumber,

        @NotBlank(message = "Brand is required")
        @Size(max = 50, message = "Brand must not exceed 50 characters")
        String brand,

        @NotBlank(message = "Model is required")
        @Size(max = 50, message = "Model must not exceed 50 characters")
        String model,

        @NotBlank(message = "Company is required")
        @Size(max = 100, message = "Company must not exceed 100 characters")
        String company,

        @NotNull(message = "Vehicle type is required")
        VehicleType vehicleType,

        VehicleStatus status
) {
}
