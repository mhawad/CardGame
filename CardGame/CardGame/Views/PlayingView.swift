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
        
    var body: some View {
        GeometryReader { geo in
            
            let hexRadius = geo.size.width / 5
            
            ZStack {
                
                VStack(spacing: 0) {
                    // 4 tiles
                    HexagonRowView(resourceTiles: Array(boardTiles[0...3]))
                        .frame(height: hexRadius)
                        .padding(.bottom, hexRadius / 2)
                    // 4 tiles
                    HexagonRowView(resourceTiles: Array(boardTiles[4...7]))
                        .frame(height: hexRadius)
                }

                
                VStack(spacing: 0) {
                    // 3 tiles
                    HexagonRowView(resourceTiles: Array(boardTiles[8...10]))
                        .frame(height: hexRadius)
                    // 5 tiles
                    HexagonRowView(resourceTiles: Array(boardTiles[11...15]))
                        .frame(height: hexRadius)
                        .padding(.vertical, hexRadius / 2)
                    // 3 tiles
                    HexagonRowView(resourceTiles: Array(boardTiles[16...18]))
                        .frame(height: hexRadius)
                }
            }
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}

struct HexagonRowView: View {
    
    let resourceTiles: [ResourceTile]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(resourceTiles, id: \.tileId) { resourceTile in
                HexagonView(resourceTile: resourceTile)
            }
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
            Text("\(resourceTile.generatingNumber)")
                .padding()
                .overlay(Circle().stroke())
        }
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
        tiles.append(ResourceTile(tileId: "\(tileId)", resource: .desert, generatingNumber: numbers.popLast() ?? 13))
        
        return tiles
    }
}
