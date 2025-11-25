
import SwiftUI
import Combine
import AVFoundation


struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            MainMenuView()
        } else {
            ZStack {
               
                GeometryReader { geometry in
                    Image("game_background")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.5)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .ignoresSafeArea()
                }
                .ignoresSafeArea()
                
                VStack {
                    Image("icon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250,height: 250)
                    
                    // CHANGED: Updated app name
                    Text("SoapFun Smasher")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 3)
                        .frame(maxWidth: .infinity)
                      
                   
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct MainMenuView: View {
    
    @State private var showLevels = false
    @State private var showHowToPlay = false
    @State private var rotationAngle: Double = 0
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("game_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.5)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()
            
            
            ScrollView {
            VStack(spacing: 50) {
                // App Logo and Title with rotating soap circle
                VStack(spacing: 25) {
                    ZStack {
                        // Rotating soap images in a circle
                        ForEach(0..<5, id: \.self) { index in
                            let angle = Double(index) * (2 * .pi / 5) + rotationAngle
                            let radius: CGFloat = 100 // Distance from center
                            
                            Image("soap\(index + 1)")
                                .resizable()
                                .frame(width: 70, height: 70) // Even larger size
                                .offset(
                                    x: radius * cos(CGFloat(angle)),
                                    y: radius * sin(CGFloat(angle))
                                )
                        }
                        
                        // Center icon
                        Image("icon")
                            .resizable()
                            .frame(width: 120, height: 120)
                    }
                    .frame(width: 300, height: 300)
                    .onReceive(timer) { _ in
                        withAnimation(.linear(duration: 0.05)) {
                            rotationAngle += 0.1
                            if rotationAngle > 2 * .pi {
                                rotationAngle = 0
                            }
                        }
                    }
                    
                    // CHANGED: Updated app name
                    Text("SoapFun\nSmasher")
                        .font(.system(size: 50, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                    
                    // CHANGED: Updated tagline to match the fun theme
                    Text("Smash & Win!")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
                }
                
                // Menu Buttons
                VStack(spacing: 25) {
                    MenuButton(title: "Start Game", action: {
                        showLevels = true
                    })
                    
                    MenuButton(title: "Guide?", action: {
                        showHowToPlay = true
                    })
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, 40)
            
          }
        }
        .fullScreenCover(isPresented: $showLevels) {
            LevelSelectionView()
        }
        .sheet(isPresented: $showHowToPlay) {
            HowToPlayView()
        }
    }
}


struct MenuButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 3)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                 startPoint: .leading,
                                 endPoint: .trailing)
                )
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
}


struct LevelSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let levels = Array(1...6)
    
    var body: some View {
        ZStack {
         
            GeometryReader { geometry in
                Image("game_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.5)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()
            
            
            VStack(spacing: 30) {
                // CHANGED: Updated title to match new app name
                Text("SoapFun Smasher")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                Text("Select Stage")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.top, -10)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                    ForEach(levels, id: \.self) { level in
                        LevelButton(level: level)
                    }
                }
                .padding(.horizontal, 40)
                
                Button("Back") {
                    dismiss()
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(15)
                
                Spacer()
            }
        }
    }
}


struct LevelButton: View {
    let level: Int
    @State private var isActive = false
    
    var body: some View {
        Button(action: {
            isActive = true
        }) {
            VStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing))
                        .frame(width: 80, height: 80)
                    
                    Text("\(level)")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Text("Stage \(level)")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                
                Text("\(level * 6) soaps")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            ContentView(level: level)
        }
    }
}

struct HowToPlayView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
         
            GeometryReader { geometry in
                Image("game_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.5)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // CHANGED: Updated title
                Text("Guide?")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                VStack(alignment: .leading, spacing: 20) {
                    InstructionStep(number: "1", text: "Select a knife from the bottom")
                    InstructionStep(number: "2", text: "Tap on a soap to select it")
                    // CHANGED: Updated action text to match smash theme
                    InstructionStep(number: "3", text: "Press 'THROW KNIFE' to smash soap")
                    InstructionStep(number: "4", text: "Smash all soaps to complete level")
                    InstructionStep(number: "5", text: "Match same soaps for double points!")
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button("Got It!") {
                    dismiss()
                }
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding()
                .frame(width: 200)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                 startPoint: .leading,
                                 endPoint: .trailing)
                )
                .cornerRadius(25)
                .padding(.bottom, 40)
            }
        }
    }
}

