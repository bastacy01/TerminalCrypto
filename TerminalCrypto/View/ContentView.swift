//
//  ContentView.swift
//  TerminalCrypto
//
//  Created by Ben Stacy on 12/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTime = Date()
    @State private var wallets = [
        (icon: "ethereumlogo", address: "0xa34Fb1A718E7985B902b696122Ab6FC8C0794"),
        (icon: "solanalogo", address: "Ero5V46KNpei17K18hxh9Cs5N8De4f1vHB6NTEi"),
//        (icon: "bitcoinlogo", address: "0xABCDEF1234567890ABCDEF1234567890ABCDE")
    ]
    @State private var animationStage = 0
    
    @State private var priceHistory: [(Date, Double)] = []
    
    @State private var totalAssetValue = 1_220_000.00
    @State private var assets = [
        ("ETH", 106, 3_930.00, 420_000.00),
        ("SOL", 1115, 225.00, 250_000.00),
        ("PEPE", 8_140_000_000, 0.000025, 200_000.00),
        ("TURBO", 12_800_000, 0.012, 150_000.00),
        ("GOAT", 124_000, 0.80, 100_000.00),
        ("AI16Z", 100_200, 0.80, 80_000.00),
        ("DEGEN", 1_300_000, 0.016, 20_000.00),
    ]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var formattedTotalAssetValue: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: totalAssetValue)) ?? "0.00"
    }
    
    var body: some View {
        ZStack {
            MeshGradient()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 13) {
                    if animationStage >= 1 {
                        TypedText(text: formattedDate)
                    }
                    if animationStage >= 2 {
                        TypedText(text: formattedTime)
                    }
                    ForEach(wallets.indices, id: \.self) { index in
                        if animationStage >= index + 3 {
                            HStack {
                                Image(wallets[index].icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                TypedText(text: wallets[index].address)
                            }
                        }
                    }
                    
                    if animationStage >= wallets.count + 3 {
                        AnimatedLineGraph()
                            .frame(height: 200)
                            .padding(.vertical)
                        
                        Spacer().frame(height: 40)
                        
                        TypedText(text: "Total Asset Value: $\(formattedTotalAssetValue)")
                        TypedText(text: "\(assets.count) Assets")
                        
                        if animationStage >= wallets.count + 4 {
                             AssetChart(assets: assets)
                         }
                    }
                }
                .padding()
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .onAppear {
            generateRandomPriceHistory()
            animateSequentially()
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: currentTime)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: currentTime)
    }
    
    func animateSequentially() {
        // Modify this function to include the new animation stages
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            animationStage = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                animationStage = 2
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    animationStage = 3
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        animationStage = 4
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            animationStage = 5
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                animationStage = 6
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    animationStage = 7
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        animationStage = 8
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            animationStage = 9
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func generateRandomPriceHistory() {
        let now = Date()
        let hours = 24
        let basePrice = 1000.0
        
        for i in 0...hours {
            let date = Calendar.current.date(byAdding: .hour, value: -i, to: now)!
            let randomChange = Double.random(in: -5...15)
            let price = basePrice + randomChange
            priceHistory.insert((date, price), at: 0)
        }
    }
}

struct TypedText: View {
    let text: String
    @State private var displayedText = ""
    @State private var isAnimating = false
    
    var body: some View {
        Text(displayedText)
            .font(.system(size: 14, weight: .medium, design: .monospaced))
            .onAppear {
                animateText()
            }
    }
    
    private func animateText() {
        isAnimating = true
        for (index, character) in text.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                displayedText += String(character)
                if index == text.count - 1 {
                    isAnimating = false
                }
            }
        }
    }
}

struct MeshGradient: View {
    @State private var noiseScale: CGFloat = 100
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .topLeading, endPoint: .bottomLeading)
                
                Canvas { context, size in
                    if let noiseImage = generateNoiseImage(size: size) {
                        context.draw(Image(uiImage: noiseImage), in:
                            CGRect(origin: .zero, size: size))
                    }
                }
                .blendMode(.overlay)
            }
        }
    }
    
    private func generateNoiseImage(size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            for y in stride(from: 0, to: size.height, by: 1) {
                for x in stride(from: 0, to: size.width, by: 1) {
                    let brightness = CGFloat.random(in: 0...0.2)
                    UIColor(white: brightness, alpha: 1).setFill()
                    context.fill(CGRect(x: x, y: y, width: 1, height: 1))
                }
            }
        }
        
        return image
    }
}

