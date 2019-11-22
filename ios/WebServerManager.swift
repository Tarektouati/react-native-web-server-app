//
//  WebServerManager.swift
//  WebServerApp
//
//  Created by tarek touati on 22/11/2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation


@objc(WebServerManager)
class WebServerManager: NSObject {
  
  private enum ServerState {
    case Stopped
    case Running
  }
  private enum Errors: Error {
    case fileNotFound
    case fileNotReadable
  }
  private let webServer: GCDWebServer = GCDWebServer()
  private var serverRunning : ServerState =  ServerState.Stopped

     override init(){
        super.init()
    }

    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
  

   /**
   Read `index.html` file and return its content

  - Throws: `Errors.fileNotReadable`
         if the content of `filePath` is unreadable
         `Errors.fileNotFound`
         if file in `filePath` is not found
  - Returns: File content
   */

   private func getfileContent() throws -> String{
     if let filePath = Bundle.main.path(forResource: "index", ofType: "html") {
         do {
             let contents = try String(contentsOfFile: filePath)
             return contents
         } catch {
            throw Errors.fileNotReadable
         }
     } else {
       throw Errors.fileNotFound
     }
   }
  
  /**
   Creates an NSError with a given message.

  - Parameter message: The error message.

  - Returns: An error including a domain, error code, and error      message.
   */
   private func createError(message: String)-> NSError{
     let error = NSError(domain: "app.domain", code: 0,userInfo: [NSLocalizedDescriptionKey: message])
     return error
   }
  
  
  /**
  Initialization  of the `webserver`
   - Throws: `Errors.fileNotReadable`
              if the content of `filePath` is unreadable
             `Errors.fileNotFound`
              if  file in `filePath` is not found
  */
  public func initWebServer()throws{
   do{
      let content = try getfileContent()
      webServer.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: {request in
        return GCDWebServerDataResponse(html:content)
      })
   } catch Errors.fileNotFound {
      throw createError(message:"File not found")
  } catch Errors.fileNotReadable {
     throw createError(message:"File not readable")
    }
  }
  
  
  /**
  Stop `webserver` and update serverRunning variable to Stopped case
  */
  @objc public func stopServer() -> Void{
    if(serverRunning == ServerState.Running){
      webServer.stop()
      serverRunning = ServerState.Stopped
    }
  }
  
  /**
   Start `webserver` on the Main Thread
  - Returns:`Promise` to JS side, resolve the server URL and reject thrown errors
   */
   @objc public func startServer(_ resolve: RCTPromiseResolveBlock,
                           rejecter reject: RCTPromiseRejectBlock) -> Void
   {
     if (serverRunning == ServerState.Stopped){
       DispatchQueue.main.sync{
         do{
           try self.initWebServer()
           serverRunning = ServerState.Running
           webServer.start(withPort: 8080, bonjourName: "RN Web Server")
           resolve(webServer.serverURL?.absoluteString )
         } catch {

           reject("0", "Server init failed : \(error.localizedDescription)", error)
         }
       }
     } else {
       let errorMessage : String = "Server start failed"
       reject("0", errorMessage, createError(message:errorMessage))
     }
   }
}