struct InstructionStep: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text(number)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color.blue))
            
            Text(text)
                .font(.system(size: 18, design: .rounded))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}


// Pause Menu View
struct PauseMenuView: View {
    @Binding var isShowing: Bool
    let gameManager: GameManager
    let dismiss: DismissAction
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("Game Paused")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    Button(action: {
                        gameManager.resumeGame()
                        isShowing = false
                    }) {
                        Text("Resume Game")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        gameManager.resetGame()
                        isShowing = false
                        dismiss()
                    }) {
                        Text("Main Menu")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220)
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                }
                
                Button(action: {
                    isShowing = false
                }) {
                    Text("Close")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 10)
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.8))
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            )
            .padding(40)
        }
    }
}

struct SoapGridView: View {
    @ObservedObject var gameManager: GameManager
    @State private var soapFrames: [UUID: CGRect] = [:]
    
    var body: some View {
        GeometryReader { gridGeometry in
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 8) {
                ForEach(gameManager.soaps) { soap in
                    SoapView(soap: soap)
                        .background(
                            GeometryReader { soapGeometry in
                                Color.clear
                                    .onAppear {
                                        // Convert soap position to global coordinates
                                        let frame = soapGeometry.frame(in: .global)
                                        soapFrames[soap.id] = frame
                                        gameManager.updateSoapPosition(soap.id, position: CGPoint(x: frame.midX, y: frame.midY))
                                    }
                                    .onChange(of: soapGeometry.frame(in: .global)) { oldFrame, newFrame in
                                        soapFrames[soap.id] = newFrame
                                        gameManager.updateSoapPosition(soap.id, position: CGPoint(x: newFrame.midX, y: newFrame.midY))
                                    }
                            }
                        )
                        .onTapGesture {
                            gameManager.selectSoap(soap)
                        }
                        .opacity(soap.isHit ? 0 : 1)
                }
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(15)
        }
        .frame(height: CGFloat(gameManager.level) * 70) // Dynamic height based on level
    }
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]),
                             startPoint: .leading,
                             endPoint: .trailing)
            )
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.top, 50)
    }
}





struct ContentView: View {
    @State private var currentLevel: Int // Use @State to track current level
    @StateObject private var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    @State private var showPauseMenu = false
    
