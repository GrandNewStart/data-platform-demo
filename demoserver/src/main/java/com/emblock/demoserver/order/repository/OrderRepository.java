package com.emblock.demoserver.order.repository;

import com.emblock.demoserver.order.domain.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository extends JpaRepository<Order, String> {
    Page<Order> findAll(Pageable pageable);
}
