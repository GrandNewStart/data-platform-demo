package com.emblock.demoserver.order.service;

import com.emblock.demoserver.comm.DemoException;
import com.emblock.demoserver.order.domain.Order;
import com.emblock.demoserver.order.dto.OrderReqDto;

import java.util.List;

public interface OrderService {
    Order createOrder(OrderReqDto req) throws DemoException;

    Order getOrder(String id) throws DemoException;

    List<Order> getPagedOrders(int page, int size) throws DemoException;
}
