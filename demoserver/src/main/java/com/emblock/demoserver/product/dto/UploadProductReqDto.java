package com.emblock.demoserver.product.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UploadProductReqDto {
    private String orderId;
    private String sender;
    private String data;
}
