//
//  ContentView.swift
//  GesturePlayground
//
//  Created by Ryan Zi on 9/30/21.
//

import SwiftUI


struct TrailingSnapArea: View {
    @GestureState private var startPos: CGPoint? = nil
    @State var currPos : CGPoint = CGPoint(x:UIScreen.main.bounds.maxX - 30, y:UIScreen.main.bounds.midY)
    @State private var buttonState: Bool = false
    @State private var buttonInDrag: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            
            let SnapTrailing: CGRect = CGRect(x: geometry.size.width - 99, y: 20, width: 100, height: geometry.size.height - 100)
            
            let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
            let longPressGesture = LongPressGesture(minimumDuration: 0.3)
                .onEnded { finished in
                    buttonInDrag = true
                    hapticImpact.impactOccurred()
                }
            
            let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: CoordinateSpace.named("TrailingSnapArea"))
                .updating($startPos) { value, gestureStart, transaction in
                    gestureStart = gestureStart ?? currPos
                }
                .onChanged { gesture in
                    var newLocation = startPos ?? currPos
                    newLocation.x += gesture.translation.width
                    newLocation.y += gesture.translation.height
                    self.currPos = newLocation
                    
                    if !SnapTrailing.contains(newLocation) {
                        if newLocation.x <= SnapTrailing.minX || newLocation.x >= SnapTrailing.maxX{
                            self.currPos.x = newLocation.x <= SnapTrailing.minX ? SnapTrailing.minX : SnapTrailing.maxX
                        }
                        if newLocation.y <= SnapTrailing.minY || newLocation.y >= SnapTrailing.maxY {
                            self.currPos.y = newLocation.y <= SnapTrailing.minY ? SnapTrailing.minY : SnapTrailing.maxY
                        }
                    }
                }
                .onEnded { value in
                    self.currPos.x = SnapTrailing.maxX
                    buttonInDrag = false
                }
            
            let longDragGesture = longPressGesture.sequenced(before: dragGesture)
            
            Rectangle()
                .fill(Color.gray)
                .position(x: SnapTrailing.midX, y: SnapTrailing.midY)
                .frame(width: SnapTrailing.width, height: SnapTrailing.height)
            
            Button(action:{
            }) {
                Text("Drag me!")
                    .font(.title)
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
        .coordinateSpace(name: "TrailingSnapArea")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SurroundSnapArea()
    }
}
