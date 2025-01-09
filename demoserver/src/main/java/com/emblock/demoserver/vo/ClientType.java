package com.emblock.demoserver.vo;

import lombok.Getter;

@Getter
public enum ClientType {
    PROVIDER(0),
    CONSUMER(1);

    final int value;

    ClientType(int value) {
        this.value = value;
    }

}
