import React from "react";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, BarChart, Bar } from "recharts";

const dummyBloodPressureData = [
  { name: "Jan", systolic: 120, diastolic: 80 },
  { name: "Feb", systolic: 122, diastolic: 82 },
  { name: "Mar", systolic: 118, diastolic: 78 },
  { name: "Apr", systolic: 124, diastolic: 85 },
  { name: "May", systolic: 115, diastolic: 79 },
  { name: "Jun", systolic: 126, diastolic: 81 },
  // Add more dummy data as needed
];

const dummyHeartRateData = [
  { name: "Jan", rate: 72 },
  { name: "Feb", rate: 74 },
  { name: "Mar", rate: 70 },
  { name: "Apr", rate: 75 },
  { name: "May", rate: 71 },
  { name: "Jun", rate: 73 },
  // Add more dummy data as needed
];

const dummyOxygenSaturationData = [
  { name: "Jan", saturation: 98 },
  { name: "Feb", saturation: 97 },
  { name: "Mar", saturation: 99 },
  { name: "Apr", saturation: 96 },
  { name: "May", saturation: 98 },
  { name: "Jun", saturation: 95 },
];

const dummyStepsData = [
  { name: "Jan", steps: 8456 },
  { name: "Feb", steps: 9234 },
  { name: "Mar", steps: 10543 },
  { name: "Apr", steps: 7843 },
  { name: "May", steps: 9567 },
  { name: "Jun", steps: 8345 },
];

const dummyCaloriesBurnedData = [
  { name: "Jan", calories: 1234 },
  { name: "Feb", calories: 1345 },
  { name: "Mar", calories: 1456 },
  { name: "Apr", calories: 1324 },
  { name: "May", calories: 1287 },
  { name: "Jun", calories: 1365 },
];

// Calculate BMI and weight status
const calculateBMI = (weight, height) => {
  return (weight / Math.pow(height / 100, 2)).toFixed(1);
};

const getWeightStatus = (bmi) => {
  if (bmi < 18.5) {
    return "Underweight";
  } else if (bmi >= 18.5 && bmi < 24.9) {
    return "Healthy weight";
  } else if (bmi >= 25 && bmi < 29.9) {
    return "Overweight";
  } else {
    return "Obese";
  }
};

const weightKg = 70; // Weight in kilograms
const heightCm = 175; // Height in centimeters
const bmi = calculateBMI(weightKg, heightCm);
const weightStatus = getWeightStatus(bmi);

export default function AnalyticsContent() {
  return (
    <div className="max-w-6xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
      <h1 className="text-4xl font-bold text-foreground">Health Analytics</h1>
      <p className="mt-2 text-base text-gray-600">
        Explore and Analyze Your Health Data Effectively.
      </p>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-8">
        <Card className="md:col-span-2">
          <CardHeader>
            <CardDescription>Blood Pressure</CardDescription>
            <CardTitle>120/80 mmHg</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={200}>
              <LineChart data={dummyBloodPressureData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="monotone" dataKey="systolic" stroke="#8884d8" name="Systolic" />
                <Line type="monotone" dataKey="diastolic" stroke="#82ca9d" name="Diastolic" />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardDescription>Steps</CardDescription>
            <CardTitle>8,456</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={200}>
              <BarChart data={dummyStepsData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="steps" fill="#8884d8" name="Steps" />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardDescription>Calories Burned</CardDescription>
            <CardTitle>1,234 kcal</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={200}>
              <BarChart data={dummyCaloriesBurnedData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="calories" fill="#8884d8" name="Calories Burned" />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
        
        <Card className="md:col-span-2">
          <CardHeader>
            <CardDescription>Heart Rate</CardDescription>
            <CardTitle>72 bpm</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={200}>
              <LineChart data={dummyHeartRateData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="monotone" dataKey="rate" stroke="#8884d8" name="Heart Rate" />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        <Card className="md:col-span-2">
          <CardHeader>
            <CardDescription>Oxygen Saturation</CardDescription>
            <CardTitle>98%</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={200}>
              <LineChart data={dummyOxygenSaturationData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="monotone" dataKey="saturation" stroke="#8884d8" name="Saturation" />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardDescription>Weight Status</CardDescription>
            <CardTitle>{weightStatus}</CardTitle>
          </CardHeader>
          <CardContent>
            <p>BMI: {bmi}</p>
            <p>Weight: {weightKg} kg</p>
            <p>Height: {heightCm} cm</p>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
