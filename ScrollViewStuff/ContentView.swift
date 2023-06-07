//
//  ContentView.swift
//  ScrollViewStuff
//
//  Created by Truong Kyle on 22/05/2023.
//

import SwiftUI

class Model: ObservableObject {
    @Published var tabBarYOffset: CGFloat = .zero
}

struct ContentView: View {
    
    @StateObject private var model = Model()
    @State private var selection: Int = .zero
    @State private var offset: CGPoint = .zero
    
    var body: some View {
        ZStack(alignment: .top) {
            // Hero image
            Image(systemName: "globe")
                .resizable()
                .scaledToFit()
                .frame(height: 300)

            // Tab bar
            HStack(spacing: 20) {
                Button("Tab 1") {
                    selection = 0
                }

                Button("Tab 2") {
                    selection = 1
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .padding(.horizontal)
            .background(.thinMaterial)
            .offset(y: max(250-model.tabBarYOffset, .zero))
            .zIndex(1)

            // Tab content
            TabView(selection: $selection) {
                TabContentVScrollView {
                    ForEach(0..<100) { idx in
                        Text("Tab \(selection + 1) - Line at \(idx)")
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color.yellow)
                }
                .tag(0)

                TabContentVScrollView {
                    ForEach(0..<100) { idx in
                        Text("Tab \(selection + 1) - Line at \(idx)")
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color.green)
                }
                .tag(1)
            }
            .environmentObject(model)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: - Tab Content View

// UIKit ScrollView
struct TabContentVScrollView<Content: View>: View {
    
    @EnvironmentObject var model: Model
    @ViewBuilder let content: Content
    @State private var offset: CGPoint = .zero
    
    var body: some View {
        VScrollView(offset: $offset) {
            VStack(spacing: .zero) {
                // Transparency
                Color.clear
                    .frame(height: 300)
                // Main content
                content
            }
        }
        .onChange(of: offset.y) { newValue in
            model.tabBarYOffset = newValue
        }
        .onAppear {
            offset.y = model.tabBarYOffset
            print("--> onAppear \(offset.y)")
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// Native SwiftUI Scroll View
struct TabContentScrollView<Content: View>: View {
    
    @EnvironmentObject var model: Model
    @ViewBuilder let content: Content
    @State private var offset: CGPoint = .zero
    
    var body: some View {
        OffsetObservingScrollView(offset: $offset) {
            VStack(spacing: .zero) {
                // Transparency
                Color.clear
                    .frame(height: 300)
                // Main content
                content
            }
        }
        .onChange(of: offset.y) { newValue in
            model.tabBarYOffset = newValue
        }
        .onAppear {
            offset.y = model.tabBarYOffset
            print("--> onAppear \(offset.y)")
        }
        .background(Color.red)
        .edgesIgnoringSafeArea(.bottom)
    }
}
