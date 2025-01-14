package com.emblock.demoserver.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DeleteOrderReqDto {
    private String publicKey;
    private String orderId;
}
