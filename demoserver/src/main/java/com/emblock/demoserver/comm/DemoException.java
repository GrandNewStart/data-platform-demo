package com.emblock.demoserver.comm;

import lombok.Getter;

@Getter
public class DemoException extends Exception {

    public static DemoException CLIENT_NOT_FOUND = new DemoException(1, "Client by the given key is not found");
    public static DemoException DUPLICATE_CLIENT_KEY = new DemoException(2, "Client by the given key already exists");
    public static DemoException INVALID_CLIENT_TYPE = new DemoException(3, "The given client type value is unsupported");
    public static DemoException INVALID_CLIENT_NAME_LENGTH = new DemoException(4, "Client name must be 1~10 characters long");
    public static DemoException INVALID_CLIENT_NAME = new DemoException(5, "The given client name is unsupported");
    public static DemoException CLIENT_CREATION_FAILED = new DemoException(6, "Internal server error");
    public static DemoException ORDER_NOT_FOUND = new DemoException(7, "Order by the given id is not found");
    public static DemoException ORDER_CREATION_FAILED = new DemoException(8, "Internal server error");
    public static DemoException ORDER_FETCH_FAILED = new DemoException(9, "Internal server error");
    public static DemoException PRODUCT_FETCH_FAILED = new DemoException(10, "Internal server error");
    public static DemoException PRODUCT_CREATION_FAILED = new DemoException(11, "Internal server error");
    public static DemoException CLIENT_NOT_ALLOWED = new DemoException(12, "Client is not allowed to access this resource");
    public static DemoException PRODUCT_CONSUME_FAILED = new DemoException(13, "Failed to delete consumed products");

    private final Integer code;
    private final String msg;

    DemoException(Integer code, String msg) {
        this.code = code;
        this.msg = msg;
    }

}
