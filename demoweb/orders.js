const user = {
    name: localStorage.getItem('username'),
    publicKey: localStorage.getItem('publicKey'),
};

// Display username
document.getElementById('username').textContent = user.name || "Anonymous";

// Menu toggle
const menuButton = document.getElementById('menuButton');
const menuOptions = document.getElementById('menuOptions');
// Toggle the visibility of the menu
menuButton.addEventListener('click', () => {
    menuOptions.classList.toggle('hidden');
});
document.addEventListener('click', (event) => {
    if (!menuButton.contains(event.target) && !menuOptions.contains(event.target)) {
        menuOptions.classList.add('hidden');
    }
});

// Elements
const itemList = document.getElementById('itemList');
const prevButton = document.getElementById('prevButton');
const nextButton = document.getElementById('nextButton');

// Fetch and render items
async function fetchItems() {
    try {
        const data = {publicKey: user.publicKey}
        const response = await fetch(
            `http://localhost:8080/order/list`, 
            {
                method: 'POST', 
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            }
        );
        if (response.ok) {
            const data = await response.json();
            renderItems(data.data);
        } else {
            console.error('Failed to fetch items');
        }
    } catch (error) {
        console.error('Error fetching items:', error);
    }
}

async function fetchData(orderId) {
    try {
        const response = await fetch(`http://localhost:8080/products?id=${orderId}`);
        if (response.ok) {
            const data = await response.json();
            showDataDialog(orderId, data.data)
        } else {
            console.error('Failed to fetch items');
        }
    } catch (error) {
        console.error('Error fetching items:', error);
    }
}

async function consumeData(orderId, data) {
    try {
        const response = await fetch(
            `http://localhost:8080/products/consume`,
            {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({consumer: user.publicKey, productId: data.id})
            }
        )
        if (response.ok) {
            downloadItem(orderId, data)
        } else {
            console.error('Failed to consume item');
        }
    } catch (error) {
        console.error('Error consuming item:', error);
    }
}

async function deleteOrder(orderId) {
    try {
        const response = await fetch(
            `http://localhost:8080/order`,
            {
                method: 'DELETE',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({publicKey: user.publicKey, orderId: orderId})
            }
        )
        if (response.ok) {
            fetchItems()
            alert('Order deleted')
        } else {
            console.error('Failed to consume item');
        }
    } catch (error) {
        console.error('Error consuming item:', error);
    }
}

