import React, { useState } from 'react';
import { CardTitle, CardHeader, CardContent, Card } from "@/components/ui/card";
import { Dna, Footprints, GlassWater, Heart, User, Weight } from 'lucide-react';

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

  const getStatusColor = () => {
    const status = getHealthStatus();
    switch (status) {
      case 'Underweight':
        return 'bg-blue-400';
      case 'Healthy':
        return 'bg-green-500';
      case 'Overweight':
        return 'bg-yellow-400';
      case 'Obese':
        return 'bg-red-500';
      default:
        return 'bg-gray-200';
    }
  };

  return (
    <div className="grid gap-4 grid-cols-2 md:grid-cols-3">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between pb-8 space-y-0">
          <CardTitle className="text-sm font-medium">Age</CardTitle>
          <User className='w-4 h-4 text-gray-500'/>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">{age}</div>
        </CardContent>
      </Card>
      <Card>
        <CardHeader className="flex flex-row items-center justify-between pb-8 space-y-0">
          <CardTitle className="text-sm font-medium">Gender</CardTitle>
          <Dna className='w-4 h-4 text-gray-500'/>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">{gender}</div>
        </CardContent>
      </Card>
      <Card>
        <CardHeader className="flex flex-row items-center justify-between pb-8 space-y-0">
          <CardTitle className="text-sm font-medium">BMI</CardTitle>
          <Weight className='w-4 h-4 text-gray-500'/>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">{calculateBMI()}</div>
        </CardContent>
      </Card>
      <Card>
        <CardHeader className="flex flex-row items-center justify-between pb-8 space-y-0">
          <CardTitle className="text-sm font-medium">Health Status</CardTitle>
          <Heart className='w-4 h-4 text-gray-500'/>
        </CardHeader>
        <CardContent>
          <div className={`text-2xl font-bold px-2 rounded-sm ${getStatusColor()}`}>{getHealthStatus()}</div>
        </CardContent>
      </Card>
      <Card>
        <CardHeader className="flex flex-row items-center justify-between pb-8 space-y-0">
          <CardTitle className="text-sm font-medium">Rec. Daily Steps</CardTitle>
          <Footprints className='w-4 h-4 text-gray-500'/>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">{getRecommendedSteps()}</div>
        </CardContent>
      </Card>
      <Card>
        <CardHeader className="flex flex-row items-center justify-between pb-8 space-y-0">
          <CardTitle className="text-sm font-medium">Rec. Daily Water Intake</CardTitle>
          <GlassWater className='w-4 h-4 text-gray-500'/>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">{getRecommendedWaterIntake()}</div>
        </CardContent>
      </Card>
    </div>
  );
}

export default HealthAnalytics;
