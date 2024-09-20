//
//  ContentView.swift
//  MultiplicationDungeon
//
//  Created by Izabela Marcinkowska on 2024-09-17.
//

import SwiftUI

struct ContentView: View {
    @State private var wishedAmountQuestions = 5
    @State private var wishedLevel = 7
    @State private var isGameActive = false
    @State private var finalScore = 0
    @State private var showAlert = false
    @State private var setAmountOfQuestions = false
    @State private var setLevelSelection = false
    
    var body: some View {
        let backgroundGradient = LinearGradient(
            colors: [Color.yellow, Color("Green-light")],
            startPoint: .top, endPoint: .bottom)
        ZStack{
            backgroundGradient
            VStack (spacing: 120) {
                HStack{
                    VStack{
                        Text("Questions")
                            .padding()
                            .multilineTextAlignment(.center)
                            .font(.custom(
                                "Chalkduster",
                                fixedSize: 28))
                        Button () {
                            setAmountOfQuestions = true
                        } label: {
                            NumberPicture(picture: wishedAmountQuestions)
                        }.sheet(isPresented: $setAmountOfQuestions) {
                            AmountOfQuestions { selectedAmount in
                                wishedAmountQuestions = selectedAmount
                            }
                        }
                    }.frame(width: 190, height: 190)
                    VStack{
                        Text("Level")
                            .padding()
                            .multilineTextAlignment(.center)
                            .font(.custom(
                                "Chalkduster",
                                fixedSize: 28))
                        Button() {
                            setLevelSelection = true
                        } label: {
                            NumberPicture(picture: wishedLevel)
                        }
                        .sheet(isPresented: $setLevelSelection) {
                            LevelSelection { selectedLevel in
                                wishedLevel = selectedLevel
                            }
                        }
                    }.frame(width: 180, height: 180)
                }
                VStack {
                    Button() {
                        isGameActive = true
                    } label: {
                        Image("start-game").resizable().frame(width: 300, height: 300).shadow(color: .black.opacity(0.5), radius: 6)
                    }
                }
            }
            .sheet(isPresented: $isGameActive) {
                GameView(
                    wishedAmountQuestions: wishedAmountQuestions,
                    wishedLevel: wishedLevel,
                    onGameEnd: { score in
                        finalScore = score
                        isGameActive = false
                        showAlert = true
                    }
                )
            }
            .alert("Game Over! Your score is \(finalScore)", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
        }.ignoresSafeArea()
    }
    
    
    
}



struct GameView: View {
    let wishedAmountQuestions: Int
    let wishedLevel: Int
    let onGameEnd: (Int) -> Void
    
    let backgroundGradient = LinearGradient(
        colors: [Color.yellow, Color.red],
        startPoint: .top, endPoint: .bottom)
    
    @State private var currentQuestion = 0
    @State private var answerText = ""
    @State private var amountPoints = 0
    @State private var questions = [Question]()
    @State private var isAnswerCorrect: Bool? = nil
    
    @State private var userGotPoint = false
    
    
    var body: some View {
        ZStack{
            backgroundGradient.ignoresSafeArea()
            VStack {
                
                VStack {
                    Text("You have \(amountPoints) points").font(.custom(
                        "Chalkduster",
                        fixedSize: 36))
                    if let isCorrect = isAnswerCorrect {
                        Text(isCorrect ? "Correct!" : "Incorrect")
                            .font(.headline)
                            .foregroundColor(isCorrect ? .green : .red)
                            .transition(.opacity)
                    }
                }
                Spacer()
                HStack {
                    NumberPicture(picture: questions.isEmpty ? 1 : questions[currentQuestion].firstNumber)
                    Image("11")
                        .resizable()
                        .frame(width: 45, height: 40)
                    NumberPicture(picture: questions.isEmpty ? 1 : questions[currentQuestion].secondNumber)
                }
                VStack {
                    
                    Text("My answer is...")
                        .padding()
                        .font(.custom(
                            "Chalkduster",
                            fixedSize: 36))
                    TextField("Answer", text: $answerText)
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .italic()
                        .keyboardType(.numbersAndPunctuation)
                        .submitLabel(.done) // This shows "Done" on the return key
                        .onSubmit {
                            submitAnswer()
                        }
                }
                Spacer()
            }
        }
        .onAppear {
            generateQuestions()
        }
        
        
    }
    
