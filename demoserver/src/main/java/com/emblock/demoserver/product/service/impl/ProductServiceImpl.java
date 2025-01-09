package com.emblock.demoserver.product.service.impl;

import com.emblock.demoserver.client.domain.Client;
import com.emblock.demoserver.client.repository.ClientRepository;
import com.emblock.demoserver.comm.DemoException;
import com.emblock.demoserver.order.domain.Order;
import com.emblock.demoserver.order.repository.OrderRepository;
import com.emblock.demoserver.product.domain.Product;
import com.emblock.demoserver.product.repository.ProductRepository;
import com.emblock.demoserver.product.service.ProductService;
import com.emblock.demoserver.vo.ClientType;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ClientRepository clientRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ProductRepository productRepository;

    @Override
    public List<Product> getProducts(String orderId) throws DemoException {
        try {
            return productRepository.findByOrderId(orderId);
        } catch (Exception e) {
            throw DemoException.PRODUCT_FETCH_FAILED;
        }
    }

    @Override
    public Product createProduct(String orderId, String senderId, String data) throws DemoException {
        Optional<Client> sender = clientRepository.findById(senderId);
        if (sender.isEmpty()) {
            throw DemoException.CLIENT_NOT_FOUND;
        }
        if (sender.get().getType() != ClientType.PROVIDER.getValue()) {
            throw DemoException.INVALID_CLIENT_TYPE;
        }
        Optional<Order> order = orderRepository.findById(orderId);
        if (order.isEmpty()) {
            throw DemoException.ORDER_NOT_FOUND;
        }
        try {
            return productRepository.save(
                    new Product(
                            orderId,
                            senderId,
                            order.get().getSender(),
                            data,
                            new Date().getTime()
                    )
            );
        } catch (Exception e) {
            throw DemoException.PRODUCT_CREATION_FAILED;
        }
    }

    @Transactional
    @Override
    public List<Product> consumeProducts(String consumerId, String orderId) throws DemoException {
        Client consumer = clientRepository.findById(consumerId).orElse(null);
        if (consumer == null) {
            throw DemoException.CLIENT_NOT_FOUND;
        }
        if (consumer.getType() != ClientType.CONSUMER.getValue()) {
            throw DemoException.INVALID_CLIENT_TYPE;
        }
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            throw DemoException.ORDER_NOT_FOUND;
        }
        if (!Objects.equals(order.getSender(), consumer.getPublicKey())) {
            throw DemoException.CLIENT_NOT_ALLOWED;
        }
        List<Product> result;
        try {
            result = productRepository.findByOrderId(orderId);
        } catch (Exception e) {
            throw DemoException.PRODUCT_FETCH_FAILED;
        }
        try {
            productRepository.deleteAllByOrderId(orderId);
        } catch (Exception e) {
            throw DemoException.PRODUCT_CONSUME_FAILED;
        }
        return result;
    }
}
