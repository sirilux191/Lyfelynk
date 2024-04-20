import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  SelectValue,
  SelectTrigger,
  SelectItem,
  SelectContent,
  Select,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { ChevronLeft } from "lucide-react";
import FileUpload from "../../Functions/file-upload";
import { DatePicker } from "@/Functions/DatePicker";
import { jsPDF } from "jspdf";
import { useState } from "react";
import { useCanister } from "@connect2ic/react";
import LoadingScreen from "../../LoadingScreen";

export default function UploadContent() {
  const [lyfelynkMVP_backend] = useCanister("lyfelynkMVP_backend");
  const [formData, setFormData] = useState({
    dateOfCheckup: "",
    typeOfCheckup: "",
    healthcareProvider: "",
    reasonForCheckup: "",
    medicationName: "",
    dosage: "",
    frequency: "",
    prescribingDoctor: "",
  });
  const [description, setDescription] = useState("");
  const [keywords, setKeywords] = useState("");
  const [category, setCategory] = useState("");
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.id]: e.target.value });
  };

  const handleSelectChange = (field, value) => {
    setFormData({ ...formData, [field]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    // Generate PDF
    const doc = new jsPDF();
    let pdfContent = "";
    for (const [key, value] of Object.entries(formData)) {
      pdfContent += `${key}: ${value}\n\n`;
    }
    doc.text(pdfContent, 10, 10);

    // Save PDF as a file
    const pdfBlob = doc.output("blob");
    const pdfFile = new File([pdfBlob], "generated.pdf", {
      type: "application/pdf",
    });

    const fileReader = new FileReader();
    fileReader.onload = async () => {
      const arrayBuffer = fileReader.result;
      const uint8Array = new Uint8Array(arrayBuffer);
      console.log(uint8Array);
      const metadata = {
        category: category,
        tags: [keywords],
        format: pdfFile.type,
      };

      const dataAsset = {
        title: pdfFile.name,
        description: description,
        data: Object.values(uint8Array),
        metadata: metadata,
      };

      const result = await lyfelynkMVP_backend.linkHealthData(dataAsset);

      Object.keys(result).forEach((key) => {
        if (key === "err") {
          alert(result[key]);
          setLoading(false);
        }
        if (key === "ok") {
          console.log(result[key]);
          alert("File uploaded successfully");
          setLoading(false);
        }
      });
    };
    fileReader.readAsArrayBuffer(pdfFile);
  };
  if (loading) {
    return <LoadingScreen />;
  }
  return (
    <div className="max-w-6xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
      <div className="flex flex-col items-center justify-center p-8">
        <div className="flex items-center justify-between w-full">
          <Link to="/Health-Service/MyHealth">
            <div className="flex text-foreground">
              <ChevronLeft className="mr-2" />
              Back
            </div>
          </Link>
        </div>
        <h1 className="mt-4 text-4xl font-bold">Upload your Health Data</h1>
        <p className="mt-2 text-lg text-gray-600">
          Choose a suitable format to upload your data.
        </p>
        <div className="mt-6 w-full max-w-4xl">
          <Tabs defaultValue="Document">
            <TabsList className="w-full">
              <TabsTrigger
                className="w-1/2"
                value="Document"
              >
                Document
              </TabsTrigger>
              <TabsTrigger
                className="w-1/2"
                value="Form"
              >
                Form
              </TabsTrigger>
            </TabsList>
            <TabsContent value="Document">
              <FileUpload />
            </TabsContent>

            <TabsContent value="Form">
              <p className="text-sm mb-4 text-gray-500">
                Fill the form out carefully and make sure the information is
                true to your knowledge.
              </p>
              <form
                className="space-y-6"
                onSubmit={handleSubmit}
              >
                <div>
                  <h2 className="text-xl font-semibold">
                    Health Checkup Details
                  </h2>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                    <div className="flex flex-col space-y-1.5">
                      <label
                        className="font-medium"
                        htmlFor="date-of-checkup"
                      >
                        Date of Checkup
                      </label>
                      <DatePicker
                        id="date-of-checkup"
                        value={formData.dateOfCheckup}
                        onChange={handleChange}
                      />
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label
                        className="font-medium"
                        htmlFor="type-of-checkup"
                      >
                        Type of Checkup
                      </label>
                      <Select
                        id="type-of-checkup"
                        value={formData.typeOfCheckup}
                        onValueChange={(value) =>
                          handleSelectChange("typeOfCheckup", value)
                        }
                      >
                        <SelectTrigger>
                          <SelectValue placeholder="Select" />
                        </SelectTrigger>
                        <SelectContent position="popper">
                          <SelectItem value="general">
                            General Checkup
                          </SelectItem>
                          <SelectItem value="blood-test">Blood Test</SelectItem>
                          <SelectItem value="cholesterol">
                            Cholesterol Test
                          </SelectItem>
                          <SelectItem value="cardiac">
                            Cardiac Evaluation
                          </SelectItem>
                          <SelectItem value="other">Other</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label
                        className="font-medium"
                        htmlFor="healthcare-provider"
                      >
                        Healthcare Provider/Facility Name
                      </label>
                      <Input
                        id="healthcareProvider"
                        placeholder="Enter name"
                        value={formData.healthcareProvider}
                        onChange={handleChange}
                      />
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label
                        className="font-medium"
                        htmlFor="reason-for-checkup"
                      >
                        Reason for Checkup
                      </label>
                      <Select
                        id="reason-for-checkup"
                        value={formData.reasonForCheckup}
                        onValueChange={(value) =>
                          handleSelectChange("reasonForCheckup", value)
                        }
                      >
                        <SelectTrigger>
                          <SelectValue placeholder="Select" />
                        </SelectTrigger>
                        <SelectContent position="popper">
                          <SelectItem value="routine">Routine</SelectItem>
                          <SelectItem value="symptoms">
                            Specific Symptoms
                          </SelectItem>
                          <SelectItem value="pre-surgery">
                            Pre-Surgery
                          </SelectItem>
                          <SelectItem value="other">Other</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </div>
                </div>
                <div>
                  <h2 className="text-xl font-semibold">
                    Prescription Details
                  </h2>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                    <div className="flex flex-col space-y-1.5">
                      <label
                        className="font-medium"
                        htmlFor="medication-name"
                      >
                        Medication Name(s)
                      </label>
                      <Input
                        id="medicationName"
                        placeholder="Enter medication name"
                        value={formData.medicationName}
                        onChange={handleChange}
                      />
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label
                        className="font-medium"
                        htmlFor="dosage"
                      >
                        Dosage
                      </label>
                      <Input
                        id="dosage"
                        placeholder="Enter dosage"
                        value={formData.dosage}
                        onChange={handleChange}
                      />
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label
                        className="font-medium"
                        htmlFor="frequency"
                      >
                        Frequency
                      </label>
                      <Input
                        id="frequency"
                        placeholder="Enter frequency"
                        value={formData.frequency}
                        onChange={handleChange}
                      />
                    </div>
                    <div className="flex flex-col space-y-1.5">
                      <label
                        className="font-medium"
                        htmlFor="prescribing-doctor"
                      >
                        Prescribing Doctor
                      </label>
                      <Input
                        id="prescribingDoctor"
                        placeholder="Enter doctor's name"
                        value={formData.prescribingDoctor}
                        onChange={handleChange}
                      />
                    </div>
                  </div>
                </div>
                <div>
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>Title</TableHead>
                        <TableHead>Description</TableHead>
                        <TableHead>Keywords</TableHead>
                        <TableHead>Category</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      <TableRow>
                        <TableCell>{"Report Generated"}</TableCell>
                        <TableCell>
                          <div className="border rounded-sm">
                            <Textarea
                              value={description}
                              onChange={(e) => setDescription(e.target.value)}
                            />
                          </div>
                        </TableCell>
                        <TableCell>
                          <div className="border rounded-sm">
                            <Textarea
                              type="text"
                              className="py-3"
                              value={keywords}
                              onChange={(e) => setKeywords(e.target.value)}
                            />
                          </div>
                        </TableCell>
                        <TableCell>
                          <div className="border rounded-sm">
                            <Textarea
                              type="text"
                              className="py-3"
                              value={category}
                              onChange={(e) => setCategory(e.target.value)}
                            />
                          </div>
                        </TableCell>
                      </TableRow>
                    </TableBody>
                  </Table>
                </div>
                <Button type="submit">Submit</Button>
              </form>
            </TabsContent>
          </Tabs>
        </div>
      </div>
    </div>
  );
}
