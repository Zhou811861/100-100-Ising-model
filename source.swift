//
// compute properties of Ising model using Metroplis Algorithm
//
import Foundation

struct Atom {
    var spin: Int = Int.random(in: 0...1)*2-1
    mutating func flipSpin() {
        spin = -spin
    }
}

class IsingModel {
    var numberOfRows: Int
    var numberOfColumns: Int
    var lattice: [[Atom]] = []
    init(numberOfRows: Int, numberOfColumns: Int) {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        var row: [Atom] = []
        for _ in 0..<numberOfRows {
            for _ in 0..<numberOfColumns {
                row.append(Atom())
            }
            lattice.append(row)
            row = []
        }
    }
    func computeMagnetization() -> Double {
        var result: Double = 0
        for row in 0..<numberOfRows{
            for column in 0..<numberOfColumns {
                result += Double(lattice[row][column].spin)
            }
        }
        return result
    }
    func computeDeltaMagnetization(row: Int, column: Int) -> Double {
        return -Double(lattice[row][column].spin) * 2.0
    }
    func computeEnergy() -> Double {
        var result: Double = 0
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let up = (row - 1 + numberOfRows) % numberOfRows
                let left = (column - 1 + numberOfColumns) % numberOfColumns
                result -= Double(lattice[row][column].spin * lattice[up][column].spin)
                result -= Double(lattice[row][column].spin * lattice[row][left].spin)
            }
        }
        return result
    }
    func computeDeltaEnergy(row: Int, column: Int) -> Double {
        let top = (row - 1 + numberOfRows) % numberOfRows
        let bottom = (row + 1) % numberOfRows
        let left = (column - 1 + numberOfColumns) % numberOfColumns
        let right = (column + 1) % numberOfColumns
        let neighborSum = lattice[top][column].spin + lattice[bottom][column].spin +
                        lattice[row][left].spin + lattice[row][right].spin
        return 2.0 * Double(lattice[row][column].spin) * Double(neighborSum)
    }

    func properties(T: Double, numberOfSteps: Int) -> (S: Double, E: Double, Cv: Double) {
        var accumEnergy: Double = 0
        var accumEnergySquared: Double = 0
        var accumMagnetization: Double = 0
        var energy = computeEnergy()
        var magnetization = computeMagnetization()
        for _ in 1...numberOfSteps {
            let rowChosen = Int.random(in: 0..<numberOfRows)
            let columnChosen = Int.random(in: 0..<numberOfColumns)
            let deltaE = computeDeltaEnergy(row: rowChosen, column: columnChosen)
            let deltaMagnetization = computeDeltaMagnetization(row: rowChosen, column: columnChosen)
            if deltaE <= 0 || exp(-deltaE / T) > Double.random(in: 0...1) {
                lattice[rowChosen][columnChosen].flipSpin()
                energy += deltaE
                magnetization += deltaMagnetization
            }
            accumMagnetization += magnetization
            accumEnergy += energy
            accumEnergySquared += energy * energy
        }
        let avgMagnetization = accumMagnetization / Double(numberOfSteps)
        let avgEnergy = accumEnergy / Double(numberOfSteps)
        let avgEnergySquared = accumEnergySquared / Double(numberOfSteps)
        let heatCapacity = (avgEnergySquared - avgEnergy * avgEnergy) / (T * T)

        return (avgMagnetization, avgEnergy, heatCapacity)
    }

}

let numberOfSteps:Int = Int(1e6)
var mySystem = IsingModel(numberOfRows: 100, numberOfColumns: 100)
print("  T                           <S>                           <E>                            Cv")
for T in stride(from: 0.2, through: 6.0, by: 0.2){
    let propertyResults = mySystem.properties(T: T, numberOfSteps: numberOfSteps)
    print(String(format:"%3.1f%30.5f%30.5f%30.5f", T, propertyResults.S, propertyResults.E, propertyResults.Cv))
}
