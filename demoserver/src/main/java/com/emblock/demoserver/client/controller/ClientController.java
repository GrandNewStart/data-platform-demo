package com.emblock.demoserver.client.controller;

import com.emblock.demoserver.client.domain.Client;
import com.emblock.demoserver.client.dto.CreateClientReqDto;
import com.emblock.demoserver.client.dto.CreateClientResDto;
import com.emblock.demoserver.client.dto.GetClientResDto;
import com.emblock.demoserver.client.service.ClientService;
import com.emblock.demoserver.comm.DemoException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/client")
public class ClientController {

    @Autowired
    private ClientService clientService;

    @PostMapping
    public ResponseEntity<CreateClientResDto> signup(@RequestBody CreateClientReqDto req) {
        try {
            clientService.createClient(req);
            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(new CreateClientResDto(201, "Sign up success"));
        } catch (DemoException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new CreateClientResDto(e.getCode(), e.getMsg()));
        }
    }

    @GetMapping
    public ResponseEntity<GetClientResDto> getClient(@RequestParam String key) {
        try {
            Client client = clientService.getClient(key);
            GetClientResDto.Data data = new GetClientResDto.Data(client.getPublicKey(), client.getType(), client.getName());
            GetClientResDto body = new GetClientResDto(200, "Client fetched", data);
            return ResponseEntity
                    .status(HttpStatus.OK)
                    .body(body);
        } catch (DemoException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new GetClientResDto(e.getCode(), e.getMsg(), null));
        }
    }

}
