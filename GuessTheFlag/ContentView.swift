//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Garrett Keyes on 11/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var selectedFlag: Int? = nil
    @State private var animationAmount = 0.0
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var questionCount = 0
    @State private var showingGameOver = false
    let maxQuestions = 8
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red:0.1, green:0.2, blue:0.45), location: 0.3),
                .init(color: Color(red:0.76, green:0.15, blue:0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .titleStyle()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){number in
                        Button{
                            selectedFlag = number
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                                animationAmount += 360
                            }
                            flagtapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                                .rotation3DEffect(
                                    .degrees(selectedFlag == number ? animationAmount : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .opacity(
                                    selectedFlag == nil || selectedFlag == number ? 1 : 0.25
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
        .alert("Game Over", isPresented: $showingGameOver) {
            Button("Play Again") {
                restartGame()
            }
        } message: {
            Text("Your final score is \(userScore) out of \(maxQuestions).")
        }
    }
    
    func flagtapped(_ number: Int){
        
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Incorrect, that is the \(countries[number]) flag."
        }

        questionCount += 1
        showingScore = true
    }
    
    func askQuestion() {
        if questionCount >= maxQuestions {
            // End the game and show final score
            showingGameOver = true
        } else {
            selectedFlag = nil
            animationAmount = 0
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func restartGame() {
        userScore = 0
        questionCount = 0
        selectedFlag = nil
        animationAmount = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: View {
    let name: String

    var body: some View {
        Image(name)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(TitleStyle())
    }
}

#Preview {
    ContentView()
}