    init(level: Int) {
        self._currentLevel = State(initialValue: level)
        self._gameManager = StateObject(wrappedValue: GameManager(level: level))
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("game_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.5)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header with Level, Score and Timer - Compact Design
                    HStack {
                        // Level - Use currentLevel instead of the initial level parameter
                        VStack(spacing: 4) {
                            Text("LEVEL")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(currentLevel)") // Use currentLevel here
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Score
                        VStack(spacing: 4) {
                            Text("SCORE")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(gameManager.score)")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.yellow)
                        }
                        
                        Spacer()
                        
                        // Soaps Left
                        VStack(spacing: 4) {
                            Text("SOAPS")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(gameManager.soapsLeft)")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Timer
                        VStack(spacing: 4) {
                            Text("TIME")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(gameManager.timeRemaining)")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(gameManager.timeRemaining <= 10 ? .red : .green)
                        }
                        
                        // Pause Button
                        Button(action: {
                            gameManager.pauseGame()
                            showPauseMenu = true
                        }) {
                            Image(systemName: "pause.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .padding(.top, 50)
                    
                    // Soap Grid with Geometry Reader for exact positioning
                    SoapGridView(gameManager: gameManager)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // Knives Selection
                    VStack(spacing: 15) {
                        Text("Select Knife")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            ForEach(gameManager.knives) { knife in
                                KnifeView(knife: knife, isSelected: gameManager.selectedKnife?.id == knife.id)
                                    .onTapGesture {
                                        gameManager.selectKnife(knife)
                                    }
                            }
                        }
                        
                        // Throw Button
                        Button(action: {
                            gameManager.throwKnife()
                        }) {
                            Text("THROW KNIFE")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                )
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .padding(.horizontal, 40)
                        .disabled(gameManager.selectedKnife == nil || gameManager.selectedSoap == nil || gameManager.isThrowing || gameManager.selectedSoap?.isHit == true || gameManager.isPaused)
                        .opacity((gameManager.selectedKnife == nil || gameManager.selectedSoap == nil || gameManager.isThrowing || gameManager.selectedSoap?.isHit == true || gameManager.isPaused) ? 0.6 : 1.0)
                    }
                    .padding(.bottom, 30)
                }
                .padding(.top, 30)
            }
            
            // Flying Knife
            if let flyingKnife = gameManager.flyingKnife {
                KnifeFlightView(knife: flyingKnife.knife,
                              startPosition: flyingKnife.startPosition,
                              targetPosition: flyingKnife.targetPosition,
                              onComplete: {
                    gameManager.completeKnifeThrow()
                })
            }
            
            // Particle Effects
            ForEach(gameManager.particles) { particle in
                ParticleView(particle: particle)
            }
            
            // Toast Messages
            if let toastMessage = gameManager.toastMessage {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Game Over Overlay
            if gameManager.isGameOver {
                GameOverView(score: gameManager.score, level: currentLevel, gameManager: gameManager, dismiss: dismiss)
            }
            
            // Level Complete Overlay - Update to use currentLevel
            if gameManager.isLevelComplete {
                LevelCompleteView(
                    score: gameManager.score,
                    level: currentLevel,
                    gameManager: gameManager,
                    dismiss: dismiss,
                    onNextLevel: {
                        // Update currentLevel when moving to next level
                        currentLevel = gameManager.level
                    }
                )
            }
            
            // Pause Menu Overlay
            if showPauseMenu {
                PauseMenuView(
                    isShowing: $showPauseMenu,
                    gameManager: gameManager,
                    dismiss: dismiss
                )
            }
        }
        .ignoresSafeArea()
        .onChange(of: gameManager.level) { oldValue, newValue in
            // Update currentLevel when gameManager's level changes
            currentLevel = newValue
        }
    }
}

// Update LevelCompleteView to include onNextLevel callback
struct LevelCompleteView: View {
    let score: Int
    let level: Int
    let gameManager: GameManager
    let dismiss: DismissAction
    let onNextLevel: (() -> Void)? // Add callback
    
    init(score: Int, level: Int, gameManager: GameManager, dismiss: DismissAction, onNextLevel: (() -> Void)? = nil) {
        self.score = score
        self.level = level
        self.gameManager = gameManager
        self.dismiss = dismiss
        self.onNextLevel = onNextLevel
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("Level Complete!")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
                
                // CHANGED: Updated message to match smash theme
                Text("You smashed all the soaps!")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Level \(level)")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Score: \(score)")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.yellow)
                
                HStack(spacing: 20) {
                    if level < 6 {
                        Button(action: {
                            gameManager.nextLevel()
                            onNextLevel?() // Call the callback
                        }) {
                            Text("Next Level")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 140)
                                .background(Color.green)
                                .cornerRadius(20)
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Main Menu")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 140)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.7))
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            )
            .padding(40)
        }
    }
}

// Also update GameOverView to use currentLevel
struct GameOverView: View {
    let score: Int
    let level: Int
    let gameManager: GameManager
    let dismiss: DismissAction
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("Game Over!")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.red)
                
                Text("Time's Up!")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Level \(level)") // This will now show the correct level
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("\(score)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.yellow)
                
                HStack(spacing: 20) {
                    Button(action: {
                        gameManager.resetGame()
                    }) {
                        Text("Try Again")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 140)
                            .background(Color.orange)
                            .cornerRadius(20)
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Main Menu")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 140)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.7))
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            )
            .padding(40)
        }
    }
}

// Knife Flight Animation View
struct KnifeFlightView: View {
    let knife: Knife
    let startPosition: CGPoint
    let targetPosition: CGPoint
    let onComplete: () -> Void
    
    @State private var currentPosition: CGPoint
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var isHit = false
    
    init(knife: Knife, startPosition: CGPoint, targetPosition: CGPoint, onComplete: @escaping () -> Void) {
        self.knife = knife
        self.startPosition = startPosition
        self.targetPosition = targetPosition
        self.onComplete = onComplete
        self._currentPosition = State(initialValue: startPosition)
    }
    
