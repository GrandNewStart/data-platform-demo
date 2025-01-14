package com.emblock.demoserver.order.controller;

import com.emblock.demoserver.comm.DemoException;
import com.emblock.demoserver.order.domain.Order;
import com.emblock.demoserver.order.dto.*;
import com.emblock.demoserver.order.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @PostMapping
    public ResponseEntity<OrderResDto> createOrder(@RequestBody OrderReqDto req) {
        try {
            Order order = orderService.createOrder(req);
            OrderResDto body = new OrderResDto(201, "Order success", order.getId());
            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(body);
        } catch (DemoException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new OrderResDto(e.getCode(), e.getMsg(), null));
        }
    }

    @GetMapping
    public ResponseEntity<GetOrderResDto> getOrder(@RequestParam String id) {
        try {
            Order order = orderService.getOrder(id);
            GetOrderResDto.Data data = new GetOrderResDto.Data(order.getSender(), order.getQueries());
            GetOrderResDto body = new GetOrderResDto(200, "Order fetch success", data);
            return ResponseEntity
                    .status(HttpStatus.OK)
                    .body(body);
        } catch (DemoException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new GetOrderResDto(e.getCode(), e.getMsg(), null));
        }
    }

    @GetMapping("/list")
    public ResponseEntity<GetOrderListResDto> getOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        try {
            List<Order> orders = orderService.getPagedOrders(page, size);
            List<GetOrderListResDto.Data> data = orders.stream().map(e ->
                    new GetOrderListResDto.Data(e.getId(), e.getSender(), e.getQueries())
            ).toList();
            GetOrderListResDto body = new GetOrderListResDto(200, "Order fetch success", data);
            return ResponseEntity
                    .status(HttpStatus.OK)
                    .body(body);
        } catch (DemoException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new GetOrderListResDto(e.getCode(), e.getMsg(), null));
        }
    }

    @PostMapping("/list")
    public ResponseEntity<GetOrderListResDto> getMyOrders(@RequestBody Map<String, String> requestData) {
        try {
            String publicKey = requestData.get("publicKey");
            List<Order> orders = orderService.getOrdersBySender(publicKey);
            List<GetOrderListResDto.Data> data = orders.stream().map(e ->
                    new GetOrderListResDto.Data(e.getId(), e.getSender(), e.getQueries())
            ).toList();
            GetOrderListResDto body = new GetOrderListResDto(200, "Order fetch success", data);
            return ResponseEntity
                    .status(HttpStatus.OK)
                    .body(body);
        } catch (DemoException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new GetOrderListResDto(e.getCode(), e.getMsg(), null));
        }
    }

    @DeleteMapping
    public ResponseEntity<DeleteOrderResDto> deleteOrder(@RequestBody DeleteOrderReqDto req) {
        try {
            orderService.deleteOrder(req.getPublicKey(), req.getOrderId());
            return ResponseEntity
                    .status(HttpStatus.OK)
                    .body(new DeleteOrderResDto(200, "Order delete success"));
        } catch (DemoException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new DeleteOrderResDto(e.getCode(), e.getMsg()));
        }
    }

}
