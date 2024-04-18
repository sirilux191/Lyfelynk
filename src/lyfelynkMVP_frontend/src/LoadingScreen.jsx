import React, { useState, useEffect } from "react";
import { Heart } from "lucide-react";

const phrases = [
  "Take care of your body. It's the only place you have to live.",
  "A healthy outside starts from the inside.",
  "Wellness is the key to a happy life.",
  "Healthy habits lead to a healthy life.",
  "Nourish your body, mind, and soul.",
  "An apple a day keeps the doctor away.",
  "Physical fitness is the first requisite of happiness.",
  "Health is wealth.",
  "Listen to your body; it knows best.",
  "Every step towards a healthier lifestyle counts.",
];

const LoadingScreen = () => {
  const [phrase, setPhrase] = useState("");

  useEffect(() => {
    // Function to set a new random phrase
    const setRandomPhrase = () => {
      const randomIndex = Math.floor(Math.random() * phrases.length);
      setPhrase(phrases[randomIndex]);
    };

    // Set the first phrase after 0.5 second
    setTimeout(setRandomPhrase, 500);

    // Set a new random phrase every 3 seconds
    const interval = setInterval(setRandomPhrase, 3000);

    // Cleanup function to clear the interval
    return () => clearInterval(interval);
  }, []); // Empty dependency array to ensure this effect runs only once

  return (
    <div className="flex flex-col items-center justify-center h-96">
      <div className="animate-ping absolute inline-flex h-32 w-32 rounded-full bg-blue-400 opacity-75"></div>
      <div className="animate-ping absolute inline-flex h-24 w-24 rounded-full bg-blue-500 opacity-50"></div>
      <div className="animate-ping absolute inline-flex h-16 w-16 rounded-full bg-blue-600 opacity-25"></div>
      <div className="text-primary text-center">
        <Heart className="h-12 w-12 mt-8" />
      </div>
      <p className="mt-4 text-sm text-primary">{phrase}</p>
    </div>
  );
};

export default LoadingScreen;