    func generateQuestions() {
        for _ in 0..<wishedAmountQuestions {
            questions.append(Question(level: wishedLevel))
        }
    }
    
    func submitAnswer() {
        guard let answerInt = Int(answerText) else {
            print("Please enter a valid number.")
            return
        }
        
        if questions[currentQuestion].checkAnswer(answer: answerInt) {
            amountPoints += 1
            isAnswerCorrect = true
        } else {
            isAnswerCorrect = false
        }
        if currentQuestion < wishedAmountQuestions - 1 {
            // Move to the next question after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                currentQuestion += 1
                answerText = ""
                isAnswerCorrect = nil // Reset feedback
            }
        } else {
            // End the game after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                onGameEnd(amountPoints)
            }
        }
        
    }
}

struct Question {
    let firstNumber: Int
    let secondNumber: Int
    let correctAnswer: Int
    
    init(level: Int) {
        self.firstNumber = Int.random(in: 1...level)
        self.secondNumber = Int.random(in: 1...level)
        self.correctAnswer = firstNumber * secondNumber
    }
    
    func checkAnswer(answer: Int) -> Bool {
        return answer == correctAnswer
    }
}

struct AmountOfQuestions: View {
    let onSetAmount: (Int) -> Void
    
    let backgroundGradient = LinearGradient(
        colors: [Color.yellow, Color.blue],
        startPoint: .top, endPoint: .bottom)
    
    @Environment(\.dismiss) var dismiss // Environment variable to dismiss the sheet
    
    init(onSetAmount: @escaping (Int) -> Void) {
        self.onSetAmount = onSetAmount
    }
    var body: some View {
        ZStack {
            backgroundGradient
            VStack(spacing: 40){
                Text("Amount questions I want to answer is:")
                    .padding()
                    .multilineTextAlignment(.center)
                    .font(.custom(
                        "Chalkduster",
                        fixedSize: 32))
                HStack(spacing: 40){
                    Button () {
                        onSetAmount(1)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 1)
                    }
                    Button () {
                        onSetAmount(2)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 2)
                    }
                    Button () {
                        onSetAmount(3)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 3)
                    }
                }
                HStack(spacing: 40){
                    Button () {
                        onSetAmount(4)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 4)
                    }
                    Button () {
                        onSetAmount(5)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 5)
                    }
                    Button () {
                        onSetAmount(6)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 6)
                    }
                }
                HStack(spacing: 40){
                    Button () {
                        onSetAmount(7)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 7)
                    }
                    Button () {
                        onSetAmount(8)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 8)
                    }
                    Button () {
                        onSetAmount(9)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 9)
                    }
                }
            }
        }.ignoresSafeArea()
    }
    
    
    
}

struct LevelSelection: View {
    let onSetLevel: (Int) -> Void
    
    let backgroundGradient = LinearGradient(
        colors: [Color.yellow, Color.purple],
        startPoint: .top, endPoint: .bottom)
    
    @Environment(\.dismiss) var dismiss
    
    init(onSetLevel: @escaping (Int) -> Void) {
        self.onSetLevel = onSetLevel
    }
    
    var body: some View {
        ZStack{
            backgroundGradient
            VStack(spacing: 40) {
                Text("Table I want to answer is up to:")
                    .padding()
                    .multilineTextAlignment(.center)
                    .font(.custom(
                        "Chalkduster",
                        fixedSize: 32))
                HStack(spacing: 40){
                    Button () {
                        onSetLevel(1)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 1)
                    }
                    Button () {
                        onSetLevel(2)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 2)
                    }
                    Button () {
                        onSetLevel(3)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 3)
                    }
                }
                HStack(spacing: 40){
                    Button () {
                        onSetLevel(4)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 4)
                    }
                    Button () {
                        onSetLevel(5)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 5)
                    }
                    Button () {
                        onSetLevel(6)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 6)
                    }
                }
                HStack(spacing: 40){
                    Button () {
                        onSetLevel(7)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 7)
                    }
                    Button () {
                        onSetLevel(8)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 8)
                    }
                    Button () {
                        onSetLevel(9)
                        dismiss()
                    } label: {
                        NumberPicture(picture: 9)
                    }
                }
            }
        }.ignoresSafeArea()
    }
    
    
}

struct NumberPicture: View {
    var picture: Int
    var body: some View {
        Image("\(picture)")
            .resizable()
            .frame(width: 100.0, height: 150.0)
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
