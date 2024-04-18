import { AvatarImage, AvatarFallback, Avatar } from "@/components/ui/avatar";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { useCanister } from "@connect2ic/react";
import { useState, useEffect } from "react";
import LoadingScreen from "../../LoadingScreen";

export default function ProfileContent() {
  const [lyfelynkMVP_backend] = useCanister("lyfelynkMVP_backend");
  const [facilityData, setFacilityData] = useState(null);
  const [facultyName, setFacultyName] = useState("");
  const [registrationId, setRegistrationId] = useState("");
  const [country, setCountry] = useState("");
  const [state, setState] = useState("");
  const [city, setCity] = useState("");
  const [pincode, setPincode] = useState("");
  const [serviceName, setServiceName] = useState("");
  const [serviceDesc, setServiceDesc] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const fetchFacilityData = async () => {
      try {
        const result = await lyfelynkMVP_backend.readFacility();
        if (result.ok) {
          const { IDNum, UUID, MetaData } = result.ok;
          const {
            DemographicInformation,
            ServicesOfferedInformation,
            LicenseInformation,
          } = MetaData;

          const parsedDemographicInfo = JSON.parse(
            String.fromCharCode.apply(null, DemographicInformation)
          );
          const parsedServicesOfferedInfo = JSON.parse(
            String.fromCharCode.apply(null, ServicesOfferedInformation)
          );
          const parsedLicenseInfo = JSON.parse(
            String.fromCharCode.apply(null, LicenseInformation)
          );

          setFacilityData({
            IDNum,
            UUID,
            DemographicInformation: parsedDemographicInfo,
            ServicesOfferedInformation: parsedServicesOfferedInfo,
            LicenseInformation: parsedLicenseInfo,
          });
        } else {
          alert(result.err);
        }
      } catch (error) {
        console.error("Error fetching facility data:", error);
      }
    };

    fetchFacilityData();
  }, [lyfelynkMVP_backend]);

  useEffect(() => {
    if (facilityData) {
      setFacultyName(facilityData.DemographicInformation.facultyName || "");
      setRegistrationId(facilityData.LicenseInformation.registrationId || "");
      setCountry(facilityData.DemographicInformation.country || "");
      setState(facilityData.DemographicInformation.state || "");
      setCity(facilityData.DemographicInformation.city || "");
      setPincode(facilityData.DemographicInformation.pincode || "");
      setServiceName(facilityData.ServicesOfferedInformation.serviceName || "");
      setServiceDesc(facilityData.ServicesOfferedInformation.serviceDesc || "");
    }
  }, [facilityData]);

  const handleUpdateFacility = async (event) => {
    event.preventDefault();
    setLoading(true);

    try {
      const demoInfo = {
        facultyName,
        country,
        state,
        city,
        pincode,
      };

      const servicesOfferedInfo = {
        serviceName,
        serviceDesc,
      };

      const licenseInfo = {
        registrationId,
      };

      // Convert demoInfo, servicesOfferedInfo, and licenseInfo objects to JSON strings
      const demoInfoJson = JSON.stringify(demoInfo);
      const servicesOfferedInfoJson = JSON.stringify(servicesOfferedInfo);
      const licenseInfoJson = JSON.stringify(licenseInfo);

      // Convert JSON strings to Uint8Array
      const demoInfoArray = new TextEncoder().encode(demoInfoJson);
      const servicesOfferedInfoArray = new TextEncoder().encode(
        servicesOfferedInfoJson
      );
      const licenseInfoArray = new TextEncoder().encode(licenseInfoJson);

      const result = await lyfelynkMVP_backend.updateFacility(
        Object.values(demoInfoArray),
        Object.values(servicesOfferedInfoArray),
        Object.values(licenseInfoArray)
      );

      if (result.ok) {
        alert("Facility health ID updated successfully");
        setLoading(false);
      } else {
        alert("Error updating facility data:", result.err);
        setLoading(false);
      }
    } catch (error) {
      console.error("Error updating facility data:", error);
    }
  };
  if (loading) {
    return <LoadingScreen />;
  }
  if (!facilityData) {
    return <LoadingScreen />;
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
            onSubmit={handleUpdateFacility}
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
                  <p>ID Number:- {facilityData.IDNum}</p>
                  <p>UUID:- {facilityData.UUID}</p>
                </div>
              </div>
              <div className="mt-6 grid grid-cols-2 gap-y-6 gap-x-4 ">
                <div>
                  <label
                    className="block text-sm font-medium leading-5 text-foreground"
                    htmlFor="facultyname"
                  >
                    Faculty Name
                  </label>
                  <div className="mt-1">
                    <Input
                      id="facultyname"
                      placeholder="Faculty Name"
                      value={facultyName}
                      onChange={(e) => setFacultyName(e.target.value)}
                    />
                  </div>
                </div>

                <div>
                  <label
                    className="block text-sm font-medium leading-5 text-foreground"
                    htmlFor="regId"
                  >
                    Registeration ID
                  </label>
                  <div className="mt-1">
                    <Input
                      id="regId"
                      placeholder="Registeration ID"
                      value={registrationId}
                      onChange={(e) => setRegistrationId(e.target.value)}
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
                    htmlFor="city"
                  >
                    City
                  </label>
                  <div className="mt-1">
                    <Input
                      id="city"
                      placeholder="City"
                      value={city}
                      onChange={(e) => setCity(e.target.value)}
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
                    htmlFor="service_name"
                  >
                    Service Name
                  </label>
                  <div className="mt-1">
                    <Input
                      id="service_name"
                      placeholder="Service Name"
                      value={serviceName}
                      onChange={(e) => setServiceName(e.target.value)}
                    />
                  </div>
                </div>

                <div>
                  <label
                    className="block text-sm font-medium leading-5 text-foreground"
                    htmlFor="service_name"
                  >
                    Service Desc
                  </label>
                  <div className="mt-1">
                    <Input
                      id="service_name"
                      placeholder="Service Desc"
                      value={serviceDesc}
                      onChange={(e) => setServiceDesc(e.target.value)}
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
