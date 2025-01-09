package com.emblock.demoserver.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class GetOrderResDto {
    private Integer code;
    private String message;
    private Data data;

    @lombok.Data
    @AllArgsConstructor
    public static class Data {
        private String sender;
        private List<String> queries;
    }
}
