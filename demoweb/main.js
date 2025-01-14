
const user = {
    name: localStorage.getItem('username'),
    publicKey: localStorage.getItem('publicKey'),
};

document.getElementById('username').textContent = user.name || "Anonymous";

const form = document.getElementById('mainForm');
const submitButton = document.getElementById('submitButton');
const menuButton = document.getElementById('menuButton');
const menuOptions = document.getElementById('menuOptions');

menuButton.addEventListener('click', () => {
    menuOptions.classList.toggle('hidden');
});

document.addEventListener('click', (event) => {
    if (!menuButton.contains(event.target) && !menuOptions.contains(event.target)) {
        menuOptions.classList.add('hidden');
    }
});


function logout() {
    localStorage.clear();
    alert('You have been logged out.');
}

form.addEventListener('input', () => {
    const formA = document.getElementById('formA').value;
    const formB = document.getElementById('formB').value;
    const formCMin = document.getElementById('formCMin').value;
    const formCMax = document.getElementById('formCMax').value;

    // Enable the button if required fields are filled
    if (formA && formB && (formCMin || formCMax)) {
        submitButton.disabled = false;
    } else {
        submitButton.disabled = true;
    }
});

// Handle form submission
form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const a = document.getElementById('formA').value
    const b = document.getElementById('formB').value
    const min = document.getElementById('formCMin').value || null
    const max = document.getElementById('formCMax').value || null
    var queryC = '';
    if (min != null) {
        queryC += `C>=${min}`
    }
    if (max != null) {
        if (queryC != '') {
            queryC += ','
        }
        queryC += `C<=${max}`
    }
    const data = {
        sender: user.publicKey,
        queries: [
            `A==${a}`,
            `B==${b}`,
            queryC
        ]
    };
    
    try {
        const response = await fetch('http://localhost:8080/order', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        });

        if (response.ok) {
            alert('Form submitted successfully!');
            form.reset();
            submitButton.disabled = true;
        } else {
            const error = await response.json();
            alert(`Error: ${error.message}`);
        }
    } catch (err) {
        console.error(err);
        alert('An error occurred while submitting the form.');
    }
});