package com.emblock.demoserver.client.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity(name = "table_client")
@AllArgsConstructor
@NoArgsConstructor
public class Client {
    @Id
    private String publicKey;
    private Integer type;
    private String name;
    private Long createdAt;
}
