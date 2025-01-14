package com.emblock.demoserver.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@AllArgsConstructor
@Data
public class DeleteOrderResDto {
    private int code;
    private String message;
}
