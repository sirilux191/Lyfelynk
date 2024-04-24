import React, { useState } from 'react';

function HealthAnalytics() {
  const [age, setAge] = useState('');
  const [gender, setGender] = useState('');
  const [weight, setWeight] = useState('');
  const [height, setHeight] = useState('');
  const [heartRate, setHeartRate] = useState('');

  const calculateBMI = () => {
    const heightInMeters = height / 100;
    const bmi = weight / (heightInMeters * heightInMeters);
    return bmi.toFixed(2);
  };

  const getHealthStatus = () => {
    const bmi = calculateBMI();
    if (bmi < 18.5) return 'Underweight';
    if (bmi >= 18.5 && bmi <= 24.9) return 'Healthy';
    if (bmi >= 25 && bmi <= 29.9) return 'Overweight';
    return 'Obese';
  };

  const getRecommendedSteps = () => {
    if (age >= 18 && age <= 64) return '7,000-10,000';
    if (age >= 65) return '5,000-7,000';
    return '10,000-14,000';
  };

  const getRecommendedWaterIntake = () => {
    if (gender === 'male') return '3.7 liters';
    return '2.7 liters';
  };

  return (
    <div>
      <h2>Health Analytics</h2>
    
      <h3>Analytics Results</h3>
      <p>Age: {age}</p>
      <p>Gender: {gender}</p>
      <p>BMI: {calculateBMI()}</p>
      <p>Health Status: {getHealthStatus()}</p>
      <p>Recommended Daily Steps: {getRecommendedSteps()}</p>
      <p>Recommended Daily Water Intake: {getRecommendedWaterIntake()}</p>
    </div>
  );
}

export default HealthAnalytics;