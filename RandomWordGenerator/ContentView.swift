//
//  ContentView.swift
//  RandomWordGenerator
//
//  Created by Dongjin Jeon on 2022/05/26.
//

import SwiftUI



struct ContentView: View {
    @State private var numberOfWords : Int = 0
    @State private var showingAlert = false
    @State private var showModal = false
    
    var body: some View {
        NavigationView{
            
            VStack {
                VStack {
                    // 제목
                    Text("Random Word Generator")
                        .padding()
                    
                    // 단어 갯수를 입력하는 TextField
                    HStack {
                        Spacer()
                        Text("Number of words")
                        TextField("1 ~ 15", value: $numberOfWords, formatter: NumberFormatter())
                    }.padding()
                    
                    // 다음으로 넘어가는 버튼
                    Button("Generate!") {
                        if(numberOfWords >= 1 && numberOfWords <= 15) {
                            
                            showModal = true
                        } else {
                            showingAlert = true
                            showModal = false
                        }
                    }.padding().alert(isPresented: $showingAlert) {
                        Alert(title: Text("단어 개수 에러"), message: Text("1에서 15까지의 숫자만 입력 가능합니다."), dismissButton: .default(Text("확인")))
                    }.sheet(isPresented: self.$showModal) {
                        WordsView(numberOfWords: numberOfWords)
                    }
                    NavigationLink(destination: WordsView(numberOfWords: numberOfWords) ) {
                        Text("Generate")
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text("단어 개수 에러"), message: Text("1에서 15까지의 숫자만 입력 가능합니다."), dismissButton: .default(Text("확인")))
                    }
                    
                    
                    
                }
            }
        }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
