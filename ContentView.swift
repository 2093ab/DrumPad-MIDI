import SwiftUI
import AudioKit

struct DrumPad : Identifiable, View {
    @EnvironmentObject var audio: Audio
    var id: String
    var number: MIDINoteNumber
    @State private var isPressed = false
    var body: some View {
        ZStack {
            Image(systemName: "square.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(isPressed ? Color.indigo : Color.blue)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if isPressed == false {
                                isPressed = true
                                audio.midi.sendNoteOnMessage(noteNumber: number, velocity: 127)
                                print("Press")
                            }
                        }
                        .onEnded { value in
                            isPressed = false
                            audio.midi.sendNoteOffMessage(noteNumber: number)
                            print("Delete")
                        }
                )
            Text("\(id)")
        }
    }
}

class Audio: ObservableObject {
    let midi = MIDI()
    
    func makeMidi() {
        midi.openOutput()    
    }
    
    func destroyMidi() {
        midi.closeInput()
    }
}

struct ContentView: View {
    @StateObject var audio = Audio()
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.blue.opacity(0.5), .black]), center: .center, startRadius: 2, endRadius: 650)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    DrumPad(id: "one", number: 36)
                    DrumPad(id: "two", number: 37)
                    DrumPad(id: "three", number: 38)
                    DrumPad(id: "four", number: 39)
                }
                HStack {
                    DrumPad(id: "five", number: 40)
                    DrumPad(id: "six", number: 41)
                    DrumPad(id: "seven", number: 42)
                    DrumPad(id: "eight", number: 43)
                }
                HStack {
                    DrumPad(id: "nine", number: 44)
                    DrumPad(id: "ten", number: 45)
                    DrumPad(id: "eleven", number: 46)
                    DrumPad(id: "twelve", number: 47)
                }
                HStack {
                    DrumPad(id: "thirteen", number: 48)
                    DrumPad(id: "fourteen", number: 49)
                    DrumPad(id: "fifteen", number: 50)
                    DrumPad(id: "sixteen", number: 51)
                }
            }
        }
        .onAppear {
            audio.makeMidi()
        }
        .onDisappear(perform: {
            audio.destroyMidi()
        })
        .environmentObject(audio)
    }
}