    var body: some View {
        Text(knife.emoji)
            .font(.system(size: 40))
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .position(currentPosition)
            .onAppear {
                startFlightAnimation()
            }
    }
    
    private func startFlightAnimation() {
        // Calculate distance for animation duration
        let distance = sqrt(pow(targetPosition.x - startPosition.x, 2) + pow(targetPosition.y - startPosition.y, 2))
        let duration = min(0.8, max(0.3, Double(distance) / 800))
        
        // Flying animation with rotation
        withAnimation(.easeIn(duration: duration)) {
            currentPosition = targetPosition
            rotation = 720 // Two full rotations
        }
        
        // Hit effect after reaching target
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            isHit = true
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 1.3
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.2)) {
                    scale = 0.1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    onComplete()
                }
            }
        }
    }
}

// Particle Effect View
struct ParticleView: View {
    let particle: Particle
    
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        Text(particle.emoji)
            .font(.system(size: particle.size))
            .position(particle.position)
            .offset(offset)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                startParticleAnimation()
            }
    }
    
    private func startParticleAnimation() {
        // Random direction and distance
        let randomAngle = Double.random(in: 0..<360)
        let randomDistance = CGFloat.random(in: 20...80)
        let targetOffset = CGSize(
            width: cos(randomAngle * .pi / 180) * randomDistance,
            height: sin(randomAngle * .pi / 180) * randomDistance
        )
        
        withAnimation(.easeOut(duration: 0.8)) {
            offset = targetOffset
            scale = 0.5
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            // Particle will be removed automatically by the game manager
        }
    }
}

struct BubbleBackground: View {
    @State private var bubbles: [Bubble] = []
    
    struct Bubble: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
        var speed: Double
    }
    
    init() {
        var bubblesArray: [Bubble] = []
        for _ in 0..<15 {
            bubblesArray.append(Bubble(
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 30...80),
                opacity: Double.random(in: 0.1...0.3),
                speed: Double.random(in: 2...5)
            ))
        }
        _bubbles = State(initialValue: bubblesArray)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [
                    Color.blue.opacity(0.8),
                    Color.purple.opacity(0.6),
                    Color.pink.opacity(0.4)
                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                // Grassy sides
                HStack {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.7)]),
                                           startPoint: .top,
                                           endPoint: .bottom))
                        .frame(width: 20)
                        .overlay(
                            Rectangle()
                                .fill(Color.green.opacity(0.3))
                                .frame(height: 10)
                                .offset(y: -5)
                        )
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.7)]),
                                           startPoint: .top,
                                           endPoint: .bottom))
                        .frame(width: 20)
                        .overlay(
                            Rectangle()
                                .fill(Color.green.opacity(0.3))
                                .frame(height: 10)
                                .offset(y: -5)
                        )
                }
                .ignoresSafeArea()
                
                // Bubbles
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(Color.white.opacity(bubble.opacity))
                        .frame(width: bubble.size, height: bubble.size)
                        .position(
                            x: bubble.x * geometry.size.width,
                            y: bubble.y * geometry.size.height
                        )
                }
            }
        }
        .onAppear {
            // Animate bubbles
            withAnimation(Animation.linear(duration: 10).repeatForever()) {
                for i in 0..<bubbles.count {
                    bubbles[i].y = bubbles[i].y > 1 ? -0.2 : bubbles[i].y + 0.01 * bubbles[i].speed
                }
            }
        }
    }
}

struct SoapView: View {
    let soap: Soap
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(soap.color)
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 2)
                )
            
            // Use Image from assets instead of emoji
            Image(soap.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
        }
        .scaleEffect(soap.isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: soap.isSelected)
    }
}

struct KnifeView: View {
    let knife: Knife
    let isSelected: Bool
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.orange.opacity(0.3) : Color.clear)
                    .frame(width: 70, height: 70)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(knife.color)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(knife.emoji)
                            .font(.system(size: 30))
                    )
                    .rotationEffect(.degrees(knife.emoji == "🔪" ? 0 : knife.emoji == "🗡️" ? 45 : -45))
            }
            
            Text(knife.name)
                .font(.caption)
                .foregroundColor(.white)
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

