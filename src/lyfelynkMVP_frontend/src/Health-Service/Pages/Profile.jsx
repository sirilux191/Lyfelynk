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