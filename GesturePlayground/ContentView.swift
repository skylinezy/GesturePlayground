//
//  ContentView.swift
//  GesturePlayground
//
//  Created by Ryan Zi on 9/30/21.
//

import SwiftUI


struct ContentView: View {
    @GestureState private var startPos: CGPoint? = nil
    @State var currPos : CGPoint = CGPoint(x:UIScreen.main.bounds.midX, y:UIScreen.main.bounds.midY)
    @State private var buttonState: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            let SnapTop: CGRect = CGRect(x: 0, y: -proxy.safeAreaInsets.top, width: proxy.size.width, height: 100 + proxy.safeAreaInsets.top)
            let SnapLeading: CGRect = CGRect(x: -1, y: 0, width: 100, height: proxy.size.height)
            let SnapTrailing: CGRect = CGRect(x: proxy.size.width - 99, y: 0, width: 100, height: proxy.size.height)
            let SnapBottom: CGRect = CGRect(x: 0, y: proxy.size.height - 99, width: proxy.size.width, height: 100 + proxy.safeAreaInsets.bottom)
            
            let dragGesture = DragGesture(minimumDistance: 0.0)
                .updating($startPos) { value, gestureStart, transaction in
                    gestureStart = gestureStart ?? currPos
                }
                .onChanged { gesture in
                    var newLocation = startPos ?? currPos
                    newLocation.x += gesture.translation.width
                    newLocation.y += gesture.translation.height
                    self.currPos = newLocation
                }
                .onEnded { value in
                    print("End on \(self.currPos.x), \(self.currPos.y)")
                     if SnapTrailing.contains(value.location) {
                        self.currPos.x = SnapTrailing.maxX
                    } else if SnapLeading.contains(value.location) {
                        self.currPos.x = SnapLeading.origin.x
                    } else if SnapTop.contains(value.location) {
                        self.currPos.y = SnapTop.origin.y + proxy.safeAreaInsets.top
                    } else if SnapBottom.contains(value.location) {
                        self.currPos.y = SnapBottom.maxY - proxy.safeAreaInsets.bottom
                    }
                }
            
            Rectangle()
                .fill(Color.green)
                .position(x: SnapTop.midX, y: SnapTop.midY)
                .frame(width: SnapTop.width, height: SnapTop.height)
            
            Rectangle()
                .fill(Color.green)
                .position(x: SnapBottom.midX, y: SnapBottom.midY)
                .frame(width: SnapBottom.width, height: SnapBottom.height)
            
            Rectangle()
                .fill(Color.gray)
                .position(x: SnapLeading.midX, y: SnapLeading.midY)
                .frame(width: SnapLeading.width, height: SnapLeading.height)
            
            Rectangle()
                .fill(Color.gray)
                .position(x: SnapTrailing.midX, y: SnapTrailing.midY)
                .frame(width: SnapTrailing.width, height: SnapTrailing.height)
            
            Button(action:{
            }) {
                Text("Drag me!")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            .padding(30)
            .background(buttonState ? Color.green : Color.red)
            .cornerRadius(12)
            .scaleEffect(startPos == nil ? 1.0 : 1.4)
            .animation(.spring(response: 0.25, dampingFraction: 0.59, blendDuration: 0.0), value: startPos == nil)
            .position(currPos)
            .simultaneousGesture(dragGesture)
            .simultaneousGesture(TapGesture() .onEnded{
                self.buttonState.toggle()
            })
            //.gesture(dragGesture)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
