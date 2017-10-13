//
//  MatrixHelper.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/29/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation
import GLKit

class MatrixHelper {
    
    //     column 0  column 1  column 2  column 3
    //         1        0         0       X          x         x + X*w  
    //         0        1         0       Y      x   y    =    y + Y*w  
    //         0        0         1       Z          z         z + Z*w  
    //         0        0         0       1          w            w    
    
    static func translationMatrix(with matrix: matrix_float4x4, for translation : vector_float4) -> matrix_float4x4 {
        var matrix = matrix
        matrix.columns.3 = translation
        return matrix
    }
    
    //      column 0  column 1  column 2  column 3
    //        cosθ      0       sinθ        0    
    //         0        1        0          0     
    //       −sinθ      0       cosθ        0     
    //         0        0        0          1    
    
    static func rotateAroundY(with matrix: matrix_float4x4, for degrees: Float) -> matrix_float4x4 {
        var matrix : matrix_float4x4 = matrix
        
        matrix.columns.0.x = cos(degrees)
        matrix.columns.0.z = -sin(degrees)
        
        matrix.columns.2.x = sin(degrees)
        matrix.columns.2.z = cos(degrees)
        return matrix.inverse
    }
    
   static func convertGLKMatrix4Tosimd_float4x4(_ matrix: GLKMatrix4) -> float4x4{
        return float4x4(float4(matrix.m00,matrix.m01,matrix.m02,matrix.m03),float4( matrix.m10,matrix.m11,matrix.m12,matrix.m13 ),float4( matrix.m20,matrix.m21,matrix.m22,matrix.m23 ),float4( matrix.m30,matrix.m31,matrix.m32,matrix.m33 ))
        
    }
    
    static func transformMatrix(for matrix: simd_float4x4, originLocation: CLLocation, location: CLLocation) -> simd_float4x4 {
        let distance = 5.0
        let bearing = originLocation.bearingToLocationRadian(location)
        print("Bearing: ", bearing)
        let translationMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, Float(-distance))
        let rotationMatrix = GLKMatrix4RotateY(GLKMatrix4Identity, Float(-bearing))
        let translationMatrix1 = convertGLKMatrix4Tosimd_float4x4(translationMatrix)
        let rotationMatrix1 = convertGLKMatrix4Tosimd_float4x4(rotationMatrix)
        let transformMatrix = simd_mul(rotationMatrix1, translationMatrix1 )
        print("transformMatrix: ", translationMatrix1)
        return simd_mul(matrix, transformMatrix)
    }
    
    static func transformMatrix1(for matrix: simd_float4x4, originLocation: CLLocation, location: CLLocation) -> simd_float4x4 {
        let distance = 5.0
        let bearing = originLocation.bearingToLocationRadian(location)
        print("Bearing: ", bearing)
        let translationMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, -50.0, Float(-distance))
        let rotationMatrix = GLKMatrix4RotateY(GLKMatrix4Identity, Float(-bearing))
        let translationMatrix1 = convertGLKMatrix4Tosimd_float4x4(translationMatrix)
        let rotationMatrix1 = convertGLKMatrix4Tosimd_float4x4(rotationMatrix)
        let transformMatrix = simd_mul(rotationMatrix1, translationMatrix1 )
        print("transformMatrix: ", translationMatrix1)
        return simd_mul(matrix, transformMatrix)
    }
}
