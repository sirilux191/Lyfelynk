import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { SelectValue, SelectTrigger, SelectItem, SelectContent, Select } from "@/components/ui/select"

import { ChevronLeft } from 'lucide-react';
import { Link } from "react-router-dom";

export default function RegisterPage2Content() {
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
            <h2 className="text-xl md:text-2xl font-bold">Register Professional</h2>
              <Link to="/Register">
                  <ChevronLeft/>
              </Link>
          </div>

          <div className="grid grid-cols-2 gap-4 py-4">
            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="name">
                Name
              </label>
              <div className="mt-1">
                <Input id="name" placeholder="Name" />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="dob">
                Date of Birth
              </label>
              <div className="mt-1">
                <Input placeholder="Date Of Birth" type="date" />
              </div>
            </div>


            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="gender">
                Gender
              </label>
              <div className="mt-1">
                <Select>
                  <SelectTrigger id="gender">
                    <SelectValue placeholder="Select" />
                  </SelectTrigger>
                  <SelectContent position="popper">
                    <SelectItem value="male">Male</SelectItem>
                    <SelectItem value="female">Female</SelectItem>
                    <SelectItem value="other">Other</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="blood_type">
                Blood Type
              </label>
              <div className="mt-1">
                <Select>
                  <SelectTrigger id="blood_type">
                    <SelectValue placeholder="Select" />
                  </SelectTrigger>
                  <SelectContent position="popper">
                    <SelectItem value="a+">A+</SelectItem>
                    <SelectItem value="a-">A-</SelectItem>
                    <SelectItem value="b+">B+</SelectItem>
                    <SelectItem value="b-">B-</SelectItem>
                    <SelectItem value="ab+">AB+</SelectItem>
                    <SelectItem value="ab-">AB-</SelectItem>
                    <SelectItem value="o+">O+</SelectItem>
                    <SelectItem value="o-">O-</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="height">
                Height
              </label>
              <div className="mt-1">
                <Input id="height" placeholder="Height in cm" />
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
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="weight">
                Weight
              </label>
              <div className="mt-1">
                <Input id="weight" placeholder="Weight in Kg" />
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
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="weight">
                Heart Rate
              </label>
              <div className="mt-1">
                <Input id="weight" placeholder="Heart Rate" />
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
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="occupation">
                Occupation
              </label>
              <div className="mt-1">
                <Input id="occupation" placeholder="Occupation" />
              </div>
            </div>


            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="certificationid">
                Certification Id
              </label>
              <div className="mt-1">
                <Input id="certificationid" placeholder="Certification Id" />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium leading-5 text-gray-700" htmlFor="company">
                Company
              </label>
              <div className="mt-1">
                <Input id="company" placeholder="Company" />
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
