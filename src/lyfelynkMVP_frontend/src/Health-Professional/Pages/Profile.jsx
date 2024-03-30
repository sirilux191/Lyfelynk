import { AvatarImage, AvatarFallback, Avatar } from "@/components/ui/avatar"
import { Input } from "@/components/ui/input"
import { SelectValue, SelectTrigger, SelectItem, SelectContent, Select } from "@/components/ui/select"
import { Button } from "@/components/ui/button"

export default function ProfileContent() {
  return (
    <div>
      <div className="h-min py-8 px-4 sm:px-6 lg:px-8">
        <div className="mx-auto max-w-screen-sm">
          <h1 className="text-center text-4xl font-bold leading-9 ">Update Profile</h1>
          <p className="mt-2 text-center text-sm leading-5 text-gray-600">Update your Profile Information</p>
          <form className="mt-8">
            <div className="rounded-md shadow-sm">
              <div className="flex flex-col items-center">
                <Avatar className="-z-10 w-36 h-36">
                  <AvatarImage alt="John Lenon" src=""/>
                  <AvatarFallback className="text-4xl">JL</AvatarFallback>
                </Avatar>

                <div className="flex space-x-2 py-4">
                  <p>ID Number-</p>
                </div> 

              </div>
              <div className="mt-6 grid grid-cols-2 gap-y-6 gap-x-4 ">
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
                    <Input disabled placeholder="Date Of Birth" type="date" />
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
            </div>
            <div className="mt-6">
              <Button className="w-full">Update</Button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}