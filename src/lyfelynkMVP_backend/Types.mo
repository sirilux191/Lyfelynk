import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
module Types {

    public type Metadata = {
        category : Text;
        tags : [Text];
        format : Text; //  e.g., "CSV", "JSON", "image/png"
    };

    public type License = {
        // **Open Source Licenses**
        #Apache2; // Apache License 2.0 (permissive)
        #MIT; // MIT License (very permissive)
        #GPLv3; // GNU General Public License v3.0 (strong copyleft)
        #LGPLv3; // GNU Lesser General Public License v3.0 (weaker copyleft)
        #MPL2; // Mozilla Public License 2.0
        #BSD3; // 3-Clause BSD License (permissive)

        // **Creative Commons**
        #CC0; // Public domain dedication
        #CCBY; // Attribution
        #CCBYSA; // Attribution-ShareAlike
        #CCBYNC; // Attribution-NonCommercial
        // ...other CC variants
    };

    public type HealthIDUserData = {
        DemographicInformation : Blob;
        BasicHealthParameters : Blob;
        BiometricData : ?Blob;
        FamilyInformation : ?Blob;
    };
    public type HealthIDUser = {
        IDNum : Text;
        UUID : Text;
        MetaData : HealthIDUserData;
    };

    public type HealthIDProfessionalData = {
        DemographicInformation : Blob;
        OccupationInformation : Blob;
        CertificationInformation : Blob;
    };
    public type HealthIDProfessional = {
        IDNum : Text;
        UUID : Text;
        MetaData : HealthIDProfessionalData;
    };

    public type HealthIDFacilityData = {
        DemographicInformation : Blob;
        ServicesOfferedInformation : Blob;
        LicenseInformation : Blob;
    };
    public type HealthIDFacility = {
        IDNum : Text;
        UUID : Text;
        MetaData : HealthIDFacilityData;
    };

    public type DataAsset = {
        owner : Text;
        publisher : ?Text;
        title : Text;
        description : ?Text;
        data : Blob;
        metadata : ?Metadata;
        license : ?License;
    };

    public type sharedActivityInfo = {
        assetID : Text;
        usedSharedTo : Text;
        time : Nat;
    };

    public type Listing = {
        title : Text;
        description : Text;
        price : Nat;
        category : Text;
        seller : Principal;
        assetID : Text;
    };
};
