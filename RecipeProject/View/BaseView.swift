//
//  BaseView.swift
//  RecipeProject
//
//  
//

import SwiftUI

// Eine Stammansicht, die Tabs und ihre untergeordneten Ansichtsinstanzen enthält.
struct BaseView: View {
    
    @State var currentTab = Constants.TabsIdentifer.home
    @State var curveAxis: CGFloat = 0
    
    init() {
        // native tab bar ausblenden
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Tab view
            TabView(selection: $currentTab) {
                
                // Tab Items
                HomeView()
                    .tag(Constants.TabsIdentifer.home)
                    .padding(.bottom, 70) // will protect child views show behind with tabs.

                FavListView()
                    .tag(Constants.TabsIdentifer.favourite)
                    .padding(.bottom, 70) // will protect child views show behind with tabs.

                QuizLandingView()
                    .tag(Constants.TabsIdentifer.quiz)
                    .padding(.bottom, 70)
            }
            .clipShape(CustomTabCurve(curveAxis: curveAxis))
            .padding(.bottom, -80)
            HStack(spacing: 0) {
                // Tab item buttons
                TabButtons()
            }
            .frame(height: 70)
            .padding(.horizontal, 35)
        }
        .background(Color.primaryColor)
        .ignoresSafeArea(.all)
    }
    
    @ViewBuilder
    func TabButtons() -> some View {
        ForEach([Constants.TabsIdentifer.home, .favourite, .quiz], id: \.self) { image in
            
            GeometryReader { proxy in
                // da wir die aktuelle Position für die Kurve benötigen.
                Button {
                    withAnimation {
                        currentTab = image
                        // updating curve axis
                        curveAxis = proxy.frame(in: .global).midX
                    }
                } label: {
                    Image(systemName: image.rawValue).font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(
                            Circle().fill(Color.primaryColor)
                        )
                        .offset(y: currentTab == image ? -25 : 0)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .onAppear {
                    // initial update
                    if curveAxis == 0 && image == Constants.TabsIdentifer.home {
                        curveAxis = proxy.frame(in: .global).midX
                    }
                }
            }
        }
    }
}


// MARK: - CustomTabCurve Shape implementation
struct CustomTabCurve: Shape {
    
    var curveAxis: CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            // Kurve über 100 von unten
            let height: CGFloat = rect.height - 100
            
            // Draw points
            let pt1 = CGPoint(x: 0, y: 0)
            let pt2 = CGPoint(x: rect.width, y: 0)
            let pt3 = CGPoint(x: rect.width, y: height)
            let pt4 = CGPoint(x: 0, y: height)
            
            path.move(to: pt1)
            // unterer Eckradius
            path.addLines([pt1, pt2, pt3, pt4])
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 0)
            path.addArc(tangent1End: pt2, tangent2End: pt3, radius: 0)
            path.addArc(tangent1End: pt3, tangent2End: pt4, radius: 40)
            path.addArc(tangent1End: pt4, tangent2End: pt1, radius: 40)
            
            let mid = curveAxis
            
            // Kurve beginnt bei -50
            let curve = rect.height - 50
            
            path.move(to: CGPoint(x: mid - 60, y: height))
            
            // Kurve
            let to1 = CGPoint(x: mid, y: curve)
            let control1 = CGPoint(x: mid - 30, y: height)
            let control2 = CGPoint(x: mid - 30, y: curve)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            
            // Kurve beitreten
            let to2 = CGPoint(x: mid + 60, y: height)
            let control3 = CGPoint(x: mid + 30, y: curve)
            let control4 = CGPoint(x: mid + 30, y: height)
            
            path.addCurve(to: to2, control1: control3, control2: control4)
            
        }
    }
}

// MARK: - BaseView Preview
struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