// Data Models
struct Soap: Identifiable {
    let id = UUID()
    let type: Int
    let imageName: String
    let color: Color
    var isSelected: Bool = false
    var isHit: Bool = false
    
    static let types: [Soap] = [
        Soap(type: 1, imageName: "soap1", color: .blue),
        Soap(type: 2, imageName: "soap2", color: .green),
        Soap(type: 3, imageName: "soap3", color: .yellow),
        Soap(type: 4, imageName: "soap4", color: .purple),
        Soap(type: 5, imageName: "soap5", color: .orange)
    ]
}

struct Knife: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
    
    static let types: [Knife] = [
        Knife(name: "Classic", emoji: "🔪", color: .gray),
        Knife(name: "Dagger", emoji: "🗡️", color: .blue),
        Knife(name: "Axe", emoji: "🪓", color: .brown)
    ]
}

struct FlyingKnife {
    let knife: Knife
    let startPosition: CGPoint
    let targetPosition: CGPoint
}

struct Particle: Identifiable {
    let id = UUID()
    let emoji: String
    let position: CGPoint
    let size: CGFloat
}

// Sound Manager for handling audio
class SoundManager: ObservableObject {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playCutSound() {
        guard let url = Bundle.main.url(forResource: "cut_sound", withExtension: "mp3") else {
            // If no sound file exists, we'll use system sound
            AudioServicesPlaySystemSound(1103) // System knife/sword sound
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.7
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
            // Fallback to system sound
            AudioServicesPlaySystemSound(1103)
        }
    }
}

class GameManager: ObservableObject {
    @Published var soaps: [Soap] = []
    @Published var knives: [Knife] = Knife.types
    @Published var selectedKnife: Knife?
    @Published var selectedSoap: Soap?
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isLevelComplete: Bool = false
    @Published var isThrowing: Bool = false
    @Published var flyingKnife: FlyingKnife?
    @Published var particles: [Particle] = []
    @Published var toastMessage: String?
    @Published var isPaused: Bool = false
    
    private var timer: Timer?
    public var level: Int
    private var totalSoaps: Int
    private var soapPositions: [UUID: CGPoint] = [:]
    private var soundManager = SoundManager.shared
    
    var soapsLeft: Int {
        soaps.filter { !$0.isHit }.count
    }
    
    init(level: Int) {
        self.level = level
        self.totalSoaps = level * 6
        startGame()
    }
    
    func startGame() {
        generateSoaps()
        setupTimer()
        startTimer()
    }
    
    private func setupTimer() {
        timeRemaining = 30 + (level - 1) * 10
    }
    
    func generateSoaps() {
        var newSoaps: [Soap] = []
        for _ in 0..<totalSoaps {
            let randomSoap = Soap.types.randomElement()!
            newSoaps.append(Soap(type: randomSoap.type, imageName: randomSoap.imageName, color: randomSoap.color))
        }
        soaps = newSoaps
    }
    
    func updateSoapPosition(_ soapId: UUID, position: CGPoint) {
        soapPositions[soapId] = position
    }
    
    func selectKnife(_ knife: Knife) {
        selectedKnife = knife
        // Deselect any previously selected soap
        if let selectedSoap = selectedSoap {
            deselectSoap(selectedSoap)
        }
    }
    
    func selectSoap(_ soap: Soap) {
        // Don't allow selecting hit soaps
        guard !soap.isHit else { return }
        
        // Deselect previous soap
        if let previousSelected = selectedSoap {
            deselectSoap(previousSelected)
        }
        
        // Select new soap
        if let index = soaps.firstIndex(where: { $0.id == soap.id }) {
            soaps[index].isSelected = true
            selectedSoap = soaps[index]
        }
    }
    
    func deselectSoap(_ soap: Soap) {
        if let index = soaps.firstIndex(where: { $0.id == soap.id }) {
            soaps[index].isSelected = false
        }
    }
    
    func throwKnife() {
        guard let selectedKnife = selectedKnife,
              let selectedSoap = selectedSoap,
              !selectedSoap.isHit,
              !isThrowing,
              !isPaused else { return }
        
        isThrowing = true
        
        // Calculate positions for animation
        let startPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
        
        // Get the exact position from our stored positions
        let targetPosition = soapPositions[selectedSoap.id] ?? calculateFallbackPosition(selectedSoap)
        
        // Create flying knife
        flyingKnife = FlyingKnife(
            knife: selectedKnife,
            startPosition: startPosition,
            targetPosition: targetPosition
        )
    }
    
