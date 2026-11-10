package com.example.backend.exception;

import java.util.Map;

public class DuplicateResourceException extends RuntimeException {
    private final Map<String, String> fieldErrors;

    public DuplicateResourceException(String message, Map<String, String> fieldErrors) {
        super(message);
        this.fieldErrors = fieldErrors;
    }

    public DuplicateResourceException(String message) {
        super(message);
        this.fieldErrors = Map.of();
    }

    public Map<String, String> getFieldErrors() {
        return fieldErrors;
    }
}