struct AnimatedLineGraph: View {
    @State private var percentage: CGFloat = 0
    private let lineColor: Color = .green
    
    private let dataPoints: [Double] = [
        1_150_000, 1_160_000, 1_180_000, 1_190_000, 1_200_000,
        1_210_000, 1_220_000, 1_215_000, 1_200_000, 1_190_000,
        1_185_000, 1_195_000, 1_200_000, 1_210_000, 1_220_000
        ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    VStack(spacing: geometry.size.height / 4.18) {
                        ForEach(0..<5) { _ in
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                        }
                    }
    
                    VStack(alignment: .leading) {
                        ForEach(0..<5) { i in
                            Text("$\(self.yAxisLabel(for: i))")
                                .font(.system(size: 8))
                                .frame(height: geometry.size.height / 5)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 5)
                    
                    Path { path in
                        for (index, point) in dataPoints.enumerated() {
                            let x = CGFloat(index) / CGFloat(dataPoints.count - 1) * (geometry.size.width - 30)
                            let y = (1 - CGFloat((point - minPrice) / (maxPrice - minPrice))) * geometry.size.height
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .trim(from: 0, to: percentage)
                    .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
                    .padding(.trailing, 30)
                }
                
                HStack {
                    Text("12/13")
                        .frame(width: 60, alignment: .leading)
                    
                    Spacer()
                    
                    Text("06:00")
                    Spacer()
                    Text("10:00")
                    Spacer()
                    Text("14:00")
                        .padding(.trailing, 40)
                }
                .font(.system(size: 10))
                .foregroundColor(.gray)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0)) {
                self.percentage = 1.0
            }
        }
    }
    
    private var minPrice: Double {
        1_000_000
    }
    
    private var maxPrice: Double {
        1_400_000
    }
    
    private func yAxisLabel(for index: Int) -> String {
        let value = minPrice + (maxPrice - minPrice) * Double(4 - index) / 4
        return String(format: "%.1fM", value / 1_000_000)
    }
}

struct AssetChart: View {
    let assets: [(String, Int, Double, Double)]
    @State private var animatedRowCount = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Text("Asset").frame(width: 50, alignment: .leading)
                Text("Quantity").frame(width: 90, alignment: .trailing)
                    .offset(x: 17)
                Text("Price").frame(width: 90, alignment: .trailing)
                    .offset(x: 8)
                Text("Value").frame(width: 90, alignment: .trailing)
                    .offset(x: 15.5)
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            ForEach(Array(assets.enumerated()), id: \.element.0) { index, asset in
                if index < animatedRowCount {
                    HStack {
                        Text(asset.0).frame(width: 50, alignment: .leading)
                        Text(formatNumber(asset.1)).frame(width: 100, alignment: .trailing)
                            .offset(x: 5)
                        Text("$\(formatNumber(asset.2))").frame(width: 90, alignment: .trailing)
                            .offset(x: -2)
                        Text("$\(formatNumber(asset.3))").frame(width: 90, alignment: .trailing)
                            .offset(x: 6)
                    }
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .transition(.opacity)
                }
            }
        }
        .padding(.horizontal, 3)
        .onAppear {
            animateRows()
        }
    }
    
    // Helper function to format numbers with commas
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    // Helper function to format numbers with commas and specified decimal places
    private func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 5
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    // Speed up the animation
    private func animateRows() {
        for index in 0..<assets.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animatedRowCount += 1
                }
            }
        }
    }
}

struct ChartView: View {
    
    // Mock Data
    private let data: [Double] = [50, 51, 52, 53, 54, 55, 60, 55, 70, 65, 85, 80, 75]
    private let maxY: Double = 85
    private let minY: Double = 50
    private let lineColor: Color = .green // Choose a default color
    private let startingDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    private let endingDate: Date = Date()
    @State private var percentage: CGFloat = 0
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 150)
        }
        .font(.caption)
        .foregroundColor(Color.gray)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

extension ChartView {

    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {

                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)

                    let yAxis = maxY - minY

                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height

                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
        }
    }

    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }

    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }

    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}

#Preview {
    ContentView()
}
