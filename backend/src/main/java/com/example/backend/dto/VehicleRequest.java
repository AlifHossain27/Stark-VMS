package com.example.backend.dto;

import jakarta.validation.constraints.Min;
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

        @NotNull(message = "Manufacture year is required")
        @Min(value = 1980, message = "Manufacture year must be at least 1980")
        Integer manufactureYear,

        @NotBlank(message = "Vehicle type is required")
        @Size(max = 30, message = "Vehicle type must not exceed 30 characters")
        String vehicleType,

        @Size(max = 30, message = "Color must not exceed 30 characters")
        String color
) {
}

