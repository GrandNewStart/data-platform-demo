package com.emblock.demoserver.product.controller;

import com.emblock.demoserver.comm.DemoException;
import com.emblock.demoserver.product.domain.Product;
import com.emblock.demoserver.product.dto.*;
import com.emblock.demoserver.product.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping
    public ResponseEntity<GetProductListResDto> getProducts(@RequestParam String id) {
        try {
            List<Product> products = productService.getProducts(id);
            List<GetProductListResDto.Data> data = products
                    .stream()
                    .map(e -> new GetProductListResDto.Data(
                            e.getId(),
                            e.getSender(),
                            e.getRecipient(),
                            e.getData(),
                            e.getCreatedAt()
                    ))
                    .toList();
            GetProductListResDto body = new GetProductListResDto(200, "Products fetch success", data);
            return ResponseEntity
                    .status(HttpStatus.OK)
                    .body(body);
        } catch (DemoException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new GetProductListResDto(e.getCode(), e.getMsg(), null));
        }
    }

    @PostMapping
    public ResponseEntity<UploadProductResDto> uploadProduct(@RequestBody UploadProductReqDto req) {
        try {
            Product product = productService.createProduct(
                    req.getOrderId(),
                    req.getSender(),
                    req.getData()
            );
            UploadProductResDto.Data data = new UploadProductResDto.Data(
                    product.getId(),
                    product.getSender(),
                    product.getRecipient(),
                    product.getData(),
                    product.getCreatedAt()
            );
            UploadProductResDto body = new UploadProductResDto(201, "Product upload success", data);
            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(body);
        } catch (DemoException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new UploadProductResDto(e.getCode(), e.getMsg(), null));
        }
    }

    @PostMapping("/consume")
    public ResponseEntity<ConsumeProductResDto> consumeProduct(@RequestBody ConsumeProductReqDto req) {
        try {
            List<Product> products = productService.consumeProducts(req.getConsumer(), req.getOrderId());
            List<ConsumeProductResDto.Data> data = products
                    .stream()
                    .map(e -> new ConsumeProductResDto.Data(
                            e.getId(),
                            e.getSender(),
                            e.getData(),
                            e.getCreatedAt()
                    ))
                    .toList();
            ConsumeProductResDto body = new ConsumeProductResDto(200, "Data consume success", data);
            return ResponseEntity
                    .status(HttpStatus.OK)
                    .body(body);
        } catch (DemoException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new ConsumeProductResDto(e.getCode(), e.getMsg(), null));
        }
    }

}
