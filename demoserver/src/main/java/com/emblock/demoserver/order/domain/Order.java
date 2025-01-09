package com.emblock.demoserver.order.domain;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.UuidGenerator;

import java.util.List;

@Data
@Entity(name = "table_order")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @UuidGenerator
    private String id;
    private String sender;
    private List<String> queries;
}
