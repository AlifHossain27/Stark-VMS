package com.example.backend.controller;

import com.example.backend.dto.VehicleRequest;
import com.example.backend.dto.VehicleResponse;
import com.example.backend.exception.DuplicateResourceException;
import com.example.backend.exception.ResourceNotFoundException;
import com.example.backend.service.VehicleService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.time.Instant;
import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(VehicleController.class)
class VehicleControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private VehicleService vehicleService;

    @Test
    void getAllVehicles_shouldReturn200AndJsonArray() throws Exception {
        VehicleResponse response = new VehicleResponse(
                1L,
                "DHAKA-METRO-GA-11-2233",
                "Toyota",
                "Hiace",
                2019,
                "VAN",
                "White",
                Instant.parse("2026-11-09T12:00:00Z"),
                Instant.parse("2026-11-09T12:00:00Z")
        );

        when(vehicleService.getAllVehicles()).thenReturn(List.of(response));

        mockMvc.perform(get("/api/vehicles")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(1))
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].vehicleNumber").value("DHAKA-METRO-GA-11-2233"));
    }

    @Test
    void getVehicleById_success_shouldReturn200() throws Exception {
        VehicleResponse response = new VehicleResponse(
                1L,
                "DHAKA-METRO-GA-11-2233",
                "Toyota",
                "Hiace",
                2019,
                "VAN",
                "White",
                Instant.parse("2026-11-09T12:00:00Z"),
                Instant.parse("2026-11-09T12:00:00Z")
        );

        when(vehicleService.getVehicleById(1L)).thenReturn(response);

        mockMvc.perform(get("/api/vehicles/1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.brand").value("Toyota"));
    }

    @Test
    void getVehicleById_notFound_shouldReturn404() throws Exception {
        when(vehicleService.getVehicleById(99L))
                .thenThrow(new ResourceNotFoundException("Vehicle not found with id 99"));

        mockMvc.perform(get("/api/vehicles/99")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404));
    }

    @Test
    void createVehicle_success_shouldReturn201WithLocation() throws Exception {
        VehicleResponse created = new VehicleResponse(
                10L,
                "DHAKA-METRO-GA-11-2233",
                "Toyota",
                "Hiace",
                2019,
                "VAN",
                "White",
                Instant.parse("2026-11-09T12:00:00Z"),
                Instant.parse("2026-11-09T12:00:00Z")
        );

        when(vehicleService.createVehicle(any(VehicleRequest.class))).thenReturn(created);

        String jsonRequest = """
                {
                    "vehicleNumber": "dhaka-metro-ga-11-2233",
                    "brand": "Toyota",
                    "model": "Hiace",
                    "manufactureYear": 2019,
                    "vehicleType": "VAN",
                    "color": "White"
                }
                """;

        mockMvc.perform(post("/api/vehicles")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(jsonRequest))
                .andExpect(status().isCreated())
                .andExpect(header().string("Location", "/api/vehicles/10"))
                .andExpect(jsonPath("$.id").value(10));
    }

    @Test
    void updateVehicle_success_shouldReturn200() throws Exception {
        VehicleResponse updated = new VehicleResponse(
                1L,
                "DHAKA-METRO-GA-11-2233",
                "Toyota Updated",
                "Hiace",
                2020,
                "VAN",
                "White",
                Instant.parse("2026-11-09T12:00:00Z"),
                Instant.parse("2026-11-09T12:00:00Z")
        );

        when(vehicleService.updateVehicle(eq(1L), any(VehicleRequest.class))).thenReturn(updated);

        String jsonRequest = """
                {
                    "vehicleNumber": "DHAKA-METRO-GA-11-2233",
                    "brand": "Toyota Updated",
                    "model": "Hiace",
                    "manufactureYear": 2020,
                    "vehicleType": "VAN",
                    "color": "White"
                }
                """;

        mockMvc.perform(put("/api/vehicles/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(jsonRequest))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.brand").value("Toyota Updated"));
    }

    @Test
    void updateVehicle_duplicateFromOtherVehicle_shouldReturn409() throws Exception {
        when(vehicleService.updateVehicle(eq(1L), any(VehicleRequest.class)))
                .thenThrow(new DuplicateResourceException(
                        "Vehicle number DHAKA-METRO-BA-12-3456 is already used by another vehicle",
                        Map.of("vehicleNumber", "already exists")
                ));

        String jsonRequest = """
                {
                    "vehicleNumber": "DHAKA-METRO-BA-12-3456",
                    "brand": "Toyota",
                    "model": "Hiace",
                    "manufactureYear": 2020,
                    "vehicleType": "VAN"
                }
                """;

        mockMvc.perform(put("/api/vehicles/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(jsonRequest))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.status").value(409));
    }

    @Test
    void deleteVehicle_success_shouldReturn204() throws Exception {
        doNothing().when(vehicleService).deleteVehicle(1L);

        mockMvc.perform(delete("/api/vehicles/1"))
                .andExpect(status().isNoContent());
    }

    @Test
    void deleteVehicle_notFound_shouldReturn404() throws Exception {
        doThrow(new ResourceNotFoundException("Vehicle not found with id 99"))
                .when(vehicleService).deleteVehicle(99L);

        mockMvc.perform(delete("/api/vehicles/99"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404));
    }
}
