//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Sondre Stokkan Spæren on 21/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var appMove = "Rock"
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var playerMove = ""
    @State private var correctAnswer = ""
    @State private var numberOfQuestions = 0
    @State private var showScore = false
    @State private var endOfGame = false
    @State private var scoreTitle = ""
    @State private var summary = ""
    
    let moves = ["Rock", "Paper", "Scissors"]
    
    let movesDict = ([
        "Rock": "Scissor",
        "Paper": "Rock",
        "Scissors": "Paper"
    ])
    
    func nextQuestion() {
        appMove = moves[Int.random(in: 0...2)]
        shouldWin = .random()
        setCorrectAnswer()
        
        if numberOfQuestions > 10{
            endOfGame = true
            summary = "End of game"
        }
    }
    
    func setCorrectAnswer() {
        if shouldWin {
            correctAnswer = movesDict.someKey(forValue: appMove) ?? "Unknown"
        } else {
            correctAnswer = movesDict[appMove] ?? "Unknown"
        }
    }
    
    func moveTapped(move: String) {
        if move == correctAnswer {
            scoreTitle = "Correct! \(move) was the correct choice"
            score += 1
        } else {
            scoreTitle = "Incorrect. The correct answer was \(correctAnswer)"
        }
        showScore = true
        numberOfQuestions += 1
    }
    
    func restartGame() {
        score = 0
        numberOfQuestions = 1
        nextQuestion()
    }
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            LinearGradient(colors: [Color.cyan.opacity(0.8), Color.clear], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("RPS Bot 2000")
                    .font(.largeTitle).bold()
                    .padding(.vertical, 30)
                HStack(spacing: 30){
                    VStack{
                        Text("Current move is")
                        Text(appMove)
                            .font(.title.bold())
                    }
                    VStack{
                        Text("Win or lose?")
                        Text("\(shouldWin ? "Win" : "Lose")")
                            .font(.title.bold())
                    }
                }
                VStack(spacing: 15){
                    Text("Select your move")
                        .font(.title2).bold()
                        .padding(.vertical,34)
                    ForEach(moves, id: \.self){move in
                        Button(action: {
                            moveTapped(move: move)
                        }, label: {
                            VStack{
                                Text(move)
                                    .bold()
                                    .foregroundStyle(.black.opacity(0.8))
                            }
                            .frame(width: 200)
                            .padding(20)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        })
                    }
                    Spacer()
                }
                Text("Score: \(score)")
                    .font(.title).bold()
                    .padding(.bottom, 30)
                    .padding(.bottom, 60)
            }
            .foregroundStyle(.white)
            .alert(scoreTitle, isPresented: $showScore) {
                Button("Continue", action: nextQuestion)
            } message: {
                Text("Your score is: \(score)")
            }
            .alert(summary, isPresented: $endOfGame){
                Button("Restart", action: restartGame)
            } message: {
                Text("Your final score was: \(score)")
            }
        }
    }
}

#Preview {
    ContentView()
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
