//
//  UIScrollViewWrapper.swift
//  ScrollViewStuff
//
//  Created by Truong Kyle on 22/05/2023.
//

import SwiftUI

struct VScrollView<Content: View>: UIViewRepresentable {
    
    @Binding var offset: CGPoint
    
    let content: Content
    
    init(
        offset: Binding<CGPoint>,
        @ViewBuilder content: () -> Content)
    {
        _offset = offset
        self.content = content()
    }
    
    func makeCoordinator() -> ScrollViewCoordinator {
        ScrollViewCoordinator(offset: $offset)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let coordinator = context.coordinator
        
        let scrollView = UIScrollView()
        scrollView.delegate = coordinator
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let hostingController = UIHostingController(rootView: content)
        let hostedView = hostingController.view!
        hostedView.backgroundColor = .clear
        scrollView.addSubview(hostedView)
        
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        hostedView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
        hostedView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
        hostedView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        hostedView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        
        // this is important for scrolling
        hostedView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        return scrollView
    }
    
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
//        print("--> updateUIView \(offset.y)")
//        scrollView.layoutIfNeeded()
        scrollView.contentOffset.y = offset.y
    }
}

class ScrollViewCoordinator : NSObject, UIScrollViewDelegate {
    
    @Binding var offset: CGPoint
    
    init(offset: Binding<CGPoint>) {
        _offset = offset
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        DispatchQueue.main.async {
//            print("--> scrollDidScroll \(scrollView.contentOffset.y)")
            self.offset = scrollView.contentOffset
//        }
    }
}
