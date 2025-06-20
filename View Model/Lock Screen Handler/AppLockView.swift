//
//  AppLockView.swift
//  Wholeseller
//
//  Created by CHANDAN on 20/06/25.
//

import SwiftUI

struct AppLockView: View {
    var onUnlock: () -> Void
    @State private var showCard = false

    var body: some View {
        ZStack {
            // Blurred background
            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
                .ignoresSafeArea()

            // Semi-transparent gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.black.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "lock.shield.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)

                    Text("Unlock the App")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Button(action: onUnlock) {
                        Text("Use Face ID / Touch ID")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal, 40)
                .scaleEffect(showCard ? 1 : 0.95)
                .opacity(showCard ? 1 : 0)
                .animation(.easeOut(duration: 0.3), value: showCard)
            }
            .onAppear {
                showCard = true
            }
        }
    }
}

// UIKit blur for SwiftUI background
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}
