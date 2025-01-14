package com.emblock.demoserver.product.service;

import com.emblock.demoserver.comm.DemoException;
import com.emblock.demoserver.product.domain.Product;

import java.util.List;

public interface ProductService {
    List<Product> getProducts(String orderId) throws DemoException;
    Product createProduct(String orderId, String senderId, String data) throws DemoException;
    Product consumeProduct(String consumerId, String productId) throws DemoException;
}
