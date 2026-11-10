package com.example.backend.service;

import com.example.backend.dto.VehicleRequest;
import com.example.backend.dto.VehicleResponse;
import com.example.backend.entity.Vehicle;
import com.example.backend.entity.VehicleStatus;
import com.example.backend.exception.DuplicateResourceException;
import com.example.backend.exception.ResourceNotFoundException;
import com.example.backend.repository.VehicleRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class VehicleService {

    private final VehicleRepository vehicleRepository;

    public VehicleService(VehicleRepository vehicleRepository) {
        this.vehicleRepository = vehicleRepository;
    }

    @Transactional(readOnly = true)
    public List<VehicleResponse> getAllVehicles() {
        return vehicleRepository.findAll().stream()
                .map(VehicleResponse::fromEntity)
                .toList();
    }

    @Transactional(readOnly = true)
    public VehicleResponse getVehicleById(Long id) {
        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found with id " + id));
        return VehicleResponse.fromEntity(vehicle);
    }

    @Transactional
    public VehicleResponse createVehicle(VehicleRequest request) {
        String normalizedNumber = request.vehicleNumber().trim().toUpperCase();

        if (vehicleRepository.existsByVehicleNumberIgnoreCase(normalizedNumber)) {
            throw new DuplicateResourceException(
                    "Vehicle number " + normalizedNumber + " already exists",
                    Map.of("vehicleNumber", "already exists")
            );
        }

        VehicleStatus status = request.status() != null ? request.status() : VehicleStatus.ACTIVE;

        Vehicle vehicle = new Vehicle(
                normalizedNumber,
                request.brand().trim(),
                request.model().trim(),
                request.company().trim(),
                request.vehicleType(),
                status
        );

        Vehicle saved = vehicleRepository.save(vehicle);
        return VehicleResponse.fromEntity(saved);
    }

    @Transactional
    public VehicleResponse updateVehicle(Long id, VehicleRequest request) {
        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found with id " + id));

        String normalizedNumber = request.vehicleNumber().trim().toUpperCase();

        if (vehicleRepository.existsByVehicleNumberIgnoreCaseAndIdNot(normalizedNumber, id)) {
            throw new DuplicateResourceException(
                    "Vehicle number " + normalizedNumber + " is already used by another vehicle",
                    Map.of("vehicleNumber", "already exists")
            );
        }

        VehicleStatus status = request.status() != null ? request.status() : (vehicle.getStatus() != null ? vehicle.getStatus() : VehicleStatus.ACTIVE);

        vehicle.setVehicleNumber(normalizedNumber);
        vehicle.setBrand(request.brand().trim());
        vehicle.setModel(request.model().trim());
        vehicle.setCompany(request.company().trim());
        vehicle.setVehicleType(request.vehicleType());
        vehicle.setStatus(status);

        Vehicle updated = vehicleRepository.save(vehicle);
        return VehicleResponse.fromEntity(updated);
    }

    @Transactional
    public void deleteVehicle(Long id) {
        if (!vehicleRepository.existsById(id)) {
            throw new ResourceNotFoundException("Vehicle not found with id " + id);
        }
        vehicleRepository.deleteById(id);
    }
}
