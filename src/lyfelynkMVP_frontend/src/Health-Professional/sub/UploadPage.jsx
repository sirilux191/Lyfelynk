import { Link } from "react-router-dom"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { SelectValue, SelectTrigger, SelectItem, SelectContent, Select } from "@/components/ui/select"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { ChevronLeft } from "lucide-react";
import FileUpload from "./file-upload"

export default function UploadContent() {
  return (
    <div>
      <div className="flex flex-col items-center justify-center p-8">
          <div className="flex items-center justify-between w-full">
            <Link to="/Health-Professional/MyHealth">
              <div className="flex text-foreground">
                <ChevronLeft className=" mr-2" />
                Back
              </div>
            </Link>
    
          </div>
        <h1 className="mt-4 text-4xl font-bold">Upload your Health Data</h1>
        <p className="mt-2 text-lg text-gray-600">Choose a suitable format to upload your data.</p>
        <div className="mt-6 w-full max-w-4xl">
          <Tabs defaultValue="Document">
            <TabsList className="w-full">
              <TabsTrigger className="w-1/2" value="Document">Document</TabsTrigger>
              <TabsTrigger className="w-1/2" value="Form">Form</TabsTrigger>
            </TabsList>
            <TabsContent value="Document">
              <FileUpload/>
            </TabsContent>

            <TabsContent value="Form">
              <p className="text-sm mb-4 text-gray-500">Fill the form out carefully and make sure the information is true to your knowledge.</p>
              <form className="space-y-6">
                <div>
                  <h2 className="text-xl font-semibold">Health Checkup Details</h2>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                    <div className="flex flex-col space-y-1.5">
                      <label className="font-medium" htmlFor="date-of-checkup">
                        Date of Checkup
                      </label>
                      <Input id="date" placeholder="dd/mm/yyyy" />
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label className="font-medium" htmlFor="type-of-checkup">
                        Type of Checkup
                      </label>
                      <Select>
                        <SelectTrigger id="type-of-checkup">
                          <SelectValue placeholder="Select" />
                        </SelectTrigger>
                        <SelectContent position="popper">
                          <SelectItem value="general">General Checkup</SelectItem>
                          <SelectItem value="blood-test">Blood Test</SelectItem>
                          <SelectItem value="cholesterol">Cholesterol Test</SelectItem>
                          <SelectItem value="cardiac">Cardiac Evaluation</SelectItem>
                          <SelectItem value="other">Other</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label className="font-medium" htmlFor="healthcare-provider">
                        Healthcare Provider/Facility Name
                      </label>
                      <Input id="healthcare-provider" placeholder="Enter name" />
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label className="font-medium" htmlFor="reason-for-checkup">
                        Reason for Checkup
                      </label>
                      <Select>
                        <SelectTrigger id="reason-for-checkup">
                          <SelectValue placeholder="Select" />
                        </SelectTrigger>
                        <SelectContent position="popper">
                          <SelectItem value="routine">Routine</SelectItem>
                          <SelectItem value="symptoms">Specific Symptoms</SelectItem>
                          <SelectItem value="pre-surgery">Pre-Surgery</SelectItem>
                          <SelectItem value="other">Other</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </div>
                </div>
                <div>
                  <h2 className="text-xl font-semibold">Prescription Details</h2>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                    <div className="flex flex-col space-y-1.5">
                      <label className="font-medium" htmlFor="medication-name">
                        Medication Name(s)
                      </label>
                      <Input id="medication-name" placeholder="Enter medication name" />
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label className="font-medium" htmlFor="dosage">
                        Dosage
                      </label>
                      <Input id="dosage" placeholder="Enter dosage" />
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label className="font-medium" htmlFor="frequency">
                        Frequency
                      </label>
                      <Input id="frequency" placeholder="Enter frequency" />
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label className="font-medium" htmlFor="prescribing-doctor">
                        Prescribing Doctor
                      </label>
                      <Input id="prescribing-doctor" placeholder="Enter doctor's name" />
                    </div>
                  </div>
                </div>
                <Button>Submit</Button>
              </form>
            </TabsContent>
          </Tabs>
        </div>


      </div>
    </div>
  )
}