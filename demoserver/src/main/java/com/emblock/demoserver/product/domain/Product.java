package com.emblock.demoserver.product.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UuidGenerator;

@Data
@Entity(name = "table_product")
@NoArgsConstructor
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @UuidGenerator
    private String id;
    private String orderId;
    private String sender;
    private String recipient;
    private String data;
    private Long createdAt;

    public Product(String orderId, String sender, String recipient, String data, Long createdAt) {
        this.orderId = orderId;
        this.sender = sender;
        this.recipient = recipient;
        this.data = data;
        this.createdAt = createdAt;
    }
}