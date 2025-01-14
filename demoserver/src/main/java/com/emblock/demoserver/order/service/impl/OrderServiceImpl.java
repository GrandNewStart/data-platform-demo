package com.emblock.demoserver.order.service.impl;

import com.emblock.demoserver.client.domain.Client;
import com.emblock.demoserver.client.repository.ClientRepository;
import com.emblock.demoserver.comm.DemoException;
import com.emblock.demoserver.order.domain.Order;
import com.emblock.demoserver.order.dto.OrderReqDto;
import com.emblock.demoserver.order.repository.OrderRepository;
import com.emblock.demoserver.order.service.OrderService;
import com.emblock.demoserver.product.repository.ProductRepository;
import org.aspectj.weaver.ast.Or;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private ClientRepository clientRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ProductRepository productRepository;

    @Override
    public Order createOrder(OrderReqDto req) throws DemoException {
        Optional<Client> client = clientRepository.findById(req.getSender());
        if (client.isEmpty()) {
            throw DemoException.CLIENT_NOT_FOUND;
        }

        Order item = new Order();
        item.setSender(req.getSender());
        item.setQueries(req.getQueries());

        try {
            return orderRepository.save(item);
        } catch (Exception e) {
            throw DemoException.ORDER_CREATION_FAILED;
        }
    }

    @Override
    public Order getOrder(String id) throws DemoException {
        Optional<Order> result = orderRepository.findById(id);
        if (result.isEmpty()) {
            throw DemoException.ORDER_NOT_FOUND;
        }
        return result.get();
    }


    @Override
    public List<Order> getPagedOrders(int page, int size) throws DemoException {
        Pageable pageable = PageRequest.of(page, size);
        try {
            Page<Order> p = orderRepository.findAll(pageable);
            if (p.isEmpty()) {
                return new ArrayList<>();
            }
            return p.get().toList();
        } catch (Exception e) {
            throw DemoException.ORDER_FETCH_FAILED;
        }
    }

    @Override
    public List<Order> getOrdersBySender(String publicKey) throws DemoException {
        try {
            return orderRepository.findBySender(publicKey);
        } catch (Exception e) {
            throw DemoException.ORDER_FETCH_FAILED;
        }
    }

    @Override
    public void deleteOrder(String publicKey, String orderId) throws DemoException {
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            throw DemoException.ORDER_NOT_FOUND;
        }
        Client client = clientRepository.findById(order.getSender()).orElse(null);
        if (client == null) {
            throw DemoException.CLIENT_NOT_FOUND;
        }
        if (!Objects.equals(client.getPublicKey(), publicKey)) {
            throw DemoException.CLIENT_NOT_ALLOWED;
        }
        try {
            orderRepository.delete(order);
        } catch (Exception e) {
            throw DemoException.ORDER_DELETE_FAILED;
        }
        try {
            productRepository.deleteAllByOrderId(orderId);
        } catch (Exception e) {
            throw DemoException.PRODUCT_DELETE_FAILED;
        }
    }

}
