document.getElementById('loginForm').addEventListener('submit', async function (e) {
    e.preventDefault(); // Prevent the form from submitting normally

    const username = document.getElementById('username').value;

    if (!username) {
        document.getElementById('status').textContent = 'Please enter your name.';
        return;
    }

    document.getElementById('status').textContent = 'Generating key pair...';

    try {
        // Generate an EC key pair using Web Crypto API
        const keyPair = await window.crypto.subtle.generateKey(
            {
                name: "ECDSA",
                namedCurve: "P-256"
            },
            true,
            ["sign", "verify"]
        );

        // Export the public key as a base64 string
        const publicKey = await window.crypto.subtle.exportKey(
            "spki",
            keyPair.publicKey
        );

        const publicKeyBase64 = btoa(String.fromCharCode(...new Uint8Array(publicKey)));

        // Send data to the server
        const response = await fetch('http://localhost:8080/client', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                publicKey: publicKeyBase64,
                name: username,
                type: 1
            })
        });

        if (response.ok) {
            document.getElementById('status').textContent = 'Login successful! Redirecting...';
            setTimeout(() => {
                localStorage.setItem('username', username);
                localStorage.setItem('publicKey', publicKeyBase64);    
                window.location.href = 'main.html'; // Redirect to the main page
            }, 1000);
        } else {
            const error = await response.json();
            document.getElementById('status').textContent = `Error: ${error.message}`;
        }
    } catch (err) {
        console.error(err);
        document.getElementById('status').textContent = 'An error occurred during login.';
    }
});