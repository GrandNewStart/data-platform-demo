package com.emblock.demoserver.product.repository;

import com.emblock.demoserver.product.domain.Product;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductRepository extends JpaRepository<Product, String> {
    List<Product> findByOrderId(String orderId);
    void deleteAllByOrderId(String orderId);
}
