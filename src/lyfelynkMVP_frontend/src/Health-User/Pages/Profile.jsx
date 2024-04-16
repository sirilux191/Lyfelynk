import { AvatarImage, AvatarFallback, Avatar } from "@/components/ui/avatar";
import { Input } from "@/components/ui/input";
import {
  SelectValue,
  SelectTrigger,
  SelectItem,
  SelectContent,
  Select,
} from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { useCanister } from "@connect2ic/react";
import { useState, useEffect } from "react";
import LoadingScreen from "../../LoadingScreen";
export default function ProfileContent() {
  const [lyfelynkMVP_backend] = useCanister("lyfelynkMVP_backend");
  const [userData, setUserData] = useState(null);
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

  useEffect(() => {
    const fetchUserData = async () => {
      try {
        const result = await lyfelynkMVP_backend.readUser();
        if (result.ok) {
          const { IDNum, UUID, MetaData } = result.ok;
          const {
            DemographicInformation,
            BasicHealthParameters,
            BiometricData,
            FamilyInformation,
          } = MetaData;

          const parsedDemographicInfo = JSON.parse(
            String.fromCharCode.apply(null, DemographicInformation)
          );
          const parsedBasicHealthParams = JSON.parse(
            String.fromCharCode.apply(null, BasicHealthParameters)
          );
          const parsedBiometricData =
            BiometricData.length > 0
              ? JSON.parse(String.fromCharCode.apply(null, BiometricData))
              : null;
          const parsedFamilyInfo =
            FamilyInformation.length > 0
              ? JSON.parse(String.fromCharCode.apply(null, FamilyInformation))
              : null;

          setUserData({
            IDNum,
            UUID,
            DemographicInformation: parsedDemographicInfo,
            BasicHealthParameters: parsedBasicHealthParams,
            BiometricData: parsedBiometricData,
            FamilyInformation: parsedFamilyInfo,
          });
        } else {
          alert(result.err);
        }
      } catch (error) {
        console.error("Error fetching user data:", error);
      }
    };

    fetchUserData();
  }, [lyfelynkMVP_backend]);

  useEffect(() => {
    if (userData) {
      setName(userData.DemographicInformation.name || "");
      setDob(userData.DemographicInformation.dob || "");
      setGender(userData.DemographicInformation.gender || "");
      setBloodType(userData.BasicHealthParameters.bloodType || "");
      setHeight(userData.BasicHealthParameters.height || "");
      setCountry(userData.DemographicInformation.country || "");
      setWeight(userData.BasicHealthParameters.weight || "");
      setState(userData.DemographicInformation.state || "");
      setHeartRate(userData.BasicHealthParameters.heartRate || "");
      setPincode(userData.DemographicInformation.pincode || "");
    }
  }, [userData]);

  const handleUpdateUser = async (event) => {
    event.preventDefault();
    try {
      const demoInfo = {
        name,
        dob,
        gender,
        country,
        state,
        pincode,
      };

      const basicHealthPara = {
        bloodType,
        height,
        heartRate,
        weight,
      };
      // Convert demoInfo and basicHealthPara objects to JSON strings
      const demoInfoJson = JSON.stringify(demoInfo);
      const basicHealthParaJson = JSON.stringify(basicHealthPara);

      // Convert JSON strings to Uint8Array
      const demoInfoArray = new TextEncoder().encode(demoInfoJson);
      const basicHealthParaArray = new TextEncoder().encode(
        basicHealthParaJson
      );
      const result = await lyfelynkMVP_backend.updateUser(
        Object.values(demoInfoArray),
        Object.values(basicHealthParaArray),
        [],
        []
      );
      if (result.ok) {
        alert("User health ID updated successfully");
      } else {
        alert("Error updating user data:", result.err);
      }
    } catch (error) {
      console.error("Error updating user data:", error);
    }
  };

  if (!userData) {
    return <LoadingScreen/>;
  }
  return (
    <div>
      <div className="h-min py-8 px-4 sm:px-6 lg:px-8">
        <div className="mx-auto max-w-screen-sm">
          <h1 className="text-center text-4xl font-bold leading-9 ">
            Update Profile
          </h1>
          <p className="mt-2 text-center text-sm leading-5 text-gray-600">
            Update your Profile Information
          </p>
          <form
            className="mt-8"
            onSubmit={handleUpdateUser}
          >
            <div className="rounded-md shadow-sm">
              <div className="flex flex-col items-center">
                <Avatar className="-z-10 w-36 h-36">
                  <AvatarImage
                    alt="John Lenon"
                    src=""
                  />
                  <AvatarFallback className="text-4xl">JL</AvatarFallback>
                </Avatar>

                <div className="flex space-x-2 py-4">
                  <p>ID Number:- {userData.IDNum}</p>
                  <p>UUID:- {userData.UUID}</p>
                </div>
              </div>
              <div className="mt-6 grid grid-cols-2 gap-y-6 gap-x-4 ">
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
                    <Input
                      disabled
                      className="border"
                      id="dob"
                      placeholder="mm/dd/yyyy"
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
                      onValueChange={setGender}
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
                      onValueChange={setBloodType}
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
              </div>
            </div>
            <div className="mt-6">
              <Button
                className="w-full"
                type="submit"
              >
                Update
              </Button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
