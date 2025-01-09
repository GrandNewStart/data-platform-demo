package com.emblock.demoserver.order.dto;

import lombok.Data;

import java.util.List;

@Data
public class OrderReqDto {
    private String sender;
    private List<String> queries;
}