    private func calculateFallbackPosition(_ soap: Soap) -> CGPoint {
        // Fallback calculation if GeometryReader fails
        let gridWidth = UIScreen.main.bounds.width - 80 // Account for padding
        let cellWidth = gridWidth / 6
        let startY: CGFloat = 200 // Adjusted start position
        
        if let index = soaps.firstIndex(where: { $0.id == soap.id }) {
            let row = index / 6
            let col = index % 6
            let x = 40 + (CGFloat(col) * cellWidth) + (cellWidth / 2)
            let y = startY + (CGFloat(row) * 58) + 25
            return CGPoint(x: x, y: y)
        }
        
        return CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    }
    
    func completeKnifeThrow() {
        guard let selectedKnife = selectedKnife,
              let selectedSoap = selectedSoap else { return }
        
        // Play cut sound effect
        soundManager.playCutSound()
        
        // Create particle effects at the exact hit position
        let hitPosition = flyingKnife?.targetPosition ?? .zero
        createParticleEffects(at: hitPosition)
        
        // Check for same soap neighbors for double points
        let pointsEarned = checkForSameSoapNeighbors(selectedSoap) ? 20 : 10
        
        // Increase score
        score += pointsEarned
        
        // Show toast message for double points
        if pointsEarned == 20 {
            showToast("Double Points! +20")
        }
        
        // Mark soap as hit
        if let index = soaps.firstIndex(where: { $0.id == selectedSoap.id }) {
            soaps[index].isHit = true
        }
        
        // Clean up
        flyingKnife = nil
        isThrowing = false
        self.selectedSoap = nil
        
        // Check if level is complete
        checkLevelComplete()
    }
    
    private func checkForSameSoapNeighbors(_ soap: Soap) -> Bool {
        guard let hitIndex = soaps.firstIndex(where: { $0.id == soap.id }) else { return false }
        
        let row = hitIndex / 6
        let col = hitIndex % 6
        
        // Check left neighbor
        if col > 0 {
            let leftIndex = hitIndex - 1
            if soaps[leftIndex].type == soap.type && !soaps[leftIndex].isHit {
                return true
            }
        }
        
        // Check right neighbor
        if col < 5 && hitIndex + 1 < soaps.count {
            let rightIndex = hitIndex + 1
            if soaps[rightIndex].type == soap.type && !soaps[rightIndex].isHit {
                return true
            }
        }
        
        return false
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.toastMessage = nil
        }
    }
    
    private func createParticleEffects(at position: CGPoint) {
        let particleEmojis = ["✨", "💫", "⭐️", "🌟", "💥", "🔥"]
        var newParticles: [Particle] = []
        
        for _ in 0..<8 {
            let randomEmoji = particleEmojis.randomElement() ?? "✨"
            let randomSize = CGFloat.random(in: 15...30)
            
            newParticles.append(Particle(
                emoji: randomEmoji,
                position: position,
                size: randomSize
            ))
        }
        
        particles = newParticles
        
        // Remove particles after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.particles.removeAll()
        }
    }
    
    private func checkLevelComplete() {
        if soapsLeft == 0 {
            levelComplete()
        }
    }
    
    private func levelComplete() {
        isLevelComplete = true
        timer?.invalidate()
        timer = nil
    }
    
    func nextLevel() {
        if level < 6 {
            level += 1
            totalSoaps = level * 6
            resetGame()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if !self.isPaused {
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.endGame()
                }
            }
        }
    }
    
    func pauseGame() {
        isPaused = true
        timer?.invalidate()
    }
    
    func resumeGame() {
        isPaused = false
        startTimer()
    }
    
    func endGame() {
        isGameOver = true
        timer?.invalidate()
        timer = nil
    }
    
    func resetGame() {
        score = 0
        isGameOver = false
        isLevelComplete = false
        isThrowing = false
        isPaused = false
        selectedKnife = nil
        selectedSoap = nil
        flyingKnife = nil
        particles.removeAll()
        toastMessage = nil
        soapPositions.removeAll()
        setupTimer()
        generateSoaps()
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
}
