//
//  WordsView.swift
//  RandomWordGenerator
//
//  Created by Dongjin Jeon on 2022/05/30.
//

import SwiftUI

struct WordsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var numberOfWords:Int
    
    @State var words:[String] = []
    
    var body: some View {
        VStack {
            if(words==[]){
                Spacer()
                Text("Please Wait...")
            } else {
                Spacer()
                Text("\(numberOfWords) words Generated!").bold()
                Spacer()
                ForEach(words, id: \.self) { word in
                    Text(word)
                }
            }
            Spacer()
            Button("Back") {
                self.presentationMode.wrappedValue.dismiss()
            }
        }.task {
            await requestWords(numberOfWords: numberOfWords)
        }
    }
    
    
    // API 통신을 통해 Random word를 받는 형식
    func requestWords(numberOfWords:Int) async {
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

        // Refer to the example: https://grokswift.com/simple-rest-with-swift/
        let todoEndpoint: String = "https://random-word-api.herokuapp.com/word?number=\(numberOfWords)"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            exit(1)
        }

        //let config = URLSessionConfiguration.default
        let session = URLSession.shared
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
                let json:[String] = try JSONDecoder().decode([String].self, from: responseData)
                print(json)
                words = json
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
}

struct WordsView_Previews: PreviewProvider {
    static var previews: some View {
        WordsView(numberOfWords: 3)
    }
}
