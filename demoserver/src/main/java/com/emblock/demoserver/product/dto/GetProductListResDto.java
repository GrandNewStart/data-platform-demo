package com.emblock.demoserver.product.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class GetProductListResDto {
    private Integer code;
    private String message;
    private List<Data> data;

    @lombok.Data
    @AllArgsConstructor
    public static class Data {
        private String id;
        private String sender;
        private String recipient;
        private String data;
        private Long createdAt;
    }
}
