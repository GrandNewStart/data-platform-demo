package com.emblock.demoserver.product.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ConsumeProductReqDto {
    private String consumer;
    private String productId;
}
