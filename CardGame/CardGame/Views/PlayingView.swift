//
//  PlayingView.swift
//  CardGame
//
//  Created by Patrick Fuller on 4/21/22.
//

import SwiftUI

struct PlayingView: View {
    var body: some View {
        VStack {
            BoardViewComp()
                .padding(30)
        }
    }
}

struct PlayingView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingView()
    }
}

struct BoardViewComp: View {
    
    var boardTiles = ResourceTile.getTilesDeck().shuffled()
    
    var vertices = [
        3,
        4,
        4,
        5,
        5,
        6,
        6,
        5,
        5,
        4,
        4,
        3
    ]
    
    var grid = [[(Int, Int)]]()
    
    var flatGrid = [Int]()
        
    init() {
//        for x in 0..<13 {
//            var row = [(Int, Int)]()
//            for y in 0..<12 {
//                row.append((x, y))
//            }
//            grid.append(row)
//        }
        for x in 0..<(rows * columns) {
            flatGrid.append(x)
        }
    }
    let rows = 23
    let columns = 11
        
    var body: some View {
        GeometryReader { geo in
            
            let hexRadius = geo.size.width / 5
            let ratio = 1 / 5.6
            
            ZStack {
                // Vertices
                VStack(spacing: 0) {
                    ForEach(vertices, id: \.self) { vertex in
                        HStack(spacing: 0) {
                            ForEach((0..<vertex), id: \.self) { vertex in
                                Circle()
                                    .padding(13)
                                    .frame(width: hexRadius, height: hexRadius * CGFloat(ratio) * 2)
                                    
                            }
                        }
                    }
                }
                .foregroundColor(.green.opacity(0.5))
                
                // Between points
                VStack(spacing: 0) {
                    ForEach((0..<rows), id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach((0..<columns), id: \.self) { column in
                                ZStack {
                                    Circle()
                                        .padding(8)
                                        .frame(width: hexRadius / 2, height: hexRadius * CGFloat(ratio))
                                }
                            }
                        }
                    }
                }
                .foregroundColor(.blue.opacity(0.3))
                
                
//                VStack(spacing: 0) {
//                    // 4 tiles
//                    HexagonRowView(resourceTiles: Array(boardTiles[0...3]))
//                        .frame(height: hexRadius)
//                        .padding(.bottom, hexRadius / 2)
//                    // 4 tiles
//                    HexagonRowView(resourceTiles: Array(boardTiles[4...7]))
//                        .frame(height: hexRadius)
//                }
//
//
//                VStack(spacing: 0) {
//                    // 3 tiles
//                    HexagonRowView(resourceTiles: Array(boardTiles[8...10]))
//                        .frame(height: hexRadius)
//                    // 5 tiles
//                    HexagonRowView(resourceTiles: Array(boardTiles[11...15]))
//                        .frame(height: hexRadius)
//                        .padding(.vertical, hexRadius / 2)
//                    // 3 tiles
//                    HexagonRowView(resourceTiles: Array(boardTiles[16...18]))
//                        .frame(height: hexRadius)
//                }
            }
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}

struct HexagonRowView: View {
    
    let resourceTiles: [ResourceTile]
    
    var body: some View {
        HStack(spacing: 0) {
            
            Spacer()
            
            ForEach(resourceTiles, id: \.tileId) { resourceTile in
                HexagonView(resourceTile: resourceTile)
            }
            
            Spacer()
        }
    }
}

struct HexagonView: View {
    var resourceTile: ResourceTile
    var body: some View {
        ZStack {
            HexagonShape()
                .aspectRatio(1/1.15, contentMode: .fit)
                .foregroundColor(resourceTile.resource.color)
                .overlay(HexagonShape().stroke(.black, lineWidth: 1))
                .padding(1)
            
            if resourceTile.generatingNumber != 7 {
                GeometryReader { geo in
                    Circle()
                        .overlay(Circle().stroke(.brown, lineWidth: 2))
                        .frame(height: geo.size.height / 3)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        .foregroundColor(Color("paleTan"))
                }
                .aspectRatio(1 / 1.15, contentMode: .fit)
                
                GeneratorNumberLabel(number: resourceTile.generatingNumber)
            }
        }
    }
}

struct GeneratorNumberLabel: View {
    let number: Int
    
    
    var numberWeight: Font.Weight{
        switch abs(7 - number) {
        case 1:
            return .black
        case 2:
            return .bold
        case 4:
            return .light
        case 5:
            return .thin
        default:
            return .regular
        }
    }
    
    var body: some View {
        Text("\(number)")
            .foregroundColor( 6...8 ~= number ? Color("redNumberColor") : .black)
            .font(.system(
                size: 2 * CGFloat(15 - abs(7 - number)),
                weight: numberWeight)
            )
            .padding()
    }
}

struct HexagonShape: Shape {
    // store how many corners the star has, and how smooth/pointed it is
    func path(in rect: CGRect) -> Path {
        
        let upperY = rect.minY + rect.height / 4
        let lowerY = rect.maxY - rect.height / 4
        let points = [
            // top middle
            CGPoint(x: rect.midX, y: rect.minY),
            // upper right
            CGPoint(x: rect.maxX, y: upperY),
            // lower right
            CGPoint(x: rect.maxX, y: lowerY),
            // bottom middle
            CGPoint(x: rect.midX, y: rect.maxY),
            // lower left
            CGPoint(x: rect.minX, y: lowerY),
            // upper left
            CGPoint(x: rect.minX, y: upperY),
        ]
        
        var path = Path()
        
        path .move(to: points[5])
        
        path.addLines(points)
        
        path.closeSubpath()
        
        return path
    }
}

enum Resource {
    case wood
    case brick
    case wool
    case wheat
    case ore
    case desert
    
    var color: Color {
        switch self {
        case .wood:
            return Color("woodColor")
        case .brick:
            return Color("brickColor")
        case .wool:
            return Color("woolColor")
        case .wheat:
            return Color("wheatColor")
        case .ore:
            return Color("oreColor")
        case .desert:
            return Color("desertColor")
        }
    }
}

struct ResourceTile: Hashable {
    var tileId: String
    var resource: Resource
    var generatingNumber: Int
    
    static func getTilesDeck() -> [ResourceTile] {
        
        // set generator numbers
        var numbers = [2, 12]
        for n in 3...6 {
            numbers.append(n)
            numbers.append(n)
        }
        for n in 8...11 {
            numbers.append(n)
            numbers.append(n)
        }
        
        var tileId = 0
        
        var tiles = [ResourceTile]()
        for _ in 1...4 {
            tiles.append(ResourceTile(tileId: "\(tileId)", resource: .wood, generatingNumber: numbers.popLast() ?? 13))
            tiles.append(ResourceTile(tileId: "\(tileId + 1)", resource: .wool, generatingNumber: numbers.popLast() ?? 13))
            tiles.append(ResourceTile(tileId: "\(tileId + 2)", resource: .wheat, generatingNumber: numbers.popLast() ?? 13))
            tileId += 3
        }
        for _ in 1...3 {
            tiles.append(ResourceTile(tileId: "\(tileId)", resource: .brick, generatingNumber: numbers.popLast() ?? 13))
            tiles.append(ResourceTile(tileId: "\(tileId + 1)", resource: .ore, generatingNumber: numbers.popLast() ?? 13))
            tileId += 2
        }
        tiles.append(ResourceTile(tileId: "\(tileId)", resource: .desert, generatingNumber: numbers.popLast() ?? 7))
        
        return tiles
    }
}
