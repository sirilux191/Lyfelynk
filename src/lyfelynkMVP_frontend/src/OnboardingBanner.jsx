import { TriangleAlert } from "lucide-react";

export default function OnboardingBanner() {
  return (
    <div className="flex justify-center bg-primary space-x-4 py-2 px-4 text-center">
      <TriangleAlert className="text-white"/>
      <p className="text-white text-lg font-bold">Connect your Wallet prior to Sign Up/Login In.</p>
    </div>
  )
}