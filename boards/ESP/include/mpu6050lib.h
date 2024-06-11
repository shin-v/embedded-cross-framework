#ifndef MPU6050LIB_H
#define MPU6050LIB_H

#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include "driver/i2c.h"
#include "esp_system.h"
#include "esp_log.h"
#include <math.h>

#define I2C_MASTER_SCL_IO 14
#define I2C_MASTER_SDA_IO 13
#define I2C_MASTER_NUM I2C_NUM_0
#define I2C_MASTER_FREQ_HZ 400000
#define MPU6050_I2C_ADDRESS 0x68

#define MPU6050_PWR_MGMT_1   0x6B
#define MPU6050_GYRO_CONFIG 0x1B
#define MPU6050_ACCEL_CONFIG 0x1C

#define MPU6050_ACCEL_XOUT_H 0x3B
#define MPU6050_ACCEL_XOUT_L 0x3C
#define MPU6050_ACCEL_YOUT_H 0x3D
#define MPU6050_ACCEL_YOUT_L 0x3E
#define MPU6050_ACCEL_ZOUT_H 0x3F
#define MPU6050_ACCEL_ZOUT_L 0x40
#define MPU6050_TEMP_OUT_H 0x41
#define MPU6050_TEMP_OUT_L 0x42
#define MPU6050_GYRO_XOUT_H 0x43
#define MPU6050_GYRO_XOUT_L 0x44
#define MPU6050_GYRO_YOUT_H 0x45
#define MPU6050_GYRO_YOUT_L 0x46
#define MPU6050_GYRO_ZOUT_H 0x47
#define MPU6050_GYRO_ZOUT_L 0x48
#define TAG "MPU6050"

typedef struct {
    float AccErrorX, AccErrorY;
    float GyroErrorX, GyroErrorY, GyroErrorZ;
    float GyroAngleX, GyroAngleY, yaw;
    TickType_t start_tick, elapsed_time;
} MPU6050;

// Constructor
MPU6050* MPU6050_i();

// Destructor
void MPU6050_d(MPU6050* instance);

// Member functions
void set_AccErrorX(MPU6050* instance, float value);
float get_AccErrorX(MPU6050* instance);

void set_AccErrorY(MPU6050* instance, float value);
float get_AccErrorY(MPU6050* instance);

void set_GyroErrorX(MPU6050* instance, float value);
float get_GyroErrorX(MPU6050* instance);

void set_GyroErrorY(MPU6050* instance, float value);
float get_GyroErrorY(MPU6050* instance);

void set_GyroErrorZ(MPU6050* instance, float value);
float get_GyroErrorZ(MPU6050* instance);

void set_GyroAngleX(MPU6050* instance, float value);
float get_GyroAngleX(MPU6050* instance);

void set_GyroAngleY(MPU6050* instance, float value);
float get_GyroAngleY(MPU6050* instance);

void set_Yaw(MPU6050* instance, float value);
float get_Yaw(MPU6050* instance);

void set_StartTick(MPU6050* instance, TickType_t value);
TickType_t get_StartTick(MPU6050* instance);

void set_ElapsedTime(MPU6050* instance, TickType_t value);
void set_ElapsedTimeFromTick(MPU6050* instance, TickType_t value);
TickType_t get_ElapsedTime(MPU6050* instance);


// Function prototypes
void i2c_init();
esp_err_t i2c_read_byte(uint8_t reg_addr, uint8_t *data);
esp_err_t i2c_write_byte(uint8_t reg_addr, uint8_t write_byte);
void get_mpu6050_data(float* gx, float* gy, float* gz, float* ax, float* ay, float* az);
void calculate_imu_error(MPU6050* instance);
float* calculate_imu_data(MPU6050* instance);

#endif // IMU_LIB_H