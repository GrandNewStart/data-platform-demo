package com.emblock.demoserver.client.service;

import com.emblock.demoserver.client.domain.Client;
import com.emblock.demoserver.client.dto.CreateClientReqDto;
import com.emblock.demoserver.comm.DemoException;

public interface ClientService {

    Client getClient(String key) throws DemoException;
    Client createClient(CreateClientReqDto req) throws DemoException;

}
