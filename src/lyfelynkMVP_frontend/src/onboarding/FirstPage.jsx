import { Button } from "@/components/ui/button";
import { ChevronRight } from "lucide-react";
import { User } from "lucide-react";
import { BriefcaseMedical } from "lucide-react";
import { Building } from "lucide-react";
import { Link } from "react-router-dom";
import { ConnectButton, ConnectDialog } from "@connect2ic/react";
import "../connect2ic/connect2ic.css";
export default function FirstPageContent() {
  return (
    <section className="px-6 flex justify-center items-center h-screen bg-[conic-gradient(at_bottom_right,_var(--tw-gradient-stops))] from-blue-700 via-blue-800 to-gray-900">
      <div className="flex flex-col md:flex-row md:w-1/2">
        <div className="flex-1 flex flex-col justify-center text-white p-4">
          <div className="flex items-center mb-4">
            <img
              alt="Logo"
              className="h-10 w-48"
              src="assets/lyfelynk.png"
            />
          </div>
          <p className="text-xl md:text-2xl">Digitally Linking your health.</p>
        </div>

        <div className="flex-1 items-center max-w-md bg-white rounded-lg p-8">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl md:text-2xl font-bold text-black">
              Get Started
            </h2>
            <div className="auth-section">
              <ConnectButton />
            </div>
            <ConnectDialog />
          </div>
          <p className="text-sm text-gray-500 mb-4">Login/Register As</p>
          <div>
            <Link to="Health-User">
              <Button
                className="flex justify-between items-center w-full border border-gray-300 p-3 rounded-md mb-2"
                variant="secondary"
              >
                <div className="flex items-center">
                  <User className="text-primary" />
                  <span className="ml-2 font-bold">Health User</span>
                </div>
                <ChevronRight />
              </Button>
            </Link>

            <Link to="Health-Professional">
              <Button
                className="flex justify-between items-center w-full border border-gray-300 p-3 rounded-md mb-2"
                variant="secondary"
              >
                <div className="flex items-center">
                  <BriefcaseMedical className="text-primary" />
                  <span className="ml-2 font-bold">Health Professional</span>
                </div>
                <ChevronRight />
              </Button>
            </Link>

            <Link to="Health-Service">
              <Button
                className="flex justify-between items-center w-full border border-gray-300 p-3 rounded-md mb-2"
                variant="secondary"
              >
                <div className="flex items-center">
                  <Building className="text-primary" />
                  <span className="ml-2 font-bold">Health Service</span>
                </div>
                <ChevronRight />
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </section>
  );
}
