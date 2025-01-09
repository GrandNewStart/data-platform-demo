package com.emblock.demoserver.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class GetOrderListResDto {
    private Integer code;
    private String message;
    private List<Data> data;

    @lombok.Data
    @AllArgsConstructor
    public static class Data {
        private String id;
        private String sender;
        private List<String> queries;
    }
}