function downloadItem(orderId, item) {
    const blob = new Blob([JSON.stringify(item, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${item.id}.json`;
    a.click();
    URL.revokeObjectURL(url);
    fetchData(orderId)
}

// Render items
function renderItems(items) {
    itemList.innerHTML = ''; // Clear previous items
    items.forEach(item => {
        const div = document.createElement('div');
        div.className = 'item';
        div.textContent = item.id; // Update with actual item properties
        div.addEventListener('click', () => showItemDetails(item))
        itemList.appendChild(div);
    });
}

// Pagination button handlers
prevButton.addEventListener('click', () => {

});

nextButton.addEventListener('click', () => {

});

function logout() {
    localStorage.clear();
    alert('You have been logged out.');
}

function showItemDetails(item) {
    // Create the overlay
    const overlay = document.createElement('div');
    overlay.style.position = 'fixed';
    overlay.style.top = '0';
    overlay.style.left = '0';
    overlay.style.width = '100%';
    overlay.style.height = '100%';
    overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.5)'; // Semi-transparent background
    overlay.style.zIndex = '999'; // Behind the dialog
    document.body.appendChild(overlay);

    // Create the alert dialog
    const dialog = document.createElement('div');
    dialog.style.position = 'fixed';
    dialog.style.top = '50%';
    dialog.style.left = '50%';
    dialog.style.transform = 'translate(-50%, -50%)';
    dialog.style.backgroundColor = 'white';
    dialog.style.padding = '2%';
    dialog.style.boxShadow = '0 2px 10px rgba(0, 0, 0, 0.1)';
    dialog.style.zIndex = '1000'; // Above the overlay
    dialog.style.borderRadius = '8px';
    dialog.style.width = '90%'; // Width relative to the screen
    dialog.style.maxWidth = '600px'; // Maximum width
    dialog.style.height = '70vh'; // Height relative to viewport height
    dialog.style.overflowY = 'auto'; // Enable scrolling for content that overflows

    // Generate dialog content
    dialog.innerHTML = `
        <h3 style="margin-bottom: 20px;">Item Details</h3>
        <p style="word-wrap: break-word; overflow-wrap: break-word;"><strong>ID:</strong> ${item.id}</p>
        <p style="word-wrap: break-word; overflow-wrap: break-word;"><strong>Sender:</strong> ${item.sender}</p>
        <p style="word-wrap: break-word; overflow-wrap: break-word;"><strong>Queries:</strong> ${item.queries.join(', ')}</p>
        <div style="margin-top: 20px; text-align: right;">
            <button id="seeDataButton" style="padding: 10px 20px; font-size: 14px; background-color: #007BFF; color: white; border: none; cursor: pointer; border-radius: 4px;">
                See Data
            </button>
            <button id="deleteButton" style="padding: 10px 20px; font-size: 14px; background-color: #FF6347; color: white; border: none; cursor: pointer; border-radius: 4px;">
                Delete
            </button>
            <button id="closeButton" style="padding: 10px 20px; font-size: 14px; background-color: #ccc; color: black; border: none; cursor: pointer; border-radius: 4px;">
                Close
            </button>
        </div>
    `;

    // Append the dialog to the overlay
    overlay.appendChild(dialog);

    // Close the dialog when clicking the "Close" button
    document.getElementById('closeButton').addEventListener('click', () => {
        overlay.remove();
    });

    // Handle "See Data" button
    document.getElementById('seeDataButton').addEventListener('click', () => {
        overlay.remove();
        fetchData(item.id); // Replace with your actual fetch logic
    });

    // Handle "Delete" button
    document.getElementById('deleteButton').addEventListener('click', () => {
        overlay.remove();
        deleteOrder(item.id)
    });

    // Close the dialog when clicking outside it
    overlay.addEventListener('click', (event) => {
        if (event.target === overlay) {
            overlay.remove(); // Remove overlay and dialog
        }
    });
}

function showDataDialog(orderId, items) {
    // Create the overlay
    const overlay = document.createElement('div');
    overlay.style.position = 'fixed';
    overlay.style.top = '0';
    overlay.style.left = '0';
    overlay.style.width = '100%';
    overlay.style.height = '100%';
    overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
    overlay.style.zIndex = '999';
    document.body.appendChild(overlay);

    // Create the data dialog
    const dataDialog = document.createElement('div');
    dataDialog.style.position = 'fixed';
    dataDialog.style.top = '50%';
    dataDialog.style.left = '50%';
    dataDialog.style.transform = 'translate(-50%, -50%)';
    dataDialog.style.backgroundColor = 'white';
    dataDialog.style.padding = '2%';
    dataDialog.style.boxShadow = '0 2px 10px rgba(0, 0, 0, 0.1)';
    dataDialog.style.zIndex = '1000';
    dataDialog.style.borderRadius = '8px';
    dataDialog.style.width = '90%'; // Width relative to the screen
    dataDialog.style.maxWidth = '600px'; // Maximum width
    dataDialog.style.height = '80vh'; // Height relative to the viewport height
    dataDialog.style.overflowY = 'auto'; // Enable scrolling for content that overflows

    // Check if the items array is empty
    let itemsHtml = '';
    if (items.length === 0) {
        itemsHtml = `<p style="text-align: center; font-size: 16px; color: #555;">No Data Provided Yet</p>`;
    } else {
        // Format timestamp into human-readable date
        const formatTimestamp = (timestamp) => {
            const date = new Date(timestamp);
            return date.toISOString().replace('T', ' ').split('.')[0]; // yyyy-mm-dd hh:MM:ss
        };

        // Generate HTML content for the items
        items.forEach((item, index) => {
            itemsHtml += `
                <div style="margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid #ddd;">
                    <p style="word-wrap: break-word; overflow-wrap: break-word;"><strong>Date:</strong> ${formatTimestamp(item.createdAt)}</p>
                    <p style="word-wrap: break-word; overflow-wrap: break-word;"><strong>Recipient:</strong> ${item.recipient}</p>
                    <p style="word-wrap: break-word; overflow-wrap: break-word;"><strong>Data:</strong> ${item.data}</p>
                    <button id="downloadButton-${index}" style="padding: 5px 10px; font-size: 14px; background-color: #007BFF; color: white; border: none; cursor: pointer; border-radius: 4px;">
                        Download
                    </button>
                </div>
            `;
        });
    }

    // Add the content and close button to the dialog
    dataDialog.innerHTML = `
        <h3 style="margin-bottom: 20px;">Data List</h3>
        <div>
            ${itemsHtml}
        </div>
        <div style="margin-top: 20px; text-align: right;">
            <button id="closeDataButton" style="padding: 10px 20px; font-size: 14px; background-color: #007BFF; color: white; border: none; cursor: pointer; border-radius: 4px;">
                Close
            </button>
        </div>
    `;

    // Append the dialog to the overlay
    overlay.appendChild(dataDialog);

    // Attach download button event listeners
    items.forEach((item, index) => {
        document.getElementById(`downloadButton-${index}`).addEventListener('click', () => {
            overlay.remove()
            consumeData(orderId, item)
        });
    });

    // Close the dialog when clicking the "Close" button
    document.getElementById('closeDataButton').addEventListener('click', () => overlay.remove());

    // Close the dialog when clicking outside it
    overlay.addEventListener('click', (event) => {
        if (event.target === overlay) {
            overlay.remove();
        }
    });
}

// Initial load
fetchItems();