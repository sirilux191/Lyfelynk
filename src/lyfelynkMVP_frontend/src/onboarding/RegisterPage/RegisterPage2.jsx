import { DatePicker } from "@/Functions/DatePicker";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  SelectValue,
  SelectTrigger,
  SelectItem,
  SelectContent,
  Select,
} from "@/components/ui/select";
import { ChevronLeft } from "lucide-react";
import { Link } from "react-router-dom";
// Connect2ic: Import Connect2ic library to interact with the backend canister
import { useCanister } from "@connect2ic/react";
//
import { useNavigate } from "react-router-dom";
import { useState } from "react";

export default function RegisterPage2Content() {
  const [lyfelynkMVP_backend] = useCanister("lyfelynkMVP_backend");
  //

  const navigate = useNavigate();
  const [name, setName] = useState("");
  const [dob, setDob] = useState("");
  const [gender, setGender] = useState("");
  const [bloodType, setBloodType] = useState("");
  const [height, setHeight] = useState("");
  const [country, setCountry] = useState("");
  const [weight, setWeight] = useState("");
  const [state, setState] = useState("");
  const [heartRate, setHeartRate] = useState("");
  const [pincode, setPincode] = useState("");
  const [occupation, setOccupation] = useState("");
  const [certificationId, setCertificationId] = useState("");
  const [company, setCompany] = useState("");

  const registerProfessional = async () => {
    const demoInfo = {
      name,
      dob,
      gender,
      bloodType,
      height,
      country,
      weight,
      state,
      heartRate,
      pincode,
    };

    const occupationInfo = {
      occupation,
      company,
    };

    const certificationInfo = {
      certificationId,
    };

    // Convert demoInfo, occupationInfo, and certificationInfo objects to JSON strings
    const demoInfoJson = JSON.stringify(demoInfo);
    const occupationInfoJson = JSON.stringify(occupationInfo);
    const certificationInfoJson = JSON.stringify(certificationInfo);

    // Convert JSON strings to Uint8Array
    const demoInfoArray = new TextEncoder().encode(demoInfoJson);
    const occupationInfoArray = new TextEncoder().encode(occupationInfoJson);
    const certificationInfoArray = new TextEncoder().encode(
      certificationInfoJson
    );

    const result = await lyfelynkMVP_backend.createProfessional(
      Object.values(demoInfoArray),
      Object.values(occupationInfoArray),
      Object.values(certificationInfoArray)
    );
    Object.keys(result).forEach((key) => {
      if (key == "err") {
        alert(result[key]);
      }
      if (key == "ok") {
        alert("Your Health Professional ID is :", result[key]);
        navigate("verify");
      }
    });
  };
  return (
    <section className="px-6 flex justify-center items-center h-screen bg-[conic-gradient(at_bottom_right,_var(--tw-gradient-stops))] from-blue-700 via-blue-800 to-gray-900">
      <div className="flex flex-col lg:flex-row md:w-4/6">
        <div className="flex-1 flex flex-col justify-center text-white p-4">
          <div className="flex items-center mb-4">
            <img
              alt="Logo"
              className="h-10 w-48"
              src="/assets/lyfelynk.png"
            />
          </div>
          <p className="text-xl md:text-2xl">Digitally Linking your health.</p>
        </div>

        <div className="flex-1 items-center max-w-xl bg-background rounded-lg p-8">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl md:text-2xl font-bold">
              Register Professional
            </h2>
            <Link to="/Register">
              <ChevronLeft />
            </Link>
          </div>

          <div className="grid grid-cols-2 gap-4 py-4">
            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="name"
              >
                Name
              </label>
              <div className="mt-1">
                <Input
                  id="name"
                  placeholder="Name"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="dob"
              >
                Date of Birth
              </label>
              <div className="mt-1">
                <DatePicker
                  value={dob}
                  onChange={(e) => setDob(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="gender"
              >
                Gender
              </label>
              <div className="mt-1">
                <Select
                  value={gender}
                  onValueChange={(value) => setGender(value)}
                >
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
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="blood_type"
              >
                Blood Type
              </label>
              <div className="mt-1">
                <Select
                  value={bloodType}
                  onValueChange={(value) => setBloodType(value)}
                >
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
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="height"
              >
                Height
              </label>
              <div className="mt-1">
                <Input
                  id="height"
                  placeholder="Height in cm"
                  value={height}
                  onChange={(e) => setHeight(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="country"
              >
                Country
              </label>
              <div className="mt-1">
                <Input
                  id="country"
                  placeholder="Country"
                  value={country}
                  onChange={(e) => setCountry(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="weight"
              >
                Weight
              </label>
              <div className="mt-1">
                <Input
                  id="weight"
                  placeholder="Weight in Kg"
                  value={weight}
                  onChange={(e) => setWeight(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="state"
              >
                State
              </label>
              <div className="mt-1">
                <Input
                  id="state"
                  placeholder="State"
                  value={state}
                  onChange={(e) => setState(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="heartRate"
              >
                Heart Rate
              </label>
              <div className="mt-1">
                <Input
                  id="heartRate"
                  placeholder="Heart Rate"
                  value={heartRate}
                  onChange={(e) => setHeartRate(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="pincode"
              >
                Pincode
              </label>
              <div className="mt-1">
                <Input
                  id="pincode"
                  placeholder="Pincode"
                  value={pincode}
                  onChange={(e) => setPincode(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="occupation"
              >
                Occupation
              </label>
              <div className="mt-1">
                <Input
                  id="occupation"
                  placeholder="Occupation"
                  value={occupation}
                  onChange={(e) => setOccupation(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="certificationid"
              >
                Certification Id
              </label>
              <div className="mt-1">
                <Input
                  id="certificationid"
                  placeholder="Certification Id"
                  value={certificationId}
                  onChange={(e) => setCertificationId(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label
                className="block text-sm font-medium leading-5 text-foreground"
                htmlFor="company"
              >
                Company
              </label>
              <div className="mt-1">
                <Input
                  id="company"
                  placeholder="Company"
                  value={company}
                  onChange={(e) => setCompany(e.target.value)}
                />
              </div>
            </div>
          </div>
          <Button
            className="w-full"
            onClick={registerProfessional}
          >
            Submit
          </Button>
        </div>
      </div>
    </section>
  );
}
