//
//  main.swift
//  RandomWordGenerator
//
//  Created by Dongjin Jeon on 2022/05/28.
//

import Foundation

URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

// Refer to the example: https://grokswift.com/simple-rest-with-swift/
let todoEndpoint: String = "https://jsonplaceholder.typicode.com/todo/1"
guard let url = URL(string: todoEndpoint) else {
    print("Error: cannot create URL")
    exit(1)
}

let config = URLSessionConfiguration.default
let session = URLSession(configuration: config)
let urlRequest = URLRequest(url: url)

let task = session.dataTask(with: urlRequest) { (data, response, error) in
    
    // check for any errors
    guard error == nil else {
        print("error calling GET on /todos/1")
        print(error!)
        return
    }
    
    // make sure we got data
    guard let responseData = data else {
        print("Error: did not receive data")
        return
    }
    
    // check the status code
    guard let httpResponse = response as? HTTPURLResponse else {
        print("Error: It's not a HTTP URL response")
        return
    }
    
    
    // Reponse status
    print("Response status code: \(httpResponse.statusCode)")
    print("Response status debugDescription: \(httpResponse.debugDescription)")
    print("Response status localizedString: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
    
    // parse the result as JSON, since that's what the API provides
    do {
        guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                as? [String: Any] else {
            print("responseData: ", responseData)
            print("error trying to convert data to JSON")
            return
        }
        // now we have the todo
        // let's just print it to prove we can access it
        print("The todo is: " + todo.description)
        
        // the todo object is a dictionary
        // so we just access the title using the "title" key
        // so check for a title and print it if we have one
        guard let todoTitle = todo["title"] as? String else {
            print("Could not get todo title from JSON")
            print("responseData: \(String(data: responseData, encoding: String.Encoding.utf8))")
            return
        }
        print("The title is: " + todoTitle)
    } catch  {
        print("error trying to convert data to JSON")
        return
    }
}
task.resume()
