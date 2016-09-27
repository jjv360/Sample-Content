
import Foundation
import JavaScriptCore

public class Plugin {
    
    var ctx : JSContext!
    public var onmessage : ((_ data : AnyObject?) -> Void)?
    
    public init(file : URL) {
        
        // Create Javascript context
        ctx = JSContext()
        ctx.name = "My Javascript Context"
        
        // Create postMessage code block that will get exposed to Javascript as a function
        let postMessageBlock : @convention(block) (AnyObject?) -> Void = { [weak self] (data) in
            
            // Pass message to host app
            self?.onmessage?(data)
            
        }
        
        // Expose the postMessage code block as a Javascript function
        ctx.globalObject.setValue(unsafeBitCast(postMessageBlock, to: AnyObject.self), forProperty: "postMessage")
        
        // Read the Javascript code into a string
        if let code = try? String(contentsOf: file, encoding: .utf8) {
            
            // Execute the Javascript code
            ctx.evaluateScript(code, withSourceURL: file)
        
        }
        
    }
    
    /** Sends a message to the plugin */
    public func postMessage(data : AnyObject?) {
        
        // Find the plugin's onmessage handler
        let handler = ctx.globalObject.forProperty("onmessage")
        
        // Send message
        handler?.call(withArguments: data == nil ? [] : [data])
        
    }
    
}
