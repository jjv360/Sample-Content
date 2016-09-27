// This function is called by our host app
function onmessage(data) {
    
    // Just pass all incoming messages back to the host app, and add a message
    postMessage(data + " Modified by Javascript!");
    
}
