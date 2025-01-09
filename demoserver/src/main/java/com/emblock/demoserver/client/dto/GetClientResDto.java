package com.emblock.demoserver.client.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class GetClientResDto {
    private int code;
    private String message;
    private Data data;

    @lombok.Data
    @AllArgsConstructor
    public static class Data {
        private String publicKey;
        private Integer type;
        private String name;
    }
}
