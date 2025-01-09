package com.emblock.demoserver.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class OrderResDto {
    private Integer code;
    private String message;
    private String data;
}
