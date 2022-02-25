//
//  SurroundSnapArea.swift
//  GesturePlayground
//
//  Created by Ryan Zi on 2/24/22.
//

import SwiftUI

struct SurroundSnapArea: View {
    @GestureState private var startPos: CGPoint? = nil
    @State var currPos : CGPoint = CGPoint(x:UIScreen.main.bounds.midX, y:UIScreen.main.bounds.midY)
    @State private var buttonState: Bool = false
    @State private var buttonInDrag: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            
            let SnapTop: CGRect = CGRect(x: 0, y: -proxy.safeAreaInsets.top, width: proxy.size.width, height: 100 + proxy.safeAreaInsets.top)
            let SnapLeading: CGRect = CGRect(x: -1, y: 0, width: 100, height: proxy.size.height)
            let SnapTrailing: CGRect = CGRect(x: proxy.size.width - 99, y: 0, width: 100, height: proxy.size.height)
            let SnapBottom: CGRect = CGRect(x: 0, y: proxy.size.height - 99, width: proxy.size.width, height: 100 + proxy.safeAreaInsets.bottom)
            
            let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
            let longPressGesture = LongPressGesture(minimumDuration: 0.3)
                .onEnded { finished in
                    buttonInDrag = true
                    hapticImpact.impactOccurred()
                }
            
            let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: CoordinateSpace.named("SurroundSnapArea"))
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
                     if SnapTrailing.contains(value.location) {
                        self.currPos.x = SnapTrailing.maxX
                    } else if SnapLeading.contains(value.location) {
                        self.currPos.x = SnapLeading.origin.x
                    } else if SnapTop.contains(value.location) {
                        self.currPos.y = SnapTop.origin.y + proxy.safeAreaInsets.top
                    } else if SnapBottom.contains(value.location) {
                        self.currPos.y = SnapBottom.maxY - proxy.safeAreaInsets.bottom
                    }
                    buttonInDrag = false
                }
            
            let longDragGesture = longPressGesture.sequenced(before: dragGesture)
            
            
            Rectangle()
                .fill(Color.yellow)
                .position(x: SnapTop.midX, y: SnapTop.midY)
                .frame(width: SnapTop.width, height: SnapTop.height)
            
            Rectangle()
                .fill(Color.yellow)
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
            .scaleEffect(buttonInDrag ? 1.4 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.59, blendDuration: 0.0), value: buttonInDrag)
            .position(currPos)
            .simultaneousGesture(longDragGesture)
            .simultaneousGesture(TapGesture() .onEnded{
                self.buttonState.toggle()
            })
        }
        .coordinateSpace(name: "SurroundSnapArea")
    }
}

struct SurroundSnapArea_Previews: PreviewProvider {
    static var previews: some View {
        SurroundSnapArea()
    }
}
