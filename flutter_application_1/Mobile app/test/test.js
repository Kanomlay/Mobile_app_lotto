const API_BASE_URL = 'https://render-lotto-deployment-3.onrender.com';
const responseDiv = document.getElementById('response');

// Helper function to display response
function displayResponse(data) {
    responseDiv.textContent = JSON.stringify(data, null, 2);
}


// Get All Trips
document.getElementById('getAllTrips').addEventListener('click', async () => {
    try {
        const response = await fetch(API_BASE_URL);
        const data = await response.json();
        displayResponse(data);
    } catch (error) {
        displayResponse({ error: error.message });
    }
});