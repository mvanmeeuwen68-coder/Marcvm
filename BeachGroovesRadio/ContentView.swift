import SwiftUI

private enum LuxuryStyle {
    static let background = Color(red: 0.025, green: 0.025, blue: 0.028)
    static let panel = Color(red: 0.09, green: 0.09, blue: 0.10)
    static let muted = Color(white: 0.65)
}

struct ContentView: View {
    @EnvironmentObject private var radio: RadioPlayer
    @State private var showingAbout = false

    var body: some View {
        ZStack {
            LuxuryStyle.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 25) {
                    HStack {
                        Image(systemName: "line.3.horizontal")
                            .font(.title3)
                            .accessibilityHidden(true)
                        Spacer()
                        Text("BEACHGROOVES")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .tracking(3)
                        Spacer()
                        Button { showingAbout = true } label: {
                            Image(systemName: "info.circle")
                                .font(.title3)
                        }
                        .accessibilityLabel("About BeachGrooves")
                    }
                    .foregroundStyle(.white)
                    .padding(.top, 12)

                    Image("BrandLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 280)
                        .frame(height: 205)
                        .accessibilityLabel("BeachGrooves — World Off, Music On")

                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(LinearGradient(colors: [Color(white: 0.25), Color(white: 0.10), .black], startPoint: .topLeading, endPoint: .bottomTrailing))
                        VStack(spacing: 18) {
                            Image(systemName: "waveform.path")
                                .font(.system(size: 92, weight: .ultraLight))
                                .foregroundStyle(.white.opacity(0.85))
                            Text("WORLD OFF, MUSIC ON!")
                                .font(.system(size: 13, weight: .medium))
                                .tracking(3)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .frame(height: 225)
                    .accessibilityLabel("BeachGrooves Radio artwork")

                    VStack(spacing: 7) {
                        HStack(spacing: 7) {
                            Circle().fill(radio.isPlaying ? .white : LuxuryStyle.muted).frame(width: 7, height: 7)
                            Text(radio.isPlaying ? "LIVE ON AIR" : "READY TO LISTEN")
                                .tracking(2.5)
                        }
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(LuxuryStyle.muted)
                        Text("BeachGrooves Radio")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundStyle(.white)
                        Text("The soundtrack to your escape")
                            .font(.subheadline)
                            .foregroundStyle(LuxuryStyle.muted)
                    }

                    HStack(spacing: 45) {
                        Image(systemName: "waveform")
                            .font(.title2)
                            .foregroundStyle(LuxuryStyle.muted)
                            .accessibilityHidden(true)
                        Button { radio.togglePlayback() } label: {
                            Image(systemName: radio.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundStyle(.black)
                                .frame(width: 86, height: 86)
                                .background(.white, in: Circle())
                        }
                        .accessibilityLabel(radio.isPlaying ? "Pause live radio" : "Play live radio")
                        ShareLink(item: URL(string: "https://beachgrooves.com")!) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundStyle(LuxuryStyle.muted)
                        }
                        .accessibilityLabel("Share BeachGrooves website")
                    }
                    .padding(.vertical, 4)

                    HStack(spacing: 16) {
                        Image(systemName: "speaker.fill")
                        Slider(value: $radio.volume, in: 0...1)
                            .tint(.white)
                            .accessibilityLabel("Radio volume")
                        Image(systemName: "speaker.wave.3.fill")
                    }
                    .foregroundStyle(LuxuryStyle.muted)
                    .padding(18)
                    .background(LuxuryStyle.panel, in: RoundedRectangle(cornerRadius: 18))

                    Text("BEACHGROOVES  •  WORLD OFF, MUSIC ON!")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(2)
                        .foregroundStyle(LuxuryStyle.muted)
                        .padding(.bottom, 16)
                }
                .padding(.horizontal, 25)
                .frame(maxWidth: 480)
                .frame(maxWidth: .infinity)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingAbout) {
            NavigationStack {
                VStack(spacing: 20) {
                    Image("BrandLogo").resizable().scaledToFit().frame(height: 180)
                    Text("WORLD OFF, MUSIC ON!").font(.headline).tracking(2)
                    Text("Listen live to BeachGrooves Radio, wherever you are.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    Link("Visit BeachGrooves", destination: URL(string: "https://beachgrooves.com")!)
                    Spacer()
                }
                .padding(25)
                .background(LuxuryStyle.background)
                .navigationTitle("About")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { showingAbout = false } } }
            }
            .preferredColorScheme(.dark)
        }
        .alert("Playback issue", isPresented: Binding(
            get: { radio.errorMessage != nil },
            set: { if !$0 { radio.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { radio.errorMessage = nil }
        } message: {
            Text(radio.errorMessage ?? "")
        }
    }
}

#Preview {
    ContentView().environmentObject(RadioPlayer())
}
