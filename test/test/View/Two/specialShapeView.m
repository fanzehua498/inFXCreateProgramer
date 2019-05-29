//
//  specialShapeView.m
//  test
//
//  Created by rrjj on 2019/5/20.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "specialShapeView.h"
@implementation specialShapeView

/**
 
 没有方向的相对坐标转换，x、y轴的方向与原点相同
 
 @param origin 坐标系原点
 
 @param point 需要转换的点
 
 @return 没有方向的相对坐标转换，x、y轴的方向与原点相同
 
 *    Y
 
 *    |
 
 *    |      CY
 
 *    |      |
 
 *    |      |    .point
 
 *    |      |
 
 *    |      |
 
 *    |  origin----------------- CX
 
 *    |
 
 *    |
 
 *    O--------------------------------------------------- X
 
 *
 
 */

+ (CGPoint)absolute_to_relative:(CGPoint)origin point:(CGPoint)point {
    
    return CGPointMake(point.x-origin.x, point.y-origin.y);
    
}

/**
 
 简单极坐标转换（转换后的x为斜边，y为角度），
 
 减少数学函数调用（可以忽略，因为通常情况下这几种情况命中概率极低）
 
 @param point 需要转换的点
 
 @return 简单极坐标转换（转换后的x为斜边，y为角度），
 
 减少数学函数调用（可以忽略，因为通常情况下这几种情况命中概率极低）
 
 */

+ (CGPoint)to_spolar_coordinate:(CGPoint)point {
    
    CGPoint result;
    
    result.x = 0;
    
    result.y = -1;
    
    if (0 == point.x == point.y) {
        
        result.y = 0;
        
        return result;
        
    }
    
    if (0 == point.y) {
        
        result.x = point.x;
        
        result.y = point.x > 0 ? 0 : 180;
        
        return result;
        
    }
    
    if (0 == point.x) {
        result.x = point.y;
        result.y = point.y > 0 ? 90 : 270;
        return result;
    }
    if (fabs(point.x) == fabs(point.y)) {
        result.x = 1.41421 * fabs(point.x);
        if (point.x > 0 && point.y > 0) {
            result.y = 45;
        } else if (point.x < 0 && point.y > 0) {
            result.y = 135;
        } else if (point.x < 0 && point.y < 0) {
            result.y = 225;
        } else if (point.x > 0 && point.y < 0) {
            result.y = 315;
        }
    }
    return result;
}
/**
 转换为极坐标（转换后的x为斜边，y为角度）
 @param point 需要转换的点
 @return 转换为极坐标（转换后的x为斜边，y为角度）
 */

+ (CGPoint)to_polar_coordinate:(CGPoint)point {
    CGPoint result;
    result.x = sqrt(point.x * point.x + point.y * point.y);
    result.y = (180.0 / M_PI) * atan2(point.y , point.x); //弧度转角度
    result.y = result.y < .0 ? result.y + 360.0 : result.y;
    return result;
}

/**
 判断一个点是否在扇形内（相对中心点）
 @param center 扇形的中心点
 @param direction 中心线的方向坐标
 @param r 半径
 @param angle 角度（0 < angle < 360）
 @param point 需要检查的点
 @return 判断一个点是否在扇形内（相对中心点）
 */
+ (BOOL)in_circular_sector:(CGPoint)center direction:(CGPoint)direction r:(double)r angle:(float)angle point:(CGPoint)point {
    
    //实际使用中，我们会把方向点的极坐标放到外部进行计算
    
    CGPoint d_rpoint = [specialShapeView absolute_to_relative:center point:direction]; //方向相对坐标
    
    CGPoint d_pc_point = [specialShapeView to_spolar_coordinate:d_rpoint]; //方向极坐标
    
    if (-1 == d_pc_point.y) { //简单的如果转换不出，则需要调用角度函数计算
        
        d_pc_point = [specialShapeView to_polar_coordinate:d_rpoint];
        
    }
    
    CGPoint rpoint = [specialShapeView absolute_to_relative:center point:point]; //目标相对坐标
    
    CGPoint pc_point = [specialShapeView to_polar_coordinate:rpoint]; //目标极坐标
    
    if (pc_point.x > r) return false;
    
    bool result = false;
    float half_angle = angle / 2;
    float angle_counter = d_pc_point.y - half_angle; //中心线顺时针方向的范围
    float angle_clockwise = d_pc_point.y + half_angle; //中心线逆时针方向的范围
    if (0 == d_pc_point.y || angle_counter < 0 || angle_clockwise > 360) {
        angle_counter = angle_counter < 0 ? angle_counter + 360 : angle_counter;
        angle_clockwise = angle_clockwise > 360 ? angle_counter - 360 : angle_counter;
        if (pc_point.y >= 0 && pc_point.y <= angle_counter) {
            result = true;
        } else if (pc_point.y >= angle_clockwise && pc_point.y <= 360) {
            result = true;
        }
    } else {
        result = angle_counter <= pc_point.y && angle_clockwise >= pc_point.y;
    }
    return result;
}
@end
