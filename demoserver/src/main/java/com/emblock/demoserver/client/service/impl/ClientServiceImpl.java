package com.emblock.demoserver.client.service.impl;

import com.emblock.demoserver.client.domain.Client;
import com.emblock.demoserver.client.dto.CreateClientReqDto;
import com.emblock.demoserver.client.repository.ClientRepository;
import com.emblock.demoserver.client.service.ClientService;
import com.emblock.demoserver.comm.DemoException;
import com.emblock.demoserver.comm.StringUtils;
import com.emblock.demoserver.vo.ClientType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Optional;
import java.util.stream.Stream;

@Service
public class ClientServiceImpl implements ClientService {

    @Autowired
    private ClientRepository clientRepository;

    @Override
    public Client getClient(String key) throws DemoException {
        Optional<Client> result = clientRepository.findById(key);
        if (result.isEmpty()) {
            throw DemoException.CLIENT_NOT_FOUND;
        }
        return result.get();
    }

    @Override
    public Client createClient(CreateClientReqDto req) throws DemoException {
        String key = req.getPublicKey();
        Optional<Client> existingItem = clientRepository.findById(key);
        if (existingItem.isPresent()) {
            throw DemoException.DUPLICATE_CLIENT_KEY;
        }
        Integer type = req.getType();
        if (!Stream.of(ClientType.values()).map(ClientType::getValue).toList().contains(type)) {
            throw DemoException.INVALID_CLIENT_TYPE;
        }
        String name = req.getName();
        if (name.isEmpty() || name.length() > 10) {
            throw DemoException.INVALID_CLIENT_NAME_LENGTH;
        }
        if (!StringUtils.isAlphanumeric(name)) {
            throw DemoException.INVALID_CLIENT_NAME;
        }
        Long createdAt = new Date().getTime();
        try {
            return clientRepository.save(new Client(key, type, name, createdAt));
        } catch (Exception e) {
            e.printStackTrace();
            throw DemoException.CLIENT_CREATION_FAILED;
        }
    }
}
