import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { SelectValue, SelectTrigger, SelectItem, SelectContent, Select } from "@/components/ui/select"

import { ChevronLeft } from 'lucide-react';
import { Link } from "react-router-dom";

export default function RegisterPage3Content() {
  return (
    <section className="px-6 flex justify-center items-center h-screen bg-[conic-gradient(at_bottom_right,_var(--tw-gradient-stops))] from-blue-700 via-blue-800 to-gray-900">
      <div className="flex flex-col lg:flex-row md:w-4/6">
        <div className="flex-1 flex flex-col justify-center text-white p-4">
          <div className="flex items-center mb-4">
            <img
              alt="Logo"
              className="h-6 w-6 md:h-10 md:w-10"
              src="/assets/LyfeLynk.png"/>
            <h1 className="text-2xl md:text-4xl font-bold ml-2">Lyfelynk</h1>
          </div>
          <p className="text-xl md:text-2xl">Digitally Linking your health.</p>
        </div>

        <div className="flex-1 items-center max-w-xl bg-background rounded-lg p-8">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl md:text-2xl font-bold">Register Service</h2>
              <Link to="/Register">
                  <ChevronLeft/>
              </Link>
          </div>

          <div className="grid grid-cols-2 gap-4 py-4">
            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="facultyname">
                Faculty Name
              </label>
              <div className="mt-1">
                <Input id="facultyname" placeholder="Faculty Name" />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="regId">
                Registeration ID
              </label>
              <div className="mt-1">
                <Input id="regId" placeholder="Registeration ID" />
              </div>
            </div>



            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="country">
                Country
              </label>
              <div className="mt-1">
                <Input id="country" placeholder="Country" />
              </div>
            </div>

            
            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="state">
                State
              </label>
              <div className="mt-1">
                <Input id="state" placeholder="State" />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="city">
                City
              </label>
              <div className="mt-1">
                <Input id="city" placeholder="City" />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="pincode">
                Pincode
              </label>
              <div className="mt-1">
                <Input id="pincode" placeholder="Pincode" />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="service_name">
                Service Name
              </label>
              <div className="mt-1">
                <Input id="service_name" placeholder="Service Name" />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="service_name">
                Service Desc
              </label>
              <div className="mt-1">
                <Input id="service_name" placeholder="Service Desc" />
              </div>
            </div>

          </div>
          <Link to='verify'>
            <Button className="w-full">Submit</Button>
          </Link>
        </div>
 
      </div>
    </section>
  )
}
