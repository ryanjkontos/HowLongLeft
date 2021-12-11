//
//  ScrollViewIfNeeded.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 1/12/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct ScrollViewIfNeeded: ViewModifier {
    
    var height: CGFloat
    
    func body(content: Content) -> some View {
        
        if height < 400 {
            
            ScrollView(showsIndicators: true) {
                content
            }
            .padding(.vertical, 5)
            .introspectScrollView(customize: { scrollView in
                scrollView.flashScrollIndicators()
            })
            
        } else {
            content
                .padding(.vertical, 20)

        }
            
            
    }
}

extension View {
    func scrollIfNeeded(height: CGFloat) -> some View {
        modifier(ScrollViewIfNeeded(height: height))
    }
}

struct TitleButtonPadding: ViewModifier {
    
    var height: CGFloat
    
    func body(content: Content) -> some View {
        
    
        content
        
        .padding(.bottom, getBottomPadding(viewHeight: height))
        .padding(.top, getTopPadding(viewHeight: height))
            
            
    }
    
    func getTopPadding(viewHeight height: CGFloat) -> CGFloat {
        
        print("Height: \(height)")
        
        if height < 400 {
            
            return 5
        }
        
        
        if height < 630 {
            return 30
        }
        
        return 40
        
    }
    
    func getBottomPadding(viewHeight height: CGFloat) -> CGFloat {
        
        print("Height: \(height)")
        
        if height < 400 {
            
            return 5
        }
        
        
        if height < 850 {
            return 20
        }
        
        return 40
        
    }
    
    
}

extension View {
    func titleButtonPadding(height: CGFloat) -> some View {
        modifier(TitleButtonPadding(height: height))
    }
}
