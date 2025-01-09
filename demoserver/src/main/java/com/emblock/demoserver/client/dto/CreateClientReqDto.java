package com.emblock.demoserver.client.dto;

import lombok.Data;

@Data
public class CreateClientReqDto {
    private String publicKey;
    private Integer type;
    private String name;
}
