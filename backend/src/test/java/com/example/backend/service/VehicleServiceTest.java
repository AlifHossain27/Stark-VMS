package com.example.backend.service;

import com.example.backend.dto.VehicleRequest;
import com.example.backend.dto.VehicleResponse;
import com.example.backend.entity.Vehicle;
import com.example.backend.exception.BadRequestException;
import com.example.backend.exception.DuplicateResourceException;
import com.example.backend.exception.ResourceNotFoundException;
import com.example.backend.repository.VehicleRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.Instant;
import java.time.Year;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class VehicleServiceTest {

    @Mock
    private VehicleRepository vehicleRepository;

    @InjectMocks
    private VehicleService vehicleService;

    private Vehicle vehicle;

    @BeforeEach
    void setUp() {
        vehicle = new Vehicle("DHAKA-METRO-GA-11-2233", "Toyota", "Hiace", 2019, "VAN", "White");
        vehicle.setId(1L);
        vehicle.setCreatedAt(Instant.now());
        vehicle.setUpdatedAt(Instant.now());
    }

    @Test
    void getAllVehicles_shouldReturnListOfVehicleResponse() {
        when(vehicleRepository.findAll()).thenReturn(List.of(vehicle));

        List<VehicleResponse> result = vehicleService.getAllVehicles();

        assertThat(result).hasSize(1);
        VehicleResponse first = result.get(0);
        assertThat(first.id()).isEqualTo(1L);
        assertThat(first.vehicleNumber()).isEqualTo("DHAKA-METRO-GA-11-2233");
    }

    @Test
    void getAllVehicles_whenEmpty_shouldReturnEmptyList() {
        when(vehicleRepository.findAll()).thenReturn(List.of());

        List<VehicleResponse> result = vehicleService.getAllVehicles();

        assertThat(result).isEmpty();
    }

    @Test
    void getVehicleById_success() {
        when(vehicleRepository.findById(1L)).thenReturn(Optional.of(vehicle));

        VehicleResponse response = vehicleService.getVehicleById(1L);

        assertThat(response.id()).isEqualTo(1L);
        assertThat(response.brand()).isEqualTo("Toyota");
    }

    @Test
    void getVehicleById_notFound_shouldThrowResourceNotFoundException() {
        when(vehicleRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> vehicleService.getVehicleById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Vehicle not found with id 99");
    }

    @Test
    void createVehicle_success() {
        VehicleRequest request = new VehicleRequest(
                "dhaka-metro-ga-11-2233",
                "Toyota",
                "Hiace",
                2019,
                "van",
                "White"
        );

        when(vehicleRepository.existsByVehicleNumberIgnoreCase("DHAKA-METRO-GA-11-2233")).thenReturn(false);
        when(vehicleRepository.save(any(Vehicle.class))).thenAnswer(invocation -> {
            Vehicle v = invocation.getArgument(0);
            v.setId(1L);
            v.setCreatedAt(Instant.now());
            v.setUpdatedAt(Instant.now());
            return v;
        });

        VehicleResponse response = vehicleService.createVehicle(request);

        assertThat(response.id()).isEqualTo(1L);
        assertThat(response.vehicleNumber()).isEqualTo("DHAKA-METRO-GA-11-2233");
    }

    @Test
    void createVehicle_duplicateVehicleNumber_shouldThrowDuplicateResourceException() {
        VehicleRequest request = new VehicleRequest(
                "DHAKA-METRO-GA-11-2233",
                "Toyota",
                "Hiace",
                2019,
                "VAN",
                "White"
        );

        when(vehicleRepository.existsByVehicleNumberIgnoreCase("DHAKA-METRO-GA-11-2233")).thenReturn(true);

        assertThatThrownBy(() -> vehicleService.createVehicle(request))
                .isInstanceOf(DuplicateResourceException.class)
                .hasMessageContaining("already exists");
    }

    @Test
    void updateVehicle_success_sameNumber() {
        VehicleRequest request = new VehicleRequest(
                "DHAKA-METRO-GA-11-2233",
                "Toyota Updated",
                "Hiace Deluxe",
                2020,
                "VAN",
                "Black"
        );

        when(vehicleRepository.findById(1L)).thenReturn(Optional.of(vehicle));
        when(vehicleRepository.existsByVehicleNumberIgnoreCaseAndIdNot("DHAKA-METRO-GA-11-2233", 1L)).thenReturn(false);
        when(vehicleRepository.save(any(Vehicle.class))).thenAnswer(invocation -> invocation.getArgument(0));

        VehicleResponse response = vehicleService.updateVehicle(1L, request);

        assertThat(response.brand()).isEqualTo("Toyota Updated");
        assertThat(response.model()).isEqualTo("Hiace Deluxe");
        assertThat(response.color()).isEqualTo("Black");
    }

    @Test
    void updateVehicle_duplicateFromOtherVehicle_shouldThrowDuplicateResourceException() {
        VehicleRequest request = new VehicleRequest(
                "DHAKA-METRO-BA-99-9999",
                "Toyota",
                "Hiace",
                2020,
                "VAN",
                null
        );

        when(vehicleRepository.findById(1L)).thenReturn(Optional.of(vehicle));
        when(vehicleRepository.existsByVehicleNumberIgnoreCaseAndIdNot("DHAKA-METRO-BA-99-9999", 1L)).thenReturn(true);

        assertThatThrownBy(() -> vehicleService.updateVehicle(1L, request))
                .isInstanceOf(DuplicateResourceException.class)
                .hasMessageContaining("already used by another vehicle");
    }

    @Test
    void deleteVehicle_success() {
        when(vehicleRepository.existsById(1L)).thenReturn(true);
        doNothing().when(vehicleRepository).deleteById(1L);

        vehicleService.deleteVehicle(1L);

        verify(vehicleRepository).deleteById(1L);
    }

    @Test
    void deleteVehicle_notFound_shouldThrowResourceNotFoundException() {
        when(vehicleRepository.existsById(99L)).thenReturn(false);

        assertThatThrownBy(() -> vehicleService.deleteVehicle(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Vehicle not found with id 99");

        verify(vehicleRepository, never()).deleteById(any());
    }
}
